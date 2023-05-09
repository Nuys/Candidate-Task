public with sharing class DataConverterController {

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param jsonData - JSON, to create SObjects
    * @description Method to create records from JSON string and accept it from Lightning component
    * @return Response - response object with status and message
    */
    @AuraEnabled
    public static ResponseBuilder createJSONRecords(String jsonData){
        return DataConverter.createSObjectsFromJSON(jsonData);
    }
    
    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param cdId - id of downloaded file
    * @description Method to getted saved ContentVersion via upload file 
    * @return Response - response object with status and Json file
    */
    @AuraEnabled
    public static ResponseBuilder getContentDocBodyById(String cdId) {
        ResponseBuilder response;
        try{
            ContentVersion cv = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: cdId];

            response = new ResponseBuilder(true, 'Selected', cv.VersionData.toString());
        }catch(Exception ex){
            response = new ResponseBuilder(false, ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        return response;
    }

}