codeunit 50101 "Customer Rewards Ext Mgt"
{
    EventSubscriberInstance = StaticAutomatic;

    //Determines if the extension is activated
    procedure IsCustomerRewardsActivated(): Boolean;
    var
        ActivationCodeInformation: Record "Activate Code Information";
    begin
        if not ActivationCodeInformation.FindFirst() then
            exit(false);
        if (ActivationCodeInformation."Date Activated" <= Today) and (today <= ActivationCodeInformation."Expiration Date") then
            exit(true);
        exit(false);
    end;


    //opens the customer rewards assisted setup guide
    procedure OpenCustomerRewardsWizard();
    var
        CustomerRewardsWizard: Page "Customer Rewards Wizard";
    begin
        CustomerRewardsWizard.RunModal();
    end;

    //opens the reward level
    procedure OpenRewardsLevelPage();
    var
        RewardsLevelList: Page "Rewards Level List";
    begin
        RewardsLevelList.Run();
    end;


    //Determines the corresponding reward level and returns it
    procedure GetRewardLevel(RewardPoints: Integer) RewardLevelText: Text;
    var
        RewardLevel: Record "Reward Level";
        MinRewardPonts: Integer;

    begin
        RewardLevelTxt := NoRewardLevelTxt;
        if RewardLevel.IsEmpty() then
            exit;
        Rewardlevel.SetRange("Minimum Reward Points", 0, RewardPoints);
        RewardLevel.SetCurrentKey("Minimum Reward Points"); //Sorted in ascending order

        if not RewardLevel.FindFirst() then
            exit;
        MinRewardLevelPoints := RewardLevel."Minimum Reward Points";

        if RewardPoints >= MinRewardPoints then begin
            RewardLevel.Reset();
            RewardLevel.SetRange("Minimum Reward Points", MinRewardPoints, RewardPoints);
            RewardLevel.SetCurrentKey("minimum Reward Points"); //Sorted in ascending order
            RewardLevel.FindLast();
            RewardLevelTxt := RewardLevel.Level;
        end
    end;

    //Activates Customer Rewards if activation code is validated successfully
    procedure ActivateCustomerRewards(ActivationCode: Text): Boolean;
    var
        ActivationCodeInformation: Record "Activation Code Information";
    begin
        //raise event
        OnGetActivationCodeStatusFromServer(ActivationCode);
        exit(ActivationCodeInformation.Get(ActivationCode));
    end;

    //publishes event
    [IntegrationEvent(false, false)]
    procedure OnGetActivationCodeStatusFromServer(ActivationCode: Text);
    begin

    end;

    //subscirbes to OnGetActivationCodeStatusFromSever event and handles it when the event is raised
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Rewards Ext Mgt", 'OnGetActivationCodeStatusFromServer', '', false, false)]
    local procedure OnGetActivationcodeStatusFromServerSubscriber(ActivationCode: Text);
    var
        ActivationCodeInfor: Record "Activation code Information";
        ResponseText: Text;
        Result: JsonToken;
        JsonResponse: JsonToken;
    begin
        if not CanHandle() then
            exit;// use the mock 

        //Get response from external servide and update activation code information if successful 
        if (GetHTTPResponse(ActivationCode, ResponseText)) then begin
            JsonResponse.ReadFrom(ResponseText);

            if (jsonResponse.SelectToken('ActivationResponse', Result)) then
                if (Result.AsValue().AsText() = 'Success') then begin
                    if (ActivationCodeInfo.FindFirst()) then
                        ActivationCodeInfo.Delete();


                    ActivationCodeInfo.Init();
                    ActivationCodeInfo.ActivationCode := ActivationCode;
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CALCDATE('<1Y>', Today);
                    ActivationCodeInfo.Insert();
                end
        end;
    end;

    //Helper method to make calls to a service to validate activation code

    local procedure GetHttpResponse(ActivationCode: Text; var ResponseText: Text): Boolean;
    begin
        //you will typically make external calls /http request to your service to validate the activation code
        //here but for the sample extension we simply return a successful dummy response
        if ActivationCoDe = '' then
            exit(false);

        ResponseText := DummySuccessResponseTxt;
        exit(true);
    end;


    //Subscribes to the OnAfterReleaseSalesDoc event and increases reward points for the sell to customer in posted sales order
    [EventSubscriber(ObjectType: Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocSubscriber(VAR SalesHeader: Record "sales Header"; PreviewMode: Boolean; LineWereModified: Boolean);
    var
        Customer: Record Customer;
    begin
        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;
        Customer.Get(SalesHeader."Sell-to Customer No.");
        Customer.RewardPoints += 1; //Add a point for each new sales order
        Customer.Modify();
    end;


    //checks if the current codeunit is allowed to handle Customer Rewards Activation Requests rather than a mock.
    local procedure CanHandle(): Boolean;
    var
        CustomerRewardsMgtSetup: Record "Customer Rewards Mgt Setup";
    begin
        if CustomerRewardsMgtSetup.Get() then
            exit(CustomerRewardsMgtSetup."Cust. Rew. Ext. Mgt. Cod. ID" = CODEUNIT::"Customer Rewards Ext Mgt");
        exit(false)
    end;

    var
        DummySuccessResponseTxt: Label '{"Activation Response":"Success"}', Locked = true;
        NoRewardLevelTxt: TextConst ENU = 'NONE';

}