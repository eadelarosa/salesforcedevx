@isTest
public without sharing class TEST_GUIDGenerator {

    @isTest
    static void testGUIDGenerator () {
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID('ClearDataArg');

        System.assert(guid != null);
    }

    @isTest
    static void testNegativeInvalidClearData () {
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID(NULL);

        System.assert(guid == null);
    }

    @isTest
    static void testNegativeLengthyClearData () {
        GUIDGenerator gg = new GUIDGenerator(NULL);
        String guid = gg.generateGUID('123456789009876543211234567890098765432112345678900987654321123456789009876543211');

        System.assert(guid == null);
    }

    @isTest
    static void testCryptoKeyIsNotNull () {
        String strKey = NULL;
        Blob blobKey = NULL;

        try {
            strKey = [SELECT Id, Keys__c FROM Unsubscribe_Crypto_Key__mdt WHERE MasterLabel = 'Default' LIMIT 1].Keys__c;
            blobKey = EncodingUtil.base64Decode(strKey);
        } Catch (Exception e) {
            System.debug('TEST_GUIDGenerator | Couldn\'t retrieve the crypto key named \'GUIDGeneratorKey\'');
        }

        System.assert(strKey != NULL); // fail fast

        GUIDGenerator gg = new GUIDGenerator(blobKey);
        String guid = gg.generateGUID('ClearData');

        System.assert(guid != null);
    }
}
