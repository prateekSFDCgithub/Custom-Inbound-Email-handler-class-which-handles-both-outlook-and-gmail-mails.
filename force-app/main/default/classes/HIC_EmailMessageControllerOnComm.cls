public class HIC_EmailMessageControllerOnComm {
    @AuraEnabled 
    public static void sendMailMethod(list<String> mMail , list<string>cc,list<string>bcc, String mSubject ,String mbody, String leadId,String folderId,String templateId,list<string>DocName ,list<string> customInputValueSplitted){
        string messageID = [select messageID__c from case__c where id=:leadID limit 1].messageID__c;
        string sendToVar = '<strong>Sent from Team BANKIT to ' + mMail + ' on ' + Datetime.now().format('d/M/yyyy h:mm a') + '</strong><br/><br/>';
        String sendToCcBCCVar = '<strong>Sent from Team BANKIT to ' + 'To Addresses: ' + mMail + ',' +' Cc Addresses: ' + cc + ',' + ' Bcc Addresses: ' + bcc + ' on ' + Datetime.now().format('d/M/yyyy h:mm a') + '</strong><br/><br/>';
        system.debug('cc: ' + cc);
        system.debug('bcc: ' + bcc);
        string bb = 'Ground Floor, D-49, Sector-63, Noida-201301 (U.P.), India<br/>' +
            
            'Ph. : +91 8142600000 & Chat @ 9311340456 | E-mail : helpdesk@bankit.in, www.bankit.in<br/><br/>' +
            
            'BANKIT SERVICES PRIVATE LIMITED<br/>' +
            '---------------------------------------------------------------------------------------------------------------------<br/>' +
            '"Print this mail only if absolutely necessary. | Your child deserves better world. | Save Paper. Save Trees.<br/><br/><br/>';
        system.debug('DocIDs:@@ '+DocName);
        system.debug('leadId'+leadId);
        List<Messaging.EmailFileAttachment> EFAList = new list<Messaging.EmailFileAttachment>();
        list<ContentVersion> attachmentContent = [SELECT id,ContentDocumentId, Title, VersionData, FileType FROM ContentVersion WHERE title =: DocName];
        system.debug('attachmentContent: '+attachmentContent);
        set<String> uniqueTitlesList = new set<String>();
        list<ContentVersion> attachmentUnique = new list<ContentVersion>();
        
        for(ContentVersion  ac : attachmentContent){
            if(!uniqueTitlesList.contains(ac.title)) {
                uniqueTitlesList.add(ac.Title);
                attachmentUnique.add(ac);
            }
        }
        
        
        for(ContentVersion cont :attachmentUnique){
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(cont.Title);
            attachment.setBody(cont.VersionData);
            
            
            String fileType = cont.FileType != null ? cont.FileType.toLowerCase() : '';
            if (fileType == 'pdf') {
                attachment.setContentType('application/pdf');
            } else if (fileType == 'png') {
                attachment.setContentType('image/png');
            } else if (fileType == 'jpeg' || fileType == 'jpg') {
                attachment.setContentType('image/jpeg');
            } else {
                
                attachment.setContentType('application/octet-stream');
            }
            EFAList.add(attachment);
        }
        string leadName = '';
        string ticketNumber ='';
        String descriptionVar = '' ;
        string leadSubject = '';
        
        list<EmailTemplate> em = new list<EmailTemplate>();
        em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where id =: templateId limit 1];
        
        if(leadId != null ){ 
            system.debug('leadId:  '+leadId);
            case__c ldObj = [select id,name,CP_Name__c,description__c,subject__c from case__c where Id =: leadId];
            
             system.debug('ldObj:  '+ldObj);
            
            if(ldObj.CP_Name__c != null){
                leadName = ldObj.CP_Name__c;
                ticketNumber = ldObj.name;
                system.debug('leadname :  '+ldObj.CP_Name__c);
            }
            if(ldObj.description__c != null){
                descriptionVar = String.ValueOf(ldObj.description__c);
            }
            if(ldObj.Subject__c !=null){
                leadSubject = string.valueOf(ldObj.Subject__c);
                system.debug('leadSub: '+leadSubject);
            }
        }
        List<EmailMessage> emailmessageList =  new List<EmailMessage>();
        emailmessageList = [select id, Subject,TextBody from emailmessage where EmailTemplateId =: templateId order By createddate desc limit 1];
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     list< string> mMailList = mMail;
        if(customInputValueSplitted != null){
            mMailList.addAll(customInputValueSplitted);
        }
        mail.setToAddresses(mMailList);
        if (cc != null && !cc.isEmpty()) {
            mail.setCcAddresses(cc);
            system.debug('cc======>' + cc);
        }
        if (bcc != null && !bcc.isEmpty() ) {
            mail.setBCcAddresses(bcc);
            system.debug('bcc======>' + bcc);
        }
        //mail.setSenderDisplayName('Team Bankit');
        mail.setReplyTo('helpdesk@bankit.in');
        mail.setOrgWideEmailAddressId('0D2T1000000006TKAQ');
        mail.setInReplyto(messageID);
        mail.setFileAttachments(EFAList);
        // mail.setEntityAttachments(DocIds);
        
        string htmlReplace = '' ;
        string finalBody ='';
        string DescriptionBodySecond ='';
        string  DescriptionBodyfirst ='';
        string htmlSubject = mSubject;
        if(mbody != null && mbody != ''){
            if (mbody.containsIgnoreCase('{!Case__c.Description__c}')) {
                finalBody = sendToVar+ mbody.replace('{!Case__c.Description__c}', bb+'{!Case__c.Description__c}');
                
                DescriptionBodyFirst =  mbody.remove('{!Case__c.Description__c}') ;
                DescriptionBodySecond = sendToCcBCCVar+'Subject:'+'<br/>'+mSubject+'<br/><br/>'+ 'Body:'+'<br/>' + DescriptionBodyfirst + bb;
                system.debug(DescriptionBodySecond);
            }
            else{
                finalBody = sendToVar + mbody +bb;
                DescriptionBodySecond = sendToCcBCCVar+'Subject:'+'<br/>'+mSubject+'<br/><br/>'+ 'Body:' +'<br/>'+ mbody + '<br/>'+bb;
                // DescriptionBodySecond = 'Sent from Team BANKIT on ' + Datetime.now().format('d/M/yyyy h:mm a') + '<br/><br/>' + DescriptionBodyfirst + bb;
                
            }
            
            htmlReplace = finalBody; 
        }
        
        
        if (mSubject != null && mSubject != '') {
            if (htmlSubject.containsIgnoreCase('{!Case__c.Subject__c}')) {
                htmlSubject = htmlSubject.replace('{!Case__c.Subject__c}', leadSubject);
            }
        }
        
        if(mbody ==''||mbody==null){
            DescriptionBodySecond = sendToCcBCCVar+'Subject:'+'<br/>'+mSubject+'<br/><br/>'+ 'Body:' +'<br/>'+ mbody + '<br/>'+bb;
        }
        if(mSubject ==''||mSubject==null){
            DescriptionBodySecond = sendToCcBCCVar+'Subject:'+'<br/>'+mSubject+'<br/><br/>'+ 'Body:' +'<br/>'+ mbody + '<br/>'+bb;
        }
        if(msubject==''&& mbody==''){
            DescriptionBodySecond = sendToCcBCCVar+'Subject:'+'<br/>'+mSubject+'<br/><br/>'+ 'Body:' +'<br/>'+ mbody + '<br/>'+bb;
        }
        
        
        if(htmlReplace != null &&  htmlReplace.containsIgnoreCase('{!Case__c.CP_Name__c}')){
            htmlReplace = htmlReplace.replace('{!Case__c.CP_Name__c}',leadName)+'<br/>'; 
            DescriptionBodySecond = DescriptionBodySecond.replace('{!Case__c.CP_Name__c}',leadName)+'<br/>';
            system.debug('htmlreplace' + htmlReplace);
        }
        if(htmlReplace != null &&  htmlReplace.containsIgnoreCase('{!Case__c.Description__c}')){
            htmlReplace = htmlReplace.replace('{!Case__c.Description__c}',descriptionVar)+'<br/>'; 
            system.debug('description: '  +descriptionVar);
        }
        if (htmlReplace!=null && htmlReplace.containsIgnoreCase('{!Case__c.Name}') ){
            htmlReplace = htmlReplace.replace('{!Case__c.Name}',ticketNumber);
        }
        if (DescriptionBodySecond!=null && DescriptionBodySecond.containsIgnoreCase('{!Case__c.Subject__c}') ){
            DescriptionBodySecond = DescriptionBodySecond.replace('{!Case__c.Subject__c}',leadSubject);
        }
        if (DescriptionBodySecond!=null && DescriptionBodySecond.containsIgnoreCase('{!Case__c.CP_Name__c}') ){
            DescriptionBodySecond = DescriptionBodySecond.replace('{!Case__c.CP_Name__c}',leadName);
        }
        if (DescriptionBodySecond!=null && DescriptionBodySecond.containsIgnoreCase('{!Case__c.Name}') ){
            DescriptionBodySecond = DescriptionBodySecond.replace('{!Case__c.Name}',ticketNumber);
        }
        
        
        mail.setHtmlBody(htmlReplace);
        mail.setSubject(htmlSubject);
        mail.setSaveAsActivity(true);
        // mail.setTargetObjectId(leadId); 
        //  mail.setTreatTargetObjectAsRecipient(true);
        mail.setTreatBodiesAsTemplate(true);
        
        if(em.size()!=0){
            mail.setTemplateId(em.get(0).id);
        }
        
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        
        list<case__c> ticketList = [select id,description__c from case__c where id =:leadId limit 1];
        
        for(case__c tick : ticketList){
            if(tick.Description__c !=null){
                tick.Description__c = DescriptionBodySecond + tick.Description__c;
            }
            else if (tick.Description__c ==null){
                tick.Description__c = DescriptionBodySecond ; 
            }
            
        }
        update ticketList;
        
    }   
    
    @AuraEnabled
    public static list<emailTemplateWrapper> getEmailTempaltes(){
        list<emailTemplateWrapper> emailTemplateWrapperlist = new list<emailTemplateWrapper>();
        
        map<String,emailTemplateWrapper> folderIdVsTemplateMap = new map<String,emailTemplateWrapper>();
        //Folder folderObj = new folder();
        set<id>folderID = new set<id>();
        list< folder> folderObj= [SELECT Id,Name FROM Folder];
        for(folder fo :folderObj){
            folderID.add(fo.id);
        }
        for(sobject emailtemp : [ SELECT Id, FolderId, HtmlValue, FolderName, isActive, body,Name,subject FROM EmailTemplate where isActive= true and FolderId in: folderId ]){ 
            if( folderIdVsTemplateMap.containskey( String.valueof(emailtemp.get('FolderId'))) ){
                
                EmailTemplates template = new EmailTemplates();
                template.emailTemplateId = String.valueOf(emailtemp.get('Id'));
                template.emailTemplatename = String.valueOf(emailtemp.get('Name'));
                template.emailbody = (emailtemp.get('HtmlValue') != null ? String.valueOf(emailtemp.get('HtmlValue')) : '' );
                template.emailSubject = String.valueOf(emailtemp.get('subject'));
                folderIdVsTemplateMap.get( String.valueof(emailtemp.get('FolderId')) ).emailtemplatelist.add( template );
                
            }else{
                emailTemplateWrapper tempWrap = new emailTemplateWrapper();
                tempWrap.folderId = String.valueOf(emailtemp.get('FolderId'));
                tempWrap.folderName = String.valueOf(emailtemp.get('FolderName'));
                
                emailTemplates template = new emailTemplates();
                template.emailTemplateId = String.valueOf(emailtemp.get('Id'));
                template.emailTemplatename = String.valueOf(emailtemp.get('Name'));
                template.emailbody = (emailtemp.get('HtmlValue') != null ? String.valueOf(emailtemp.get('HtmlValue')) : '' );
                template.emailSubject = String.valueOf(emailtemp.get('subject'));
                tempWrap.emailtemplatelist = new list<emailTemplates>{ template };
                    folderIdVsTemplateMap.put( String.valueof(emailtemp.get('FolderId'))  , tempWrap );
            }   
        }
        
        if( !folderIdVsTemplateMap.isEmpty() ){
            emailTemplateWrapperlist.addAll( folderIdVsTemplateMap.values() );
            
            return emailTemplateWrapperlist;
        }
        return null;
    }
    
    public class emailTemplateWrapper{
        
        @AuraEnabled 
        public String folderName{get;set;}
        
        @AuraEnabled 
        public String folderId{get;set;}
        
        @AuraEnabled
        public list<emailTemplates> emailtemplatelist{get;set;}
        
    }
    
    public class emailTemplates{
        
        @AuraEnabled 
        public String emailTemplateId{get;set;}
        
        @AuraEnabled 
        public String emailbody{get;set;}
        
        @AuraEnabled
        public String emailSubject {get;set;}
        
        @AuraEnabled 
        public String emailTemplatename{get;set;}
    }  
    
    @AuraEnabled
    public static case__c getLeadRec(String leadId){
        case__c leadObj = new case__c();
        leadObj = [select id,name,CP_Name__c,description__c from case__c where id=: leadId Limit 1];
        system.debug('leadId : '+leadId);
         system.debug('leadObj : '+leadObj);
        return leadObj;
        
    }
    @AuraEnabled
    public static Map<String, String> UserEmailListClass(string leadId) {
        Map<String, String> emailMap = new Map<String, String>();
        
        List<Case__c> caseList = [SELECT from__c , id FROM Case__c WHERE (from__c != null and id =:leadId)];
        for (Case__c caseRec : caseList) {
            // Use a unique key for Case object, such as prefixing with 'case_'
            emailMap.put('case_' + caseRec.Id, caseRec.from__c);
        }
        
        List<User> userList = [SELECT email FROM User WHERE email != null];
        for (User userRec : userList) {
            // Use a unique key for User object, such as prefixing with 'user_'
            emailMap.put('user_' + userRec.Id, userRec.email);
        }
        
        System.debug(emailMap);
        return emailMap;
    }
    @AuraEnabled
    public static string getCurrentSubject(id ticketId){
        list<case__c>TicketList = [select id,subject__c from case__c where id=:ticketId limit 1];
        string subject ='';
        for(case__c tick : TicketList){
            subject = tick.Subject__c;
        }
        return subject;
    }
   
}