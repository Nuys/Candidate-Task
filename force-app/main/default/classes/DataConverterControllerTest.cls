@isTest
public with sharing class DataConverterControllerTest {

    @TestSetup
    private static void makeData(){
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'test.json';
        cv.VersionData = Blob.valueOf('{ "Accounts":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" }]}');
        insert cv;
    }

    @isTest
    private static void createJSONRecords_created(){
        String jsonString = '{ "Accounts":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" } ], "Contacts":[ { "Name":"TestName TestLastName", "Phone":"37034123123131", "Id": "contact1", "accountId": "acc1" } ], "Cases":[ { "Status":"New", "Priority":"Medium", "Origin":"Phone", "Id": "acc1", "contactId":"contact1" } ] }';
        
        System.Test.StartTest();
        ResponseBuilder response = DataConverterController.createJSONRecords(jsonString);
        System.Test.StopTest();
        
        System.assertEquals(true, response.isSuccess);
        
        List<Account> accounts = [SELECT Id, (SELECT Id, FirstName FROM Contacts) FROM Account];
        List<Case> cases = [SELECT Id FROM Case];
        
        System.assertEquals(1, accounts.size());
        System.assertEquals(1, accounts[0].Contacts.size());
        System.assertEquals(1, cases.size());
    }

    @isTest
    private static void getContentDocBodyById_Error(){
       
       ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'Test Document' LIMIT 1];
       System.Test.StartTest();
       ResponseBuilder response = DataConverterController.getContentDocBodyById(cv.Id);
       System.Test.StopTest();
	
       System.assertEquals(false, response.isSuccess); 

    }
}