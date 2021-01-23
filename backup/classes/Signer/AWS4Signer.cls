public virtual class AWS4Signer {

    public static final String Schema = 'AWS4';
    public static final String Algorithm  = 'HMAC-SHA256';
    public static final String AWS4AlgorithmTag  = Scheme + '-' + Algorithm;
    public static final String Terminator = 'aws4_request';
    public static final Blob TerminatorBytes = Blob.valueOf(Terminator);
    
    public static final String Credential = 'Credential';
    public static final String SignedHeaders = 'SignedHeaders';
    public static final String Signature = 'Signature';

    public static final String EmptyBodySha256 = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
    public static final String StreamingBodySha256 = 'STREAMING-AWS4-HMAC-SHA256-PAYLOAD';
    public static final String AWSChunkedEncoding = 'aws-chunked';

    public static final String UnsignedPayload = 'UNSIGNED-PAYLOAD';

    static final SigningAlgorithm SignerAlgorithm = SigningAlgorithm.HmacSHA256;

    public static final Integer MaxAWS4PreSignedUrlExpiry = 7 * 24 * 60 * 60;

    public static final String XAmzSignature = 'X-Amz-Signature';
    public static final String XAmzAlgorithm = 'X-Amz-Algorithm';
    public static final String XAmzCredential = 'X-Amz-Credential';
    public static final String XAmzExpires = 'X-Amz-Expires';
        
    static Set<String> lHeadersToIgnoreWhenSigning  = new Set<String>{
        HeaderKeys.XAmznTraceIdHeader,
        HeaderKeys.TransferEncodingHeader,
        HeaderKeys.AmzSdkInvocationId,
        HeaderKeys.AmzSdkRequest
    } ;

    public AWS4Signer() {

    }

    protected static MapIngnoreCase SortAndPruneHeaders( MapIngnoreCase requestHeaders)
    {
        MapIngnoreCase sortedHeaders = new MapIngnoreCase<string, string>();
        
        for ( String k : requestHeaders.keySet() ){
            if( lHeadersToIgnoreWhenSigning.contains(k) ){
                continue;
            }
            sortedHeaders.put(k, requestHeaders.get(k));
        }
        return sortedHeaders;
    }

    protected static String CanonicalizeHeaderNames(MapIngnoreCase sortedHeaders)
    {
        List<String> builder = new List<String>();
        
         for ( String k : sortedHeaders.sortedKeySet() ){
             if( builder.size() > 0 ){
                 builder.add(';');
             }
             builder.add(k.toLowerCase());
        }
        return String.join(builder, '');
    }
    
    protected static List<KeyValuePair<string, string>> GetParametersToCanonicalize(SignerRequest request)
    {
        MapIngnoreCase parametersToCanonicalize = new MapIngnoreCase();

        if (request.SubResources != null && request.SubResources.Count > 0)
        {
            for ( String k : request.SubResources.keySet() ){
                parametersToCanonicalize.Add(k, request.SubResources.get(k));
            }
        }

        if (request.UseQueryString && request.ParameterCollection != null && request.ParameterCollection.Count > 0)
        {
            for ( String k : request.ParameterCollection.sortedKeySet() ){
                String val = request.ParameterCollection.get(k);
                if ( val != null ){
                    parametersToCanonicalize.Add(k, val);
                }
            }
        }

        return parametersToCanonicalize;
    }
        
    protected static String CanonicalizeQueryParameters(
        MapIngnoreCase parameters,
        Boolean uriEncodeParameters)
        {
            if (parameters == null){
                return string.Empty;
            }

            List<String> canonicalQueryString = new List<String>();
            for ( String k : parameters.sortedKeySet() ){
            {
                var key = k;
                var value = parameters.get(k);

                if (canonicalQueryString.size() > 0){
                    canonicalQueryString.add('&');
                }
                if (uriEncodeParameters)
                {
                    if (String.isBlank(value)){
                        canonicalQueryString.add(String.format('{0}=', AWSSDKUtils.UriEncode(key, false)));
                    }
                    else{
                        canonicalQueryString.add(String.format('{0}={1}', new List<Object>{ AWSSDKUtils.UriEncode(key, false), AWSSDKUtils.UrlEncode(value, false)}));
                    }
                }
                else
                {
                    if (String.isBlank(value)){
                        canonicalQueryString.add(String.format('{0}=', key));
                    }
                    else{
                        canonicalQueryString.add(String.format('{0}={1}', new List<Object>{ key,value}));
                    }
                }
            }

            return String.join( canonicalQueryString,'');
        }
    }
        
    protected static String CanonicalizeHeaders( MapIngnoreCase sortedHeaders)
    {
        if (sortedHeaders == null || sortedHeaders.Count == 0){
            return '';
        }

        List<String> builder = new List<String>();
        for ( String k : sortedHeaders.sortedKeySet() ){
            
            builder.add(k.toLowerCase());
            builder.add(':');
            builder.add(AWSSDKUtils.CompressSpaces(sortedHeaders.get(k)));
            builder.add('\n');
        }
        return String.join(builder, '');
    }
        
    protected static String CanonicalizeRequestHelper(Url endpoint,
                                                    String resourcePath,
                                                    String httpMethod,
                                                    MapIngnoreCase sortedHeaders,
                                                    String canonicalQueryString,
                                                    String precomputedBodyHash,
                                                    MapIngnoreCase pathResources,
                                                    int marshallerVersion,
                                                    Boolean detectPreEncode)
    {
        List<String> canonicalRequest = new List<String>();
        canonicalRequest.add('{0}\n', httpMethod);
        canonicalRequest.add('{0}\n', AWSSDKUtils.CanonicalizeResourcePath(endpoint, resourcePath, detectPreEncode, pathResources, marshallerVersion) );

        canonicalRequest.add('{0}\n', canonicalQueryString);

        canonicalRequest.add('{0}\n', CanonicalizeHeaders(sortedHeaders));
        canonicalRequest.add('{0}\n', CanonicalizeHeaderNames(sortedHeaders));

        if (precomputedBodyHash != null)
        {
            canonicalRequest.add(precomputedBodyHash);
        }
        else
        {
            String contentHash;
            if (sortedHeaders.containsKey(HeaderKeys.XAmzContentSha256Header) ){
                 canonicalRequest.add(sortedHeaders.get(HeaderKeys.XAmzContentSha256Header));
            }
        }

        return String.join(canonicalRequest, '');
    }
        
    public static AWS4SigningResult SignRequest( GetS3PreSignedRequest request,
                                                AmazonClientConfig clientConfig,
                                                String awsAccessKeyId,
                                                String awsSecretAccessKey)
    {

        Datetime signedAt = Datetime.now();

        request.Headers.remove(HeaderKeys.AuthorizationHeader);

        if ( !request.Headers.containsKey(HeaderKeys.HostHeader) ){
            String hostHeader = request.Endpoint.getHost();
            /* TODO
            if ( request.Endpoint.getPort()){
                hostHeader += ':' + request.Endpoint.getPort();
            }
            */
            request.Headers.put(HeaderKeys.HostHeader, hostHeader);
        }

        if (request.Headers.ContainsKey(HeaderKeys.XAmzContentSha256Header)){
                request.Headers.Remove(HeaderKeys.XAmzContentSha256Header);
        }

        MapIngnoreCase sortedHeaders = SortAndPruneHeaders(request.Headers);

        String canonicalizedHeaderNames = CanonicalizeHeaderNames( sortedHeaders );

        MapIngnoreCase parametersToCanonicalize = GetParametersToCanonicalize( request );
        parametersToCanonicalize.Add( XAmzAlgorithm, AWS4AlgorithmTag);

        String xAmzCredentialValue = String.Format( '{0}/{1}/{2}/{3}/{4}',
                                                        new List<Object>{
                                                       awsAccessKeyId,
                                                       AWSSDKUtils.getDate(signedAt),
                                                       clientConfig.Region,
                                                       clientConfig.Service,
                                                       Terminator});

    
        parametersToCanonicalize.Add(XAmzCredential, xAmzCredentialValue);

        parametersToCanonicalize.Add(HeaderKeys.XAmzDateHeader,  AWSSDKUtils.getTimestamp(signedAt));
        parametersToCanonicalize.Add(HeaderKeys.XAmzSignedHeadersHeader, canonicalizedHeaderNames);

        String canonicalQueryParams = CanonicalizeQueryParameters( parametersToCanonicalize, true );


    }                                                   
}
