public with sharing virtual class AWSServiceClient {
    
    protected AWSClientConfig Config = null;
    protected Url RequestUrl;
    protected Boolean IsQueryString = false;
    protected Integer Expiresin = 30;
        
    private final String ALGORITHM = 'AWS4-HMAC-SHA256';
    private string signedHeader = '';
    private Datetime dtime = Datetime.now();
    private String lcontentType = 'application/x-www-form-urlencoded';
	private String d;
	private String timestamp;
	private String scope;
    private String canonicalRequest;
    private String canonicalHeaders;
    private String canonicalQueryString;
    private String signedString;
    private AWSRequestService.Protocol protocol = AWSRequestService.Protocol.Https; 
    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSServiceClient( AWSClientConfig clientConfig  ) {
        this.Config = clientConfig;
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    */
    public AWSServiceClient( String accessKey, String secretKey ) {
        Config = new AWSClientConfig( accessKey, secretKey );
    }

    /**
	* Constructor
	* Parameters: 
	*   accessKey => access key
	*   secretKey => secret key
    *   token => token
    */
    public AWSServiceClient( String accessKey, String secretKey, String token ) {
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
    public AWSServiceClient( String accessKey, String secretKey, String token, string region ) {
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
    public AWSServiceClient( String accessKey, String secretKey, String token, string region, string service ) {
        Config = new AWSClientConfig( accessKey, secretKey, token );
        Config.Region = region;
        Config.Service = service;
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
        get { return Config.Service; }
        set { Config.Service = value; } 
    }

    /**
	* Property
	* service
    */
    public String ContentType 
    { 
        get { return this.lcontentType; }
        set { this.lcontentType = value; } 
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

    protected Blob Content { get; set; }

    protected Map<String, String> Headers  = new Map<String, String>();

    protected Map<String, String> Metadata  = new Map<String, String>();

    protected Map<String, String> Parameters  = new Map<String, String>();
    
    protected void initialize()
    {
        this.dtime = Datetime.now();
        this.d = this.getDate();
        this.timestamp = this.getTimestamp();
        this.scope = this.getScope();
        this.setHeaders();
        this.setCanonicalHeaders();
        this.setCanonicalQueryString();
        this.canonicalRequest = this.getCanonicalRequest();
        this.signedString = this.getSignature();
    }
    
    protected String getSignedQueryString(){
        this.initialize();
        return this.RequestUrl.toExternalForm() + '?' + canonicalQueryString + '&X-Amz-Signature=' + this.signedString;
    }
    
	private String getStringToSignDebug() {
		String stringToSign = this.ALGORITHM + '\n' + 
				this.timestamp + '\n' + 
				this.scope + '\n' + 
				this.canonicalRequest;
		return stringToSign;
    }
    
    protected String getStringTosignToCheck(){
        this.initialize();
        return getStringToSignDebug();
    }
    private void setHeaders()
    {
        this.setHeader('Host', this.ApiHost);
        //this.setHeader('Host', 's3.us-east-1.amazonaws.com');
        this.setHeader('X-Amz-Date', this.timestamp);
        if ( String.isNotBlank(this.Config.Token))
            this.setHeader('X-Amz-Security-Token', this.Config.Token);        
        if ( String.isNotBlank(this.lcontentType))
            this.setHeader('Content-Type', this.lcontentType);
    }
    
    public void setHeader( String key, String value)   
    {
        this.Headers.put(key, value);
    }

    /**
	* Generate the authorization header for the list bucket operation.
	*/
	private String getAuthHeader() {
		String authHeader = this.ALGORITHM + ' ';
		authHeader += 'Credential=' + this.Config.AccessKey + '/' + this.scope + ', ';
		authHeader += 'SignedHeaders=' + this.signedHeader;
		authHeader += 'Signature=' + this.signedString;
		return authHeader;
	}

	/**
	* Construct the AWS scope parameter.
	*/
	private String getScope() {
		return this.d + '/' + this.Config.Region + '/' + this.Service + '/aws4_request';
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
        return this.HttpMethod.name();
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
        
        if ( canonicalUri.length() > 1 )
            canonicalUri = AWSRequestService.TrimSlashesFromBegining( canonicalUri );
        return canonicalUri;
    }
    private void setCanonicalQueryString()
    {
        canonicalQueryString = '';
        if ( String.isNotBlank( this.QueryString ) ){
            System.PageReference ref = new System.PageReference( this.QueryString );
            Map<String, String> params = ref.getParameters();
            Map<String, String> paramsLowerKry = AWSRequestService.convertMapKeysTolower( this.Parameters );
            
            if ( paramsLowerKry.size() > 0 && params != null && params.size() > 0 ){
                for (String key : params.keySet()){
                    if( !paramsLowerKry.containsKey(key.toLowerCase()) )
                        this.Parameters.put(key, params.get(key));
                }
            }
            else if (  params != null && params.size() > 0 ){
                this.Parameters = params;
            }

        }
            
        if( this.Parameters != null && this.Parameters.size() > 0 ){
            List<String> sortedParam = sortedKeys( this.Parameters );
            List<String> paramList = new List<String>();
            for ( String k : sortedParam ){
                String val = this.Parameters.get(k).escapeHtml4();
                paramList.add(k.escapeHtml4()+'='+val);
            }
            canonicalQueryString = String.join(paramList, '&');
        }
        
        if( this.IsQueryString ){
            canonicalQueryString += '&' + encodedQueryString('X-Amz-Algorithm', ALGORITHM);
            canonicalQueryString += '&' + encodedQueryString('X-Amz-Credential', this.Config.AccessKey + '/' + this.scope);
            canonicalQueryString += '&' + encodedQueryString('X-Amz-Date', this.timestamp);
            canonicalQueryString += '&' + encodedQueryString('X-Amz-Expires', String.valueOf( this.Expiresin));
            canonicalQueryString += '&' + encodedQueryString('X-Amz-SignedHeaders', this.signedHeader);   
        }
    }
    
    private String encodedQueryString( String key, String val ){
        return key.escapeHtml4() + '=' + val.escapeHtml4();
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
        List<String> sortedHeader = sortedKeys( this.Headers );
        for ( String k : sortedHeader ){
            String hdr = k.toLowerCase();
            String val = this.Headers.get(k).trim();
            
            Boolean addHeader = !( this.IsQueryString && hdr.startsWith('x-amz-') );
            if( addHeader ){
                canonicalHeaders += hdr+':'+val+'\n';
                
                if ( signedHeader.length() > 0 )
                    signedHeader += ';';

                signedHeader += hdr;
            }        
        }
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
        if( this.Content == null ){
            this.Content = Blob.valueOf('');
        }
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', this.Content)).toLowerCase();
    }

    private String getUrlEncodedString( String path ){
        //Each path segment must be URI-encoded twice (except for Amazon S3 which only gets URI-encoded once)
        if ( this.Service.toLowerCase() == 's3' ){
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
		return String.valueOf(this.dtime.yearGmt()) + 
				this.getString(this.dtime.monthGmt()) + 
				this.getString(this.dtime.dayGmt());
	}

	/**
	* Returns the current timestamp in ISO format (YYYYMMDDTHHMMSSZ)
	*/
	private String getTimestamp() {
		return this.getString(this.dtime.yearGmt()) + 
				this.getString(this.dtime.monthGmt()) + 
				this.getString(this.dtime.dayGmt()) + 'T' + 
				this.getString(this.dtime.hourGmt()) + 
				this.getString(this.dtime.minuteGmt()) + 
				this.getString(this.dtime.secondGmt()) + 
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
		Blob kDate = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.d), Blob.valueOf('AWS4' +this.Config.SecretKey));
		Blob kRegion = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.Config.Region), kDate);
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
        this.RequestUrl = new Url(AWSRequestService.GetApiEndpoint(functionName, this.Service, this.Config.Region, stage));
        this.HttpMethod = method;
        this.Content = Blob.valueOf(content);
        this.ApiHost = this.RequestUrl.getHost();
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
        this.RequestUrl = new Url(baseUrl + this.ResourcePath );
        this.HttpMethod = method;
        this.Service = 'execute-api';
        this.Content = Blob.valueOf(content);
        this.ApiHost = this.RequestUrl.getHost();
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
		req.setEndpoint(this.RequestUrl.toExternalForm());
		req.setMethod(this.HttpMethod.name());
        for(String key : this.Headers.keySet()){
            req.setHeader(key, this.Headers.get(key));
        }
		req.setHeader('Authorization', this.getAuthHeader());
		req.setBodyAsBlob(content);

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
