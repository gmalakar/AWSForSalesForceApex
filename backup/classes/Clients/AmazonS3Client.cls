public class AmazonS3Client extends AmazonServiceClient {
    public AmazonS3Client( AmazonS3Client config ) {

    }
    
    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AmazonS3Client( AWSClientConfig clientConfig  ) {
        super( clientConfig );
        this.Service = 's3';
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    */
    public AmazonS3Client( String accessKey, String secretKey ) {
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
    public AmazonS3Client( String accessKey, String secretKey, String token ) {
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
    public AmazonS3Client( String accessKey, String secretKey, String token, string region ) {
        super( accessKey, secretKey, token, region );
        this.Service = 's3';
    }
    
    private String GetPreSignedURLInternal( GetS3PreSignedRequest getPreSignedUrlRequest ){
        if ( this.Config == null ){
            throw new Exception( 'Config must be set, cannot call method anonymously' );
        }
        if ( String.isBlank( this.Config.AccessKey) ){
            throw new Exception( 'Access key must be specified, cannot call method anonymously' );
        }
        if ( String.isBlank( this.Config.SecretKey) ){
            throw new Exception( 'Missing Secret Key, cannot call method anonymously' );
        }
        if ( getPreSignedUrlRequest == null ){
            throw new Exception( 'The PreSignedUrlRequest specified is null!' );
        }
        if ( !getPreSignedUrlRequest.IsSetExpires() ){
            throw new Exception( 'The Expires specified is null!' );
        }

        SignerRequest request = new SignerRequest(getPreSignedUrlRequest, '"AmazonS3');

        request.HttpMethod = getPreSignedUrlRequest.Verb;
        HeaderCollection headers = getPreSignedUrlRequest.Headers;

        for ( String k : headers.Keys ){
            request.Headers.put(k, headers.get(k));
        }

        for ( String k : getPreSignedUrlRequest.Metadata.Keys ){
            request.Headers.put(k, getPreSignedUrlRequest.Metadata.get(k));
        }

        if (String.isNotBlank(this.Config.Token)){
            request.Headers[HeaderKeys.XAmzSecurityTokenHeader] = this.Config.Token;            
        }
        
        MapIngnoreCase queryParameters = request.Parameters;

        List<String> uriResourcePath  = new List<String>{'/'};

        if (String.isNotBlank(getPreSignedUrlRequest.BucketName)){
            uriResourcePath.add(S3Transforms.ToStringValue(getPreSignedUrlRequest.BucketName));
        }

        if (String.isNotBlank(getPreSignedUrlRequest.Key)){
            if ( uriResourcePath.size() > 1 ){
                uriResourcePath.add('/');
            }
            uriResourcePath.add(S3Transforms.ToStringValue(getPreSignedUrlRequest.BucketName));
        }

        if ( getPreSignedUrlRequest.ExpiresIn > AWS4Signer.MaxAWS4PreSignedUrlExpiry ){
            throw new Exception( 'The maximum expiry period for a presigned url using AWS4 signing is ' + AWS4Signer.MaxAWS4PreSignedUrlExpiry + ' seconds' );
        }

        queryParameters.put(AWS4Signer.XAmzExpires, String.valueOf(getPreSignedUrlRequest.ExpiresIn));

        if ( String.isNotBlank( this.Config.Token ) ){
            queryParameters.put('x-amz-security-token', this.Config.Token);
        }
        if (getPreSignedUrlRequest.IsSetUploadId()){
            request.AddSubResource('uploadId', getPreSignedUrlRequest.UploadId);
        }
        if (getPreSignedUrlRequest.IsSetPartNumber()){
            request.AddSubResource('partNumber', S3Transforms.ToStringValue( getPreSignedUrlRequest.PartNumber) );
        }

        ResponseHeaderOverrides responseHeaderOverrides = getPreSignedUrlRequest.ResponseHeaderOverrides;
        if (String.isNotBlank(responseHeaderOverrides.CacheControl)){
            queryParameters.put('response-cache-control', responseHeaderOverrides.CacheControl);
		}
        if (String.isNotBlank(responseHeaderOverrides.ContentType)){
            queryParameters.put('response-content-type', responseHeaderOverrides.ContentType);
        }
        if (String.isNotBlank(responseHeaderOverrides.ContentLanguage)){
            queryParameters.put('response-content-language', responseHeaderOverrides.ContentLanguage);
        }
        if (String.isNotBlank(responseHeaderOverrides.Expires)){
            queryParameters.put('response-expires', responseHeaderOverrides.Expires);
        }
        if (String.isNotBlank(responseHeaderOverrides.ContentDisposition)){
            queryParameters.put('response-content-disposition', responseHeaderOverrides.ContentDisposition);
        }
        if (String.isNotBlank(responseHeaderOverrides.ContentEncoding)){
            queryParameters.put('response-content-encoding', responseHeaderOverrides.ContentEncoding);
        }

        for ( String k : getPreSignedUrlRequest.Parameters.Keys ){
            queryParameters.put(k, getPreSignedUrlRequest.Parameters.get(k));
        }

        request.ResourcePath = String.join(uriResourcePath, '');

        SignerRequest aws4Signer = new SignerRequest(  );
    }
}
