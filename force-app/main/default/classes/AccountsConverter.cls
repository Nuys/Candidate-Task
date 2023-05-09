public with sharing class AccountsConverter implements ConverterInterface {

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param objectMap - object details map
    * @param mappingList - map with fields mapping info
    * @description convert map with details to Account
    * @return List<SObject> - Accounts objects List
    */
    public List<SObject> convert(List<Object> objectList, List<Map<String, String>> mappingList){
        List<SObject> buildedSobjectList = new List<SObject>();
        for(Object obj: objectList){
            Map<String, Object> objMap = (Map<String, Object>)obj;
            Account newAcc = new Account();
            for(Map<String, String> fieldMap: mappingList){
                newAcc.put(fieldMap.get(Constants.SOBJECT_FIELD), objMap.get(fieldMap.get(Constants.PAYLOAD_FIELD)));
            }
            buildedSobjectList.add(newAcc);
        }
        return buildedSobjectList;
    }

}