public class AWSApiGateway {
    
    public static HttpRequest generateAuthorizedRequest( Url requestUrl, String accesskey, String secretKey, String region, String httpMethod, String payLoad ){
        httpMethod = httpMethod.toUpperCase();
        Datetime signedAt = Datetime.now();

        String authorization = generateAuthorization( signedAt, requestUrl, accesskey, secretKey, region, httpMethod, payLoad);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestUrl.toExternalForm().toLowerCase());
        request.setHeader('X-Amz-Date', AWSSignerUtils.getTimestamp(signedAt) );
        request.setHeader('X-Amz-Content-Sha256', AWSSignerUtils.getHashedPayload( payLoad) );
        request.setHeader('Host', requestUrl.getHost() );
        request.setHeader('Authorization', authorization );
        request.setHeader('Content-Type', 'application/json' );
        request.setBody(payLoad);
        request.setMethod(httpMethod);
        return request;
    }

    public static string generateAuthorization( Datetime signedAt, Url requestUrl, String accesskey, String secretKey, String region, String httpMethod, String payLoad ){

        String service = 'execute-api';
        String hashedpayload = AWSSignerUtils.getHashedPayload( payLoad);
        String headerNames = 'host;x-amz-content-sha256;x-amz-date';

        String canonicalRequest =  httpMethod + lineBreak +
            AWSSignerUtils.getCanonicalpath(requestUrl) + lineBreak +
            AWSSignerUtils.getSortedQueryString( requestUrl) + lineBreak +
            'host:' + requestUrl.getHost() + lineBreak +
            'x-amz-content-sha256:' + hashedpayload + lineBreak +
            'x-amz-date:' + AWSSignerUtils.getTimestamp(signedAt) + lineBreak +
            lineBreak +
            headerNames + lineBreak +
            hashedpayload;

        String hashedCononicalrequest = AWSSignerUtils.ToHexEncode(AWSSignerUtils.ToHash(canonicalRequest), false);
        String scope = AWSSignerUtils.getScope(signedAt, region, service);

        String stringToSign = AWSSignerUtils.getStringToSign(AWS4AlgorithmTag, signedAt, scope, hashedCononicalrequest);

        Blob signingKey = AWSSignerUtils.getSigningKey(signedAt, secretKey, region, service);

        String signature = AWSSignerUtils.getSignature(stringToSign, signingKey);

        String credentialsAuthorizationHeader = 'Credential=' + accesskey + '/' + scope;
        String signedHeadersAuthorizationHeader = 'SignedHeaders=' + headerNames;
        String signatureAuthorizationHeader = 'Signature=' + signature;
        String authorization = AWS4AlgorithmTag + ' ' 
            + credentialsAuthorizationHeader + ', '
            + signedHeadersAuthorizationHeader + ', '
            + signatureAuthorizationHeader;
        return authorization;

    }

    public static final String EmptyBodySha256 = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
    public static final String AWSSchema = 'AWS4';
    public static final String Algorithm  = 'HMAC-SHA256';
    public static final String AWS4AlgorithmTag  = AWSSchema + '-' + Algorithm;
    public static final String Terminator = 'aws4_request';
    public static final String MacAlorithm = 'hmacSHA256';   
    public static final String lineBreak ='\n';
   
}
