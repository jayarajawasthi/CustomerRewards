table 50102 "Customer Rewards Mgt. Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Rewards Mgt. Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';

        }
        field(2; "Cust. Rew. Ext. Mgt. Cod. ID"; Integer)
        {
            Caption = 'Customer Rewards Ext. Mgt. Codeunit ID';
            DataClassification = CustomerContent;
            // TestTableRelation = "Codeunit Metadata".ID;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }



}