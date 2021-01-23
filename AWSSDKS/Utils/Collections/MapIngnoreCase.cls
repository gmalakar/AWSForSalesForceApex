public virtual class MapIngnoreCase {

    protected String headerPrefix = '';
    protected final Map<String,String> lInternalMap;
    protected final Map<String,String> lKeyMap;
    protected final List<String> lKeys;
    
    public MapIngnoreCase() {
        this.lInternalMap = new Map<String,String>();
        this.lKeyMap = new Map<String,String>();
        this.lKeys = new List<String>();
    }

    public void clear()
    {
        lInternalMap.clear();
        lKeyMap.clear();
        lKeys.clear();
    }
    
    public Boolean containsKey(String key)
    {
        return lKeys.contains(key.toLowerCase());
    }

    public String get(String key)
    {
        if( headerPrefix.length() > 0 && !key.toLowerCase().startsWith( headerPrefix ) ){
            key = headerPrefix + key;
        }

        String val = '';
        if ( containsKey( key) ){
            val = this.lInternalMap.get(lKeyMap.get(key.toLowerCase()));
        }

        return val;
    }

    public Boolean isEmpty()
    {
        return lInternalMap.isEmpty();
    }

    public Set<String> keySet()
    {
        return this.lKeyMap.keySet();
    }

    public List<String> sortedKeySet()
    {
        this.lKeys.sort();
        return this.lKeys;
    }

    public Set<String> originalKeySet()
    {
        return this.lInternalMap.keySet();
    }

    public void put(String key, String val)
    {
        if( headerPrefix.length() > 0 && !key.toLowerCase().startsWith( headerPrefix ) ){
            key = headerPrefix + key;
        }
        
        lKeyMap.put(key.toLowerCase(), key);
        lInternalMap.put(key, val);
        lKeys.add(key);
    }

    public void Add(String key, String val)
    {
       this.put(key, val);
    }
    
    public String remove(String key)
    {
        lKeyMap.remove(key.toLowerCase());
        Integer idx = lKeys.indexOf(key);
        if ( idx >= 0 ){
            lKeys.remove(idx);       
        }
        return lInternalMap.remove(key);
    }

    public List<String> values()
    {
        return lInternalMap.values();
    }

    public override String toString()
    {
        return lInternalMap.toString();
    }

    /// <summary>
    /// Gets the count of headers.
    /// </summary>
    public Integer Count
    {
        get { return this.size(); }
    }
    
    public Integer size()
    {
        return lInternalMap.size();
    }
    /// <summary>
    /// Gets the names of the headers set.
    /// </summary>
    public Set<String> Keys
    {
        get { return keySet(); }
    }
}