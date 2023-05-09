 /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @description creation of SObjects by JSON string data
    * Test classes: DataConverterTest
    */
public with sharing class DataConverter {

    
    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param jsonData - JSON, to create SObjects
    * @description creation of SObjects by JSON string data
    * @return ResponseBuilder - response with status of dml operation and info msg
    */
    public static ResponseBuilder createSObjectsFromJSON(String jsonData){
        ResponseBuilder response;
    
        try{
            List<SObject> sObjectsToInsert = new List<SObject>();
            Map<String, List<Object>> sObjectApiNameToDataMap = DataConverterHelper.obtainJSONData(jsonData);
            List<Object_Mapping__mdt> mappingList = [SELECT Object_API_Name__c, Payload_Field_API_Name__c, SObject_Field_API_Name__c FROM Object_Mapping__mdt WHERE Object_API_Name__c IN: sObjectApiNameToDataMap.keySet()];
            Map<String, List<Map<String, String>>> fieldMappingMap = DataConverterHelper.buildFieldMappingMap(mappingList);

            for(String objApiName: sObjectApiNameToDataMap.keySet()){
                String converterName = objApiName + Constants.CONVERTER;
                Type converterType = Type.forName(converterName);
                if(converterType != null){
                    List<SObject> sObjectList = ((ConverterInterface)converterType.newInstance()).convert(sObjectApiNameToDataMap.get(objApiName), fieldMappingMap.get(objApiName));
                    if(sObjectList != null && !sObjectList.isEmpty()){
                        sObjectsToInsert.addAll(sObjectList);
                    }
                }else{
                    throw new TypeNotFoundErrorException(System.Label.Convertion_Error_Label);
                }
            }

            if(!sObjectsToInsert.isEmpty()){
                System.debug('sObjectsToInsert==> ' + sObjectsToInsert);
                insert sObjectsToInsert;
                response = new ResponseBuilder(true, System.Label.Records_Created_Successfully_Label);
            }
        }catch(Exception ex){
            response = new ResponseBuilder(false, ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        return response;
    }

    private class TypeNotFoundErrorException extends Exception{}
}   