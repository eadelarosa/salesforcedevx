/**
 * Class        : SubscriptionProcessor.cls
 * Description  : RESTful API Web Service that processes the unsubscribe request by a customer
 * Date Created : 25-Feb-2020
 * Author       : eduardo.delarosa@resmed.com.au
 * App          : Generic - Marketing
 */

 /*
  * Base (case-sensitive) endpoint definition is https://<instance>.force.com/services/apexrest/ 
  */
@RestResource(urlMapping='/SubscriptionProcessor/*')
global without sharing class SubscriptionProcessor {
    
    static final String URL_MAPPING_NAME = 'SubscriptionProcessor';
    static final Integer URL_MAPPING_LENGTH = URL_MAPPING_NAME.length() + 1;

    @HttpGet
    global static void doGet() {
        
        // Retrieve the request object
        RestRequest req = RestContext.request;

        // Retrieve and validate the GUID from the request
        String guid = req.requestURI.substring(req.requestURI.indexOf(URL_MAPPING_NAME) + URL_MAPPING_LENGTH);
        
        // Query Subscription mapping table for the given GUID
        Subscription_Map__c subMap = null;
        
        try {
            subMap = [SELECT Id, GUID__c, Unsubscribed__c, Date_Unsubscribed__c FROM Subscription_Map__c WHERE GUID__c = :guid AND Unsubscribed__c = False LIMIT 1];
            System.debug('SubscriptionProcessor | Value of the queried Subscription Map: ' + subMap);            
        } catch (Exception e) {
            // It's okay if nonthing is found; it would mean that the GUID may have already been unsubscribed
            System.debug('There was no entry found in the database for GUID ' + guid);            
        }
       
        // If GUID exists, then validate and process update its "Unsubscribed__c" flag to TRUE
        if (subMap != null) {

            System.debug ('*** 1 | Value of GUID: ' + subMap.GUID__c);

            // If this is the first time the request has been received, then unsubscribe the customer
            If (!subMap.Unsubscribed__c) {

                subMap.Unsubscribed__c = TRUE;
                subMap.Date_Unsubscribed__c = DateTime.Now();

                // Update the record
                update subMap;
                System.debug('SubscriptionProcessor | Updated the record Subscription Map successfully - Unsubscribed__c = ' + subMap.Unsubscribed__c);            
            }
        }

        RestResponse res = RestContext.response;
        System.debug('Value of RestResponse: ' + res);
        res.addHeader('Content-Type', 'text/html');
        res.responseBody = Blob.valueOf('<html><head><style>.center {font-family: Arial, Helvetica, sans-serif; line-height: 200px; height: 200px; text-align: center; border: 3px solid #000080;}</style></head><body><div class=\"center\"><p>Your subscriber ID ' + guid + ' was successfully unsubscribed</p></div></body></html>' );
    }
}