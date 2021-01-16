public with sharing class AWSServiceClient {
    
    private AWSClientConfig config = null;
    private final String ALGORITHM = 'AWS4-HMAC-SHA256';
    private string signedHeader = '';
    private Datetime dateTime = Datetime.now();
    private String contentType = 'application/x-www-form-urlencoded';
	private String d;
	private String timestamp;
	private String scope;
    private String canonicalRequest;
    private string signedHeader = '';
    private String canonicalHeaders;
    private String canonicalQueryString;
    private Url requestUrl;
    private Boolean isQueryString = false;
    private Integer expiresin = 30;
    
    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSServiceClient( AWSClientConfig clientConfig  ) {
        this.config = config;
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    */
    public AWSServiceClient( String accessKey, String secretKey ) {
        config = new AWSClientConfig( accessKey, secretKey );
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSServiceClient( String accessKey, String secretKey, String token ) {
        config = new AWSClientConfig( accessKey, secretKey, token );
    }
    

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    *   region => region 
    */
    public AWSServiceClient( String accessKey, String secretKey, String token, string region ) {
        config = new AWSClientConfig( accessKey, secretKey, token );
        config.Region = region;
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
    public AWSServiceClient( String accessKey, String secretKey, String token, string region, string service ) {
        config = new AWSClientConfig( accessKey, secretKey, token );
        config.Region = region;
        config.Service = service;
    }


    /**
	* Property
	* base url
    */
    public String ApiHost { get; set; }

    /**
	* Property
	* base api id
    */
    public String ApiId { get; set; }

    /**
	* Property
	* base api id
    */
    public String Service 
    { 
        get { return config.Service; }
        set { config.Service = value; } 
    }

    /**
	* Property
	* service
    */
    public String ContentType 
    { 
        get { return this.contentType; }
        set { this.contentType = value; } 
    }

    /**
	* Property
	* method
    */
    public AWSRequestService.HttpMethod HttpMethod{ get; set; }

    /**
	* Property
	* ResourcePath
    */
    public String ResourcePath { get; set; }

    public String QueryString { get; set; }

    private Blob Content { get; set; }

    Map<String, String> headers  = new Map<String, String>();

    Map<String, String> metadata  = new Map<String, String>();

    Map<String, String> parameters  = new Map<String, String>();
    
    private void initialize()
    {
        this.dateTime = Datetime.now();
        this.d = this.getDate();
        this.timestamp = this.getTimestamp();
        this.scope = this.getScope();
        this.setHeaders();
        this.setCanonicalHeaders();
        this.setCanonicalQueryString();
        this.canonicalRequest = this.getCanonicalRequest();
        this.signedString = this.getSignature();
    }
    
    private void setHeaders()
    {
        this.setHeader('Host', this.host);
        this.setHeader('X-Amz-Date', this.timestamp);
        if ( String.isNotBlank(this.config.Token))
            this.setHeader('X-Amz-Security-Token', this.config.Token);        
        if ( String.isNotBlank(this.contentType))
            this.setHeader('Content-Type', this.contentType);        
    }
    
    public void setHeader( String key, String value)   
    {
        this.headers.put(key, value);
    }

	/**
	* Generate the authorization header for the list bucket operation.
	*/
	private String getAuthHeader() {
		String authHeader = this.ALGORITHM + ' ';
		authHeader += 'Credential=' + this.config.AccessKey + '/' + this.scope + ', ';
		authHeader += 'SignedHeaders=' + this.signedHeader;
		authHeader += 'Signature=' + this.signedString;
		return authHeader;
	}

	/**
	* Construct the AWS scope parameter.
	*/
	private String getScope() {
		return this.d + '/' + this.config.Region + '/' + this.Service + '/aws4_request';
	}


    private String getCanonicalRequest()
    {
        return this.getHttpRequestMethod() + '\n' +
            this.getCanonicalURI() + '\n' +
            this.getCanonicalQueryString() + '\n' +
            this.getCanonicalHeaders() + '\n' + 
            this.getSignedHeaders() + '\n' +
            this.getPayload();
    }

    private String getHttpRequestMethod()
    {
        return this.HttpMethod;
    }

    private String getCanonicalURI()
    {
        String canonicalUri = '/';
        if ( String.isNotBlank( this.ResourcePath ) ){
            List<String> encodedPath = new List<String>();
            for( String p : this.ResourcePath.split('/') ){
                encodedPath.add(this.getUrlEncodedString(p));
            }
            canonicalUri = String.join(encodedPath, '/');
        }
        
        //headers

        return canonicalUri;
    }
    private void setCanonicalQueryString()
    {
        canonicalQueryString = '';
        if ( String.isNotBlank( this.QueryString ) ){
            System.PageReference ref = new System.PageReference( this.QueryString );
            Map<String, String> params = ref.getParameters();
            if( params != null && params.size() > 0 ){
                List<String> sortedHeader = sortedKeys( params );
                List<String> paramList = new List<String>();
                for ( String k : sortedHeader ){
                    String val = this.headers.get(k).escapeHtml4();
                    paramList.add(k+'='+val);
                }
                canonicalQueryString = String.join(paramList, '&');
            }
        }
        if( this.isQueryString ){
            canonicalQueryString += '&X-Amz-Algorithm=' + ALGORITHM;
            canonicalQueryString += '&X-Amz-Credential=' + this.config.AccessKey + '/' + this.scope;
            canonicalQueryString += '&X-Amz-Date=' + this.timestamp;
            canonicalQueryString += '&X-Amz-Expires=' + String.valueOf( this.expiresin);
            canonicalQueryString += '&X-Amz-SignedHeaders=' + this.signedHeader;   
        }
    }
    
    private String getCanonicalQueryString()
    {
        return canonicalQueryString;
    }

    /*
    CanonicalHeaders =
    CanonicalHeadersEntry0 + CanonicalHeadersEntry1 + ... + CanonicalHeadersEntryN
    CanonicalHeadersEntry =
    Lowercase(HeaderName) + ':' + Trimall(HeaderValue) + '\n'
    */

    private void setCanonicalHeaders()
    {
        canonicalHeaders = '';
        List<String> sortedHeader = sortedKeys( this.headers );
        for ( String k : sortedHeader ){
            String hdr = k.toLowerCase();
            String val = this.headers.get(k).trim();

            canonicalHeaders += hdr+':'+val+'\n';
            
            if ( signedHeader.length() > 0 )
                signedHeader += ';';

            signedHeader += hdr;            
        }
        canonicalHeaders;
    }
    
    private String getCanonicalHeaders()
    {
        return canonicalHeaders;
    }

    private String getSignedHeaders()
    {
        return signedHeader;
    }

    private String getPayload()
    {
        if( this.Content = null ){
            this.Content = Blob.valueOf('');
        }
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(this.Content))).toLowerCase();
    }

    private String getUrlEncodedString( String path ){
        //Each path segment must be URI-encoded twice (except for Amazon S3 which only gets URI-encoded once)
        if ( this.Service.toLowerCase() = 's3' ){
            return EncodingUtil.urlEncode(path,'UTF-8');
        }
        else {
            return EncodingUtil.urlEncode(EncodingUtil.urlEncode(path,'UTF-8'), 'UTF-8' );
        }
    }
   
    /*
    Static methods
    */
    private static List<String> sortedKeys( Map<String, String> collection ){
        List<String> sortedList = new List<String>();
        if( collection != null && collection.size() > 0 ){
            for ( String key : collection.keySet() ){
                sortedList.add(key);
            }
        }
        sortedList.sort();
        return sortedList;
    }


	/**
	* Returns the current date in string format (YYYYMMDD)
	*/
	private String getDate() {
		return String.valueOf(this.dateTime.yearGmt()) + 
				this.getString(this.dateTime.monthGmt()) + 
				this.getString(this.dateTime.dayGmt());
	}

	/**
	* Returns the current timestamp in ISO format (YYYYMMDDTHHMMSSZ)
	*/
	private String getTimestamp() {
		return this.getString(this.dateTime.yearGmt()) + 
				this.getString(this.dateTime.monthGmt()) + 
				this.getString(this.dateTime.dayGmt()) + 'T' + 
				this.getString(this.dateTime.hourGmt()) + 
				this.getString(this.dateTime.minuteGmt()) + 
				this.getString(this.dateTime.secondGmt()) + 
				'Z';
	}

	/**
	* Generate the string to sign for API Gateway authorization.
	*/
	private Blob getStringToSign() {
		String stringToSign = this.ALGORITHM + '\n' + 
				this.timestamp + '\n' + 
				this.scope + '\n' + 
				EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(this.canonicalRequest)));
		return Blob.valueOf(stringToSign);
	}

	/**
	* Generate the request signature
	*/
	private String getSignature() {
		return EncodingUtil.convertToHex(Crypto.generateMac('hmacSHA256', this.getStringToSign(), this.getSigningKey()));
	}

	/**
	* Generate the AWS signing key.
	*/
	private Blob getSigningKey() {
		Blob kDate = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.d), Blob.valueOf('AWS4' +this.config.SecretKey));
		Blob kRegion = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.config.Region), kDate);
		Blob kService = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.Service), kRegion);
		Blob kSigning = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'), kService);
		return kSigning;
    }

    
    /**
	* To invoke aws lambda.
	* Parameters: 
	*   functionName => The name of your function
	*   method => The HTTP method (GET, POST, PATCH, etc.)
	*   content => The request content
	*   stage => The stage of your API, as defined in your API Gateway settings (prod, beta, etc.)
	*/
	public HttpResponse sendLambdaRequest(String functionName, AWSRequestService.HttpMethod method , String content, String stage) {
        this.Service = 'lambda';
        this.ResourcePath = '/' + stage + '/' + functionName;
        this.requestUrl = new Url(AWSRequestService.GetApiEndpoint(functionName, this.Service, this.config.Region, stage));
        this.HttpMethod = method;
        this.Content = Blob.valueOf(content);
        this.ApiHost = this.requestUrl.getHost();
        this.initialize();
		HttpRequest req = this.getRequest();
		Http http = new Http();
		return http.send(req);
	}

    /**
	* To send api request.
	* Parameters: 
	*   functionName => The name of your function
	*   method => The HTTP method (GET, POST, PATCH, etc.)
	*   content => The request content
	*   stage => The stage of your API, as defined in your API Gateway settings (prod, beta, etc.)
	*/
	public HttpResponse sendApiRequest(String baseUrl, String functionName, AWSRequestService.HttpMethod method , String content, String environment) {
		this.ResourcePath = '/' + environment + '/' + functionName;
        this.requestUrl = new Url(baseUrl, + this.ResourcePath );
        this.HttpMethod = method;
        this.Service = 'execute-api';
        this.Content = Blob.valueOf(content);
        this.ApiHost = this.requestUrl.getHost();
        this.initialize();
		HttpRequest req = this.getRequest();
		Http http = new Http();
		return http.send(req);
	}

	/**
	* Generate the HTTP request to getcr the list of files in the specified folder.
	*/
	private HttpRequest getRequest() {
		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.requestUrl.toExternalForm());
		req.setMethod(this.HttpMethod);
        for(String key : this.headers.keySet()){
            req.setHeader(key, this.headers.get(key));
        }
		req.setHeader('Authorization', this.getAuthHeader());
		req.setBody(this.content);

		return req;
	}

	/**
	* Convert a date/time component to string format (prependig a '0' if necessary).
	*/
	private String getString(Integer comp) {
		String s = String.valueOf(comp);
		if (s.length() == 1) {
			return '0'+s;
		}
		return s;
	}

}
