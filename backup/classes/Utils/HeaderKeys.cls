public abstract class HeaderKeys {
	public static final String IfModifiedSinceHeader = 'If-Modified-Since';
        public static final String IfMatchHeader = 'If-Match';
        public static final String IfNoneMatchHeader = 'If-None-Match';
        public static final String IfUnmodifiedSinceHeader = 'If-Unmodified-Since';
        public static final String ConfirmSelfBucketAccess = 'x-amz-confirm-remove-self-bucket-access';
        public static final String ContentRangeHeader = 'Content-Range';
        public static final String ContentTypeHeader = 'Content-Type';
        public static final String ContentLengthHeader = 'Content-Length';
        public static final String ContentMD5Header = 'Content-MD5';
        public static final String ContentEncodingHeader = 'Content-Encoding';
        public static final String ContentDispositionHeader = 'Content-Disposition';
        public static final String ETagHeader = 'ETag';
        public static final String Expires = 'Expires';
        public static final String AuthorizationHeader = 'Authorization';
        public static final String HostHeader = 'host';
        public static final String UserAgentHeader = 'User-Agent';
        public static final String LocationHeader = 'location';
        public static final String DateHeader = 'Date';
        public static final String RangeHeader = 'Range';
        public static final String ExpectHeader = 'Expect';
        public static final String AcceptHeader = 'Accept';
        public static final String ConnectionHeader = 'Connection';
        public static final String StatusHeader = 'Status';
        public static final String XHttpMethodOverrideHeader = 'X-HTTP-Method-Override';
        public static final String TransferEncodingHeader = 'transfer-encoding';

        public static final String RequestIdHeader = 'x-amzn-RequestId';
        public static final String XAmzId2Header = 'x-amz-id-2';
        public static final String XAmzCloudFrontIdHeader = 'X-Amz-Cf-Id';
        public static final String XAmzRequestIdHeader = 'x-amz-request-id';
        public static final String XAmzDateHeader = 'X-Amz-Date';
        public static final String XAmzErrorType = 'x-amzn-ErrorType';
        public static final String XAmznErrorMessage = 'x-amzn-error-message';
        public static final String XAmzSignedHeadersHeader = 'X-Amz-SignedHeaders';
        public static final String XAmzContentSha256Header = 'X-Amz-Content-SHA256';
        public static final String XAmzDecodedContentLengthHeader = 'X-Amz-Decoded-Content-Length';
        public static final String XAmzSecurityTokenHeader = 'x-amz-security-token';
        public static final String XAmzAuthorizationHeader = 'X-Amzn-Authorization';
        public static final String XAmzNonceHeader = 'x-amz-nonce';
        public static final String XAmzServerSideEncryptionHeader = 'x-amz-server-side-encryption';
        public static final String XAmzServerSideEncryptionAwsKmsKeyIdHeader = 'x-amz-server-side-encryption-aws-kms-key-id';
        public static final String XAmzBucketRegion = 'x-amz-bucket-region';
        public static final String XAmzAccountId = 'x-amz-account-id';
        public static final String XAmzOutpostId = 'x-amz-outpost-id';
        public static final String XAmzApiVersion = 'x-amz-api-version';

        public static final String XAmzSSECustomerAlgorithmHeader = 'x-amz-server-side-encryption-customer-algorithm';
        public static final String XAmzSSECustomerKeyHeader = 'x-amz-server-side-encryption-customer-key';
        public static final String XAmzSSECustomerKeyMD5Header = 'x-amz-server-side-encryption-customer-key-MD5';

        public static final String XAmzCopySourceSSECustomerAlgorithmHeader = 'x-amz-copy-source-server-side-encryption-customer-algorithm';
        public static final String XAmzCopySourceSSECustomerKeyHeader = 'x-amz-copy-source-server-side-encryption-customer-key';
        public static final String XAmzCopySourceSSECustomerKeyMD5Header = 'x-amz-copy-source-server-side-encryption-customer-key-MD5';

        public static final String XAmzStorageClassHeader = 'x-amz-storage-class';
        public static final String XAmzWebsiteRedirectLocationHeader = 'x-amz-website-redirect-location';
        public static final String XAmzContentLengthHeader = 'x-amz-content-length';
        public static final String XAmzAclHeader = 'x-amz-acl';
        public static final String XAmzCopySourceHeader = 'x-amz-copy-source';
        public static final String XAmzCopySourceRangeHeader = 'x-amz-copy-source-range';
        public static final String XAmzCopySourceIfMatchHeader = 'x-amz-copy-source-if-match';
        public static final String XAmzCopySourceIfModifiedSinceHeader = 'x-amz-copy-source-if-modified-since';
        public static final String XAmzCopySourceIfNoneMatchHeader = 'x-amz-copy-source-if-none-match';
        public static final String XAmzCopySourceIfUnmodifiedSinceHeader = 'x-amz-copy-source-if-unmodified-since';
        public static final String XAmzMetadataDirectiveHeader = 'x-amz-metadata-directive';
        public static final String XAmzMfaHeader = 'x-amz-mfa';
        public static final String XAmzVersionIdHeader = 'x-amz-version-id';
        public static final String XAmzUserAgentHeader = 'x-amz-user-agent';
        public static final String XAmzAbortDateHeader = 'x-amz-abort-date';
        public static final String XAmzAbortRuleIdHeader = 'x-amz-abort-rule-id';
        public static final String XAmznTraceIdHeader = 'x-amzn-trace-id';

        public static final String XAwsEc2MetadataTokenTtlSeconds = 'x-aws-ec2-metadata-token-ttl-seconds';
        public static final String XAwsEc2MetadataToken = 'x-aws-ec2-metadata-token';

        public static final String AmzSdkInvocationId = 'amz-sdk-invocation-id';
        public static final String AmzSdkRequest = 'amz-sdk-request';
}
