public with sharing class AWSS3Client extends AWSServiceClient {

        /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSS3Client( AWSClientConfig clientConfig  ) {
        super( clientConfig );
        this.Service = 's3';
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    */
    public AWSS3Client( String accessKey, String secretKey ) {
        super( accessKey, secretKey );
        this.Service = 's3';
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSS3Client( String accessKey, String secretKey, String token ) {
        super( accessKey, secretKey, token );
        this.Service = 's3';
    }
    

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    *   region => region 
    */
    public AWSS3Client( String accessKey, String secretKey, String token, string region ) {
        super( accessKey, secretKey, token, region );
        this.Service = 's3';
    }

    /**
	* To get s3 presigned URL.
	* Parameters: 
	*   functionName => The name of your function
	*   method => The HTTP method (GET, POST, PATCH, etc.)
	*   content => The request content
	*   stage => The stage of your API, as defined in your API Gateway settings (prod, beta, etc.)
	*/
	public string  getPresignedUrl( AWSRequestService.GetS3PreSignedRequest request ) {
        
        long timeSpan = request.ExpiresIn;
        if ( timeSpan == null || timeSpan <= 0 ){
            timeSpan = 60;
        }
        String resource = AWSRequestService.TrimSlashesFromBegining(request.Key);
        String delim = '?';
        if( String.isNotBlank(request.UploadId) && String.isNotBlank(request.PartNumber) ){
            resource += String.format('?uploadId={0}&partNumber={1}', new List<String>{ request.UploadId, String.valueOf( request.PartNumber ) });
            delim = '&';
            timeSpan=3600;
            Integer timeOfTimeSpan = Integer.valueOf(request.TotalPartCount) - Integer.valueOf(request.PartNumber) + 1;
            if ( timeOfTimeSpan > 1 )
                timeSpan = 3600 * timeOfTimeSpan;
        }
        if ( request.MultiPartAction == AWSRequestService.MultiPartAction.CMP){
            request.Verb = AWSRequestService.HttpMethod.Put;
            if( String.isNotBlank(request.UploadId) ){
                resource += String.format('?uploadId={0}', new List<String>{ request.UploadId});
                delim = '&';
            }
            request.setHeader('Content-Type', request.ContentType);
        }
        else if ( request.MultiPartAction == AWSRequestService.MultiPartAction.AMP){
            request.Verb = AWSRequestService.HttpMethod.Del;
            if( String.isNotBlank(request.UploadId) ){
                resource += String.format('?uploadId={0}', new List<String>{ request.UploadId});
                delim = '&';
            }
        }
        this.HttpMethod = request.Verb;
        this.ContentType = request.ContentType;
        this.Headers = request.Headers;
        this.Metadata = request.Metadata;
        this.Parameters = request.Parameters;
        this.RequestUrl = new Url(request.Endpoint( this.Config.Region ) + '/' + resource );
        this.HttpMethod = request.Verb;
        this.Content = request.Content;
        this.ApiHost = this.RequestUrl.getHost();
        this.ResourcePath = this.RequestUrl.getPath();
        this.IsQueryString = true;
        this.QueryString = this.RequestUrl.getQuery();
        //return ResourcePath;
        return this.getSignedQueryString();
	}

}