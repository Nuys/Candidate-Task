@isTest
public with sharing class CreatedDataControllerTest {
    
    @TestSetup
    private static void makeData(){
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }

    @isTest
    private static void getSObjectData_success(){
        Account testAcc = [SELECT Id, Name FROM Account LIMIT 1];

        System.Test.StartTest();
        ResponseBuilder response = CreatedDataController.getSObjectData('Account', 'Id, Name');
        System.Test.StopTest();

        System.assertEquals(true, response.isSuccess);
        System.assert(true, response.responseData !=null);

        Object responseData = response.responseData;
        Map<String, Object> resultMap = (Map<String, Object>)responseData;
       	List<Map<String, Object>> dataList = (List<Map<String, Object>>)resultMap.get('data');
        Map<String, Object> dataMap = (Map<String, Object>)dataList[0];

        System.assertEquals(testAcc.Name, String.valueOf(dataMap.get('Name')));
        
    }

    @isTest
    private static void getSObjectData_error(){

        System.Test.StartTest();
        ResponseBuilder response = CreatedDataController.getSObjectData('', 'Id, Name');
        System.Test.StopTest();

        System.assertEquals(false, response.isSuccess);
        System.assert(true, response.responseData !=null);
    
    }

}