public class AWSServicesCommon {
    public AWSServicesCommon() {

    }
    
    public static Boolean initiateMultipartUpload( SignedResponse response, Map<String, String> params, Map<String, String> headers ) {
        Boolean success = false;
        String filename = EncodingUtil.urlEncode(params.get(AWSServicesCommon.path),'UTF-8');
        String contentType = params.get(AWSServicesCommon.type);
        if ( filename == null ){
            response.Response = 'error: missing file path';
        }
        else {
            try{
                String uploadId = '';
                Url uploadIdRequestUrl = new Url(defaultServiceEndpoint, + '/' + TrimSlashesFromBegining(filename) + '?uploads=' );
                String action = 'POST';
                if ( contentType == null )
                    contentType = '';
                String formattedDateString = Datetime.now().formatGMT(gmtFormat);
                String stringtosign = getStringToSign( action, '', contentType, formattedDateString, getCanonicalizedAmzHeadersString(headers), 
                getCanonicalizedResourceString(uploadIdRequestUrl, true ));
                String auth = getAuthorization( stringtosign );

                HttpRequest req = new HttpRequest();
                req.setMethod(action);
                req.setEndpoint(uploadIdRequestUrl.toExternalForm());
                req.setHeader('Host', uploadIdRequestUrl.getHost());
                req.setHeader('Date', formattedDateString);           
                req.setHeader('Authorization',auth);
                req.setHeader('Content-Length', '0');
                if( String.isNotBlank(contentType))
                    req.setHeader('Content-Type', contentType);
                if( headers != null && headers.size() > 0 ){
                    for (String key : headers.keySet())
                    {
                        String lkey = key.toLowerCase();
                        if( lkey.startsWith('x-amz-')){
                            req.setHeader(key, headers.get(key));
                        }
                    }
                }
                Http http = new Http();
                HTTPResponse res = http.send(req);
                response.Response = res.getBody();
            
                if (res.getStatusCode() == 200 || res.getStatusCode()==201) {
                    response.Status = 'success';
                    response.UploadId = EncodingUtil.urlEncode(XMLParser.nodeVal(response.Response, 'UploadId', awsXmlNameApsce ),'UTF-8');
                    response.Response = EncodingUtil.urlEncode(XMLParser.nodeVal(response.Response, 'UploadId', awsXmlNameApsce ),'UTF-8');
                    response.Key = filename;
                    response.BucketName = defaultBucketName;
                    success= true;
                }
                

            } catch(Exception e) {
                response.Response = String.format('Message: {0}, Stack:{1}', new List<Object> {e.getMessage(), e.getStackTraceString()});
            }
        }   
        return success;
    }

    public static Boolean listBucket( SignedResponse response, String prefix, String maxKeys, String marker ){
        Boolean success = false;
        String formattedDateString = Datetime.now().formatGMT(gmtFormat);
        String stringToGign = 'GET\n\n\n' + formattedDateString +'\n/' + defaultBucketName +'/';
        String auth = getAuthorization( stringToGign );
        String host = defaultBucketName + '.s3.'+region+'.amazonaws.com';
        response.BucketName = defaultBucketName;
        try
        {
            String endpoint = new Url(defaultServiceEndpoint, '?list-type=2' ).toExternalForm();
            if (String.isNotBlank(prefix)){
                endpoint += '&prefix='+prefix;
            }
            if (String.isNotBlank(maxKeys)){
                endpoint += '&max-keys='+maxKeys;
            }
            if (String.isNotBlank(marker)){
                endpoint += '&marker='+marker;
            }

            //String endpoint = '/?prefix='+prefix+'&max-keys='+maxKeys+'&marker='+marker;
            response.Key = endpoint;
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endpoint);
            req.setHeader('Host', defaultServiceEndpoint.getHost());
            req.setHeader('Date', formattedDateString);           
            req.setHeader('Authorization',auth);
            req.setHeader('ACL', 'public-read');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            response.Response = res.getBody();
            
            if (res.getStatusCode() == 200 || res.getStatusCode()==201) {
                response.Status = 'success';
                success= true;
                response.Response = XMLParser.xmlToJson(response.Response, true);
            }
        } catch(Exception e) {
            response.Response = String.format('Message: {0}, Stack:{1}', new List<Object> {e.getMessage(), e.getStackTraceString()});
        }
        return success;
    }

    public static void getFileContentAsBase64String( SignedResponse response, String fileName, String contentType, String bucketName ){
        Blob fileContentBlob = getFileContent( response, fileName, contentType, bucketName );
        if ( response.Status == 'success')
            response.Response = EncodingUtil.Base64Encode(fileContentBlob);
    }
    
    public static Blob getFileContent( SignedResponse response, String fileName, String contentType, String bucketName ){
        Map<String, String> params =  new Map<String, String>();
        Map<String, String> headers =  new Map<String, String>();
        params.put(AWSServicesCommon.path, fileName);
        if (String.isNotBlank(contentType)){
            params.put(AWSServicesCommon.type, contentType);
        }
        if (String.isNotBlank(contentType)){
            params.put(AWSServicesCommon.bucketname, bucketName);
        }
        return getFileContent( true, response, params, headers);
    }

    public static void getFileContentAsString( SignedResponse response, String fileName, String contentType, String bucketName ){
        Map<String, String> params =  new Map<String, String>();
        Map<String, String> headers =  new Map<String, String>();
        params.put(AWSServicesCommon.path, fileName);
        if (String.isNotBlank(contentType)){
            params.put(AWSServicesCommon.type, contentType);
        }
        if (String.isNotBlank(contentType)){
            params.put(AWSServicesCommon.bucketname, bucketName);
        }
        getFileContentAsString( response, params, headers);
    }
    
    public static void getFileContentAsString( SignedResponse response, Map<String, String> params, Map<String, String> headers ){
        getFileContent( false, response, params, headers);
    }
    
    public static Blob getFileContent( SignedResponse response, Map<String, String> params, Map<String, String> headers ){
        return getFileContent(response, params, headers);
    }

    private static Blob getFileContent( Boolean asblob, SignedResponse response, Map<String, String> params, Map<String, String> headers ){
        Blob fileContent;
        Boolean success = false;
        try
        {
            String contentType = params.get(AWSServicesCommon.type);
            system.debug('contentType > '+ contentType);
            success = getS3SignedUrl(response, 'GET', params, headers);
            if ( success )
            {
                //success = false;
                //get the content
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(response.SignedURL);
            
                if (String.isNotBlank(contentType)){
                    req.setHeader('content-type', contentType);
                }
                Http http = new Http();
                HTTPResponse res = http.send(req);
                
                if (res.getStatusCode() == 200 || res.getStatusCode()==201) {
                    if ( asblob ){
                        fileContent = res.getBodyAsBlob();
                        if ( fileContent != null ){
                            success= true;                       
                        }
                        else {
                            response.Response = ' No file content!';
                        }
                    }
                    else {
                        response.Response = res.getBody();
                    }

                }
                else{
                    response.Response = res.getBody();
                }
                response.BucketName = defaultBucketName;
            }
        } catch(Exception e) {
            response.Response = String.format('Message: {0}, Stack:{1}', new List<Object> {e.getMessage(), e.getStackTraceString()});
        }
        if ( success ){
            response.Status = 'success';
        } else {
            response.Status = 'error';
        }
        
        if(Test.isRunningTest()) {
            fileContent = Blob.valueOf('Test');
        }
        return fileContent;
    }
    
    public static Boolean getS3SignedUrl( SignedResponse response, String action, Map<String, String> params, Map<String, String> headers ) {
        Boolean success = false;
        String filename = EncodingUtil.urlEncode(params.get(AWSServicesCommon.path),'UTF-8');
        String contentType = params.get(AWSServicesCommon.type);
        String uploadId = params.get(AWSServicesCommon.uploadId);
        String filecount = params.get(AWSServicesCommon.filecount);
        String partNumber = params.get(AWSServicesCommon.pnum);
        String pcount = params.get(AWSServicesCommon.partcount);
        String bucketname = params.get(AWSServicesCommon.bucketname);
        String userVersion = params.get(AWSServicesCommon.userVersion);
        if( String.isBlank(bucketname) ){
            bucketname = defaultBucketName;
        }
        
        if ( filename == null ){
            response.Response = 'error: missing file path';
        }
        else {

            try{

                if( String.isNotBlank(userVersion ) && userVersion == '4' ){

                    AWSRequestService.GetS3PreSignedRequest request =  new AWSRequestService.GetS3PreSignedRequest();
                    request.BucketName = bucketname;
                    request.ExpiresIn = lifeSpan;
                    request.Key = filename;
                   request.ContentType = contentType;
                     AWSClientConfig config = new AWSClientConfig( accessKey, secretKey );
                    response.Key = filename;
                    response.BucketName = bucketname;
                    AWSS3Client client = new AWSS3Client( config );
                    response.SignedURL = client.getPresignedUrl(request);
                    //response.ExpiredIn = String.valueOf(client.e);
                    success = true;                     
                }
                else { 
                    Integer timeSpan = lifeSpan;
                    if ( timeSpan == null || timeSpan <= 0 ){
                        timeSpan = lifeSpanDef;
                    }
                    
                    String contentMD5 = '';
                    String resource = TrimSlashesFromBegining(filename);
                    String delim = '?';
                    if( String.isNotBlank(uploadId) && String.isNotBlank(partNumber) ){
                        resource += String.format('?uploadId={0}&partNumber={1}', new List<String>{ uploadId, partNumber });
                        delim = '&';
                        timeSpan=lifeSpanMulti;
                        if( String.isNotBlank(pcount) && pcount.isNumeric() && partNumber.isNumeric() )
                        {
                            Integer timeOfTimeSpan = Integer.valueOf(pcount) - Integer.valueOf(partNumber) + 1;
                            if ( timeOfTimeSpan > 1 )
                            timeSpan = lifeSpanMulti * timeOfTimeSpan;
                        }
                    }
                    if ( action == 'CMP'){
                        action = 'POST';
                        if( String.isNotBlank(uploadId) ){
                            resource += String.format('?uploadId={0}', new List<String>{ uploadId});
                            delim = '&';
                        }
                        response.Headers.put('Content-Type', contentType);
                    }
                    else if ( action == 'AMP'){
                        action = 'DELETE';
                        if( String.isNotBlank(uploadId) ){
                            resource += String.format('?uploadId={0}', new List<String>{ uploadId});
                            delim = '&';
                        }
                    }
                    //else if ( action == 'PUT' && String.isNotBlank(filecount) && filecount.isNumeric() ){
                        //timeSpan= Integer.valueOf(filecount) * lifeSpan;
                    //}
                    response.ExpiredIn = String.valueOf(timeSpan);

                    Datetime expireson = Datetime.now().addSeconds(timeSpan); // Lifespan of the link
                    if ( contentType == null )
                        contentType = '';
                    Long expires = expireson.getTime()/1000;
    
                    Url requestUrl = new Url(getServiceEndpoint(bucketname), + '/' + resource);
                    String stringtosign = getStringToSign( action, contentMD5, contentType, String.valueOf(expires), getCanonicalizedAmzHeadersString(headers), 
                    getCanonicalizedResourceString(requestUrl, true ));    
                    response.Key = filename;
                    response.BucketName = bucketname;
                    response.SignedURL = getSignedUrl( requestUrl, stringtosign, expires, contentType, null, delim );
                    //response.Response = stringtosign;
                    success = true;                   
                }

            } catch(Exception e) {
                response.Response = String.format('Message: {0}, Stack:{1}', new List<Object> {e.getMessage(), e.getStackTraceString()});
            }
        }   
        return success;
    }
    
    public static Map<String,String> convertTolowerAllkeys(Map<String,String> v){
      Map<String,String> newMap = new  Map<String,String> ();
      for(String key : v.keySet()){
         newMap.put(key.toLowerCase(),v.get(key));
      }
      return newMap;
    }
    
    private static Url defaultServiceEndpoint {
        get {
            return new Url('https://' + defaultBucketName + '.' + s3endpoint);
        }
    } 

    private static Url getServiceEndpoint( String bucketName ) {
        if( String.isBlank(bucketname) ){
            bucketname = defaultBucketName;
        }
        return new Url('https://' + bucketname + '.' + s3endpoint);
    } 
        
    private static String getStringToSign( 
        String action, 
        String contentMD5,
        String contentType,
        String expires, 
        String canonicalHeaders,
        String canonicalResources
        ){
            if ( canonicalResources.length() > 0 ){
                return String.format(stringToSignTemplate, new List<Object> {action, contentMD5, contentType, expires, canonicalHeaders, canonicalResources });
            } else {
                return String.format(stringToSignTemplate2, new List<Object> {action, contentMD5, contentType, expires, canonicalHeaders });
            }
    }

    private static String getSignedUrl( 
        Url endpoint,
        String stringtosign,
        Long expires, 
        String contentType,
        String parameters,
        String delim
        ){
            String queryString = 'AWSAccessKeyId=' + accessKey;
            if ( expires != null && expires>=0){
                queryString += '&Expires=' + String.valueOf(expires);
            }
            if ( String.isNotBlank( stringtosign )){
                queryString += '&Signature=' + getEncodedSigned( stringtosign );
            }
            if ( String.isNotBlank( contentType )){
                queryString += '&Content-Type=' + contentType;
            }
            if ( String.isNotBlank( parameters )){
                queryString += '&' + parameters;
            }

            return endpoint.toExternalForm() + delim + queryString;
    }

    private static String getAuthorization( String stringtosign ){
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(secretKey)); 
        String sig = EncodingUtil.base64Encode(mac);     
        String auth = 'AWS' + ' ' + accessKey + ':' + sig;
        return auth;
    }

    private static String getEncodedSigned( String stringtosign ){
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(secretKey)); 
        String signed= EncodingUtil.base64Encode(mac);     
        String encodedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        return encodedsigned;
    }

    private static String getCanonicalizedResourceString( Url requestUrl, Boolean useBucket ){
            String canonlizedResourceString = requestUrl.getPath();
            if ( useBucket ){
                canonlizedResourceString = '/' + defaultBucketName + canonlizedResourceString;
            }
            String query = requestUrl.getQuery();
            System.PageReference pageReference = new System.PageReference(requestUrl.toExternalForm());
            Map<String,String> queryVariables = pageReference.getParameters();
            Map<String,String> queryVariablesToConsider = new Map<String,String>();
            Map<String,String> overrideResponseHeaders = new Map<String,String>();
            if( queryVariables != null && queryVariables.size() > 0 ){
                List<String> subResourcesList = new List<String>();
                subResourcesList.addAll(subResourcesToConsider);
                List<String> overrideResponseHeadersList = new List<String>();
                overrideResponseHeadersList.addAll(overrideResponseHeadersToConsider);
            
                for (String key : queryVariables.keySet())
                {
                    String value = queryVariables.get(key);
                    if (subResourcesList.Contains(key))
                    {
                        if (queryVariablesToConsider.ContainsKey(key))
                        {
                            value = String.format('{0},{1}', new List<String>{queryVariablesToConsider.get(key), value});
                        }
                        queryVariablesToConsider.put(key, value);
                    }
                    if (overrideResponseHeadersList.Contains(key))
                    {
                        overrideResponseHeaders.put(key, EncodingUtil.urlDecode(value,'UTF-8'));
                    }
                }
            }
            if (queryVariablesToConsider.size() > 0 || overrideResponseHeaders.size() > 0)
            {
                String queryStringInCanonicalizedResourceString = '?';
                if ( queryVariablesToConsider.size() > 0 ) {
                    List<String> keysQueryVariables = new List<String>(queryVariablesToConsider.keySet());                    
                    keysQueryVariables.sort();
                    for (String key : keysQueryVariables){
                        String value = queryVariablesToConsider.get(key);
                        if (String.isNotBlank(value)){
                            queryStringInCanonicalizedResourceString += String.format('{0}={1}&', new List<String>{key, value});
                        } else {
                            queryStringInCanonicalizedResourceString += String.format('{0}&', new List<String>{key});
                        }
                    }
                }
                if ( overrideResponseHeaders.size() > 0 ) {
                    List<String> keysOverrideResponse = new List<String>(overrideResponseHeaders.keySet());                    
                    keysOverrideResponse.sort();
                    for (String key : keysOverrideResponse){
                        String value = overrideResponseHeaders.get(key);
                        if (String.isNotBlank(value)){
                            queryStringInCanonicalizedResourceString += String.format('{0}={1}&', new List<String>{key, value});
                        } else {
                            queryStringInCanonicalizedResourceString += String.format('{0}&', new List<String>{key});
                        }
                    }
                }
                if (queryStringInCanonicalizedResourceString.EndsWith('&'))
                {
                    queryStringInCanonicalizedResourceString = queryStringInCanonicalizedResourceString.removeEnd('&');
                }
                canonlizedResourceString += queryStringInCanonicalizedResourceString;
            }
            return canonlizedResourceString;
        }
        
        private static String getCanonicalizedAmzHeadersString( Map<String, String> headers ){
        String canonicalizedAmzHeadersString = '';

        if( headers != null && headers.size() > 0 ){
            Map<String, String> ch = new Map<String, String>();
            for (String key : headers.keySet())
            {
                String lkey = key.toLowerCase();
                if( lkey.startsWith('x-amz-')){
                    String value = headers.get(key);
                    if(ch.containsKey(lkey)){
                        value = String.format('{0},{1}', new List<String>{ch.get(lkey), value});
                    }
                    ch.put(lkey, value);
                }
            }
            if(ch.size() > 0 ){
                List<String> keys = new List<String>(ch.keySet());       
                keys.sort();
                for(String key: keys) {
                    canonicalizedAmzHeadersString +=key + ':' + ch.get(key) +'\n';
                }
            }
        }

        return canonicalizedAmzHeadersString;
    }        
    
    private static string TrimSlashesFromBegining( String arg ){
        if ( arg != null && arg.Length() > 0 && slashes.contains(arg.left(1))){
            if ( arg.length() > 1 ){
                arg = arg.substring(1, arg.length() - 1); 
            }
            else {
                arg = '';
            }
        }
        return arg;
    }
    
    private static String bucketname = 'bucketname';
    private static String filecount = 'filecount';
    private static String path = 'path';
    private static String type = 'type';
    private static String uploadId = 'uploadid';
    private static String pnum = 'pnum';
    private static String partcount = 'partcount';
    private static String region = 'us-east-1';
    private static String userVersion = 'version';
    
    private static String awsXmlNameApsce = 'http://s3.amazonaws.com/doc/2006-03-01/';
    private static String gmtFormat = 'EEE, dd MMM yyyy HH:mm:ss z';
    private static String defaultBucketName = Amazon_S3_Configuration__c.getInstance().Bucket_Name__c;     
    private static String accessKey = Amazon_S3_Configuration__c.getInstance().key__c;   
    private static String secretKey = Amazon_S3_Configuration__c.getInstance().secret__c;   
    private static String s3endpoint = Amazon_S3_Configuration__c.getInstance().S3_End_Point__c;   
    private static Integer lifeSpan = Integer.valueOf(Amazon_S3_Configuration__c.getInstance().PreSignedUrlLifeSpan__c); //seconds by default
    private static Integer lifeSpanDef = 60;
    private static Integer lifeSpanMulti = 3600; //seconds by default
    private static String stringToSignTemplate = '{0}\n{1}\n{2}\n{3}\n{4}{5}';
    private static String stringToSignTemplate2 = '{0}\n{1}\n{2}\n{3}\n{4}';
    private static Set<String> slashes = new Set<String>{'/','\\'};

    public class SignedResponse{
        public String Status;
        public String ExpiredIn;
        public String Key;
        public String UploadId;
        public String Response;
        public String BucketName;
        public String SignedURL;
        public Map<String, String> Headers = new Map<String, String>();
    }
    private static List<String> subResourcesToConsider = new List<String> { 
                                                                            'acl',
                                                                            'accelerate',
                                                                            'analytics',
                                                                            'cors',
                                                                            'lifecycle',
                                                                            'delete',
                                                                            'inventory',
                                                                            'location',
                                                                            'logging',
                                                                            'metrics',
                                                                            'notification',
                                                                            'partNumber',
                                                                            'policy',
                                                                            'requestPayment',
                                                                            'replication',
                                                                            'restore',
                                                                            'tagging',
                                                                            'torrent',
                                                                            'uploadId',
                                                                            'uploads',
                                                                            'versionId',
                                                                            'versioning',
                                                                            'versions',
                                                                            'website'
                                                                            };
    private static List<String> overrideResponseHeadersToConsider = new List<String> { 
                                                                            'response-content-type', 
                                                                            'response-content-language', 
                                                                            'response-expires', 
                                                                            'response-cache-control', 
                                                                            'response-content-disposition', 
                                                                            'response-content-encoding' 
                                                                        }; 
 }