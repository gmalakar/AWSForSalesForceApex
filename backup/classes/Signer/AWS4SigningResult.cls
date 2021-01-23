public class AWS4SigningResult {
        static final String _awsAccessKeyId;
        static final DateTime _originalDateTime;
        static final String _signedHeaders; 
        static final String _scope;
        static final Blob _signingKey;
        static final Blob _signature;

        /// <summary>
        /// Constructs a new signing result instance for a computed signature
        /// </summary>
        /// <param name="awsAccessKeyId">The access key that was included in the signature</param>
        /// <param name="signedAt">Date/time (UTC) that the signature was computed</param>
        /// <param name="signedHeaders">The collection of headers names that were included in the signature</param>
        /// <param name="scope">Formatted 'scope' value for signing (YYYYMMDD/region/service/aws4_request)</param>
        /// <param name="signingKey">Returns the key that was used to compute the signature</param>
        /// <param name="signature">Computed signature</param>
        public AWS4SigningResult(String awsAccessKeyId, 
                                 DateTime signedAt, 
                                 String signedHeaders, 
                                 String scope, 
                                 Blob signingKey, 
                                 Blob signature)
        {
            this._awsAccessKeyId = awsAccessKeyId;
            this._originalDateTime = signedAt;
            this._signedHeaders = signedHeaders;
            this._scope = scope;
            this._signingKey = signingKey;
            this._signature = signature;
        }

        /// <summary>
        /// The access key that was used in signature computation.
        /// </summary>
        public String AccessKeyId
        {
            get { return _awsAccessKeyId; }
        }

        /// <summary>
        /// ISO8601 formatted date/time that the signature was computed
        /// </summary>
        public String ISO8601DateTime
        {
            get { return AWS4Signer.FormatDateTime(_originalDateTime, AWSSDKUtils.ISO8601BasicDateTimeFormat); }
        }

        /// <summary>
        /// ISO8601 formatted date that the signature was computed
        /// </summary>
        public String ISO8601Date
        {
            get { return AWS4Signer.FormatDateTime(_originalDateTime, AWSSDKUtils.ISO8601BasicDateFormat); }
        }

        /// <summary>
        /// The ;-delimited collection of header names that were included in the signature computation
        /// </summary>
        public String SignedHeaders
        {
            get
            {
                return _signedHeaders;                
            }
        }

        /// <summary>
        /// Formatted 'scope' value for signing (YYYYMMDD/region/service/aws4_request)
        /// </summary>
        public String Scope
        {
            get { return _scope; }
        }

        /// <summary>
        /// Returns a copy of the key that was used to compute the signature
        /// </summary>
        public Blob SigningKey
        {
            get
            {
                return AWSSDKUtils.BlobCopy(_signingKey);
            }
        }

        /// <summary>
        /// Returns the hex String representing the signature
        /// </summary>
        public String Signature
        {
            get
            {
                return AWSSDKUtils.ToHex(_signature, true);
            }
        }

        /// <summary>
        /// Returns a copy of the byte array containing the signature
        /// </summary>
        public Blob SignatureBytes
        {
            get
            {
                return AWSSDKUtils.BlobCopy(_signature);
            }
        }

        /// <summary>
        /// Returns the signature in a form usable as an 'Authorization' header value.
        /// </summary>
        public String ForAuthorizationHeader
        {
            get
            {
                List<String> authorizationHeader = new List<String>();
                authorizationHeader.add(AWS4Signer.AWS4AlgorithmTag);
                authorizationHeader.add( String.format(' {0}={1}/{2},', new List<Object>{AWS4Signer.Credential, AccessKeyId, Scope} ) );
                authorizationHeader.add( String.format(' {0}={1},', new List<Object>{AWS4Signer.SignedHeaders, SignedHeaders} ) );
                authorizationHeader.add( String.format(' {0}={1},', new List<Object>{AWS4Signer.Signature, Signature} ) );
                
                return String.join( authorizationHeader,'' );
            }
        }

        /// <summary>
        /// Returns the signature in a form usable as a set of query String parameters.
        /// </summary>
        public String ForQueryParameters
        {
            get
            {
                List<String> authParams = new List<String>();
                authParams.add( AWS4Signer.AWS4AlgorithmTag );
                authParams.add( String.format('{0}={1}', new List<Object>{AWS4Signer.XAmzAlgorithm, AWS4Signer.AWS4AlgorithmTag} ) );
                authParams.add( String.format('&{0}={1},', new List<Object>{AWS4Signer.XAmzCredential, 
                    String.format('{0}/{1}', new List<Object>{AccessKeyId, Scope} ) } ) );
                authParams.add( String.format('&{0}={1},', new List<Object>{HeaderKeys.XAmzDateHeader, ISO8601DateTime} ) );
                authParams.add( String.format('&{0}={1},', new List<Object>{AWS4Signer.XAmzSignedHeadersHeader, SignedHeaders} ) );
                authParams.add( String.format('&{0}={1},', new List<Object>{AWS4Signer.XAmzSignature, Signature} ) );
                
                return String.join( authParams,'' );
            }
        }

}
