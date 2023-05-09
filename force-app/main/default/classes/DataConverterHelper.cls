public inherited sharing class DataConverterHelper {
     /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param jsonData - JSON, to create SObjects
    * @description - obtain JSON and build Map SObject name to List of them
    * @return Map<String, List<Object>> - map with Object details
    */
    public static Map<String, List<Object>> obtainJSONData(String jsonData){//,aybe deserilise can be done without this method
        Map<String, List<Object>> objApiNameToObjectsData = new Map<String, List<Object>>();

        Map<String, Object> jsonDataMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        
        for(String objName: jsonDataMap.keySet()){
            List<Object> objects = new List<Object>();
            for (Object objData : (List<Object>) jsonDataMap.get(objName)) {
                objects.add((Map<String, Object>) objData);
            }
            objApiNameToObjectsData.put(objName, objects);
        }

        return objApiNameToObjectsData;
    }

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param mappingList - list with Object_Mapping__mdt records
    * @description - build Map: object to parser fields details 
    * @return Map<String, List<Object>> - map with Object details
    */
    public static Map<String, List<Map<String, String>>> buildFieldMappingMap(List<Object_Mapping__mdt> mappingList){
        Map<String, List<Map<String, String>>> objectFieldMappingMap = new Map<String, List<Map<String, String>>>();
        for (Object_Mapping__mdt mapping : mappingList) {
            String objectApiName = mapping.Object_API_Name__c;
        
            if (!objectFieldMappingMap.containsKey(objectApiName)) {
                objectFieldMappingMap.put(objectApiName, new List<Map<String, String>>());
            }
        
            Map<String, String> fieldMap = new Map<String, String>();
            fieldMap.put(Constants.PAYLOAD_FIELD, mapping.Payload_Field_API_Name__c);
            fieldMap.put(Constants.SOBJECT_FIELD, mapping.SObject_Field_API_Name__c);
        
            objectFieldMappingMap.get(objectApiName).add(fieldMap);
        }
        return objectFieldMappingMap;
    }
}