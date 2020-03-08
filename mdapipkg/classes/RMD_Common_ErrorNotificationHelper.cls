/********************************************************************************** 
 * Name: RMD_Common_ErrorNotificationHelper
 * Description: Singleton to Store message during request
 * Change History: 
 * <Version>    <Date of Change>    <Author Name>    <Describe the changes made> 
 * ---------------------------------------------------------------------------------
 * v1.0         24-May-2017        Ong Fong Tien     To store all error messages and send email only once to SysAdmin.
 ***********************************************************************************/
public with sharing class RMD_Common_ErrorNotificationHelper {
    // private static variable referencing the class
    private static RMD_Common_ErrorNotificationHelper instance = null;
    public Boolean isSendEmailActivated { get; private set; } // check custom setting on whether 
    public List<String> messageList { get; private set; } // to store all exception / error occurred.

    public String subjectStr { get; private set; } // to store all exception / error occurred.
    public String attachmentFileNameStr { get; private set; } // the attachment file name
    public String emailBodyStr { get; private set; } // the email body


    // The constructor is private and initializes the messageList and indicator
    private RMD_Common_ErrorNotificationHelper() {
        isSendEmailActivated = (!String.isBlank(Label.RMD_Enable_Email_Notification) && 'Y'.equalsIgnoreCase(Label.RMD_Enable_Email_Notification))? TRUE:FALSE;
        messageList = new List<String> ();
        subjectStr = 'EMAIL SUBJECT'; //this is optionally set during runtime.
        attachmentFileNameStr = 'ErrorDetails.txt'; //this is can be optionally set during runtime.
        emailBodyStr = 'Please refer to attachment on error occurred.'; //this is can be optionally set during runtime.
    }

    // a static method that returns the instance 
    public static RMD_Common_ErrorNotificationHelper getInstance() {
        // lazy load - only initialize if it doesn't already exist
        if (instance == null) {
            instance = new RMD_Common_ErrorNotificationHelper();
        }
        return instance;
    }

    // Method to add errorMessage to List
    public void addExceptionMessage(String errMsg) {
        messageList.add(errMsg);
    }

    // Method to set Email Subject
    public void setEmailSubject(String subjectArg) {
        subjectStr = subjectArg;
    }

    // Method to set attachmentFileName
    public void setAttachmetFileName(String attachmentNameArg) {
        attachmentFileNameStr = attachmentNameArg;
    }

    // Method to set email body
    public void setEmailBody(String emailBodyArg) {
        emailBodyStr = emailBodyArg;
    }

    // Method to sendEmail in one Go.
    public void sendEmail() {
        try {

            // If not enabled/ activated, just return and dont proceed to send email.
            System.debug('isSendEmailActivated : ' + isSendEmailActivated);
            if (!isSendEmailActivated) {
                return;
            }

            // if messageList is not empty, prepared to send email
            System.debug('messageList  : ' + messageList);
            if (messageList != null && messageList.size() > 0) {

                Messaging.EmailFileAttachment errorAttachment = new Messaging.EmailFileAttachment();
                errorAttachment.setContentType('text/plain');
                errorAttachment.setFileName(attachmentFileNameStr);
                errorAttachment.setInline(false);
                errorAttachment.Body = Blob.valueOf(JSON.serializePretty(messageList));


                // Get list of recipients
                Exception_Recipient__mdt[] exceptionRecipient = [SELECT MasterLabel FROM Exception_Recipient__mdt];
                List<String> recipientList = new List<String> ();
                for (Exception_Recipient__mdt recipient : exceptionRecipient) {
                    recipientList.add(recipient.MasterLabel);
                }

                Messaging.SingleEmailMessage singEmail = new Messaging.SingleEmailMessage();
                String[] toAddresses = recipientList;
                singEmail.setToAddresses(toAddresses);
                singEmail.setSubject(subjectStr);
                singEmail.setFileAttachments(new Messaging.EmailFileAttachment[] { errorAttachment });

                singEmail.setPlainTextBody(emailBodyStr);
                Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singEmail });
            }
        } catch(Exception ex) {
            System.debug('Unexpected error during sending email : ' + ex.getMessage() + ', ' + ex.getStackTraceString()); //This is to handle unforseens issues. Eg. deliverability disabled, invalid emails.
        }
    }
}