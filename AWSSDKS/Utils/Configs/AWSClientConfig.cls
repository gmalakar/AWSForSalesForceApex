public class AWSClientConfig {

    private static String DEFAULT_TOKEN = null;
    
    private String DEFAULT_REGION = 'us-east-1';
    
    private String DEFAULT_SERVICE = 's3';
    /*
    Public properties
    */
    public String AccessKey { get; private set; }

    public String SecretKey { get; private set; }

    public String Token { get; private set; }

    public JSON Attributes { get; set; }

    public String Service { get; set; }
    
    public String Region { get; set; }

    public AWSClientConfig( String accessKey, String secretKey ) {
        this( accessKey, secretKey, DEFAULT_TOKEN );
    }

    public AWSClientConfig( String accessKey, String secretKey, String token ) {
        this.AccessKey = accessKey;
        this.SecretKey = secretKey;
        this.Token = token;
        this.Region = DEFAULT_REGION;
    }

}