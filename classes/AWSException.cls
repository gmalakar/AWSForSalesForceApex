// ===============================
// AUTHOR           : Goutam malakar
// CREATE DATE      : 01/23/2021
// PURPOSE          : AWS Exceptions
// SPECIAL NOTES    :
// ===============================

public class AWSException extends Exception {

    public AWSException( String source, String message){
        this.setMessage( String.format('Source: {0}, Error: {1}.', new List<Object>{ source, message}));
    }

    public AWSException( String argument, String source, String message){
        this.setMessage( String.format('Source: {0}, Argument:{1}, Error: {2}.', new List<Object>{ source, argument, message}));
    }
}