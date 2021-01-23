public class AWSExamples {

    public static HttpResponse invokeApi(){
        AWSConfig.APIGateway apiConfig = new AWSConfig.APIGateway('<your access key>', '<your secret key>' );
        AWSServiceClient.APIGateway apiClient = new AWSServiceClient.APIGateway( apiConfig );
        apiConfig.ApiKey = '<your api key>';
        apiConfig.Stage = '<your stage name>'; //example v1, prod, stag
        apiConfig.Region = '<your region>'; //default is 'us-east-1'
        apiConfig.HttpMethod = AWSUtils.HttpMethod.Post; // http method, default is Get
        String payload = '<your pay load>'; //request body
        return apiClient.invokeApi('zip-and-get-key', payload );
    }
}
