public abstract class AWSUtils {

    static final Set<String> slashes = new Set<String>{'/','\\'};

   //Http method variables
    public class HttpMethods {
        public final String Get = 'GET';
        public final String Post = 'POST';
        public final String Put = 'PUT';
        public final String Del = 'DELETE';
        public final String Head = 'HEAD';
        public final String Patch = 'PATCH';
    }
    
    public static HttpMethods HttpMethod = new HttpMethods();

    public static Blob BlobCopy( Blob data ) 
    {
        return EncodingUtil.base64Decode(EncodingUtil.base64Encode(data));
    }

    public static Map<String,String> convertMapKeysTolower(Map<String,String> v){
      Map<String,String> newMap = new  Map<String,String> ();
      for(String key : v.keySet()){
         newMap.put(key.toLowerCase(),v.get(key));
      }
      return newMap;
    }
    
    public static String TrimSlashesFromBegining( String arg ){
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
    
    public static String UriEncode( String arg, Boolean path ){
        return EncodingUtil.urlEncode(arg,'UTF-8');
    }

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
