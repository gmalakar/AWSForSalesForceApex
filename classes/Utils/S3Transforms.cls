public class S3Transforms {
    
    public static String ToStringValue(String value)
    {
        if ( String.isBlank(value)){
            value = '';
        }
        return value;
    }

    public static String ToStringValue(Integer value)
    {
        return String.valueOf(value);
    }

    public static String ToStringValue(Long value)
    {
        return String.valueOf(value);
    }

    //TODO
    /*
    public static String ToStringValue(DateTime value, String dateFormat = AWSSDKUtils.RFC822DateFormat)
    {
        return value.ToUniversalTime().ToString(dateFormat, CultureInfo.InvariantCulture);
    }      
    */          

    public static String ToStringValue(Boolean value)
    {
        return String.valueOf(value).toLowerCase();
    }
}
