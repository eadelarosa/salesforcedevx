@isTest
public without sharing class TEST_SubscriptionGenerator {
 
    @TestSetup
    static void makeData() {

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
    }

    @isTest
    static void testCreateSubscriptionURL () {

        String SUBSCRIPTION_TYPE = 'Register Your Product';
        String BASE_URL_KEY = 'Subscription Processor';

        // Step 1: Query for Account Id
        String accId = [SELECT Id FROM Account LIMIT 1].Id;
        System.assert(accId != NULL);

        // Step 2: Get a new GUID using default crypto key (NULL)
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID(accId);
        System.assert(guid != NULL);

        SubscriptionGenerator sg = new SubscriptionGenerator();
        Boolean success = sg.createSubscriptionURL(SUBSCRIPTION_TYPE, accId, guid, BASE_URL_KEY);

        System.assertEquals(true, success);
    }

    @isTest
    static void testNegativeInvalidURLKey () {

        String SUBSCRIPTION_TYPE = 'Register Your Product';
        String BASE_URL_KEY = 'Non-Subscription Processor';

        // Step 1: Query for Account Id
        String accId = [SELECT Id FROM Account LIMIT 1].Id;
        System.assert(accId != NULL);

        // Step 2: Get a new GUID using default crypto key (NULL)
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID(accId);
        System.assert(guid != NULL);

        SubscriptionGenerator sg = new SubscriptionGenerator();
        Boolean success = sg.createSubscriptionURL(SUBSCRIPTION_TYPE, accId, guid, BASE_URL_KEY);

        System.assertEquals(false, success);
    }

    @isTest
    static void testNegativeInvalidAccountId () {

        String SUBSCRIPTION_TYPE = 'Register Your Product';
        String URL_KEY = 'Subscription Processor';

        // Step 1: Query for Account Id
        String accId = 'THIS\'SHOULD\"IVALIDATE()343&#@!';

        // Step 2: Get a new GUID using default crypto key (NULL)
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID(accId);
        System.assert(guid != NULL);

        SubscriptionGenerator sg = new SubscriptionGenerator();
        Boolean success = sg.createSubscriptionURL(SUBSCRIPTION_TYPE, accId, guid, URL_KEY);

        System.assertEquals(false, success);
    }
}
