// ===============================
// AUTHOR           : Goutam malakar
// CREATE DATE      : 01/23/2021
// PURPOSE          : Static methods related to AWS4 signer
// SPECIAL NOTES    :
// ===============================

public class AWSSignerUtils {

    static final String EmptyBodySha256 = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
    public static final String AWSSchema = 'AWS4';
    static final String Algorithm  = 'HMAC-SHA256';
    public static final String AWS4AlgorithmTag  = AWSSchema + '-' + Algorithm;
    static final String Terminator = 'aws4_request';
    static final String MacAlorithm = 'hmacSHA256';   
    static final String lineBreak ='\n';
    static final String Slash = '/';
    static final String HashAlorithm = 'SHA-256';   

    public static String getCanonicalpath( Url requestUrl ){    
        String path = requestUrl.getPath().toLowerCase();

        if ( String.isBlank( path ) ){
            path = '/';
        }
        else{
            List<String> splits = path.split('/');
            for (Integer i = 0; i < splits.size(); i++) {
                splits[i] = uriEncode(splits[i]);
            }    
            path = String.join(splits, '/');
        }
        return path;     
    }

	/**
	* Generate the AWS signing key.
	*/
	public static Blob getSigningKey( Datetime signedAt, String secretKey, String region, String service ) {
        Blob kSecret = Blob.valueOf( AWSSchema + secretKey);
		Blob kDate = toHmacSha256(kSecret, getDate(signedAt));
		Blob kRegion = toHmacSha256(kDate, region);       
        Blob kService = toHmacSha256(kRegion, service);
        Blob kSigning = toHmacSha256(kService, Terminator);
		return kSigning;
    }

    /**
	* Generate string to sign.
	*/
	public static String getStringToSign( String alogorithmUsed, Datetime signedAt, String scope, String hashedCononicalrequest ) {
        return  alogorithmUsed + lineBreak + getTimestamp(signedAt) + lineBreak + scope + lineBreak + hashedCononicalrequest;
    }

    /**
	* get authorized signature.
	*/
	public static String getSignature( String stringToSign, Blob signingKey ) {
        return toHexEncode(toHmacSha256(signingKey, stringToSign));
    }
    
    /**
	* get scope of the service.
	*/
	public static String getScope( Datetime signedAt, String region, String service ) {
        if( String.isBlank(region) ){
            region = 'us-east-1';
        }
		return getDate( signedAt ) + '/' + region + '/' + service + '/aws4_request';
	}

    /**
	* get hashed payload.
	*/
	public static String getHashedPayload( String payload )
    {
        if( String.isBlank(payload) ){
            return EmptyBodySha256;
        }
        return getHashedString( payload, false );
    }

    /**
	* get hashed string.
	*/
	public static String getHashedString( String stringToHash, Boolean lowerCase ){
        return ToHexEncode(ToHash(stringToHash), lowercase);
    }

    /**
	* get hashed blob.
	*/
	public static String getHashedBlob( Blob blobToHash, Boolean lowerCase ){
        String hashedString = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', blobToHash));
        if( lowerCase ){
            hashedString = hashedString.toLowerCase();
        }
        return hashedString;
    }

    /**
	* get sorted query string.
	*/
	public static String getSortedQueryString( Url requestUrl ){
        STring sortedQueryString = '';
        String query = requestUrl.getQuery();
        if ( String.isNotBlank( query ) ){
            System.PageReference ref = new System.PageReference( query );
            Map<String, String> params = ref.getParameters();
            if ( params != null && params.size() > 0 ){
                AWSCollection.MapIngnoreCase sortedParams = new AWSCollection.MapIngnoreCase();
                for (String key : params.keySet()){
                    sortedParams.Add(key, params.get(key));               
                }
                List<String> paramList = new List<String>();
                for (String k : sortedParams.sortedKeySet() ){
                    String val = uriEncode( sortedParams.get(k) );
                    paramList.add(uriEncode( k )+'='+val);      
                }
                sortedQueryString = String.join(paramList, '&');
            }
        }
        return sortedQueryString;
    }
    
    /**
	* encode url.
	*/
	public static string uriEncode( String arg ){
        return EncodingUtil.urlEncode(arg,'UTF-8');
    }
    /**
	* Returns the current date in String format (YYYYMMDD)
	*/
	public static String getDate( Datetime dtime ) {
        return String.valueOf(dtime.yearGmt()) + 
				getString(dtime.monthGmt()) + 
                getString(dtime.dayGmt());
	}

	/**
	* Returns the current timestamp in ISO format (YYYYMMDDTHHMMSSZ)
	*/
	public static String getTimestamp(  Datetime dtime ) {
       return getString(dtime.yearGmt()) + 
				getString(dtime.monthGmt()) + 
				getString(dtime.dayGmt()) + 'T' + 
				getString(dtime.hourGmt()) + 
				getString(dtime.minuteGmt()) + 
				getString(dtime.secondGmt()) + 
                'Z';
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

    public static String compressSpaces(String data){
        if ( data == null ) {
            return null;           
        }
        if ( data.length() == 0  ) {
            return '';           
        }

        return data.normalizeSpace();
    }
    
    public static Blob toHash( Blob data) 
    {
        return Crypto.generateDigest(HashAlorithm, data);
    }

    public static Blob toHash( String data) 
    {
        return Crypto.generateDigest(HashAlorithm, Blob.valueOf(data));
    }

    public static String toHexEncode( Blob data, Boolean lowercase) 
    {
        String hex = EncodingUtil.convertToHex(data);
        if ( lowercase )
            hex = hex.toLowerCase();

        return hex.replace('-', '');
    }

    public static String toHexEncode( String data, Boolean lowercase) 
    {
        return toHexEncode( Blob.valueOf(data), lowercase );
    }

    public static String toHexEncode( Blob data) 
    {
       return toHexEncode( data, false );
    }

    public static String toHexEncode( String data) 
    {
        return toHexEncode( Blob.valueOf(data), false );
    }
    
    public static Blob toHmacSha256(  Blob key, String data )
    {
        return Crypto.generateMac( MacAlorithm, Blob.valueOf(data), key);
    }
    
}