public abstract class AWSCollection {

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

    public class Header extends AWSCollection.MapIngnoreCase {

        public Header() {

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

    public class Metadata extends AWSCollection.MapIngnoreCase {
        
        public Metadata() {
            this.headerPrefix = 'x-amz-meta-';
        }
    }

    public class Parameter extends AWSCollection.MapIngnoreCase {
        
        public Parameter() {
            this.headerPrefix = 'x-';
        }
    }
}
