table 50101 "Activation Code Information"
{
    DataClassification = SystemMetadata;
    Caption = 'Activation Code Information';


    fields
    {
        field(1; ActivationCode; Text[14])
        {
            DataClassification = SystemMetadata;
            Description = 'Activation code used to activate Customer Rewards';

        }
        field(2; "Date Activate"; Date)
        {
            Caption = 'Date Activated';
            DataClassification = SystemMetadata;
            Description = 'Date Customer Rewards was activated';
        }
        field(3; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
            Description = 'Date Customer Rewards activation expires';
        }

    }

    keys
    {
        key(PK; ActivationCode)
        {
            Clustered = true;
        }
    }

}