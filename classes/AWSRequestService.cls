public with sharing class AWSRequestService {
    /**
	* HttpMethod
	*/
    
    public static class HttpMethod {
        
        public static String Get { get { return 'GET';} }
        public static String Put { get { return 'PUT';} }
        public static String Post { get { return 'POST';} }
        public static String Del { get { return 'DELETE';} }
        public static String Patch { get { return 'PATCH';} }
    }

    public static String GetLambdaEndpoint( String region )
    {
        return 'https://lambda.' + region + '.amazonaws.com';
    }

    public static String GetApiEndpoint( String id, String service, String region, String stagename )
    {
        return 'https://' + id + '.' + service + '.' + region + '.amazonaws.com/' + stagename +'/';
    }
}
