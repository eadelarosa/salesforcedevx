/**
 * Author: Eduardo Dela Rosa
 * Date Created: 28-Feb-2020
 * Class: GUIDGenerator.class
 * Description: This class will be used as instance-wide GUID generator for any business processes that requires one. 
 *              This is primarily created for unsubscribe process.
 */
public with sharing class GUIDGenerator {
    
    private final Blob CRYPTOKEY;
    private static final String CLASS_NAME = 'GUIDGenerator.class'; 
    private static final String AES_ALGO = 'AES256'; 

    /**
     * Description: GUIDGenerator - consructor which would initialize an instance of this generator
     * @param cryptoKey - Blob parameter is required in order to generate GUID. Pass in a NULL value  
     *                    if you want to use the default entry in the custom metadata settings. A
     *                    new one will be created if a default doesn't exist yet. A key must be
     *                    generated using Crypto.generateAESKey(256);
     */
    public GUIDGenerator(Blob cryptoKey) {
        if (cryptoKey == NULL) {
            System.debug(CLASS_NAME + ' | No crypto key parameter was detected | Using default crypto key instead.');

            Blob defaultKey = null;
            
            try {
                Unsubscribe_Crypto_Key__mdt mKey = [SELECT Id, Keys__c FROM Unsubscribe_Crypto_Key__mdt WHERE MasterLabel = 'Default' LIMIT 1];
                defaultKey = EncodingUtil.base64Decode(mKey.Keys__c);
                System.debug(CLASS_NAME + ' | Value of default key: ' + mKey.Keys__c + ', length: ' + mKey.Keys__c.length());

            } Catch (Exception e1) {
                System.debug(CLASS_NAME + ' | I was unable to find entry for default crypto key in Unubscribe_Crypto_Key__mdt; check that there is a default entry');
            }

            if (defaultKey != NULL) {
                this.CRYPTOKEY = defaultKey; // use the default key
            }
        } else {
            this.CRYPTOKEY = cryptoKey; // use the passed key
        }
    }

    /**
     * @Method generateGUID
     * @param String clearData - the plain text that you want to generate GUID against; length MUST NOT EXCEED 80 chars
     * 
     */
    public String generateGUID (String clearData) {
        
        if (this.CRYPTOKEY == NULL) {
            System.debug(CLASS_NAME + ' | GUID Generator was not initialized with a valid Crypto key.');
            return NULL;
        }

        if (clearData != NULL && clearData.length() > 80) {
            System.debug(CLASS_NAME + ' | Parameter MUST NOT exceed 80 characters.');
            RETURN NULL;
        }

        Blob newGUID = Crypto.encryptWithManagedIV(AES_ALGO, this.CRYPTOKEY, Blob.valueOf(clearData));
        String strGUID = EncodingUtil.base64Encode(newGUID);
        System.debug(CLASS_NAME + ' | New GUID generated - ' + strGUID);

        return strGUID;
    }
}