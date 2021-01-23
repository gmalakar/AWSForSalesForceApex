public class AWSException extends Exception {
    public AWSException( String source, String message){
        this.setMessage( message + ' from [' +source +']');
    }
}