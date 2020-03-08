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
    
    @HttpGet
    global static void doGet() {
        
        // Retrieve the request object
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Retrieve and validate the GUID from the request
        String guid = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Query Subscription mapping table for the given GUID
        Subscription_Map__c subMap = null;
        
        try {
            subMap = [SELECT Id, GUID__c, Unsubscribed__c, Date_Unsubscribed__c FROM Subscription_Map__c WHERE GUID__c = :guid AND Unsubscribed__c = False LIMIT 1];
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
            }
        }

        res.addHeader('Content-Type', 'text/html');
        res.responseBody = Blob.valueOf('Your subscriber ID ' + guid + ' has been successfully unsubscribed' );
    }
}