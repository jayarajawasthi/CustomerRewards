tableextension 50100 Customer extends Customer
{
    fields
    {
        field(100001; RewardPoints; Integer)
        {
            Caption = 'Reward Points';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}