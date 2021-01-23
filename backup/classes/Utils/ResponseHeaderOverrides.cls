public class ResponseHeaderOverrides {

    public static final String RESPONSE_CONTENT_TYPE = 'response-content-type';
    public static final String RESPONSE_CONTENT_LANGUAGE = 'response-content-language';
    public static final String RESPONSE_EXPIRES = 'response-expires';
    public static final String RESPONSE_CACHE_CONTROL = 'response-cache-control';
    public static final String RESPONSE_CONTENT_DISPOSITION = 'response-content-disposition';
    public static final String RESPONSE_CONTENT_ENCODING = 'response-content-encoding';

    String _contentType;
    String _contentLanguage;
    String _expires;
    String _cacheControl;
    String _contentDisposition;
    String _contentEncoding;
        
    public ResponseHeaderOverrides() {

    }
    /// <summary>
    /// A standard MIME type describing the format of the object data.
    /// </summary>
    /// <remarks>
    /// The content type for the content being uploaded. This property defaults to "binary/octet-stream".
    /// For more information, refer to: <see href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17"/>
    /// </remarks>
    public String ContentType
    {
        get { return this._contentType; }
        set { this._contentType = value; }
    }

    /// <summary>
    /// ContentLanguage header value.
    /// </summary>
    public String ContentLanguage
    {
        get { return this._contentLanguage; }
        set { this._contentLanguage = value; }
    }

    /// <summary>
    /// Expiry header value.
    /// </summary>
    public String Expires
    {
        get { return this._expires; }
        set { this._expires = value; }
    }

    /// <summary>
    /// CacheControl header value.
    /// </summary>
    public String CacheControl
    {
        get { return this._cacheControl; }
        set { this._cacheControl = value; }
    }

    /// <summary>
    /// The ContentDisposition header value.
    /// </summary>
    public String ContentDisposition
    {
        get { return this._contentDisposition; }
        set { this._contentDisposition = value; }
    }

    /// <summary>
    /// The ContentEncoding header value.
    /// </summary>
    public String ContentEncoding
    {
        get { return this._contentEncoding; }
        set { this._contentEncoding = value; }
    }
    }
