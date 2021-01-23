public class GetS3PreSignedRequest {
    public GetS3PreSignedRequest()
    {
        this.Verb = AWSSDKUtils.HttpVerb.Get;
        this.Protocol = AWSSDKUtils.Protocol.Https;
    }

    private HeaderCollection _headersCollection = new HeaderCollection();
    private MetadataCollection _metadataCollection = new MetadataCollection();
    private ParameterCollection _parameterCollection = new ParameterCollection();
    
    private ResponseHeaderOverrides _responseHeaderOverrides = new ResponseHeaderOverrides();
    
    private Long lexpiresIn = 60;

    public AWSSDKUtils.HttpVerb Verb { get; set; }
    
    public AWSSDKUtils.Protocol Protocol { get; set; }
    
    public String UploadId { get; set; }

    public Integer PartNumber { get; set; }

    public Integer TotalPartCount { get; set; }
    
    public String Key { get; set; }

    public String Region { get; set; }

    public String BucketName { get; set; }

    public Long ExpiresIn 
    { 
        get { return lexpiresIn;}
        set { lexpiresIn = value;}
    }


    public String ContentType 
    { 
        get { return this._headersCollection.ContentType; }
        set { this._headersCollection.ContentType = value; } 
    }

    public MultiPartAction MultiPartAction { get; set; }

    public Url Endpoint { get { return new Url( AWSSDKUtils.GetS3Endpoint(this.BucketName, this.Region) );} }
    
    public Boolean IsSetExpires()
    {
        return this.lexpiresIn != null;
    }
    
    public Boolean IsSetKey()
    {
        return String.isNotBlank( this.Key );
    }
    
    public Boolean IsSetBucketName()
    {
        return String.isNotBlank( this.BucketName );
    }

    public Boolean IsSetPartNumber()
    {
        return String.isNotBlank( String.valueOf( this.PartNumber ) );
    }

    public Boolean IsSetUploadId()
    {
        return String.isNotBlank( this.UploadId );
    }

    public HeaderCollection Headers 
    { 
        get 
        { 
            if ( _headersCollection == null ){
                _headersCollection = new HeadersCollection();
            }
            return _headersCollection;
        }
        set { _headersCollection = value;}
    }

    public MetadataCollection Metadata 
    { 
        get 
        { 
            if ( _metadataCollection == null ){
                _metadataCollection = new MetadataCollection();
            }
            return _metadataCollection;
        }
        set { _metadataCollection = value;}
    }

    public ParameterCollection Parameter 
    { 
        get 
        { 
            if ( _parameterCollection == null ){
                _parameterCollection = new ParameterCollection();
            }
            return _parameterCollection;
        }
        set { _parameterCollection = value;}
    }

    public ResponseHeaderOverrides ResponseHeaderOverrides 
    { 
        get 
        { 
            if ( _responseHeaderOverrides == null ){
                _responseHeaderOverrides = new ResponseHeaderOverrides();
            }
            return _responseHeaderOverrides;
        }
        set { _responseHeaderOverrides = value;}
    }

}
