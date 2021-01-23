public class AWSConfig {

    static final String DEFAULT_TOKEN = null;
    
    static final String DEFAULT_REGION = 'us-east-1';
    
    static final String DEFAULT_SERVICE = 's3';

    //abstract client config
    public abstract class ClientConfig {

        /*
        Public properties
        */
        public String AccessKey { get; private set; }

        public String SecretKey { get; private set; }

        public String Token { get; private set; }

        public JSON Attributes { get; set; }

        public String Service { get; set; }
        
        public String Region { get; set; }

        public Integer HttpTimeOut { get; set; }

        public ClientConfig( String accessKey, String secretKey ) {
            this( accessKey, secretKey, DEFAULT_TOKEN );
        }

        public ClientConfig( String accessKey, String secretKey, String token ) {
            this.AccessKey = accessKey;
            this.SecretKey = secretKey;
            this.Token = token;
            this.Region = DEFAULT_REGION;
            this.HttpTimeOut = 10000;
        }
    }

    //config for api gateway
    public class APIGateway extends ClientConfig {
        
        public String Stage { get; set; }

        public String ApiKey { get; set; }

        public String HttpMethod { get; set; }

        public APIGateway( String accessKey, String secretKey ) {
            super( accessKey, secretKey);
            this.Service = 'execute-api';
            this.HttpTimeOut = 30000;
            this.HttpMethod = AWSUtils.HttpMethod.Get;
        }

        public APIGateway( String accessKey, String secretKey, String token ) {
            super( accessKey, secretKey, token );
            this.Service = 'execute-api';
            this.HttpTimeOut = 30000;
            this.HttpMethod = AWSUtils.HttpMethod.Get;
        }
    }
}
