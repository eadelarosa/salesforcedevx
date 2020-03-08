/**
 * Class        : TEST_SubscriptionProcessor
 * Desctipion   : Test class for the RESTful API Web Service class - SubscriptionProcessor.cls
 * Date Created : 04-Mar-2020
 * Author       : eduardo.delarosa@resmed.com.au
 * App          : Generic - Marketing
 */

@isTest
public without sharing class TEST_SubscriptionProcessor {

    @TestSetup
    static void makeData() {

        String CLASS_NAME = 'TEST_SubscriptionProcessor | ';
        String SUBSCRIPTION_TYPE = 'Register Your Product';
        String BASE_URL_NAME = 'Subscription Processor';
        String REST_URL = '/services/apexrest/SubscriptionProcessor/';
        String base_url = NULL;
        String guid = NULL;
        Id testAccountId = NULL;
    
            // Step 1: Retrieve record type for Account
        RecordType recType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Member' AND SobjectType = 'Account' LIMIT 1];

        // Step 2: Create a test Member account
        Account testAcct = new Account(
                FirstName_SPE__c = 'Eduardo',
                FirstName = 'Eduardo',
                LastName_SPE__c = 'Dela Rosa - Unsubscribe',
                LastName = 'Dela Rosa - Unsubscribe',
                Gender__c = 'M',
                Mailing_City_SPE__c = 'Bella Vista',
                Mailing_Country_SPE__c = 'Australia',
                Mailing_State_Province_SPE__c = 'New South Wales',
                Mailing_Street_SPE__c = '1 Elizabeth Macarthur Drive',
                Mailing_Zip_Postal_Code_SPE__c = '2761',
                PersonBirthdate_SPE__c = Date.newInstance(2000,01,01),
                PersonEmail = 'eduardo.delarosa@resmed.com.au',
                PersonEmail_SPE__c = 'eduardo.delarosa@resmed.com.au',
                Phone_SPE__c = '0288842767',
                RecordTypeId = recType.Id,
                Salutation = 'Mr'
        );

        insert testAcct;
        testAccountId = testAcct.Id;

        // Step 3: Create a GUID
        GUIDGenerator gg = new GUIDGenerator(NULL);
        guid = gg.generateGUID(testAccountId);

        System.debug(CLASS_NAME + 'Id of the created test Account: ' + testAccountId);
        System.debug(CLASS_NAME + 'Value of the generated GUID: ' + guid);

        // Step 4: Retrieve the Base URL for unsubscribe type 'Register Your Product'
        base_url = [SELECT Id, Base_URL__c FROM Base_URL__mdt WHERE MasterLabel = 'Subscription Processor' LIMIT 1].Base_URL__c;
        System.debug(CLASS_NAME + 'Value of BASE_URL from Custom Metadata Setting: ' + BASE_URL);
        
        // Step 5: Insert a new entry into the Subscription Map sObject
        Subscription_Map__c subsMap = new Subscription_Map__c (
            Account__c = testAcct.Id,
            GUID__c = guid,
            Type__c = SUBSCRIPTION_TYPE,
            Unsubscribe_URL__c = base_url+REST_URL+guid,
            Unsubscribed__c = false
        );

        insert subsMap;

        System.debug(CLASS_NAME + 'Id of the created Subscription Map: ' + subsMap.Id);
        System.debug(CLASS_NAME + 'Value of the newly created Subscription Map: ' + subsMap);        
    }

    @isTest
    static void testDoGet () {

        // CONTINUE WORKING ON TEST
        // FOUND OUT THAT REGISTRATION IS NOT WORKING, TOO
        final String BASE_URL_NAME = 'Subscription Processor';
        final String REST_URL = '/services/apexrest/SubscriptionProcessor/';

        String base_url = [SELECT Id, Base_URL__c FROM Base_URL__mdt WHERE MasterLabel = 'Subscription Processor' LIMIT 1].Base_URL__c;

        // Before unsubscribe
        Subscription_Map__c subsMap = [SELECT Id, GUID__c, Unsubscribed__c, Unsubscribe_URL__c FROM Subscription_Map__c LIMIT 1];

        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.requestUri = subsMap.Unsubscribe_URL__c;

        System.debug('TEST_SubscriptionProcessor | Unscubscribe full URL: ' + request.requestUri);
        RestContext.request = request;
        RestContext.response = new RestResponse(); 

        // Invoke the doGet() Method of the SubscriptionProcessor
        SubscriptionProcessor.doGet();
        Test.stopTest();

        // After unsubscribe
        subsMap = [SELECT Id, GUID__c, Unsubscribed__c FROM Subscription_Map__c LIMIT 1];

        // The record should be in an Unsubscribed state (i.e., Unsubscribe__c == true)
        System.assertEquals (true, subsMap.Unsubscribed__c);
    }


    @isTest
    static void testNegativeDoGet () {

        final String BASE_URL_NAME = 'Subscription Processor';
        final String REST_URL = '/services/apexrest/SubscriptionProcessor/';

        String base_url = [SELECT Id, Base_URL__c FROM Base_URL__mdt WHERE MasterLabel = 'Subscription Processor' LIMIT 1].Base_URL__c;

        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.requestUri = base_url+REST_URL+'a6s5d5f4e8d5s4s6d8d65s4s254e54t';

        System.debug('TEST_SubscriptionProcessor | Unscubscribe full URL: ' + request.requestUri);
        RestContext.request = request;
        RestContext.response = new RestResponse(); 

        // Invoke the doGet() Method of the SubscriptionProcessor
        SubscriptionProcessor.doGet();
        Test.stopTest();

        // After unsubscribe
        Subscription_Map__c subsMap = [SELECT Id, GUID__c, Unsubscribed__c FROM Subscription_Map__c LIMIT 1];

        // The record should still be in a Subscribed state (i.e., Unsubscribe__c == false)
        System.assertEquals (false, subsMap.Unsubscribed__c);
    }
}
