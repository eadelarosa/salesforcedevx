/**
 * @author Eduardo Dela Rosa
 * @dateCreated 02-Mar-2020
 * @Descripion. SubscriptionGenerator is a utility class that will help create a record entry into 
 *              the Subscription Map table - which is utilized by the Subscription Processor REST API
 *              when an end customer chose to unsubscribe/opt-out from such subscription.
 */
public without sharing class SubscriptionGenerator {

    private static final String CLASS_NAME = 'SubscriptionGenerator.cls | ';
    private String locURL = NULL;

    /**
     * Description. This public would be invoked by client Apex classes when there's a need to create
     *              a subscription mapping between an account and subscription. This will build a new record 
     *              out of the GUID and URL and will be inserted the Subscription Map.
     * @param String type - the type of subscription to unsubscribe
     * @param String accId - the account Id to search for
     * @param String guid - the unique guid to set as paramater to the URL
     * @param String URLKey - the URLKey (MasterLabel) to retrieve from the Base_URL__mdt
     */
    public Boolean createSubscriptionURL (String type, String accId, String guid, String URLkey) {


        // Step 1. Validate and retrieve URLkey; see if a record is existing in the custom metadata setting
        this.locURL = getURL(URLkey); // assign the retrieve URL to the instance var
        if (this.locURL == NULL) {
            System.debug(CLASS_NAME + 'Can\'t do much, unable to retrieve the URL based on the URLkey - ' + URLkey);
            return false;
        }

        // Step 2. Build the whole unsubscribe URL and create an entry into the Subscription_Map__c
        String unsubURL = this.locURL.trim() + guid.trim();
        Subscription_Map__c mapRec = NULL;

        try {
             mapRec = new Subscription_Map__c(
                Unsubscribe_URL__c = unsubURL, 
                Type__c = type, 
                GUID__c = guid.trim(), 
                Account__c = accId);
    
                insert mapRec;
        } catch (Exception e) {
            System.debug(CLASS_NAME + 'Error while inserting new Subscription Map record with guid ' + guid.trim() + ' | Message ' + e.getMessage());
        }

        if (mapRec == NULL) {
            return false;
        }

        System.debug(CLASS_NAME + 'Subscription Map record successfully created | Value of Subscription_Map__c.GUID__c: ' + mapRec.GUID__c);
        return true;

    }

    private String getURL(String URLkey) {

        System.debug(CLASS_NAME + 'Inside the SubscriptionGenerator.getURL | Value of URLKkey: ' + URLkey);
        Base_URL__mdt urlObj = NULL;

        try {
            urlObj = [SELECT Id, Base_URL__c FROM Base_URL__mdt WHERE MasterLabel = :URLkey LIMIT 1];
            System.debug(CLASS_NAME + 'getURL() | After an attempt to retrieve the value of Base URL for Subscription Generator | Value of Base_URL__mdt.Base_URL__c: ' + urlObj.Base_URL__c);
        } catch (Exception e) {
            System.debug(CLASS_NAME + 'getURL() | Unable to validate URLKey | Error | ' + e.getMessage());
        }


        if (urlObj == NULL) { // something must have gone wrong when retrieving URLkey
            System.debug(CLASS_NAME + 'getURL() | Base_URL__mdt is NULL.');
            return NULL;
        }

        return urlObj.Base_URL__c;
    }
}
