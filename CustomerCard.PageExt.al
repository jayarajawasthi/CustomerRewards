pageextension 50100 "Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(RewardLevel; RewardLevel)
            {
                ApplicationArea = All;
                Caption = 'Reward Level';
                Description = 'Reward Level of the customer';
                ToolTip = 'Specifies the level of the reward that the customer has at this point';
                Editable = false;
            }
            field(RewardPoits; Rec.RewardPoints)
            {
                ApplicationArea = All;
                Caption = 'Reward Points';
                Description = 'Reward Points accrued by customer ';
                ToolTip = 'Specifies the total number of the points that the cusomter has at this point';
                Editable = false;
            }
        }
    }


    trigger OnAfterGetRecord();
    var
        CustomerRewardsMgtExt: Codeunit "Customer Rewards Ext Mgt";
    begin
        //Get the reward level associated with reward points
        RewardLevel := CustomerRewardsMgtExt.GetRewardLevel(Rec.RewardPoints);
    end;

    var
        RewardLevel: Text;
}