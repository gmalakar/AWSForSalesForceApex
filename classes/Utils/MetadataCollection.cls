public class MetadataCollection extends MapIngnoreCase {
    
    static final String MetaDataHeaderPrefix = 'x-amz-meta-';

    public MetadataCollection() {
        this.headerPrefix = 'x-amz-meta-';
    }
    
    /// <summary>
    /// Adds the metadata to the collection, if the name already exists it will be overwritten.
    /// </summary>
    /// <param name="name">The name of the metadata element</param>
    /// <param name="value">The value for the metadata</param>
    public void Add(String name, String val)
    {
        this.put( name, val);
    }

    /// <summary>
    /// Gets the count of headers.
    /// </summary>
    public Integer Count
    {
        get { return this.size(); }
    }

    /// <summary>
    /// Gets the names of the headers set.
    /// </summary>
    public Set<String> Keys
    {
        get { return keySet(); }
    }
}
