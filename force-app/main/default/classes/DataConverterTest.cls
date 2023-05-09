@isTest
public with sharing class DataConverterTest {
    
    @isTest
    private static void createSObjectsFromJSON_created(){
        String jsonString = '{ "Accounts":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" } ], "Contacts":[ { "Name":"TestName TestLastName", "Phone":"37034123123131", "Id": "contact1", "accountId": "acc1" } ], "Cases":[ { "Status":"New", "Priority":"Medium", "Origin":"Phone", "Id": "acc1", "contactId":"contact1" } ] }';
        
        System.Test.StartTest();
        ResponseBuilder response = DataConverter.createSObjectsFromJSON(jsonString);
        System.Test.StopTest();
        
        System.assertEquals(true, response.isSuccess);
        
        List<Account> accounts = [SELECT Id, (SELECT Id, FirstName FROM Contacts) FROM Account];
        List<Case> cases = [SELECT Id FROM Case];
        
        System.assertEquals(1, accounts.size());
        System.assertEquals(1, accounts[0].Contacts.size());
        System.assertEquals(1, cases.size());
    }

    @isTest
    private static void createSObjectsFromJSON_noTypeFound(){
        String jsonString = '{ "Failer":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" } ], "Fail":[ { "Name":"TestName TestLastName", "Phone":"37034123123131", "Id": "contact1", "accountId": "acc1" } ], "CustomSobjectToFaile":[ { "Status":"New", "Priority":"Medium", "Origin":"Phone", "Id": "acc1", "contactId":"acc1" } ] }';
        
        System.Test.StartTest();
        ResponseBuilder response = DataConverter.createSObjectsFromJSON(jsonString);
        System.Test.StopTest();

        System.assertEquals(false, response.isSuccess);
        System.assertEquals(true, response.message != null);
        System.assertEquals(true, response.message != 'Created');
    }
	
    @isTest
    private static void createSObjectsFromJSON_error (){
        String jsonString = '{ "Accounts":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" } ], "Contacts":[ { "Name":"TestName TestLastName", "Phone":"37034123123131", "Id": "contact1", "accountId": "acc1" } ], "Cases":[ { "Status":"New", "Priority":"Medium", "Origin":"Phone", "Id": "acc1", "contactId":"error" } ] }';
        
        System.Test.StartTest();
        ResponseBuilder response = DataConverter.createSObjectsFromJSON(jsonString);
        System.Test.StopTest();
        
        System.assertEquals(false, response.isSuccess);
        System.assertEquals(true, response.message != null);
        
        List<Account> accounts = [SELECT Id, (SELECT Id, FirstName FROM Contacts) FROM Account];
        List<Case> cases = [SELECT Id FROM Case];
        
        System.assertEquals(0, accounts.size());
        System.assertEquals(0, cases.size());
    }
    
    @isTest
    private static void createSObjectsFromJSON_createdWithoutRefferences(){
        String jsonString = '{ "Accounts":[ { "Name":"TestName TestLastName", "Priority":"High", "Rating": "Hot", "Id": "acc1" } ], "Contacts":[ { "Name":"TestName TestLastName", "Phone":"37034123123131", "Id": "contact1" } ], "Cases":[ { "Status":"New", "Priority":"Medium", "Origin":"Phone", "Id": "acc1" } ] }';
        
        System.Test.StartTest();
        ResponseBuilder response = DataConverter.createSObjectsFromJSON(jsonString);
        System.Test.StopTest();
        
        System.assertEquals(true, response.isSuccess);
    
        List<Account> accounts = [SELECT Id, (SELECT Id, FirstName FROM Contacts) FROM Account];
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Case> cases = [SELECT Id FROM Case];
        
        System.assertEquals(1, accounts.size());
        System.assertEquals(0, accounts[0].Contacts.size());
        System.assertEquals(1, contacts.size());
        System.assertEquals(1, cases.size());
    }
}