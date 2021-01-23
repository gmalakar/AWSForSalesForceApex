// ===============================
// AUTHOR           : Goutam malakar
// CREATE DATE      : 01/23/2021
// PURPOSE          : Different AWS service client
// SPECIAL NOTES    :
// ===============================

public class AWSServiceClient {

    static final String lineBreak ='\n';

    //service client for api gateway
    public class APIGateway {
        public APIGateway( AWSConfig.APIGateway config ) {
            this.ApiConfig = config;
        }

        public APIGateway() {
        }


        public HttpResponse invokeApi( String resource, String payload  )
        {
            this.validate( resource, true );

            Url requestUrl = new Url( AWSUtils.getApiEndpoint( this.ApiConfig.ApiKey, this.ApiConfig.Region, this.ApiConfig.Stage) + AWSUtils.trimSlashesFromBegining(resource ) );

            return invokeApiLocal( requestUrl, payload );

        }

        private HttpResponse invokeApiLocal( Url requestUrl, String payload )
        {
            /*
            HttpResponse res = new HttpResponse();

            res.setBody(requestUrl.toExternalForm());

            return res;
            */
            HttpRequest httprequest = AWSServiceClient.generateAuthorizedRequestForApi( requestUrl, this.ApiConfig.AccessKey, this.ApiConfig.SecretKey, this.ApiConfig.Region, this.ApiConfig.HttpMethod.toUpperCase(), payload);
            httprequest.setTimeout(this.ApiConfig.HttpTimeOut);
            Http http = new Http();
            return http.send(httprequest);
        }

        private HttpResponse invokeApi( String requestEndpoint, String resource, String payload  )
        {
            this.validate( resource, false );
            
            Url requestUrl = new Url( requestEndpoint + AWSUtils.trimSlashesFromBegining(resource ) );

            return invokeApiLocal( requestUrl, payload );
        }

        private void validate( String resource, Boolean validateApi )
        {
            if ( ApiConfig == null ){
                throw new AWSException('ApiConfig', 'InvokeApi', 'Please set Config APIGateway!' );
            }
            if ( validateApi && String.isBlank( this.ApiConfig.ApiKey ) ){
                throw new AWSException('ApiKey', 'InvokeApi', 'Missing value!' );
            }
            if ( String.isBlank( this.ApiConfig.Stage ) ){
                throw new AWSException('Stage', 'InvokeApi', 'Missing value!' );
            }
            if ( String.isBlank( this.ApiConfig.HttpMethod ) ){
                throw new AWSException('HttpMethod', 'InvokeApi', 'Missing value!' );
            }
            if ( String.isBlank( resource ) ){
                throw new AWSException('resource', 'InvokeApi', 'Missing value!' );
            }
        }

        public AWSConfig.APIGateway ApiConfig { get; set; } 
    }

    public static HttpRequest generateAuthorizedRequestForApi( Url requestUrl, String accesskey, String secretKey, String region, String httpMethod, String payLoad ){
        Datetime signedAt = Datetime.now();

        String authorization = generateAuthHeaderForApi( signedAt, requestUrl, accesskey, secretKey, region, httpMethod, payLoad);

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

    public static string generateAuthHeaderForApi( Datetime signedAt, Url requestUrl, String accesskey, String secretKey, String region, String httpMethod, String payLoad ){

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

        String stringToSign = AWSSignerUtils.getStringToSign( AWSSignerUtils.AWS4AlgorithmTag, signedAt, scope, hashedCononicalrequest);

        Blob signingKey = AWSSignerUtils.getSigningKey(signedAt, secretKey, region, service);

        String signature = AWSSignerUtils.getSignature(stringToSign, signingKey);

        String credentialsAuthorizationHeader = 'Credential=' + accesskey + '/' + scope;
        String signedHeadersAuthorizationHeader = 'SignedHeaders=' + headerNames;
        String signatureAuthorizationHeader = 'Signature=' + signature;
        String authorization = AWSSignerUtils.AWS4AlgorithmTag + ' ' 
            + credentialsAuthorizationHeader + ', '
            + signedHeadersAuthorizationHeader + ', '
            + signatureAuthorizationHeader;
        return authorization;
    }
}