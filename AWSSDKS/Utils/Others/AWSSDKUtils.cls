public class AWSSDKUtils {
    static final Set<String> slashes = new Set<String>{'/','\\'};

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
}
