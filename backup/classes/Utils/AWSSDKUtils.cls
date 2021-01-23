public static class AWSSDKUtils {
    /// <summary>
    /// The ISO8601 Basic date/time format string. Used when parsing date objects
    /// </summary>
    public final String ISO8601BasicDateTimeFormat = 'yyyyMMdd\'T\'HHmmss\'Z\'';

    public final String ISO8601BasicDateFormat = 'yyyyMMdd';

    private static Set<String> slashes = new Set<String>{'/','\\'};

    private final String Slash = '/';
    /**
    * HttpMethod
    */
    public enum HttpMethod {GET, PUT, POST, DEL, PATCH}
    
    public enum HttpVerb {GET, PUT, POST, DEL}

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
    
    public static String ToHex( Blob data, Boolean lowercase) 
    {
        String hex = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', data));
        if ( lowercase )
            hex = hex.toLowerCase();

        return hex;
    }

    public static Blob BlobCopy( Blob data ) 
    {
        return EncodingUtil.base64Decode(EncodingUtil.base64Encode(data));
    }


    public static String CanonicalizeResourcePath(Url endpoint, String resourcePath, Boolean detectPreEncode, MapIngnoreCase pathResources, Integer marshallerVersion)
    {
        if ( endpoint != null)
        {
            String path = endpoint.getPath();

            if (String.isBlank(path) || path == Slash){
                path = '';
            }

            if (String.isNotBlank(resourcePath) && resourcePath.startsWith(Slash)){
                resourcePath = resourcePath.substring(1);
            }
            if (String.isNotBlank(resourcePath)){
                path = path + Slash + resourcePath;
            }
        }
/*
        if (string.IsNullOrEmpty(resourcePath))
            return Slash;

        
        
        IEnumerable<string> encodedSegments;
        if(marshallerVersion >= 2)
        {
            encodedSegments = AWSSDKUtils.SplitResourcePathIntoSegments(resourcePath, pathResources);
        }
        else
        {
            //split path at / into segments
            encodedSegments = resourcePath.Split(new char[] { SlashChar }, StringSplitOptions.None);                
        }
        
        var pathWasPreEncoded = false;
        if (detectPreEncode)
        {
            if (endpoint == null)
                throw new ArgumentNullException(nameof(endpoint), "A non-null endpoint is necessary to decide whether or not to pre URL encode.");

            // S3 is a special case.  For S3 skip the pre encode.
            // For everything else URL pre encode the resource path segments.
            if (!S3Uri.IsS3Uri(endpoint))
            {
                if(marshallerVersion >= 2)
                {
                    encodedSegments = encodedSegments.Select(segment => UrlEncode(segment, true).Replace(Slash, EncodedSlash));
                }
                else
                {
                    encodedSegments = encodedSegments.Select(segment => ProtectEncodedSlashUrlEncode(segment, true));
                }
                
                pathWasPreEncoded = true;
            }
        }

        var canonicalizedResourcePath = string.Empty;
        if(marshallerVersion >= 2)
        {
            canonicalizedResourcePath = AWSSDKUtils.JoinResourcePathSegments(encodedSegments, false);
        }
        else
        {
            // Encode for canonicalization
            encodedSegments = encodedSegments.Select(segment => UrlEncode(segment, false));

            // join the encoded segments with /
            canonicalizedResourcePath = string.Join(Slash, encodedSegments.ToArray());
        }
        
        // Get the logger each time (it's cached) because we shouldn't store it in a static variable.
        Logger.GetLogger(typeof(AWSSDKUtils)).DebugFormat("{0} encoded {1}{2} for canonicalization: {3}",
            pathWasPreEncoded ? "Double" : "Single",
            resourcePath,
            endpoint == null ? "" : " with endpoint " + endpoint.AbsoluteUri,
            canonicalizedResourcePath);
*/
        // /return canonicalizedResourcePath;
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

	/**
	* Returns the current date in String format (YYYYMMDD)
	*/
	public static String getDate( Datetime dtime ) {
        return String.valueOf(dtime.yearGmt()) + 
				this.getString(dtime.monthGmt()) + 
                this.getString(dtime.dayGmt());
	}

	/**
	* Returns the current timestamp in ISO format (YYYYMMDDTHHMMSSZ)
	*/
	public static String getTimestamp(  Datetime dtime ) {
       return this.getString(dtime.yearGmt()) + 
				this.getString(dtime.monthGmt()) + 
				this.getString(dtime.dayGmt()) + 'T' + 
				this.getString(dtime.hourGmt()) + 
				this.getString(dtime.minuteGmt()) + 
				this.getString(dtime.secondGmt()) + 
                'Z';
    }
    
    public static String UriEncode( String arg, Boolean path ){
        return EncodingUtil.urlEncode(arg,'UTF-8');
    }

    public static String CompressSpaces(String data){
        if ( data == null ) {
            return null;           
        }
        if ( data.length() == 0  ) {
            return '';           
        }

        return data.normalizeSpace();
    }
	/**
	* Convert a date/time component to String format (prependig a '0' if necessary).
	*/
	private static String getString(Integer comp) {
		String s = String.valueOf(comp);
		if (s.length() == 1) {
			return '0'+s;
		}
		return s;
	}

}
