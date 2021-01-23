public abstract class AmazonServiceClient {
    
    protected AmazonClientConfig Config = null;
    public AmazonServiceClient() {

    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AmazonServiceClient( AWSClientConfig clientConfig  ) {
        this.Config = clientConfig;
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    */
    public AmazonServiceClient( String accessKey, String secretKey ) {
        Config = new AWSClientConfig( accessKey, secretKey );
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AmazonServiceClient( String accessKey, String secretKey, String token ) {
        Config = new AWSClientConfig( accessKey, secretKey, token );
    }
    

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    *   region => region 
    */
    public AmazonServiceClient( String accessKey, String secretKey, String token, string region ) {
        Config = new AWSClientConfig( accessKey, secretKey, token );
        Config.Region = region;
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    *   region => region 
    *   service => service
    */
    public AmazonServiceClient( String accessKey, String secretKey, String token, string region, string service ) {
        Config = new AWSClientConfig( accessKey, secretKey, token );
        Config.Region = region;
        Config.Service = service;
    }
}
