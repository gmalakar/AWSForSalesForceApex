public virtual class MapIngnoreCase {

    protected String headerPrefix = '';
    protected Map<String,String> _internalMap;
    protected Map<String,String> _keyMap;
    protected List<String> _keys;
    
    public MapIngnoreCase() {
        this._internalMap = new Map<String,String>();
        this._keyMap = new Map<String,String>();
        this._keys = new List<String>();
    }

    public void clear()
    {
        _internalMap.clear();
        _keyMap.clear();
        _keys.clear();
    }
    
    public Boolean containsKey(String key)
    {
        return _keys.contains(key.toLowerCase());
    }

    public String get(String key)
    {
        if( headerPrefix.length() > 0 && !key.toLowerCase().startsWith( MetaDataHeaderPrefix ) ){
            key = MetaDataHeaderPrefix + key;
        }

        String val = '';
        if ( containsKey( key) ){
            val = this._internalMap.get(_keyMap.get(key.toLowerCase()));
        }

        return val;
    }

    public Boolean isEmpty()
    {
        return _internalMap.isEmpty();
    }

    public Set<String> keySet()
    {
        return this._keyMap.keySet();
    }

    public List<String> sortedKeySet()
    {
        this._keys.sort();
        return this._keys;
    }

    public Set<String> originalKeySet()
    {
        return this._internalMap.keySet();
    }

    public void put(String key, String val)
    {
        if( headerPrefix.length() > 0 && !key.toLowerCase().startsWith( MetaDataHeaderPrefix ) ){
            key = MetaDataHeaderPrefix + key;
        }
        
        _keyMap.put(key.toLowerCase(), key);
        _internalMap.put(key, val);
        _keys.add(key);
    }

    public void Add(String key, String val)
    {
       this.put(key, val);
    }
    
    public String remove(String key)
    {
        _keyMap.remove(key.toLowerCase());
        _keys.remove(key);
        return _internalMap.remove(key);
    }

    public List<String> values()
    {
        return _internalMap.values();
    }

    public String toString()
    {
        return _internalMap.toString();
    }

    public Integer size()
    {
        return _internalMap.size();
    }

    public Integer Count { get { return this.size(); } }
}