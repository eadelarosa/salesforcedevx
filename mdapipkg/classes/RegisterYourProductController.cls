/********************************************************************************************
 * Create By     :   Thomas Thankachan
 * Create Date   :   06-Mar-2017
 * Description   :   RegisterYourProductController controller that exposes the functionality to register your product as a Case record. 
 * Modification Log:
 *   ------------------------------------------------------------------------------------------
  /********************************************************************************************
 * Create By     :   Siva Prasad
 * Create Date   :   21-July-2017
 * Description   :   As part of Shield Encryptiin Project Case and Account Standard fields are replaced with Custom Encrypted fields.For code change Refference-'SPE__c'
 * Modification Log:
  //------------------------------------------------------------------------------------------------
 *   * Developer       Date          Description
 *   * ----------------------------------------------------------------------------------------
 *   * TT            06-Mar-2017     Initial version.                    
 *   * Fong Tien      26-Jul-2018    Adding validation and exception handling. Email notification if Product registration failed. Remove old commented codes.
 *   * Eduardo Dela Rosa  25-Jul-2019  Changing the sObject field in SOQL where Asset is "purchased from"; from Online Account Name to Product Rego Account Name.
 *   * Ajit Surana    13-Aug-2019      Changes for SV Phase 2 enahncements
 *   * Ajit Surana    19-Nov-2019    Changes for adding Promotional Code field on screen-1 and remove from screen-2 (related to COMMEXC-2068)
 *   * Ajit Surana    09-Dec-2019    Changes for fixing the invalid Purchase Date and DOB issue (related to COMMEXC-2232)
 *   * Ajit Surana    07-Jan-2020    Added capitalize() method in registerProduct() method (related to SCTASK0022983 in SNow)
 *   * Ajit Surana    17-Jan-2020    Modified getResmedDevices() and showMaskNameMethod() to add ORDER BY clause (related to INC0017603 in SNow)
 **********************************************************************************************/
public without sharing class RegisterYourProductController {
    public String title { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String dateOfBirth { get; set; }
    public String Day { get; set; }
    public String Month { get; set; }
    public String Year { get; set; }

    public String phone { get; set; }
    public String streetAddress { get; set; }
    public String suburb { get; set; }
    public String postCode { get; set; }
    public String state { get; set; }

    public String resmedDeviceName { get; set; }
    public String resmedMaskName { get; set; }
    public String serialNumber { get; set; }
    public String purchaseDate { get; set; }
    public String extendedWarrantySecurityCode { get; set; }
    public Boolean hasAcceptedTerms { get; set; }
    public Boolean isRegistered { get; set; }
    public transient blob imageFileContent { get; set; }
    public String imageFilename { get; set; }
    public Id caseId { get; set; }
    public String caseNumber { get; set; }
    public String resMedMaskProductCode { get; set; }

    public String PurchasedFrom { get; set; }
    public String devicePurchasedFrom { get; set; }
    public String maskPurchasedFrom { get; set; }
    public String MobileNumber { get; set; }
    public String country { get; set; }
    public String devicePromotionalCode { get; set; }
    public String maskPromotionalCode { get; set; }
    public String nonResmedMask { get; set; }
    
    public String memShipNo { get; set; }
    public Boolean displayConSecFlag { get; set; }
    public Boolean isExistingUser { get; set; }
    public Boolean isNewUser { get; set; }
  public string showFormString{get;set;}
    public string infoSection{get;set;}
    public string filterSection{get;set;}
  public Boolean isExistingCustomer { get; set; }
    public Boolean disableConData { get; set; }
    
    public Map<String, List<String>> countryStateMap { get; set; }
    //public Map<String, String> customErrorMessageMap { get; set; }

    // indicators for Server-Side validations - START
    public Boolean isDateOfBirthError { get; set; } //2018-07-24: FT: Indicator to check valid DOB.
    public Boolean isExtendedWarranyCodeError { get; set; } //2018-07-24: FT: Indicator to check valid DOB.
    public Boolean isPurchaseDateError { get; set; } //2018-07-24: FT: Indicator to check valid purchase date.
    // indicators for Server-Side validations - END

    //public String currencyISO { get; set; } //1-Nov-2018: Commented until needed by business
    //public Decimal purchasePrice { get; set; } //1-Nov-2018: Commented until needed by business
    public String gender { get; set; }

    private static String baseUrl = Label.SV_ReCaptcha_Endpoint; 
    private static String secret = Label.SV_ReCaptcha_SecretKey;
    
    //Added by Ajit Surana - 07/16/2019
    public Set<String> emailRetreiveRequestIdErrMessage {get;set;}
    public Boolean showError {get;set;}
    public String newEmail {get;set;}
    public boolean displayPopup {get; set;} 
    public String addtlComment {get; set;}
    public Account acc;
    public String maskSize { get; set; }
    public List<SelectOption> maskNameOptions{get;set;}
    public List<SelectOption> maskSizeOptions{get;set;}
    public Boolean serialNumberInvalid;
    
    //Added by Ajit Surana - 11/19/2019
    public String Is_Using_Device_For_Treament{get; set;} 
    public string Err_Use_Promotional_Code {get; set;} 
    public string Err_Promotional_Code_Str {get; set;} 
    public boolean Promotional_Code_Pannel{get; set;}
    
    public String sitekey { 
        get { return Label.SV_ReCaptcha_Key; }
    }
    
    public String response { 
        get { return ApexPages.currentPage().getParameters().get('g-recaptcha-response'); } 
    }
    
    private RMD_Common_ErrorNotificationHelper notificationHelper = RMD_Common_ErrorNotificationHelper.getInstance();

    public RegisterYourProductController() {

        isRegistered = false;
        isDateOfBirthError = false;
        isExtendedWarranyCodeError = false;
        isPurchaseDateError = false;
    displayConSecFlag = false;
        isExistingUser = false;
        isNewUser = false;
        showFormString='display:none;';
        infoSection ='display:block;';
        filterSection ='display:none;';
        isExistingCustomer = false;
        disableConData = false;
        maskNameOptions = new List<SelectOption>();
        maskSizeOptions = new List<SelectOption>();
        acc = new Account();
        displayPopup = false;
        loadStateCountryMapping();
        //loadCustomErrorMessageMapping();
        serialNumberInvalid = false;
        Promotional_Code_Pannel = false;
        
        caseNumber=Apexpages.currentpage().getparameters().get('req#');      
        System.debug('@@@@ caseNumber' + caseNumber);  
        
        if(caseNumber!=null){
        
            Case caseRec = [Select Id, CreatedDate, Account.CreatedDate From Case Where CaseNumber=: caseNumber LIMIT 1];
            
            if(caseRec!=null){
                if(caseRec.Account.CreatedDate < caseRec.CreatedDate)
                    isExistingCustomer = true;
                else
                    isRegistered = true;
            }
        }
        
        // Set notification details.
        notificationHelper.setEmailSubject(Label.SV_Exception_Email_Subject);
        notificationHelper.setEmailBody(Label.SV_Exception_Email_Body);
        notificationHelper.setAttachmetFileName('Exception Details.txt');

    }
  
    public List <String> errorMessages {get;set;}
    
    public void displayFormForNewUser(){ 
        
        Err_Use_Promotional_Code = '';
        Err_Promotional_Code_Str = '';
        errorMessages = new List<string>(); 
        
        if(Is_Using_Device_For_Treament == null|| Is_Using_Device_For_Treament == '') {
            Err_Use_Promotional_Code = Label.SV_Missing_Promotional_Code_Selection;
            errorMessages.add(Label.SV_Missing_Promotional_Code_Selection);
        } else if(Is_Using_Device_For_Treament == 'Yes' && (devicePromotionalCode == '' || devicePromotionalCode == '')) {
            Err_Promotional_Code_Str = Label.SV_Missing_Promotional_Code_Value;
            errorMessages.add(Label.SV_Missing_Promotional_Code_Value);
        } 
        
        if(errorMessages.size()>0){
            isExistingUser = false;
          isNewUser = false;
            return;
        }
        
        if(isNewUser==true) {
            showFormString='display:block;';
            infoSection = 'display:none;';
            filterSection = 'display:none;';
            lastName = '';
          memShipNo = '';
            title ='';
            disableConData = false;
            firstname = '';
            email = '';
            phone ='';
            MobileNumber = '';
            gender = '';
            streetAddress = '';
            suburb = '';
            postCode = '';
            state = '';
            country = '';
            day = '';
            month = '';
            year = '';
        } else {
            //showFormString='display:none;';
      }
    }
    
    public void loadFormForExistingUser(){ 
        
        Err_Use_Promotional_Code = '';
        Err_Promotional_Code_Str = '';
        errorMessages = new List<string>(); 
        
        if(Is_Using_Device_For_Treament == null|| Is_Using_Device_For_Treament == '') {
            Err_Use_Promotional_Code = Label.SV_Missing_Promotional_Code_Selection;
            errorMessages.add(Label.SV_Missing_Promotional_Code_Selection);
        } else if(Is_Using_Device_For_Treament == 'Yes' && (devicePromotionalCode == '' || devicePromotionalCode == '')) {
            Err_Promotional_Code_Str = Label.SV_Missing_Promotional_Code_Value;
            errorMessages.add(Label.SV_Missing_Promotional_Code_Value);
        } 
        System.debug('@@@@ errorMessages' + errorMessages);
        
        if(errorMessages.size()>0){
            isExistingUser = false;
          isNewUser = false;
            return;
        }
        
        if(isExistingUser==true) {
            showFormString='display:none;';
            infoSection = 'display:none;';
            filterSection = 'display:block;';
        } else {
            //showFormString='display:none;';
        }
    }
    
    // This loads the dependency piclist between State and Country
    public void loadStateCountryMapping() {
        countryStateMap = new Map<String, List<String>> ();
        try {
            PageReference pr = new PageReference(PageReference.forResource('SVresources', 'countrystate.json').getUrl());
            String bodyContent = pr.getContent().toString();
            countryStateMap = (Map<String, List<String>>) JSON.deserialize(bodyContent, Map<String, List<String>>.class);
        } catch(Exception ex) {
            System.debug('Exception loading of country state map, ' + ex.getMessage() + ', ' + ex.getStackTraceString());
        }

        System.debug('countryStateMap : ' + countryStateMap);
    }

    // This loads a map standard to custom error message
    /*public void loadCustomErrorMessageMapping() {
        customErrorMessageMap = new Map<String, String> ();
        try {
            PageReference pr = new PageReference(PageReference.forResource('SVresources', 'standardToCustomErrorMessage.json').getUrl());
            String bodyContent = pr.getContent().toString();
            customErrorMessageMap = (Map<String, String>) JSON.deserialize(bodyContent, Map<String, String>.class);
        } catch(Exception ex) {
            System.debug('Exception loading of country state map, ' + ex.getMessage() + ', ' + ex.getStackTraceString());
        }

        System.debug('customErrorMessageMap : ' + customErrorMessageMap);
    }*/

    public PageReference registerProduct()
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            // RESET indicator flags
            isDateOfBirthError = false;
            isExtendedWarranyCodeError = false;
            isPurchaseDateError = false;
            
            system.debug('title=>' + title);
            system.debug('firstName=>' + firstName);
            system.debug('lastName=>' + lastName);
            system.debug('email=>' + email);
            system.debug('streetAddress=>' + streetAddress);
            system.debug('suburb=>' + suburb);
            system.debug('postCode=>' + postCode);
            
            if (!isNullOrWhiteSpace(firstName) &&
                !isNullOrWhiteSpace(lastName) &&
                !isNullOrWhiteSpace(email) && 
                !isNullOrWhiteSpace(streetAddress) &&
                !isNullOrWhiteSpace(suburb) &&
                !isNullOrWhiteSpace(postCode)
            )
            {
        
                Boolean isNotValidEmailDomain = false;
                
                Set<string> emailSet = new Set<string>();
                emailSet.addall(Label.SV_Valid_Email_Domain_List.split(','));
                
                String emailDomainName = email.substringAfter('@').substringBefore('.');
                
                if(emailSet!= null && emailSet.size() > 0){
                    if(!emailSet.contains(emailDomainName)){
                        isNotValidEmailDomain = true;
                    }
                }   
                
                if(isNotValidEmailDomain){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Invalid_Email_Domain_Message));
                    return null;
                }

                Id rgisterYourProductRecordTypeId = getRecordTypeIdByDeveloperName('Case', 'RegisterYourProduct');

                if (day != null && month != null && year != null) {
                    dateOfBirth = day + '/' + month + '/' + year;
                }
                system.debug('dateOfBirth :' + dateOfBirth);
                
                Case registerProductAsCase = new Case();
                registerProductAsCase.Title__c = title;
                registerProductAsCase.Gender__c = gender;
                registerProductAsCase.First_Name__c = firstName;
                registerProductAsCase.Last_Name__c = lastName;
                if (dateOfBirth != null) {
                    registerProductAsCase.Date_of_Birth__c = dateOfBirth;
                }
                registerProductAsCase.SuppliedPhone_SPE__c = phone;
                registerProductAsCase.SuppliedEmail_SPE__c = email;
                registerProductAsCase.Street_Address__c = streetAddress;
                registerProductAsCase.Suburb__c = suburb;
                registerProductAsCase.Country__c = country;
                registerProductAsCase.Post_Code__c = postCode;
                registerProductAsCase.State_Region__c = state;
                registerProductAsCase.RecordTypeId = rgisterYourProductRecordTypeId;
                //registerProductAsCase.CurrencyIsoCode = currencyISO;//1-Nov-2018: Commented until needed by business
                //registerProductAsCase.Purchase_Price__c = purchasePrice;//1-Nov-2018: Commented until needed by business
        
                if(!String.isBlank(addtlComment)){
                    registerProductAsCase.Description = addtlComment;
                }
                
                
                try {
                    List<String> dateStr = purchaseDate.split('/');
                    
                    Integer  pDay;
                    Integer  pMonth;
                    Integer  pYear;
                    
                    pDay = Integer.valueOf(dateStr[0]);
                    pMonth = Integer.valueOf(dateStr[1]);
                    pYear = Integer.valueOf(dateStr[2]);
                    
                    
                    Date dateStrInstance =  Date.newInstance(pYear, pMonth, pDay);
                    System.debug('@@@@ dateStrInstance >>> ->' + dateStrInstance);
                    
                    registerProductAsCase.Purchased_Date__c = dateStrInstance;
                } catch(Exception ex) {
                    isPurchaseDateError = true;
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Invalid_Purchase_Date));
                    return null;
                }

                INSERT registerProductAsCase;

                Case createdCase = [SELECT Id, CaseNumber FROM Case WHERE ID = :registerProductAsCase.Id] [0];
                system.debug('case record created successfully with Product Registration. CaseId=>' + registerProductAsCase.Id);
                caseId = registerProductAsCase.Id;

                Account[] memberAccounts = null;
                
                // Ajit Surana: 1-APR-2019: Searching by email, Last name and initial letter of First Name (Phase 2 enhancement)
                String searchTerms = '';

                if(!String.isEmpty(email)){
                    searchTerms += '("' + email + '")';
                }
                
                if(!String.isEmpty(lastName)){
                    if(!String.isEmpty(searchTerms)){
                        searchTerms += ' AND ';
                    }
                    //Used capitalize() function to fix the issue raised in SCTASK0022983
                    searchTerms += '("' + lastName.capitalize() + '")';
                }
                if(!String.isEmpty(firstName)){
                    firstName = firstName.trim();
                    if(!String.isEmpty(searchTerms)){
                        searchTerms += ' AND ';
                    }
                    searchTerms += '("' + firstName.capitalize().left(1) + '*")';
                }
                
                String searchQuery = 'FIND \'' + searchTerms + '\' IN ALL FIELDS RETURNING Account(id,PersonEmail_SPE__c, AccountName_SPE__c, PersonBirthdate_SPE__c, RecordTypeId ORDER BY LastModifiedDate ASC)';
                List<List<SObject>> EmailSearchList = search.query(searchQuery);
                memberAccounts = ((List<Account>) EmailSearchList[0]);
                System.debug('@@@@@ memberAccounts' + memberAccounts);
                
                //Modified the code and added SOSL as part of Field Encryption 
                // FT: 9-Nov-2018: Remove searching by email (as made optional)
                /*if (!String.isBlank(email)) {
                    
                    String SearchQueryOnEmail = 'FIND \'' + email + '\' IN EMAIL FIELDS RETURNING Account(id,PersonEmail_SPE__c, AccountName_SPE__c, RecordTypeId)';
                    List<List<SObject>> EmailSearchList = search.query(SearchQueryOnEmail);
                    memberAccounts = ((List<Account>) EmailSearchList[0]);
                }*/
                /*
                else{
                    String SearchQueryOnPhone = 'FIND \'' + phone + '\' IN PHONE_SPE__C FIELDS RETURNING Account(id,Phone_SPE__c,AccountName_SPE__c, RecordTypeId)';
                    List<List<SObject>> PhoneSearchList = search.query(SearchQueryOnPhone);
                    memberAccounts = ((List<Account>) PhoneSearchList[0]);
                }*/
        
                Account memberAccount = null;
                
                if (dateOfBirth != null && dateOfBirth != '') {
                    try {
                        List<String> dateStr = dateOfBirth.split('/');
                    
                        Integer  dobDay;
                        Integer  dobMonth;
                        Integer  dobYear;
                        
                        dobDay = Integer.valueOf(dateStr[0]);
                        dobMonth = Integer.valueOf(dateStr[1]);
                        dobYear = Integer.valueOf(dateStr[2]);
                        
                        
                        Date dateStrInstance =  Date.newInstance(dobYear, dobMonth, dobDay);
                        System.debug('@@@@ dateStrInstance DOB >>> ->' + dateStrInstance);
                        
                        Date inputDate = dateStrInstance;
                        
                        if(memberAccounts != null && memberAccounts.size() > 0){
                    
                            for(Account acct : memberAccounts){
                            
                            if(acct.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId()
                              && ((acct.PersonBirthdate_SPE__c == null) || (inputDate == acct.PersonBirthdate_SPE__c))){
                                memberAccount = acct;
                                }
                            }
                            System.debug('@@@@@ memberAccount' + memberAccount);
                        }
                    } catch(Exception ex) {
                        isDateOfBirthError = true;
                        Database.rollback(sp);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Invalid_Date_of_Birth));
                        return null;
                    }
                }
                
                /*if (memberAccounts != null && memberAccounts.size() > 0 && 
                    memberAccounts[0].RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId()
                   && ((MobileNumber == memberAccounts[0].PersonMobilePhone_SPE__c) || (inputDate == memberAccounts[0].PersonBirthdate_SPE__c))) {
                    memberAccount = memberAccounts[0];
                }*/

                //Find Referring Partner based on Name
                Account deviceReferringPartnerAccount = new Account();
                Account maskReferringPartnerAccount = new Account();
                system.debug('devicePurchasedFrom :' + devicePurchasedFrom);
                if (devicePurchasedFrom != null && devicePurchasedFrom != '') {

                    String SearchqueryOnDevicePurchasedForm = 'FIND \'' + String.escapeSingleQuotes(devicePurchasedFrom) + '\' IN ALL FIELDS RETURNING Account(id,PersonEmail_SPE__c,AccountName_SPE__c, RecordTypeId WHERE RecordType.Name IN (\'Authorised Dealer\', \'Pharmacy\', \'Accredited Partner\', \'Partner - Sleep Lab\') AND Type IN (\'CPAP Outlet\',\'Accredited Partner\', \'Partner - Sleep Lab\', \'HST CPAP Outlet\', \'ResMed Retail\', \'National\', \'ResMed Affiliate\', \'Franchisee\', \'Pharmacy\'))';
                    system.debug('SearchqueryOnDevicePurchasedForm :' + SearchqueryOnDevicePurchasedForm);
                    List<List<SObject>> deviceSearchListResults = search.query(SearchqueryOnDevicePurchasedForm);
                    Account[] deviceReferringPartners = ((List<Account>) deviceSearchListResults[0]);

                    if (deviceReferringPartners != null && deviceReferringPartners.size() > 0) {
                        deviceReferringPartnerAccount = deviceReferringPartners[0];
                    } else {
                        deviceReferringPartnerAccount = null;
                    }

                }
                system.debug('maskPurchasedFrom :' + maskPurchasedFrom);
                if (maskPurchasedFrom != null && maskPurchasedFrom != '') {

                    String SearchqueryOnMaskPurchasedForm = 'FIND \'' +  String.escapeSingleQuotes(maskPurchasedFrom) + '\' IN ALL FIELDS RETURNING Account(id,PersonEmail_SPE__c,AccountName_SPE__c, RecordTypeId WHERE RecordType.Name IN (\'Authorised Dealer\', \'Pharmacy\', \'Accredited Partner\', \'Partner - Sleep Lab\') AND Type IN (\'CPAP Outlet\',\'Accredited Partner\', \'Partner - Sleep Lab\', \'HST CPAP Outlet\', \'ResMed Retail\', \'National\', \'ResMed Affiliate\', \'Franchisee\', \'Pharmacy\'))';
                    system.debug('SearchqueryOnMaskPurchasedForm :' + SearchqueryOnMaskPurchasedForm);
                    List<List<SObject>> maskSearchListResults = search.query(SearchqueryOnMaskPurchasedForm);
                    Account[] maskReferringPartners = ((List<Account>) maskSearchListResults[0]);

                    if (maskReferringPartners != null && maskReferringPartners.size() > 0) {
                        maskReferringPartnerAccount = maskReferringPartners[0];
                    } else {
                        maskReferringPartnerAccount = null;
                    }
                }

                Id caseAccountId = null;
                //Account acc = new Account();
                if (memberAccount == null) {
                    //Create new Member if one with given email does not exist
                    acc.FirstName_SPE__c = registerProductAsCase.First_Name__c;
                    acc.LastName_SPE__c = registerProductAsCase.Last_Name__c;
                    acc.LastName = registerProductAsCase.Last_Name__c;//LastName is mandatory cannot remove
                    acc.Gender__c = registerProductAsCase.Gender__c;
                    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
                    acc.Status__c = 'Member';
                    acc.PersonEmail_SPE__c = registerProductAsCase.SuppliedEmail_SPE__c;
                    acc.Salutation = registerProductAsCase.Title__c;
                    acc.Mailing_Street_SPE__c = registerProductAsCase.Street_Address__c;
                    acc.Mailing_State_Province_SPE__c = registerProductAsCase.State_Region__c;
                    acc.Mailing_Zip_Postal_Code_SPE__c = registerProductAsCase.Post_Code__c;
                    acc.Mailing_City_SPE__c = registerProductAsCase.Suburb__c;
                    acc.Mailing_Country_SPE__c = country;
                    acc.Phone_SPE__c = registerProductAsCase.SuppliedPhone_SPE__c;
                    acc.PersonMobilePhone_SPE__c = MobileNumber;
                    
                    acc.FirstName = registerProductAsCase.First_Name__c;
                    acc.AccountName_SPE__c = registerProductAsCase.First_Name__c + ' ' + registerProductAsCase.Last_Name__c;
                    acc.CPAP_Status__c = Label.SV_Account_Web_Status;
                    acc.membershipSource__c = Label.SV_Account_Source;

                    if (dateOfBirth != null && dateOfBirth != '') {
                        try {
                            List<String> dateStr = dateOfBirth.split('/');
                    
                            Integer  dobDay;
                            Integer  dobMonth;
                            Integer  dobYear;
                            
                            dobDay = Integer.valueOf(dateStr[0]);
                            dobMonth = Integer.valueOf(dateStr[1]);
                            dobYear = Integer.valueOf(dateStr[2]);
                            
                            
                            Date dateStrInstance =  Date.newInstance(dobYear, dobMonth, dobDay);
                            
                            acc.PersonBirthdate_SPE__c = dateStrInstance;
                        } catch(Exception ex) {
                            isDateOfBirthError = true;
                            Database.rollback(sp);
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Invalid_Date_of_Birth));
                            return null;
                        }
                    }

                    if (deviceReferringPartnerAccount != null) {
                        acc.Referring_Account__c = deviceReferringPartnerAccount.id;
                    }

                    INSERT acc;
                    system.debug('acc.RecordId :' + acc.Id);
                    caseAccountId = acc.Id;
                    isRegistered = true;
                } else {
                    //If Member account exists then update member account
                    acc = new Account(Id = memberAccount.Id);
                    acc.FirstName_SPE__c = registerProductAsCase.First_Name__c;
                    acc.LastName_SPE__c = registerProductAsCase.Last_Name__c;
                    acc.Gender__c = registerProductAsCase.Gender__c;
                    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Member').getRecordTypeId();
                    acc.Status__c = 'Member';
                    acc.PersonEmail_SPE__c = registerProductAsCase.SuppliedEmail_SPE__c;
                    acc.Salutation = registerProductAsCase.Title__c;
                    acc.Mailing_Street_SPE__c = registerProductAsCase.Street_Address__c;
                    acc.Mailing_State_Province_SPE__c = registerProductAsCase.State_Region__c;
                    acc.Mailing_Zip_Postal_Code_SPE__c = registerProductAsCase.Post_Code__c;
                    acc.Mailing_City_SPE__c = registerProductAsCase.Suburb__c;
                    acc.Mailing_Country_SPE__c = country;
                    acc.Phone_SPE__c = registerProductAsCase.SuppliedPhone_SPE__c;
                    acc.PersonMobilePhone_SPE__c = MobileNumber;
                    if (dateOfBirth != null && dateOfBirth != '') {
                        try {
                            List<String> dateStr = dateOfBirth.split('/');
                    
                            Integer  dobDay;
                            Integer  dobMonth;
                            Integer  dobYear;
                            
                            dobDay = Integer.valueOf(dateStr[0]);
                            dobMonth = Integer.valueOf(dateStr[1]);
                            dobYear = Integer.valueOf(dateStr[2]);
                            
                            
                            Date dateStrInstance =  Date.newInstance(dobYear, dobMonth, dobDay);
                            
                            acc.PersonBirthdate_SPE__c = dateStrInstance;
                        } catch(Exception ex) {
                            isDateOfBirthError = true;
                            Database.rollback(sp);
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Invalid_Date_of_Birth));
                            return null;
                        }
                    }
                    if (deviceReferringPartnerAccount != null && (deviceReferringPartnerAccount.id != acc.id)) {
                        system.debug('deviceReferringPartnerAccount :' + deviceReferringPartnerAccount);
                        system.debug('deviceReferringPartnerAccount.id :' + deviceReferringPartnerAccount.id);
                        acc.Referring_Account__c = deviceReferringPartnerAccount.id;
                    }

                    UPDATE acc;
                    caseAccountId = memberAccount.Id;
                    isExistingCustomer = true;
                }

                //Update Case Account to Member created/Updated
                registerProductAsCase.AccountId = caseAccountId;
                update registerProductAsCase;
                
                List<Asset> allAssetListToInsert = new List<Asset>();
                
                Asset deviceProductRegistration = new Asset();
                Asset extdWarrantyProdRegistration = new Asset();
                
                if (resmedDeviceName != null) {
                    List<SV_DeviceMask__c> prodRecForDeviceList = [SELECT Id, Device_Product_Code__c, Device_Product_Code__r.Name, Extended_Warranty_Code__c, Extended_Warranty_Code__r.Name 
                                                                   FROM SV_DeviceMask__c 
                                                                   Where Is_Web_Enabled__c = true AND Device_Name__c=: resmedDeviceName];
                  System.debug('@@@@ prodRecForDeviceList ->' + prodRecForDeviceList);
                  
                    if(prodRecForDeviceList!=null){
                        deviceProductRegistration.Name = prodRecForDeviceList[0].Device_Product_Code__r.Name;
                        deviceProductRegistration.Product2Id = prodRecForDeviceList[0].Device_Product_Code__c;
                    }
                    
                    deviceProductRegistration.case__c = registerProductAsCase.id;
                    deviceProductRegistration.SerialNumber = serialNumber;
                    
                    if(serialNumberInvalid)
            deviceProductRegistration.Serial_Number_Validation_Failed__c = true;
                    
                    if (deviceReferringPartnerAccount != null) {
                        deviceProductRegistration.referringPartner__c = deviceReferringPartnerAccount.Id;
                    } else {
                        deviceProductRegistration.Purchased_From__c = devicePurchasedFrom;
                    }
          System.debug('@@@@ devicePromotionalCode >>> ->' + devicePromotionalCode);
                    
                    deviceProductRegistration.Promotional_code__c = devicePromotionalCode;
                    deviceProductRegistration.Extended_Warranty_Code__c = extendedWarrantySecurityCode;
                    deviceProductRegistration.AccountId = acc.Id;
                    deviceProductRegistration.PurchaseDate = registerProductAsCase.Purchased_Date__c;
                    deviceProductRegistration.Quantity = Decimal.valueOf(Label.SV_Asset_Default_Quantity);
                    deviceProductRegistration.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Patient_Product_Registration').getRecordTypeId();
                    
                    if(extendedWarrantySecurityCode!=null && extendedWarrantySecurityCode!=''){
                        deviceProductRegistration.warrantyType__c = Label.SV_Asset_Extended_Warranty_Type;
                    }else{
                        deviceProductRegistration.warrantyType__c = Label.SV_Asset_Default_Warranty_Type;
                    }
                    
                    //Code block to insert Extended Warranty Asset
                    if(prodRecForDeviceList!=null && (extendedWarrantySecurityCode!=null && extendedWarrantySecurityCode!='')){
                       
                        extdWarrantyProdRegistration.Name = prodRecForDeviceList[0].Extended_Warranty_Code__r.Name;
                        extdWarrantyProdRegistration.Product2Id = prodRecForDeviceList[0].Extended_Warranty_Code__c;
                        //extdWarrantyProdRegistration.Extended_Warranty_Code__c = extendedWarrantySecurityCode;
                        extdWarrantyProdRegistration.AccountId = acc.Id;
                        extdWarrantyProdRegistration.case__c = registerProductAsCase.id;
                        extdWarrantyProdRegistration.PurchaseDate = registerProductAsCase.Purchased_Date__c;
                        extdWarrantyProdRegistration.Quantity = Decimal.valueOf(Label.SV_Asset_Default_Quantity);
                        extdWarrantyProdRegistration.warrantyType__c = Label.SV_Asset_Extended_Warranty_Type;
                        extdWarrantyProdRegistration.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Patient_Product_Registration').getRecordTypeId();
                      
                        if (deviceReferringPartnerAccount != null) {
                            extdWarrantyProdRegistration.referringPartner__c = deviceReferringPartnerAccount.Id;
                        } else {
                            extdWarrantyProdRegistration.Purchased_From__c = devicePurchasedFrom;
                        }
                        allAssetListToInsert.add(extdWarrantyProdRegistration);
                      //insert extdWarrantyProdRegistration;
                    }
                    allAssetListToInsert.add(deviceProductRegistration);
                    //INSERT deviceProductRegistration;
                    
                    //Code block to insert Bundle records for AirMini pack
                    List<Asset> bundleAssetListToInsert = new List<Asset>();
                    List<SV_Bundles__c> svBundleList = new List<SV_Bundles__c>();
                    
                    //Set<String> maskBundleSet = new Set<String>();
                  //maskBundleSet.addall(Label.SV_AirMini_Mask_Bundle_List.split(', '));
          
                    if(resmedDeviceName=='AirMini'){
                        
                        svBundleList = [Select Id, Device_Mask__c, Product_Code__c, Product_Code__r.Name, Quantity__c From SV_Bundles__c 
                                            Where Device_Mask__r.Device_Name__c=: resmedDeviceName  AND Device_Mask__r.Mask_Name__c=: resmedMaskName 
                                            AND Device_Mask__r.Mask_Size__c=: maskSize];
                        /*if(maskBundleSet.contains(resmedMaskName)){
                            System.debug('@@@@ Inside Bundle block ->');
                            
                            svBundleList = [Select Id, Device_Mask__c, Product_Code__c, Product_Code__r.Name, Quantity__c From SV_Bundles__c 
                                            Where Device_Mask__r.Device_Name__c=: resmedDeviceName  AND Device_Mask__r.Mask_Name__c=: resmedMaskName 
                                            AND Device_Mask__r.Mask_Size__c=: maskSize];
                        }*/
                        
                        if(svBundleList.size()>0){
                            
                            for(SV_Bundles__c bundleRec: svBundleList){
                                Asset bundleAssetRec = new Asset();
                                
                                bundleAssetRec.Name = bundleRec.Product_Code__r.Name;
                                bundleAssetRec.Product2Id = bundleRec.Product_Code__c;
                                bundleAssetRec.Quantity = bundleRec.Quantity__c;
                                bundleAssetRec.AccountId = acc.Id;
                                bundleAssetRec.case__c = registerProductAsCase.id;
                                bundleAssetRec.PurchaseDate = registerProductAsCase.Purchased_Date__c;
                                bundleAssetRec.warrantyType__c = Label.SV_Asset_Default_Warranty_Type;
                                bundleAssetRec.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Patient_Product_Registration').getRecordTypeId();
                                if (maskReferringPartnerAccount != null) {
                                    bundleAssetRec.referringPartner__c = maskReferringPartnerAccount.Id;
                                }else {
                                    bundleAssetRec.Purchased_From__c = maskPurchasedFrom;
                                }
                                allAssetListToInsert.add(bundleAssetRec);
                                //bundleAssetListToInsert.add(bundleAssetRec);
                            }
                        }
                    }
                    
                }

                system.debug('deviceProductRegistration.product2Id :' + deviceProductRegistration.product2Id);

                Asset maskProductRegistration = new Asset();
                Product2 maskProduct = new Product2();
                if (resmedMaskName != null || (nonResmedMask != null && nonResmedMask != '')) {
                    
                    SV_DeviceMask__c prodRecForMask = [SELECT Id, Mask_Product_Code__c, Mask_Product_Code__r.Name FROM SV_DeviceMask__c 
                                                       Where Is_Web_Enabled__c = true AND Mask_Name__c=: resmedMaskName 
                                                       AND Mask_Size__c=: maskSize LIMIT 1];
                  
                    System.debug('@@@ prodRecForMask' + prodRecForMask);
                    /*--START--20181118,HY: Create a Competitor Asset when only non-ResMed Mask is entered*/
                    if (resmedMaskName == null && nonResmedMask != null && nonResmedMask != ''){
                        maskProductRegistration.Name = nonResmedMask;
                        maskProductRegistration.warrantyType__c = Label.SV_Asset_Warranty_Type_Other;
                        
                        String SearchqueryOnProduct = 'FIND {' + Label.Competitor_Mask+ '} IN NAME FIELDS RETURNING PRODUCT2(Id,Name)';
                        system.debug('SearchqueryOnProduct :' + SearchqueryOnProduct);
                        List<List<SObject>> productSearchListResults = search.query(SearchqueryOnProduct);
                        Product2[] maskProductList = ((List<Product2>) productSearchListResults[0]);

                        if (maskProductList != null && maskProductList.size() > 0) {
                            maskProduct = maskProductList[0];
                            maskProductRegistration.Product2Id = maskProduct.Id;
                        } else {
                            maskProduct = null;
                        }
                    }
                    else{
                        
                        if(prodRecForMask!=null){
                            maskProductRegistration.Name = prodRecForMask.Mask_Product_Code__r.Name;
                            maskProductRegistration.Product2Id = prodRecForMask.Mask_Product_Code__c;
                        }
                        
                        maskProductRegistration.warrantyType__c = Label.SV_Asset_Default_Warranty_Type;
                    }
                    /*--END--*/
                    
                    maskProductRegistration.case__c = registerProductAsCase.id;

                    if (maskReferringPartnerAccount != null) {
                        maskProductRegistration.referringPartner__c = maskReferringPartnerAccount.Id;
                    } else {
                        maskProductRegistration.Purchased_From__c = maskPurchasedFrom;
                    }

                    maskProductRegistration.Promotional_code__c = maskPromotionalCode;
                    maskProductRegistration.Description = nonResmedMask;
                    maskProductRegistration.AccountId = acc.Id;
                    maskProductRegistration.PurchaseDate = registerProductAsCase.Purchased_Date__c;
                    maskProductRegistration.Quantity = Decimal.valueOf(Label.SV_Asset_Default_Quantity);
                    maskProductRegistration.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Patient_Product_Registration').getRecordTypeId();
                    
                    //INSERT maskProductRegistration;
                    allAssetListToInsert.add(maskProductRegistration);
                }

                System.debug('@@@ allAssetListToInsert all' + allAssetListToInsert);
                
                if(allAssetListToInsert.size()>0)
                        insert allAssetListToInsert;
        
                system.debug('maskProductRegistration.product2Id :' + maskProductRegistration.product2Id);

                system.debug('imageFilename :' + imageFilename);
                system.debug('imageFileContent :' + imageFileContent);

                //insert attachment
                if (imageFilename != null && imageFileContent != null) {
                    Attachment attach = new Attachment(parentId = registerProductAsCase.Id, name = imageFilename, body = imageFileContent);
                    INSERT attach;

                    system.debug('an attachment added successfully to the case record. AttachmentId=>' + attach.Id);
                }

                if (!ApexPages.hasMessages()) {
                    //isRegistered = true;
                    caseNumber = createdCase.CaseNumber;

                    /** THIS IS WHERE PRODUCT REGISTRATION PROCESS ENDS SUCCESSFULLY */
                    // Added by Eduardo Dela Rosa | COMMEXC-2551 | 02-March-2020
                    // Add record entry to the Subscription Map which will be used to generate an unsubscibe URL and GUID
                    createSubscriptionURL(acc.Id);

                } else {
                    Database.rollback(sp);

                    // Add in custom error message for a matching standard exception - for a more information message.
                    /*for (ApexPages.Message mess : ApexPages.getMessages()) {
                        if (customErrorMessageMap != null && customErrorMessageMap.containsKey(mess.getSummary())) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, customErrorMessageMap.get(mess.getSummary())));
                        }
                    }*/
                }
                PageReference pageRef = new PageReference('/apex/SV_Thank_You');
                pageRef.getParameters().put('req#',createdCase.CaseNumber);      
                pageRef.setRedirect(true);      
                return pageRef;

                //return new PageReference('https://www.sleepvantage.com.au/home-page/index.html');
            } else {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.SV_Missing_Required_Fields));
                return null;
            }
        } catch(DmlException ex) {
            Database.rollback(sp);

            if (ex.getMessage().contains('Extended_Warranty_Code__c')) {
                isExtendedWarranyCodeError = true;
                
                //Made boolean to false to show error message instead of showing the success message on dupe warranty code
                isRegistered = false;
                
                ApexPages.addMessage(new apexPages.Message(Apexpages.Severity.ERROR, Label.SV_Warranty_Code_Error));
            } else {
                ApexPages.addMessage(new apexPages.Message(Apexpages.Severity.ERROR, Label.SV_Error_Processing_Registration));

                // Send email inform Salesforce Admin.
                notificationHelper.addExceptionMessage(ex.getMessage());
                notificationHelper.addExceptionMessage(ex.getStackTraceString());
                notificationHelper.sendEmail();
            }

        } catch(Exception e) {
            Database.rollback(sp);

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, Label.SV_Error_Processing_Registration));

            // Send email inform Salesforce Admin.
            notificationHelper.addExceptionMessage(e.getMessage());
            notificationHelper.addExceptionMessage(e.getStackTraceString());
            notificationHelper.sendEmail();
        }

        return null;
    }


    // AJAX method to update Country Picklist Value based on State selection
    public void updateCountryPicklist() {
        System.debug('UPDATE COUNTRY PICKLIST');

        for (String countryKey : countryStateMap.keySet()) {

            List<String> stateList = countryStateMap.get(countryKey);
            for (String stateStr : stateList) {
                if (!String.isBlank(stateStr) && stateStr.equalsIgnoreCase(state)) {
                    country = countryKey; // Pre-select if state for the country is selected.
                }
            }
        }

    }

    // AJAX method to clear state value upon country changed
    public void updateStatePicklist() {
        System.debug('UPDATE STATE PICKLIST');
        state = '';
    }

    public List<SelectOption> getTitles() {
        return getAccountSalutations();
    }

    public List<String> getPurchaseFromString() {
        
        List<String> options = new List<String> ();
        
        for (Account acc :[SELECT Name, id, isWebEnabled__c, Product_Rego_Account_Name__c, RecordType.Name, Type 
            FROM Account 
            WHERE RecordType.Name IN('Accredited Partner', 'Partner - Sleep Lab', 'Authorised Dealer', 'Pharmacy') 
                AND Type IN('Accredited Partner', 'Partner - Sleep Lab','CPAP Outlet', 'HST CPAP Outlet', 'ResMed Retail', 'National', 'ResMed Affiliate', 'Franchisee', 'Pharmacy') 
                AND isWebEnabled__c = true Order by Name]) { //limit 999
            
            /** REFERENCE: TASK0287184 | EduardoD | 26-Jul-2019
                Commented the check for null/blank value; Astrid has populated the fields Product_Rego_Account_Name__c and Online_Account_Name__c in production
                The same set of values have been updated in UAT
                Checks are put in place via Validation Rules to make sure that these fields are populated by business user when a business Account record is created or edited
            */
            // if(acc.Product_Rego_Account_Name__c != null || acc.Product_Rego_Account_Name__c != '' ){            
                options.add(String.valueOf(acc.Product_Rego_Account_Name__c));
            // }else{
            // options.add(string.valueOf(acc.Name));
            // } 
            
            //Commented to include check for isWebEnabled__c inside the above query
            /*if(acc.isWebEnabled__c){            
                options.add(String.valueOf(acc.Product_Rego_Account_Name__c));
            }else{
                options.add(string.valueOf(acc.Name));
            }*/
            
        }        
        system.debug('options.size() :' + options.size());
        return options;
    }

    //Commented by Ajit Surana - 07/23/2019 - SV Phase 2 changes 
    /*public List<SelectOption> getResmedDevices() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Device List'));


        for (list<RegisterYourProductList__c> lstProducts :[SELECT Name, ProductName__c, ProductType__c FROM RegisterYourProductList__c
             Where ProductType__c = 'device'])
        {
            for (RegisterYourProductList__c prod : lstProducts)
            {
                if (prod.ProductName__c != null) {
                    options.add(new SelectOption(prod.ProductName__c, prod.ProductName__c));
                }
            }
        }
        return options;
    }*/
  
    public List<SelectOption> getResmedDevices() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Device List'));
    Set<String> uniqueDeviceNames = new Set<String>();
        
        for (list<SV_DeviceMask__c> lstProducts :[SELECT Id, Device_Name__c FROM SV_DeviceMask__c Where Is_Web_Enabled__c = true AND Mask_Name__c='' ORDER BY Sort_Index__c ASC])
        {
            for (SV_DeviceMask__c prod : lstProducts)
            {
                if (prod.Device_Name__c!= null) {
                    uniqueDeviceNames.add(prod.Device_Name__c);
                }
            }
        }
        
        if(uniqueDeviceNames.size()>0){
            for (String devName : uniqueDeviceNames)
            {
                options.add(new SelectOption(devName, devName));
            }
        }
        
        //To populate Mask Name list on page load
        maskNameOptions = new List<SelectOption>();
        maskNameOptions.add(new SelectOption('','Select'));
        Set<String> uniqueMaskNames = new Set<String>();
        
        for (list<SV_DeviceMask__c> lstProducts :[SELECT Id, Mask_Name__c FROM SV_DeviceMask__c Where Is_Web_Enabled__c = true AND Device_Name__c='' ORDER BY Sort_Index__c ASC])
        {
            for (SV_DeviceMask__c prod : lstProducts)
            {
                if (prod.Mask_Name__c != null) {
                    uniqueMaskNames.add(prod.Mask_Name__c);
                }
            }
        }
        
        if(uniqueMaskNames.size()>0){
            for (String maskName : uniqueMaskNames)
            {
                maskNameOptions.add(new SelectOption(maskName, maskName));
            }
        }
        
        return options;
    }
    
    //Commented by Ajit Surana - 07/23/2019 - SV Phase 2 changes
    /*public List<SelectOption> getResmedMasks() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Mask List'));


        for (list<RegisterYourProductList__c> lstProducts :[SELECT Name, ProductName__c, ProductType__c FROM RegisterYourProductList__c
             Where ProductType__c = 'mask'])
        {
            for (RegisterYourProductList__c prod : lstProducts)
            {
                if (prod.ProductName__c != null) {
                    options.add(new SelectOption(prod.ProductName__c, prod.ProductName__c));
                }
            }
        }
        return options;
    }*/

  public void showMaskNameMethod() {
    
        String selDeviceName = Apexpages.currentPage().getParameters().get('deviceName');
        
        try{
            
            maskNameOptions = new List<SelectOption>();
            maskNameOptions.add(new SelectOption('','Select'));
            Set<String> uniqueMaskNames = new Set<String>();
            
            for (list<SV_DeviceMask__c> lstProducts :[SELECT Id, Mask_Name__c FROM SV_DeviceMask__c Where Is_Web_Enabled__c = true AND Device_Name__c=: selDeviceName
                                                      ORDER BY Sort_Index__c ASC])
            {
                for (SV_DeviceMask__c prod : lstProducts)
                {
                    if (prod.Mask_Name__c != null) {
                        uniqueMaskNames.add(prod.Mask_Name__c);
                    }
                }
            }
            
            if(uniqueMaskNames.size()>0){
                for (String maskName : uniqueMaskNames)
                {
                    maskNameOptions.add(new SelectOption(maskName, maskName));
                }
            }
        } catch (Exception e) { 
            System.debug('Exception Error : Error in showMaskNameMethod'+e); 
        }
    }
    
    public void showMaskSizeMethod() {
    
        String selMaskName = Apexpages.currentPage().getParameters().get('maskName');
        String selDeviceName = Apexpages.currentPage().getParameters().get('selDeviceName');
        Set<String> uniqueMaskSizes = new Set<String>();
        
        try{
            
            maskSizeOptions = new List<SelectOption>();
            maskSizeOptions.add(new SelectOption('','Select'));
            
            for (list<SV_DeviceMask__c> lstProducts :[SELECT Id, Mask_Size__c FROM SV_DeviceMask__c Where Is_Web_Enabled__c = true AND Device_Name__c=: selDeviceName AND Mask_Name__c =: selMaskName])
            {
                for (SV_DeviceMask__c prod : lstProducts)
                {
                    if (prod.Mask_Size__c != null) {
                        uniqueMaskSizes.add(prod.Mask_Size__c);
                    }
                }
            }

            if(uniqueMaskSizes.size()>0){
                for (String maskSize : uniqueMaskSizes)
                {
                    maskSizeOptions.add(new SelectOption(maskSize, maskSize));
                }
            }
        } catch (Exception e) { 
            System.debug('Exception Error : Error in showMaskSizeMethod'+e); 
        }
    }
    
    public  List<SelectOption> getMaskSizes() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Mask Size'));

        Schema.DescribeFieldResult fieldResultTitles = SV_DeviceMask__c.Mask_Size__c.getDescribe();
        List<Schema.PicklistEntry> lstPicklistEntryTitles = fieldResultTitles.getPicklistValues();
        for (Schema.PicklistEntry ple : lstPicklistEntryTitles)
        {
            options.add(new SelectOption(ple.getLabel(), ple.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption> ();

        options.add(new SelectOption('', 'Please select'));

        System.debug(countryStateMap);

        for (String countryKey : countryStateMap.keySet()) {

            if (!String.isBlank(country) && !countryKey.equalsIgnoreCase(country)) {
                continue; //skip finding states if not match with Country value.
            }

            List<String> stateList = countryStateMap.get(countryKey);
            for (String stateStr : stateList) {
                options.add(new SelectOption(stateStr, stateStr));
            }

        }

        options.sort();

        return options;
    }

    public List<SelectOption> getCountries() {
        List<SelectOption> options = new List<SelectOption> ();

        options.add(new SelectOption('', 'Please select'));

        System.debug(countryStateMap);

        for (String countryKey : countryStateMap.keySet()) {
            options.add(new SelectOption(countryKey, countryKey));
        }

        return options;
    }

    public List<SelectOption> getDays() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Day'));
        for (Integer i = 1; i <= 31; i++) {
            options.add(new SelectOption(string.valueOf(i), string.valueOf(i)));
        }
        return options;
    }

    public List<SelectOption> getGenders() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Gender'));

        options.add(new SelectOption('M', 'Male'));
        options.add(new SelectOption('F', 'Female'));
        return options;
    }

    public List<SelectOption> getMonths() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Month'));

        options.add(new SelectOption('01', '01'));
        options.add(new SelectOption('02', '02'));
        options.add(new SelectOption('03', '03'));
        options.add(new SelectOption('04', '04'));
        options.add(new SelectOption('05', '05'));
        options.add(new SelectOption('06', '06'));
        options.add(new SelectOption('07', '07'));
        options.add(new SelectOption('08', '08'));
        options.add(new SelectOption('09', '09'));
        options.add(new SelectOption('10', '10'));
        options.add(new SelectOption('11', '11'));
        options.add(new SelectOption('12', '12'));

        return options;
    }

    public List<SelectOption> getYears() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Year'));
        Integer currentYear = System.Today().year();
        for (Integer i = currentYear; i > currentYear - 150; i--) {
            options.add(new SelectOption(string.valueOf(i), string.valueOf(i)));
        }
        return options;
    }
    /*13/11/18, Hilary: Purchase Price not required in this release
    public List<SelectOption> getCurrency() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Currency'));

        options.add(new SelectOption('AUD', 'AUD'));
        options.add(new SelectOption('NZD', 'NZD'));

        return options;
    }
    */
    /*
     *   Fetch Saluation (Title) picklist values from Account Salutation picklist field.
     */
    @testVisible
    private static List<SelectOption> getAccountSalutations() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', 'Title'));

        Schema.DescribeFieldResult fieldResultTitles = Account.Salutation.getDescribe();
        List<Schema.PicklistEntry> lstPicklistEntryTitles = fieldResultTitles.getPicklistValues();
        for (Schema.PicklistEntry ple : lstPicklistEntryTitles)
        {
            options.add(new SelectOption(ple.getLabel(), ple.getValue()));
        }
        return options;
    }

    private static Id getRecordTypeIdByDeveloperName(String sObjectName, String recordTypeDeveloperName) {
        List<RecordType> lstRecordTypes = [Select Id From RecordType Where SObjectType = :sObjectName And DeveloperName = :recordTypeDeveloperName LIMIT 1];
        if (lstRecordTypes == null || lstRecordTypes.isEmpty())
        {
            return null;
        }
        return lstRecordTypes[0].Id;
    }

    private static boolean isNullOrWhiteSpace(String str) {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }
    
    public void AccountPopulated(){
        
        String searchTerms = '';
        Account[] accList = null;
    
        if(!String.isEmpty(lastName)){
        
            searchTerms += '("' + lastName + '")';
          
            String searchQuery = 'FIND \'' + searchTerms + '\' IN ALL FIELDS RETURNING Account(id,Name, Salutation, Gender__c, FirstName_SPE__c, LastName_SPE__c, PersonEmail_SPE__c, Mailing_Street_SPE__c, Mailing_City_SPE__c, ' +
                                 'Mailing_State_Province_SPE__c, Mailing_Country_SPE__c, Phone_SPE__c, PersonMobilePhone_SPE__c, Mailing_Zip_Postal_Code_SPE__c, ' +
                                 'PersonBirthdate_SPE__c, membershipNumberFinal__c ORDER BY LastModifiedDate DESC)';
            
            List<List<SObject>> acctSearchList = search.query(searchQuery);
            accList = ((List<Account>) acctSearchList[0]);
            System.debug('@@@@@ accList' + accList);

            filterSection = 'display:none;';
            showFormString='display:block;';
        }
        
        if(accList!=null && accList.size()>0){
            
            for(Account acct : accList){
                
                if(acct.membershipNumberFinal__c.equalsIgnoreCase(memShipNo)){
          
                    title = acct.Salutation;
                    firstname = acct.FirstName_SPE__c;
                    lastName = acct.LastName_SPE__c;
                    email = acct.PersonEmail_SPE__c;
                    phone = acct.Phone_SPE__c;
                    MobileNumber= acct.PersonMobilePhone_SPE__c;
                    gender = acct.Gender__c;
                    streetAddress = acct.Mailing_Street_SPE__c;
                    suburb = acct.Mailing_City_SPE__c;
                    postCode = acct.Mailing_Zip_Postal_Code_SPE__c;
                    state = acct.Mailing_State_Province_SPE__c; 
                    country = acct.Mailing_Country_SPE__c; 
                    
                    if(acct.PersonBirthdate_SPE__c!=null){
                        String dOBString = acct.PersonBirthdate_SPE__c.format();
                  String[] arrTest = dOBString.split('/');
                        
                        if(arrTest[0].length() == 1){
                          month = '0' + arrTest[0];    
                        }else{
                            month = arrTest[0];
                        }
                        
                        day =  arrTest[1];
                        year = arrTest[2];
                    }
                    showFormString='display:block;';
                    disableConData = true;
                }
            }
        }
     }
    
    // funtion to return the credentials 
    public static Resmed_Custom__c customSettingMethod(Boolean isAusUser) {
        Resmed_Custom__c settingObj = new Resmed_Custom__c();
        
        if(isAusUser){
            String erp_setting_Name_AUS = 'Resmed ERP Setting_AU';
            settingObj = Resmed_Custom__c.getValues(erp_setting_Name_AUS);   
        }else{
            String erp_setting_Name_NZ = 'Resmed ERP Setting_NZ';
            settingObj = Resmed_Custom__c.getValues(erp_setting_Name_NZ);   
        }
        
        system.debug('@@@@@ settingObj ' + settingObj);
        return settingObj;
    }
    
    //Calls Web service
    public PageReference callWS() {
        System.debug('@@@@@ serialNumber' + serialNumber); 
        
        //Web service block starts.
        try {
            // Ajit Surana - 04/04/2019 - To validate the input serial number
            if(!isNullOrWhiteSpace(serialNumber)){
                string XMLstring;
                string XMLstring1;
                XMLstring = MakeCallout(serialNumber, true);
                XMLstring1 = MakeCallout(serialNumber, false);
                System.debug('@@@@@ XMLParserMethod(XMLstring)' + XMLParserMethod(XMLstring));
                
                if(XMLParserMethod(XMLstring) == 'Y' || XMLParserMethod(XMLstring1) == 'Y') {  
                    serialNumberInvalid = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, Label.SV_Serial_Number_Valid_Msg));
                    return null;
                }else if(XMLParserMethod(XMLstring) == 'N' && XMLParserMethod(XMLstring1) == 'N') {     
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, Label.SV_Serial_Number_Not_Valid_Msg));
                    serialNumberInvalid = true;
                    return null;
                }
            }
        } catch (Exception ex){
            ApexPages.addMessages(ex);
        }
        //Web service block ends.
    
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Serial number found successfully!!! '));
        return null;
    }
    
    // Call Another ERP to check the Serial Number
    // Method to perform callouts
    public static String MakeCallout(String serialNumber, Boolean isAUSUser) {

        //Define a response to caller
        String outcomeMsg;
        string endpoint;
        string resource;
        string username;
        string password;
        string method;
        string apikey;
        
        // define basic information for later, store these in a protected custom setting
        // be sure this is configured in "Remote Site Settings"
        Resmed_Custom__c settingObj = customSettingMethod(isAUSUser);
        system.debug('**********'+settingObj);
        
        endpoint = settingObj.endpoint__c;    // 'https://apigateway-uat.resmed.com'; 
        resource = settingObj.resource__c;    // '/CN/product/';
        username = settingObj.username__c;    //'wechat_api';
        password = settingObj.password__c;    // 'Welcome@123';
        method = 'GET';
        apikey = settingObj.apikey__c;
        
        // check to ensure a callout can be performed using the Limits class. 
        // This is 100 callouts per execution as of Spring 16 release
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {  outcomeMsg = 'Maximum number of callouts has been reached.';
            // check for credentials error
        } else if (endpoint == null || username == null || password == null) {
            outcomeMsg = 'Please verify your API Credentials';
            // configure and perform the callout
        } else {
            // define transaction variables
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();

            // Configure the request
            req.setEndpoint(endpoint + resource + serialNumber + '/valid');
            req.setMethod(method);
            req.setTimeout(120000);

            Blob headerValue = Blob.valueOf(username + ':' + password);
            // Base 64 Encode the blob and prepend "Basic "
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            // Add the basic auth string to the Request Header
            req.setHeader('Authorization', authorizationHeader);

            // Configure standard headers
            req.setHeader('Accept', '*/*');
            req.setHeader('apikey', apikey);
            
            try {
                // Perform callout and set response
                res = h.send(req);
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    outcomeMsg = res.getBody();
                } else {
                    System.debug('@@@@@ res.getBody()' + res.getBody());
                    // callout failed
                    outcomeMsg = 'Error: Callout failed. Please review the debug log for additional details.';
                }
            } catch(exception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
            }
        }
        return outcomeMsg;
    }
    
    //To return XML Result 
    public static string XMLParserMethod(string XMLString) {
       
        string statusMessage;
        
        //XMLString = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns0:Response xmlns:ns0=\"http://apigateway.resmed.com/schemas/ProductServices/SharedResources\"><ns0:ValidatedStatus>N</ns0:ValidatedStatus><ns0:StatusMessage>No match found</ns0:StatusMessage></ns0:Response>';
        DOM.Document doc=new DOM.Document();
        doc.load(XMLString);
        DOM.XmlNode rootNode = doc.getRootElement();
        system.debug(' *******' + rootNode);
        
        if(rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        system.debug(rootNode.getName());
        }
        
        for(Dom.XMLNode child: rootNode.getChildElements()) {
        system.debug('***** child  '+child);
        child.getText().trim();
        if(child.getName() == 'ValidatedStatus') {
            system.debug('****' + child.getText().trim());
            statusMessage = child.getText().trim();
        }else {}
        
        }
        return statusMessage;
     }
    
    /*@testvisible
    private static String makeRequestForReCaptcha(string url, string body) { 
        HttpResponse response = null; 
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(url); 
        req.setMethod('POST'); 
        req.setBody (body); 
        
        try{ 
            Http http = new Http(); 
            response = http.send(req); 
            return response.getBody(); 
        }catch(System.Exception e) { 
            System.debug('ERROR: ' + e); 
        } 
        
        return '{“success”:false}'; 
    } 
    
    public static string getValueFromJson( String strJson, String field ) { 
        JSONParser parser = JSON.createParser(strJson); 
        
        while (parser.nextToken() != null) { 
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) { 
                if(parser.getText() == field){
                    // Get the value. 
                    parser.nextToken(); 
                    return parser.getText(); 
                } 
            } 
        } 
        return null; 
    }*/
    
    public void processEmailChangeRequest(){
        showError = false;
        emailRetreiveRequestIdErrMessage = new Set<String>();

        System.debug('@@@@ newEmail' + newEmail);
        
        String emailRegex = '^[A-Za-z0-9](([_\\.\\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\\.\\-]?[a-zA-Z0-9]+)*)\\.([A-Za-z0-9]{2,})$';
        
        if(!String.isBlank(newEmail)) {
            if(newEmail.length() > 80){
                emailRetreiveRequestIdErrMessage.add(Label.SV_Email_Char_Limit_Msg);
            }
            else {
                Pattern regexPattern = Pattern.compile(emailRegex);
                Matcher regexMatcher = regexPattern.matcher(newEmail);
                
                if(!regexMatcher.matches()) {
                    emailRetreiveRequestIdErrMessage.add('Invalid Email address');
                }
            }
            
            List<Account> accList = [SELECT Id FROM Account WHERE PersonEmail_SPE__c =: newEmail];
            
            if(accList.size() > 0)
                emailRetreiveRequestIdErrMessage.add(Label.SV_User_Exist_With_Entered_Email_Msg);
            
            
            Boolean isNotValidEmailDomain = false;
                
            Set<string> emailSet = new Set<string>();
            emailSet.addall(Label.SV_Valid_Email_Domain_List.split(','));
            
            String emailDomainName = newEmail.substringAfter('@').substringBefore('.');
            
            if(emailSet!= null && emailSet.size() > 0){
                if(!emailSet.contains(emailDomainName)){
                    isNotValidEmailDomain = true;
                }
            }   
            
            if(isNotValidEmailDomain){
                emailRetreiveRequestIdErrMessage.add('Invalid Domain name');
            }
        }else {
            emailRetreiveRequestIdErrMessage.add('Email cannot be blank');
        }
        
        if (emailRetreiveRequestIdErrMessage.size() > 0){
            showError = true;
        }
        
        else if(emailRetreiveRequestIdErrMessage.size() == 0){
            submitChangeRequest('Email Change');
            displayPopup = false;
        
        }
    }
    
    public void submitChangeRequest (String requestType) {
        try{
            if (requestType == 'Email Change'){
                
                List<Account> accList = [SELECT Id, PersonEmail_SPE__c FROM Account WHERE PersonEmail_SPE__c =: email ORDER BY CreatedDate DESC];
                
                if(accList.size() > 0){
                    for(Account acc : accList){
                        acc.PersonEmail_SPE__c = newEmail;
                    }
                }
                update accList;
                
                email = newEmail;
            }
            
        }catch(Exception ex){
            System.debug('submitChangeRequest :: Exception= ' + ex.getMessage());  
        }
    }
    
    public void showPopup(){
        showError = false;
        emailRetreiveRequestIdErrMessage = new Set<String>();
        newEmail = '';
        displayPopup = true;
    }
    
    public void hidePopUp(){
        displayPopup = false;
    }
    
    public List<SelectOption> getPromotionalCodeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'Select'));
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;  
    }
    
    public void renderPromotionalCodeField() {
        Err_Use_Promotional_Code = '';
        Err_Promotional_Code_Str = '';
        
        String textVal = Apexpages.currentPage().getParameters().get('promoCodeValue');
        if(textVal == 'Yes') {
            Promotional_Code_Pannel = true;
            
        } else if(textVal == 'No') {
            Promotional_Code_Pannel = false;
            
        }
    }
    
    public void goPrevious(){
        infoSection ='display:block;';
        showFormString='display:none;';
        isExistingUser = false;
        isNewUser = false;
        
        if(Is_Using_Device_For_Treament == 'Yes'){
            Promotional_Code_Pannel = true;
        }
    }
    
    /**
     * @author Eduardo Dela Rosa
     * @dateCreated 02-Mar-202
     * @param accountId - Id of the account to be created for subscription entry
     */
    private void createSubscriptionURL(String accountId) {

        final String TYPEKEY = 'Register Your Product'; // this value should point to the name for the Register Your Product process
        final String URLKEY = 'Subscription Processor'; // this value should point to the site.com URL 
        String TYPE = NULL;
        String GUID = NULL;
        GUIDGenerator guidFactory = NULL;

        try {
            TYPE = [SELECT Id, Type__c FROM Subscription_Type__mdt WHERE MasterLabel = :TYPEKEY LIMIT 1].Type__c;
        } catch (Exception e) {
            System.debug('RegisterYourProductController | Error while retrieving TYPE value from Subscription_Type__mdt | Reason: ' + e.getMessage());
            System.debug('RegisterYourProductController | No subscription record will be created.');
        }

        if (TYPE != NULL) { // only proceed when the TYPE is found; otherwise, do nothing

            // Check if there is already a subscription entry for the same Account and Type
            Subscription_Map__c rec = [SELECT Id FROM Subscription_Map__c WHERE Account__c = :accountId AND Type__c = :TYPE.trim() LIMIT 1];

            if (rec == NULL) { // If a record was not found, it means the account is not yet subscribed for this subscription; otherwise do nothing
                guidFactory = new GUIDGenerator(NULL);
                GUID = guidFactory.generateGUID(accountId);
    
                SubscriptionGenerator subsGenerator = new SubscriptionGenerator();
                if (subsGenerator.createSubscriptionURL(TYPE, accountId, GUID, URLKEY)) {
                    System.debug('RegisterYourProductController | createSubscriptionURL() | Successfully created a subscription entry.');
                } else {
                    System.debug('RegisterYourProductController | createSubscriptionURL() | Unsuccessful at creating subscription entry.');
                }
            }
        }
    }
}