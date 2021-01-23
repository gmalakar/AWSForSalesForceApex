public abstract class AmazonClientConfig {
    public AmazonClientConfig() {

    }
    private static String DEFAULT_TOKEN = null;

    private static Boolean _EnableUnicodeEncodingForObjectMetadata = false;
    
    private String DEFAULT_REGION = 'us-east-1';
    
    private String DEFAULT_SERVICE = 's3';
    /*
    Public properties
    */
    public String AccessKey { get; set; }

    public String SecretKey { get; set; }

    public String Token { get; set; }

    public JSON Attributes { get; set; }

    public String Service { get; set; }
    
    public String Region { get; set; }

    public static Boolean EnableUnicodeEncodingForObjectMetadata 
    { 
        get { return _EnableUnicodeEncodingForObjectMetadata; }
        set { _EnableUnicodeEncodingForObjectMetadata = value; } 
    }

    public AmazonClientConfig( String accessKey, String secretKey ) {
        this( accessKey, secretKey, DEFAULT_TOKEN );
    }

    public AmazonClientConfig( String accessKey, String secretKey, String token ) {
        this.AccessKey = accessKey;
        this.SecretKey = secretKey;
        this.Token = token;
        this.Region = DEFAULT_REGION;
    }
}
