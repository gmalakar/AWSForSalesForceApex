public class HeaderCollection extends MapIngnoreCase {

    public HeaderCollection() {

    }
    /// <summary>
    /// Specifies presentational information for the object.
    /// </summary>
    public String ContentDisposition
    {
        get { return this.get('Content-Disposition'); }
        set { this.put('Content-Disposition', value); }
    }

    /// <summary>
    /// The size of the object, in bytes.
    /// </summary>
    public Long ContentLength
    {
        get { 
            String val = this.get('Content-Length');
            if ( String.isBlank(val) )
                return -1;
            return Long.valueOf(val);
        }
        set { this.put('Content-Length', String.valueOf( value ) ); }
    }

    /// <summary>
    /// The base64-encoded 128-bit MD5 digest of the message (without the headers) according to RFC 1864. This 
    /// header can be used as a message integrity check to verify that the data is the same data that was originally sent.
    /// </summary>
    public String ContentMD5
    {
        get { return this.get('Content-MD5'); }
        set { this.put('Content-MD5', value); }
    }

    /// <summary>
    /// A standard MIME type describing the format of the object data.
    /// </summary>
    public String ContentType
    {
        get { return this.get('Content-Type'); }
        set { this.put('Content-Type', value); }
    }

    public Boolean IsSetContentType()
    {
        return String.isNotBlank(this.ContentType);
    }

    /// <summary>
    /// Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type
    /// referenced by the Content-Type header field.
    ///  
    /// </summary>
    public String ContentEncoding
    {
        get { return this.get('Content-Encoding'); }
        set { this.put('Content-Encoding', value); }
    }

}