public with sharing class AWSRequestService {
    private static Set<String> slashes = new Set<String>{'/','\\'};
    /**
	* HttpMethod
    */
    public enum HttpMethod {GET, PUT, POST, DEL, PATCH}

    public enum MultiPartAction {CMP, IMP, AMP}

    public enum Protocol {Http, Https }
    
    public static String GetLambdaEndpoint( String region )
    {
        return 'https://lambda.' + region + '.amazonaws.com';
    }

    public static String GetApiEndpoint( String id, String service, String region, String stagename )
    {
        return 'https://' + id + '.' + service + '.' + region + '.amazonaws.com/' + stagename +'/';
    }

    public static String GetS3Endpoint( String bucketName, String region )
    {
        return 'https://' + bucketName + '.s3.' + region + '.amazonaws.com';
    }

    public virtual class AWSPreSignedRequest
    {        
        public Map<String, String> Headers { get; private set; }
        
        public HttpMethod Verb { get; set; }  

        public long ExpiresIn { get; set; }  

        public Protocol Protocol { get; set; } 
        
        public Blob Content { get; set; }  
        
        public void setHeader( String key, String value )
        {
            this.Headers.put(key, value);
        }
        
        public String getHeader( String key )
        {
            String value = '';
            if ( this.Headers.containsKey(key ) )
                value = this.Headers.get(key);

            return value;
        }

        public Map<String, String> Metadata { get; private set; }
        
        public void setMetadata( String key, String value )
        {
            this.Metadata.put(key, value);
        }
        
        public String getMetadata( String key )
        {
            String value = '';
            if ( this.Metadata.containsKey(key ) )
                value = this.Metadata.get(key);

            return value;
        }

        public Map<String, String> Parameters { get; private set; }
        
        public void setParameter( String key, String value )
        {
            this.Parameters.put(key, value);
        }
        
        public String getParameter( String key )
        {
            String value = '';
            if ( this.Parameters.containsKey(key ) )
                value = this.Parameters.get(key);

            return value;
        }

        public AWSPreSignedRequest()
        {
            this.Headers = new Map<String, String>();
            this.Metadata = new Map<String, String>();
            this.Parameters = new Map<String, String>();
        }        
    }

    public static Map<String,String> convertMapKeysTolower(Map<String,String> v){
      Map<String,String> newMap = new  Map<String,String> ();
      for(String key : v.keySet()){
         newMap.put(key.toLowerCase(),v.get(key));
      }
      return newMap;
    }
    
    public static string TrimSlashesFromBegining( String arg ){
        if ( arg != null && arg.Length() > 0 && slashes.contains(arg.left(1))){
            if ( arg.length() > 1 ){
                arg = arg.substring(1, arg.length() ); 
            }
            else {
                arg = '';
            }
        }
        return arg;
    }

    public static string UriEncode( String arg ){
        return EncodingUtil.urlEncode(arg,'UTF-8');
    }

    public class GetS3PreSignedRequest extends AWSPreSignedRequest
    {
        public GetS3PreSignedRequest()
        {
            this.Verb = HttpMethod.Get;
            this.Protocol = AWSRequestService.Protocol.Https;
        }

        public String UploadId { get; set; }

        public String PartNumber { get; set; }

        public Integer TotalPartCount { get; set; }
        
        public String Key { get; set; }

        public String BucketName { get; set; }

        public String ContentType { get; set; }

        public MultiPartAction MultiPartAction { get; set; }

        public String Endpoint ( String region ) {  
            return AWSRequestService.GetS3Endpoint(bucketName, region);  
        }
    }
}
