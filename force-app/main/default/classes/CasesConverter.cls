public with sharing class CasesConverter implements ConverterInterface{

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param objectMap - object details map
    * @param mappingList - map with fields mapping info
    * @description convert map with details to Case object
    * @return List<SObject> - Cases objects List
    */
    public List<SObject> convert(List<Object> objectList, List<Map<String, String>> mappingList){
        List<SObject> buildedSobjectList = new List<SObject>();
        for(Object obj: objectList){
            Map<String, Object> objMap = (Map<String, Object>)obj;
            Case newCase = new Case();

            for(Map<String, String> fieldMap: mappingList){
                newCase.put(fieldMap.get(Constants.SOBJECT_FIELD), objMap.get(fieldMap.get(Constants.PAYLOAD_FIELD)));
            }

            if(objMap.containsKey(Constants.CONTACT_ID)){
                newCase.Contact = new Contact(Contact_External_Id__c = String.valueOf(objMap.get(Constants.CONTACT_ID)));
            }
            buildedSobjectList.add(newCase);
        }
        return buildedSobjectList;
    }

}