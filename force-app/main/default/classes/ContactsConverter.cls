public with sharing class ContactsConverter implements ConverterInterface{
    
     /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @param objectMap - object details map
    * @param mappingList - map with fields mapping info
    * @description convert map with details to Contacts
    * @return List<SObject> - Contact objects List
    */
    public List<SObject> convert(List<Object> objectList, List<Map<String, String>> mappingList){
        List<SObject> buildedSobjectList = new List<SObject>();
        for(Object obj: objectList){
            Map<String, Object> objMap = (Map<String, Object>)obj;
            Contact newContact = new Contact();
            for(Map<String, String> fieldMap: mappingList){
                newContact.put(fieldMap.get(Constants.SOBJECT_FIELD), objMap.get(fieldMap.get(Constants.PAYLOAD_FIELD)));
            }
            
            if(objMap.containsKey(Constants.NAME)){
                String[] fullName = String.valueOf(objMap.get(Constants.NAME)).split(' ');

                newContact.FirstName = fullName[0];
                if (fullName.size() > 1) {
                    newContact.LastName = fullName[fullName.size() - 1];
                }
            }

            if(objMap.containsKey(Constants.ACCOUNT_ID)){
                newContact.Account = new Account( Account_External_Id__c = String.valueOf(objMap.get(Constants.ACCOUNT_ID)));
            }

            buildedSobjectList.add(newContact);
        }
        return buildedSobjectList;
    }

}   