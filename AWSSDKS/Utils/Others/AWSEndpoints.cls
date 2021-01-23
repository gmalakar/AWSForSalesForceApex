public with sharing class AWSEndpoints {
    public static String GetLambdaEndpoint( String region )
    {
        return 'https://lambda.' + region + '.amazonaws.com';
    }

    public static String GetServiceEndpoint( String id, String service, String region, String stagename )
    {
        String api = 'https://' + id + '.' + service + '.' + region + '.amazonaws.com/';
        if( String.isNotBlank(( stagename ))){
            api = api + stagename +'/';
        }
        return api;
    }

    public static String GetApiEndpoint( String id, String region, String stagename )
    {
        return GetServiceEndpoint( id, 'execute-api', region,stagename);
    }

    public static String GetS3Endpoint( String bucketName, String region )
    {
        return GetServiceEndpoint( bucketName, 's3', region, null );
    }
}
