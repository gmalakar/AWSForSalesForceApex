public class SignerRequest {
    static final ParameterCollection lParametersCollection = new ParameterCollection();
    static final MapIngnoreCase _headers = new MapIngnoreCase();
    static final MapIngnoreCase _subResources = new MapIngnoreCase(StringComparer.OrdinalIgnoreCase);
    static final MapIngnoreCase _pathResources = new MapIngnoreCase(StringComparer.Ordinal);

    Url endpoint;
    String resourcePath;
    String serviceName;
    static final AmazonWebServiceRequest originalRequest;
    Blob content;
    Stream contentStream;
    String contentStreamHash;
    String httpMethod = 'POST';
    bool useQueryString = false;
    String requestName;
    String canonicalResource;
    Long originalStreamLength;
    Integer marshallerVersion = 1; //1 is the default version and must be used whenever a version is not specified in the marshaller.

    /// <summary>
    /// Constructs a new DefaultRequest with the specified service name and the
    /// original, user facing request object.
    /// </summary>
    /// <param name='request'>The orignal request that is being wrapped</param>
    /// <param name='serviceName'>The service name</param>
    public SignerRequest( AmazonWebServiceRequest request, String serviceName )
    {
        if (request == null) throw new IllegalArgumentException( 'request ');
        if (String.isBlank(serviceName)) throw new IllegalArgumentException('serviceName');

        this.serviceName = serviceName;
        this.originalRequest = request;
        this.requestName = this.originalRequest.Name;
        this.UseSigV4 = true;
        this.HostPrefix = String.Empty;
    }


    /// <summary>
    /// The name of the request
    /// </summary>
    public String RequestName
    {
        get { return this.requestName; }
    }


    /// <summary>
    /// Gets and sets the type of http request to make, whether it should be POST,GET or DELETE
    /// </summary>
    public String HttpMethod
    {
        get
        {
            return this.httpMethod;
        }
        set
        {
            this.httpMethod = value;
        }
    }

    /// <summary>
    /// Gets and sets a flag that indicates whether the request is sent as a query String instead of the request body.
    /// </summary>
    public bool UseQueryString
    {
        get
        {
            if (this.HttpMethod == 'GET')
                return true;
            return this.useQueryString;
        }
        set
        {
            this.useQueryString = value;
        }
    }

    /// <summary>
    /// Returns the original, user facing request object which this internal
    /// request object is representing.
    /// </summary>
    public AmazonWebServiceRequest OriginalRequest
    {
        get
        {
            return originalRequest;
        }
    }

    /// <summary>
    /// Returns a dictionary of the headers included in this request.
    /// </summary>
    public MapIngnoreCase Headers
    {
        get
        {
            return this._headers;
        }
    }


    /// <summary>
    /// Returns a dictionary of the parameters included in this request.
    /// </summary>
    //todo
    /*
    public MapIngnoreCase Parameters
    {
        get
        {
            return this.p;
        }
    }
    */

    /// <summary>
    /// Collection of parameters included in this request.
    /// </summary>
    public MapIngnoreCase ParameterCollection
    {
        get
        {
            return this.lParametersCollection;
        }
    }

    /// <summary>
    /// Returns the subresources that should be appended to the resource path.
    /// This is used primarily for Amazon S3, where object keys can contain '?'
    /// characters, making String-splitting of a resource path potentially 
    /// hazardous.
    /// </summary>
    public MapIngnoreCase SubResources
    {
        get
        {
            return this._subResources;
        }
    }

    /// <summary>
    /// Adds a new null entry to the SubResources collection for the request
    /// </summary>
    /// <param name='subResource'>The name of the subresource</param>
    public void AddSubResource(String subResource)
    {
        AddSubResource(subResource, null);
    }

    /// <summary>
    /// Adds a new entry to the SubResources collection for the request
    /// </summary>
    /// <param name='subResource'>The name of the subresource</param>
    /// <param name='value'>Value of the entry</param>
    public void AddSubResource(String subResource, String value)
    {
        _subResources.put(subResource, value);
    }

    /// <summary>
    /// Gets and Sets the endpoint for this request.
    /// </summary>
    public Uri Endpoint
    {
        get
        {
            return this.endpoint;
        }
        set
        {
            this.endpoint = value;
        }
    }

    /// <summary>
    /// Gets and Sets the resource path added on to the endpoint.
    /// </summary>
    public String ResourcePath
    {
        get
        {
            return this.resourcePath;
        }
        set
        {
            this.resourcePath = value;
        }
    }

    /// <summary>
    /// Returns the path resources that should be used within the resource path.
    /// This is used for services where path keys can contain '/'
    /// characters, making String-splitting of a resource path potentially 
    /// hazardous.
    /// </summary>
    public MapIngnoreCase PathResources
    {
        get
        {
            return this._pathResources;
        }
    }

    /// <summary>
    /// Adds a new entry to the PathResources collection for the request
    /// </summary>
    /// <param name='key'>The name of the pathresource with potential greedy syntax: {key+}</param>
    /// <param name='value'>Value of the entry</param>
    public void AddPathResource(String key, String value)
    {
        _pathResources.put(key, value);
    }

    /// <summary>
    /// Gets and Sets the version number for the marshaller used to create this request. The version number
    /// is used to support backward compatible changes that would otherwise be breaking changes when a 
    /// newer core is used with an older service assembly.
    /// Versions:
    ///     1 - Default version
    ///     2 - Support for path segments
    /// </summary>
    public int MarshallerVersion
    {
        get
        {
            return this.marshallerVersion;
        }            
        set
        {
            this.marshallerVersion = value;
        }
    }

    public String CanonicalResource
    {
        get
        {
            return this.canonicalResource;
        }
        set
        {
            this.canonicalResource = value;
        }
    }


    /// <summary>
    /// Gets and Sets the content for this request.
    /// </summary>
    public Blob Content
    {
        get
        {
            return this.content;
        }
        set
        {
            this.content = value;
        }
    }

    /// <summary>
    /// Flag that signals that Content was and should be set
    /// from the Parameters collection.
    /// </summary>
    public bool SetContentFromParameters { get; set; }


    /// <summary>
    /// The name of the service to which this request is being sent.
    /// </summary>
    public String ServiceName
    {
        get
        {
            return this.serviceName;
        }
    }


    /// <summary>
    /// Host prefix value to prepend to the endpoint for this request, if any.
    /// </summary>
    public String HostPrefix { get; set; }

    /// <summary>
    /// Gets and sets the Suppress404Exceptions property. If true then 404s return back from AWS will not cause an exception and 
    /// an empty response object will be returned.
    /// </summary>
    public bool Suppress404Exceptions
    {
        get;
        set;
    }

    /// <summary>
    /// If using AWS4 signing protocol, contains the resultant parts of the
    /// signature that we may need to make use of if we elect to do a chunked
    /// encoding upload.
    /// </summary>
    public AWS4SigningResult AWS4SignerResult { get; set; }

    /// <summary>
    /// Used for Amazon S3 requests where the bucket name is removed from
    /// the marshalled resource path into the host header. To comply with
    /// AWS2 signature calculation, we need to recover the bucket name
    /// and include it in the resource canonicalization, which we do using
    /// this field.
    /// </summary>
    public String CanonicalResourcePrefix
    {
        get;
        set;
    }

    /// <summary>
    /// This flag specifies if SigV4 is required for the current request.
    /// </summary>
    public bool UseSigV4 { get; set; }

    /// <summary>
    /// The authentication region to use for the request.
    /// Set from Config.AuthenticationRegion.
    /// </summary>
    public String AuthenticationRegion { get; set; }

    /// <summary>
    /// The region in which the service request was signed.
    /// </summary>
    public String DeterminedSigningRegion { get ; set; }

    /// <summary>
    /// If the request needs to be signed with a different service name 
    /// than the client config AuthenticationServiceName, set it here to override
    /// the result of DetermineService in AWS4Signer
    /// </summary>
    public String OverrideSigningServiceName { get; set; }

    /// <summary>
    /// Returns true if the request can contain a request body, else false.
    /// </summary>
    /// <returns>Returns true if the currect request can contain a request body, else false.</returns>
    public bool MayContainRequestBody()
    {
        return
            (this.HttpMethod == 'POST' ||
                this.HttpMethod == 'PUT' ||
                this.HttpMethod == 'PATCH');
    }

    /// <summary>
    /// Returns true if the request has a body, else false.
    /// </summary>
    /// <returns>Returns true if the request has a body, else false.</returns>
    public bool HasRequestBody()
    {
        var isPutPost = (this.HttpMethod == 'POST' || this.HttpMethod == 'PUT' || this.HttpMethod == 'PATCH');
        var hasContent = this.HasRequestData();
        return (isPutPost && hasContent);
    }

    public String GetHeaderValue(String headerName)
    {
        return _headers.get(headerName);
    }
}
