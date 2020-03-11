/********************************************************************************************
 * Create By     :   Thomas Thankachan
 * Create Date   :   09-March-2017
 * Description   :   RegisterYourProductControllerTest class to define all the test common methods to test RegisterYourProductController class. 
 * Modification Log:
 *   ------------------------------------------------------------------------------------------
 *   * Developer       Date              Description
 *   * ----------------------------------------------------------------------------------------
 *   * TT            09-March-2017       Initial version.
 *   * Fong Tien     30-Jul-2018         Updated Test class to cover more methods.
 *   * Ajit Surana   10-Sept-2019        Updated Test class to cover more methods.
 *   * Ajit Surana   26-Nov-2019         Updated Test class to cover more methods (related to COMMEXC-2068).
 **********************************************************************************************/
@isTest(SeeAllData = False)
public with sharing class RegisterYourProductControllerTest
{
    @testSetup static void setup() {
        // Create Custom Settings records.
        List<RegisterYourProductList__c> csCollection = new List<RegisterYourProductList__c> ();
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D101', ProductName__c = 'AirSense 10 Elite', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D102', ProductName__c = 'AirSense 10 AutoSet with Built-in Wireless Connectivity, HumidAir and ClimateLineAir', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D103', ProductName__c = 'AirSense 10 Autoset', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D104', ProductName__c = 'AirSense 10 Elite with Built-in Wireless Connectivity, HumidAir and ClimateLineAir', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D105', ProductName__c = 'AirSense 10 Autoset for Her', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D106', ProductName__c = 'AirSense 10 AutoSet for Her with Built-in Wireless Connectivity, HumidAir and ClimateLineAi', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-D107', ProductName__c = 'AirCurve 10 CS PaceWave', ProductType__c = 'device'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-H101', ProductName__c = 'H4i Heated Humidifier', ProductType__c = 'humidifier'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-H102', ProductName__c = 'H5i', ProductType__c = 'humidifier'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M101', ProductName__c = 'AirFit™ P10', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M102', ProductName__c = 'AirFit™ N10', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M103', ProductName__c = 'AirFit N20 for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M104', ProductName__c = 'AirFit F20 for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M105', ProductName__c = 'AirFit N20', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M106', ProductName__c = 'AirFit F20', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M107', ProductName__c = 'AirFit P10 for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M108', ProductName__c = 'AirFit™ F10', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M109', ProductName__c = 'AirFit F10 for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M110', ProductName__c = 'AirFit N10 for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M111', ProductName__c = 'Swift FX', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M112', ProductName__c = 'Swift FX Bella', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M113', ProductName__c = 'Swift FX Nano for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M114', ProductName__c = 'Quattro Air for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M115', ProductName__c = 'Swift FX Nano', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M116', ProductName__c = 'MirageTM FX', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M117', ProductName__c = 'Mirage FX for Her', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M118', ProductName__c = 'Quattro Air', ProductType__c = 'mask'));
        csCollection.add(new RegisterYourProductList__c(Name = 'TEST-M119', ProductName__c = 'Pixi Paediatric', ProductType__c = 'mask'));

        insert csCollection;
        
        
        // Create SV_DeviceMask__c records.
        List<SV_DeviceMask__c> deviceMaskList = new List<SV_DeviceMask__c> ();
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = 'AirSense 10 Elite 4G', Is_Web_Enabled__c =true, Mask_Name__c= null, Mask_Size__c = null));
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = 'AirSense 10 Elite 4G', Is_Web_Enabled__c = true, Mask_Name__c='AirFit F20', Mask_Size__c = 'Large'));
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = 'AirSense 10 AutoSet for Her', Is_Web_Enabled__c = true, Mask_Name__c= 'AirFit F30', Mask_Size__c= 'Small'));
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = 'AirMini', Is_Web_Enabled__c = true, Mask_Name__c= 'AirTouch F20 Starter Kit', Mask_Size__c =  'Small'));
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = null, Is_Web_Enabled__c = true, Mask_Name__c= 'AirFit F30' , Mask_Size__c = 'Medium'));
        deviceMaskList.add(new SV_DeviceMask__c(Device_Name__c = null, Is_Web_Enabled__c = true, Mask_Name__c= 'AirFit P10 for Her' , Mask_Size__c = 'Standard'));
        
        /*deviceMaskList.add(new SV_DeviceMask__c(Name = 'TEST-D107', Device_Name__c = 'AirCurve 10 CS PaceWave', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c= ));
        deviceMaskList.add(new SV_DeviceMask__c(Name = 'TEST-H101', Device_Name__c = 'H4i Heated Humidifier', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new SV_DeviceMask__c(Name = 'TEST-H102', Device_Name__c = 'H5i', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M101', ProductName__c = 'AirFit™ P10', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M102', ProductName__c = 'AirFit™ N10', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M103', ProductName__c = 'AirFit N20 for Her', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M104', ProductName__c = 'AirFit F20 for Her', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M105', ProductName__c = 'AirFit N20', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));
        deviceMaskList.add(new RegisterYourProductList__c(Name = 'TEST-M106', ProductName__c = 'AirFit F20', Is_Web_Enabled__c = true, Mask_Name__c=  , Mask_Size__c = ));*/
        
        insert deviceMaskList;
        
        // Create SV Bundles records.
        List<SV_Bundles__c> bundleList = new List<SV_Bundles__c> ();
        bundleList.add(new SV_Bundles__c(Device_Mask__c = deviceMaskList[0].Id, Quantity__c = 1));
        bundleList.add(new SV_Bundles__c(Device_Mask__c = deviceMaskList[1].Id, Quantity__c = 1));
        bundleList.add(new SV_Bundles__c(Device_Mask__c = deviceMaskList[2].Id, Quantity__c= 1));
        bundleList.add(new SV_Bundles__c(Device_Mask__c = deviceMaskList[3].Id, Quantity__c= 1));
        bundleList.add(new SV_Bundles__c(Device_Mask__c = deviceMaskList[4].Id, Quantity__c= 1));
        
        insert bundleList;
    }

    
    @isTest
    private static void testRegisterYourProductController() {

        Test.StartTest();
        
        Resmed_Custom__c rec = new Resmed_Custom__c();
        rec.Name = 'Resmed ERP Setting_AU';
        rec.apikey__c='Test123';
        rec.endpoint__c='Test1234';
        rec.method__c='GET';
        rec.password__c='Test12345';
        rec.resource__c='Test123456';
        rec.username__c='Test12';
        insert rec;
        
        Datetime myDate = Datetime.now();
        String dateOutput = myDate.format('dd/MM/yyyy');
        Case c = new Case();
        c.First_Name__c = 'testfn';
        c.Last_Name__c = 'testfn';
        c.Gender__c = 'M';
        c.SuppliedEmail = 'testfn@mail.com';
        c.Title__c = 'testfn';
        c.Street_Address__c = 'testfn';
        c.State_Region__c = 'testfn';
        c.Post_Code__c = '8745';
        c.Suburb__c = 'testfn';
        c.SuppliedPhone = '55464';
        c.Date_of_Birth__c = '01/05/2015';
        c.Status = 'New';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register Your Product').getRecordTypeId();
        insert c;

        Account acc = new Account();
        acc.LastName = 'Device referring Account';
        acc.PersonEmail = 'testLastName@mail.com';
        acc.Gender__c = 'M';
        acc.Status__c = 'Member';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc;

        Account acc3 = new Account();
        acc3.LastName = 'testLastName';
        acc3.PersonEmail = 'test.thomas@test.com.au';
        acc3.Gender__c = 'M';
        acc3.Status__c = 'Member';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc3;

        Account acc0 = new Account();
        acc0.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Accredited Partner').getRecordTypeId();
        acc0.Type = 'Accredited Partner';
        acc0.Phone = '9876543210';
        acc0.Name = 'testAccName0';
        insert acc0;

        Account acc1 = new Account();
        acc1.Referring_Account__c = acc0.id;
        acc1.Name = 'testLastName1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Accredited Partner').getRecordTypeId();
        acc1.Type = 'Accredited Partner';
        acc1.Phone = '9876543210';
        insert acc1;

        RegisterYourProductController controller = new RegisterYourProductController();
        controller.getDays();
        controller.getMonths();
        controller.getYears();
        controller.getTitles();
        controller.getPurchaseFromString();
        controller.getResmedDevices();
        //controller.getResmedMasks();
        controller.getStates();

        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirSense 10 Elite';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.nonResmedMask = 'Non ResMed Mask';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '123546';
        
        controller.title = 'Mr';
        controller.firstName = 'Test09032017';
        controller.lastName = 'Thomas09032017';
        controller.phone = '0413805555';
        controller.email = 'test.thomas@test.com.au';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub';
        controller.postCode = '2000';
        controller.purchaseDate = dateOutput;
        controller.serialNumber = '22145678901';
        controller.resMedMaskProductCode = '';
        controller.MobileNumber = '8888888888';
        controller.PurchasedFrom = 'testdatadropdown';

        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';
        controller.caseId = c.id;
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testRegisterYourProductController ->' + e.getMessage());
        }

        System.assertEquals(FALSE, controller.isRegistered); // should not pass registration as having invalid domain
        
        controller.newEmail = 'test.thomas@gmail@yahoo.com.au';
        controller.processEmailChangeRequest();

    
        //Re-instantiate controller with testing valid domain
        controller = new RegisterYourProductController();
        controller.getDays();
        controller.getMonths();
        controller.getYears();
        controller.getTitles();
        controller.getGenders();
        controller.getPurchaseFromString();
        controller.getResmedDevices();
        controller.getMaskSizes();
        //controller.getResmedMasks();
        controller.getStates();

        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirSense 10 Elite';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.nonResmedMask = 'Non ResMed Mask';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '123546';
        
        controller.title = 'Mr';
        controller.firstName = 'Test09032017';
        controller.lastName = 'Thomas09032017';
        controller.phone = '0413805555';
        controller.email = 'test.thomas@gmail.com.au';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub';
        controller.postCode = '2000';
        controller.purchaseDate = dateOutput;
        controller.serialNumber = '22145678901';
        controller.resMedMaskProductCode = '';
        controller.MobileNumber = '8888888888';
        controller.PurchasedFrom = 'testdatadropdown';

        bodyBlob = Blob.valueOf('Unit Test Attachment Body - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';
        controller.caseId = c.id;
        controller.callWS();
        RegisterYourProductController.MakeCallout(controller.serialNumber, true);
        
        String XMLString = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns0:Response xmlns:ns0=\"http://apigateway.resmed.com/schemas/ProductServices/SharedResources\"><ns0:ValidatedStatus>N</ns0:ValidatedStatus><ns0:StatusMessage>No match found</ns0:StatusMessage></ns0:Response>';
        RegisterYourProductController.XMLParserMethod(XMLString);
        
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testRegisterYourProductController ->' + e.getMessage());
        }

        System.assertEquals(TRUE, controller.isRegistered); 
        
        controller.email = 'test.thomas@test.com.au';
        controller.newEmail = 'test.thomas@gmail.com.au';
        controller.processEmailChangeRequest();
        
        Test.StopTest();

    }

    @isTest
    private static void testMissingFieldRegisterYourProductController() {

        Test.StartTest();
        Datetime myDate = Datetime.now();
        String dateOutput = myDate.format('dd/MM/yyyy');
        Case c = new Case();
        c.First_Name__c = 'testfn';
        c.Last_Name__c = 'testfn';
        c.Gender__c = 'M';
        c.SuppliedEmail = 'testfn@mail.com';
        c.Title__c = 'testfn';
        c.Street_Address__c = 'testfn';
        c.State_Region__c = 'testfn';
        c.Post_Code__c = '8745';
        c.Suburb__c = 'testfn';
        c.SuppliedPhone = '55464';
        c.Date_of_Birth__c = '58/05/2015';
        c.Status = 'New';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register Your Product').getRecordTypeId();
        insert c;

        Account acc = new Account();
        acc.LastName = 'Device referring Account';
        acc.PersonEmail = 'testLastName@mail.com';
        acc.Gender__c = 'M';
        acc.Status__c = 'Member';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc;

        Account acc3 = new Account();
        acc3.LastName = 'testLastName';
        acc3.PersonEmail = 'test.thomas@test.com.au';
        acc3.Gender__c = 'M';
        acc3.Status__c = 'Member';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc3;

        Account acc0 = new Account();
        acc0.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Accredited Partner').getRecordTypeId();
        acc0.Type = 'Accredited Partner';
        acc0.Phone = '9876543210';
        acc0.Name = 'testAccName0';
        insert acc0;

        Account acc1 = new Account();
        acc1.Referring_Account__c = acc0.id;
        acc1.Name = 'testLastName1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Accredited Partner').getRecordTypeId();
        acc1.Type = 'Accredited Partner';
        acc1.Phone = '9876543210';
        insert acc1;

        RegisterYourProductController controller = new RegisterYourProductController();
        controller.firstName = '';
        controller.lastName = '';
        controller.phone = '';
        controller.email = '';
        controller.streetAddress = '';
        controller.suburb = '';
        controller.postCode = '';
        controller.purchaseDate = '';
        controller.serialNumber = '';
        controller.resMedMaskProductCode = '';
        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirSense 10 Elite';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.nonResmedMask = 'Non ResMed Mask';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '123546';
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testMissingFieldRegisterYourProductController ->' + e.getMessage());
        }

        System.assertEquals(FALSE, controller.isRegistered); // should fail registration due to empty fields.
    }

    @isTest
    private static void testBirthdateValidations() {

        Test.StartTest();
        
        PageReference pageRef = Page.registeryourproduct;
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        

        controller.firstName = 'Test Validation';
        controller.lastName = 'LNAME';
        controller.phone = '12341234123';
        controller.email = 'testvalidation@resmed.com';
        controller.day = '31'; // Simulate Invalid Date
        controller.month = '11'; // Simulate Invalid Date
        controller.year = '1000';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.maskPromotionalCode = '12533';
        controller.nonResmedMask = 'Non ResMed Mask';
        controller.hasAcceptedTerms = true;
        controller.maskPurchasedFrom = 'Mask referring Account';

        controller.title = 'Mr';
        controller.firstName = 'First Name';
        controller.lastName = 'Patient 1';
        controller.phone = '0413805555';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub';
        controller.postCode = '2000';
        controller.purchaseDate = '30/07/2018';
        controller.serialNumber = '22145678901';
        controller.resMedMaskProductCode = '';
        controller.MobileNumber = '8888888888';
        controller.PurchasedFrom = 'testdatadropdown';

        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';

        // this will simulate failure in creation
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testBirthdateValidations ->' + e.getMessage());
        }

        System.assertEquals(false, controller.isRegistered);


        Test.stopTest();
    }
    
    @isTest 
    private static void testStateCountryPicklist() {

        Test.startTest();

        PageReference pageRef = Page.registeryourproduct;
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        
        controller.countryStateMap = new Map<String, List<String>>{'New Zealand' => new List<String>{'Wellington'} };
        controller.state = 'Wellington';
        controller.getStates();
        controller.getCountries();
        //controller.getCurrency();
        controller.updateCountryPicklist();
        controller.updateStatePicklist();

        System.assertEquals('New Zealand', controller.country); // verify dependency is enforced. Eg selection of state will map to the correct Country.

        Test.stopTest();
    }
    
    @isTest 
    private static void testLoadNewUserScenario() {

        Test.startTest();

        PageReference pageRef = Page.registeryourproduct;
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        
        controller.Is_Using_Device_For_Treament = 'No';
        controller.isNewUser = true;
        controller.displayFormForNewUser();

        System.assertEquals('display:block;', controller.showFormString);

        Test.stopTest();
    }
    
    @isTest 
    private static void testExistingUserScenario() {

        Test.startTest();
    Datetime myDate = Datetime.now();
        String dateOutput = myDate.format('dd/MM/yyyy');
        
    Case c = new Case();
        c.First_Name__c = 'testfn';
        c.Last_Name__c = 'testfn';
        c.Gender__c = 'M';
        c.SuppliedEmail = 'testfn@mail.com';
        c.Title__c = 'testfn';
        c.Street_Address__c = 'testfn';
        c.State_Region__c = 'testfn';
        c.Post_Code__c = '8745';
        c.Suburb__c = 'testfn';
        c.SuppliedPhone = '55464';
        c.Date_of_Birth__c = '01/01/2015';
        c.Status = 'New';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register Your Product').getRecordTypeId();
        insert c;
        
        Account acc = new Account();
        acc.FirstName = 'Test09032017';
        acc.LastName = 'Thomas09032017';
        acc.PersonEmail = 'test.thomas@gmail.com.au';
        acc.Gender__c = 'Male';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc;
        
        PageReference pageRef = Page.registeryourproduct;
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        
        controller = new RegisterYourProductController();
        controller.getDays();
        controller.getMonths();
        controller.getYears();
        controller.getTitles();
        controller.getPurchaseFromString();
        controller.getResmedDevices();
        //controller.getResmedMasks();
        controller.getStates();

        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirSense 10 Elite';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.nonResmedMask = 'Non ResMed Mask';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '123546';
        
        controller.title = 'Mr';
        controller.firstName = 'Test09032017';
        controller.lastName = 'Thomas09032017';
        controller.phone = '0413805555';
        controller.email = 'test.thomas@gmail.com.au';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub';
        controller.postCode = '2000';
        controller.purchaseDate = dateOutput;
        controller.serialNumber = '22145678901';
        controller.resMedMaskProductCode = '';
        controller.MobileNumber = '8888888888';
        controller.PurchasedFrom = 'testdatadropdown';

        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';
        controller.caseId = c.id;
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testExistingUserScenario ->' + e.getMessage());
        }

        System.assertEquals(TRUE, controller.isRegistered);
        
        controller.isExistingUser = true;
        controller.loadFormForExistingUser();
    controller.AccountPopulated();
        controller.processEmailChangeRequest();
        controller.showPopup();
        controller.hidePopUp();
        
        Test.stopTest();
    }
    
    @isTest 
    private static void testShowMaskNameMethod() {

        Test.startTest();

        PageReference pageRef = Page.registeryourproduct;
        pageRef.getParameters().put('deviceName', 'AirMini');
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        controller.showMaskNameMethod();

        Test.stopTest();
    }
    
    @isTest 
    private static void testShowMaskSizeMethod() {

        Test.startTest();

        PageReference pageRef = Page.registeryourproduct;
        pageRef.getParameters().put('maskName', 'AirFit F20');
        pageRef.getParameters().put('selDeviceName', 'AirSense 10 Elite 4G');
        
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        controller.showMaskSizeMethod();

        Test.stopTest();
    }
    
    @isTest
    private static void testMemberUpdationScenario() {

        Test.StartTest();
        Datetime myDate = Datetime.now();
        String dateOutput = myDate.format('dd/MM/yyyy');
        
        Case c = new Case();
        c.First_Name__c = 'testfn';
        c.Last_Name__c = 'testfn';
        c.Gender__c = 'M';
        c.SuppliedEmail = 'testfn@mail.com';
        c.Title__c = 'testfn';
        c.Street_Address__c = 'testfn';
        c.State_Region__c = 'testfn';
        c.Post_Code__c = '8745';
        c.Suburb__c = 'testfn';
        c.SuppliedPhone = '55464';
        c.Date_of_Birth__c = '01/02/2015';
        c.Status = 'New';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register Your Product').getRecordTypeId();
        insert c;
        
        Resmed_Custom__c rec = new Resmed_Custom__c();
        rec.Name = 'Resmed ERP Setting_AU';
        rec.apikey__c='Test123';
        rec.endpoint__c='Test1234';
        rec.method__c='GET';
        rec.password__c='Test12345';
        rec.resource__c='Test123456';
        rec.username__c='Test12';
        insert rec;
        
        Account acc = new Account();
        acc.FirstName = 'Test09032017';
        acc.LastName = 'Thomas09032017';
        acc.PersonEmail = 'test.thomas@gmail.com.au';
        acc.Gender__c = 'Male';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
        insert acc;

        Account acc0 = new Account();
        acc0.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Accredited Partner').getRecordTypeId();
        acc0.Type = 'Accredited Partner';
        acc0.Phone = '9876543210';
        acc0.Name = 'testAccName0';
        insert acc0;
    
        RegisterYourProductController controller = new RegisterYourProductController();
        controller.getDays();
        controller.getMonths();
        controller.getYears();
        controller.getTitles();
        controller.getGenders();
        controller.getPurchaseFromString();
        controller.getResmedDevices();
        controller.getMaskSizes();
        //controller.getResmedMasks();
        controller.getStates();

        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirMini';
        controller.resmedMaskName = 'AirTouch F20 Starter Kit';
        controller.maskSize = 'Small';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '1235464gtfr';
        controller.nonResmedMask = 'Non ResMed Mask';
        
        controller.title = 'Mr';
        controller.firstName = 'Test09032017';
        controller.lastName = 'Thomas09032017';
        controller.phone = '0413805555';
        controller.email = 'test.thomas@gmail.com.au';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub';
        controller.postCode = '2000';
        controller.purchaseDate = dateOutput;
        controller.serialNumber = '22145678901';
        controller.resMedMaskProductCode = '';
        controller.MobileNumber = '8888888888';
        controller.PurchasedFrom = 'testdatadropdown';
    controller.state = 'Wellington';
        
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';
        //controller.caseId = c.id;
        
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testMemberUpdationScenario ->' + e.getMessage());
        }

        System.assertEquals(TRUE, controller.isRegistered); 
        
        /*List<Account> accList = [Select Id, firstName, PersonEmail_SPE__c, MembershipNumber_Auto__c, lastName From Account Where RecordTypeId =: Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId()];
        System.debug('@@@@ accList ' + accList);
        
        
        controller.lastName = accList[0].lastName;
        controller.memShipNo = accList[0].MembershipNumber_Auto__c;
        controller.AccountPopulated();
        
        System.assertEquals('test.thomas@gmail.com.au', controller.email);*/
        
        
        
        //Re-initiate the controller
        controller = new RegisterYourProductController();
        
        controller.title = 'Mrs';
        controller.firstName = 'Test09032017-Update';
        controller.lastName = 'Thomas09032017';
        controller.email = 'test.thomas@gmail.com.au';
        controller.MobileNumber = '1234567890';
        controller.gender = 'F';
        controller.streetAddress = '101 Fake Street';
        controller.suburb = 'Fake Subrub (Update)';
        controller.postCode = '2000';
        controller.purchaseDate = dateOutput;
        controller.serialNumber = '42145678901';
        controller.devicePurchasedFrom= 'Device referring Account';
      
        controller.day = '20';
        controller.month = '10';
        controller.year = '1984';
        controller.resmedDeviceName = 'AirSense 10 Elite';
        controller.resmedMaskName = 'Pixi Paediatric';
        controller.devicePromotionalCode = '12312';
        controller.maskPromotionalCode = '12533';
        controller.hasAcceptedTerms = true;
        controller.devicePurchasedFrom = 'Device referring Account';
        controller.maskPurchasedFrom = 'Mask referring Account';
        controller.extendedWarrantySecurityCode = '12354678asd';
        
        bodyBlob = Blob.valueOf('Unit Test Attachment Body (Updated) - 102');
        controller.imageFileContent = bodyBlob;
        controller.imageFilename = 'mylogo11.jpg';
        try{
            controller.registerProduct();
        } catch (exception e) {
            System.debug('@@@@ Exception inside testMemberUpdationScenario ->' + e.getMessage());
        }
        
        Test.StopTest();
    }
    
    @isTest 
    private static void testGoPrevious() {

        Test.startTest();

        PageReference pageRef = Page.registeryourproduct;
        Test.setCurrentPage(pageRef);

        RegisterYourProductController controller = new RegisterYourProductController(); 
        
        controller.getPromotionalCodeOptions();
        controller.renderPromotionalCodeField();
        
        controller.Is_Using_Device_For_Treament = 'No';
        controller.isNewUser = true;
        controller.displayFormForNewUser();

        System.assertEquals('display:block;', controller.showFormString);
        System.assertEquals('display:none;', controller.infoSection);
        
        controller.goPrevious();
        
        System.assertEquals('display:none;', controller.showFormString);
         System.assertEquals('display:block;', controller.infoSection);

        Test.stopTest();
    }
}