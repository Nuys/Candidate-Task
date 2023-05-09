global class ResponseBuilder {
    
    @AuraEnabled
    global String message { get; set; }
   
    @AuraEnabled
    global Object responseData { get; set; }
   
    @AuraEnabled
    global Boolean isSuccess  { get; set; }

    public ResponseBuilder(Boolean isSuccess, String message) {
        this.isSuccess = isSuccess;
        this.message = message;
    }

    public ResponseBuilder(Boolean isSuccess, String message, Object responseData) {
        this.isSuccess = isSuccess;
        this.message = message;
        this.responseData = responseData;
    }

    public ResponseBuilder(Boolean isSuccess, Object responseData) {
        this.isSuccess = isSuccess;
        this.responseData = responseData;
    }
}