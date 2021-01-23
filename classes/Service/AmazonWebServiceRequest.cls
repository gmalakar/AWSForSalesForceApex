public class AmazonWebServiceRequest {
    public AmazonWebServiceRequest() {
        this.Headers = new MapIngnoreCase();
        this.Metadata = new MapIngnoreCase();
        this.Parameters = new MapIngnoreCase();
        }

    public abstract String Name = 'AmazonWebServiceRequest';

    public MapIngnoreCase Headers { get; private set; }
    
    public HttpMethod Verb { get; set; }  

    public long ExpiresIn { get; set; }  

    public Protocol Protocol { get; set; } 
    
    public Blob Content { get; set; }  
    
    public void setHeader( String key, String value )
    {
        this.Headers.put(key, value);
    }
    
    public String getHeader( String key )
    {
        return this.Headers.get(key);
    }

    public MapIngnoreCase Metadata { get; private set; }
    
    public void setMetadata( String key, String value )
    {
        this.Metadata.put(key, value);
    }
    
    public String getMetadata( String key )
    {
        return this.Metadata.get(key);
    }

    public MapIngnoreCase Parameters { get; private set; }
    
    public void setParameter( String key, String value )
    {
        this.Parameters.put(key, value);
    }
    
    public String getParameter( String key )
    {
        return this.Parameters.get(key);
    }      
}
