public with sharing class myHandler implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        boolean OurEmployee = false;
        boolean NewSubject = false; 
         string[] emailBodySections;
        system.debug('emailpalintextbody: '+email.plainTextBody);
        if(email.plainTextbody.contains('________________________')){
            emailBodySections = email.plainTextbody.split('________________________');
            system.debug('emailBodySections: if split: '+email.plainTextbody.split('________________________'));
        }
      else  if (email.plainTextbody.contains('On ')) {
    // Regular expression pattern to match weekdays
    Pattern pattern = Pattern.compile('\\b(?:On\\s+Sun|On\\s+Mon|On\\s+Tue|On\\s+Wed|On\\s+Thu|On\\s+Fri|On\\s+Sat)\\b');
    
    // Match the pattern in the email body
    Matcher matcher = pattern.matcher(email.plainTextbody);
    
    // Check if the pattern is found
    if (matcher.find()) {
        // Split the email body based on the matched weekday
        emailBodySections = email.plainTextbody.split(matcher.group());
        
        // Debug the split sections
        System.debug('emailBodySections: ' + emailBodySections);
    }
}
        
        else{
            emailBodySections = new list<string>{email.plainTextbody};
                system.debug('emailBodySections: if not split: '+ email.plainTextbody);
            system.debug('emailBodySections: ' + emailBodySections );
            system.debug( 'emailBodySectionsSize:  '+emailBodySections.size());
        }
        string body = emailBodySections[0] != null ? emailBodySections[0] : email.htmlBody;
        String ToCcBCCVar = '<strong>Came from ' + email.fromAddress +' to ' + 'To Addresses: ' + email.toAddresses + ',' +' Cc Addresses: ' + 
            email.ccAddresses + ' on ' + Datetime.now().format('d/M/yyyy h:mm a') + '</strong><br/><br/>'+'Subject: '+ email.subject 
            + '<br/><br/>' + 'Body: ' + body + '<br/><br/>';
        system.debug('ToCcBCCVar: '+ToCcBCCVar);
       
        
        list<user>UserList =[select id ,email from user where email =:email.fromAddress ];
        
        system.debug('userList: ' + UserList);
        ourEmployee = !UserList.isEmpty() ? true :false;
        list<case__c>TicketList3 = new list<case__c>();
        
        if(ourEmployee == true){
            system.debug('emailSub: '+email.subject);
            string emailSubTrim = email.subject.remove('Re: ');
            system.debug('emailSubTrim: '+ emailSubTrim);
            TicketList3 =[select id,description__c,from__c,subject__c from case__c where subject__c =:emailSubTrim limit 1];
            system.debug('TicketList3'+TicketList3);
        }
        system.debug('ourEmployee: '+ourEmployee);
        list<case__c>TicketList =[select id,description__c,from__c,Subject__c from case__c where from__c =:email.fromAddress limit 1];
        
        system.debug('TicketList: '+TicketList);
        system.debug('TicketList3@@@'+TicketList3);
        if(!TicketList.isEmpty()||(!ticketList3.isEmpty()&&ourEmployee==true&&TicketList.isEmpty())){
            for(case__c tick : TicketList.isEmpty() ? ticketList3:TicketList){
                if(tick.description__c == null || tick.Description__c == ''){
                    tick.description__c =  ToCcBCCVar;
                    system.debug('ToCcBCCVar NULL Runing');
                }
                if(tick.description__c != null || tick.Description__c != ''){
                    tick.description__c = ToCcBCCVar + tick.description__c;
                    system.debug('ToCcBCCVar Not Null Runing');
                }
                
                
                if(tick.From__c == email.fromAddress){
                    string emailSub2 = email.subject.remove('Re: ');
                    system.debug('emailSub2###: '+emailSub2);
                    
                    tick.MessageId__c =email.messageId;
                    if(tick.Subject__c!=emailSub2){
                        NewSubject = true;
                        tick.Subject__c = emailSub2;
                        tick.Status__c = 'Re-Open';
                        if (emailBodySections.size() > 1) {
                            string latestReply = emailBodySections[0];
                            // The first element would be the newest reply
                            system.debug('latestReply: '+latestReply);
                            // Update the appropriate if blocks:
                            if(email.plainTextBody != null) {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c fuirst: '+ tick.Body_Tooltip2__c );
                            } else {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c second: '+ tick.Body_Tooltip2__c );
                            }
                        }
                        if (emailBodySections.size() == 1) {
                            string latestReply = emailBodySections[0];
                            // The first element would be the newest reply
                            system.debug('latestReply: '+latestReply);
                            // Update the appropriate if blocks:
                            if(email.plainTextBody != null) {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c fuirst: '+ tick.Body_Tooltip2__c );
                            } else {
                                tick.Body_Tooltip2__c = latestReply; 
                                system.debug('Body_Tooltip2__c second: '+ tick.Body_Tooltip2__c );
                            }
                        }
                    }
                    else if(tick.Subject__c==emailSub2){
                        tick.Status__c = 'Open';
                        
                        
                        if (emailBodySections.size() > 1) {
                            string latestReply = emailBodySections[0];
                            // The first element would be the newest reply
                            system.debug('latestReply: '+latestReply);
                            // Update the appropriate if blocks:
                            if(email.plainTextBody != null) {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c fuirst: '+ tick.Body_Tooltip2__c );
                            } else {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c second: '+ tick.Body_Tooltip2__c );
                            }
                        }
                        if (emailBodySections.size() == 1) {
                            string latestReply = emailBodySections[0];
                            // The first element would be the newest reply
                            system.debug('latestReply: '+latestReply);
                            // Update the appropriate if blocks:
                            if(email.plainTextBody != null) {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c fuirst: '+ tick.Body_Tooltip2__c );
                            } else {
                                tick.Body_Tooltip2__c = body; 
                                system.debug('Body_Tooltip2__c second: '+ tick.Body_Tooltip2__c );
                            }
                        }
                    }
                    
                    
                    
                    if(email.ccAddresses!=null){
                        tick.CC__c = string.join(email.ccAddresses, ';');
                    }
                    
                }
            }
            if(!TicketList.isEmpty()){
                update TicketList;
            }
            
            if (!ticketList3.isEMpty()){
                update ticketList3;
            }
            string emailSubTrim = email.subject.remove('Re: ');
            system.debug('emailSubTrim: '+ emailSubTrim);
            list<case__c>  ticketId2List = [select id,description__c,from__c from case__c where from__c =:email.fromAddress limit 1];
            string   ticketId2;
            system.debug('ticketId2List: '+ ticketId2List);
            
            if(!ticketId2List.isEmpty()){
                ticketId2 =  ticketId2List[0].id; 
            }
            system.debug('ticketId2: '+ ticketId2);
            list<case__c>  ticketId3List = [select id,description__c,subject__c from case__c where subject__c =:emailSubTrim limit 1];
            system.debug('ticketId3List: '+ ticketId3List);
            string   ticketId3;
            
            if(!ticketId3List.isEmpty()){
                ticketId3 =  ticketId3List[0].id; 
                
            }
            
            system.debug('ticketId3: '+ ticketId3);
            
            List<Attachment> atachlist = new List<Attachment>();
            system.debug('binaryAttachm: '+email.binaryAttachments);
            if(email.binaryAttachments !=null && email.binaryAttachments.size() > 0){
                
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    if(ticketId2!=null){
                        system.debug('if runing@@@222');
                        attachment.ParentId = ticketId2;
                    }
                    else{
                        system.debug('else runing@@2222');
                        attachment.ParentId = ticketId3;
                    }
                    
                    atachlist.add(attachment);
                }
                insert atachlist;
            }
            
            if(NewSubject == true){
                string  ticketNum2 = [select id,name,from__c from case__c where from__c =:email.fromAddress].name;
                messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                mail.setToAddresses(new list<string>{email.fromAddress});
                mail.setReplyTo('helpdesk@bankit.in');
                //  mail.setSenderDisplayNAme('Team Bankit');
                mail.setOrgWideEmailAddressId('0D2T1000000006TKAQ');
                mail.setSubject(email.subject);
                mail.setPlainTextBody('Thanks for contacting BANKIT! \n\n'+
                                      'This reply is just to let you know we received your request, and we’ll get back to you with a response as quickly as possible. During 9:00AM – 8:00PM (Monday-Saturday), we usually reply within a couple of hours, evenings and weekends may take us a little bit longer. \n\n'+
                                      'While you wait, you are welcome look at our Frequently Asked Questions in our Website https://www.bankit.in/Faq\'s (bankit.in) ,where you can find lots of guidance about Products. \n\n'+
                                      'Or, if your request is urgent, feel free to give us a call at 8142600000 or e-mail us at helpdesk@bankit.in. We look forward to getting you back in business! \n\n'+
                                      'Best Regards, \n\n'+
                                      'Team Bankit\n\n');                  
                mail.setInReplyto(email.messageID);
                messaging.sendEmail(new list<messaging.singleEmailMessage>{mail});
                
                list<case__c>TicketListReply = [select id,Description__c,from__c from case__c where from__c =:email.fromAddress];
                string tickNum221 =[select id,Description__c,from__c,name from case__c where from__c =:email.fromAddress].name;
                for(case__c tick :TicketListReply){
                    tick.Description__c = '<strong> This is Auto Reply Sended on behalf of bankit to ' + email.fromAddress + ' on '  + Datetime.now().format('d/M/yyyy h:mm a')
                        +'<br/><br></strong>'+ email.subject + '<br/><br/>'  + 'Body: ' + 'Thanks for contacting BANKIT! <br><br>'+
                        'This reply is just to let you know we received your request, and we’ll get back to you with a response as quickly as possible. During 9:00AM – 8:00PM (Monday-Saturday), we usually reply within a couple of hours, evenings and weekends may take us a little bit longer. <br><br>'+
                        'While you wait, you are welcome look at our Frequently Asked Questions in our Website https://www.bankit.in/Faq\'s (bankit.in) ,where you can find lots of guidance about Products. <br><br>'+
                        'Or, if your request is urgent, feel free to give us a call at 8142600000 or e-mail us at helpdesk@bankit.in. We look forward to getting you back in business! <br><br>'+
                        'Best Regards, <br><br>'+
                        'Team Bankit<br><br>'
                        + '<br/><br/>' + tick.Description__c;
                }
                update TicketListReply;
            }
            
        }
        
        else {
            if(ourEmployee == false){
                Case__c ticket = new Case__c();
                ticket.Status__c = 'Open';
                ticket.Subject__c = email.subject;
                ticket.MessageId__c = email.messageId;
                ticket.CP_Name__c = email.fromName;
                
                if(email.plainTextBody != null) {
                    ticket.Body_Tooltip2__c = body;
                } else {
                    ticket.Body_Tooltip2__c = body;
                }
                
                system.debug('Email@@@##: '+ email.toAddresses);
                ticket.From__c = email.fromAddress;
                ticket.To__c = string.join(email.toAddresses, ';');
                system.debug('ticket.To__c: '+ ticket.To__c);
                ticket.Description__c = ToCcBCCVar;
                system.debug('ToCcBCCVar:@@  '+ToCcBCCVar +'ticket.Description__c: '+ ticket.Description__c );
                if(email.ccAddresses!=null){
                    ticket.CC__c = string.join(email.ccAddresses, ';');
                }
                
                Database.SaveResult[] insertResults = Database.insert(new list<case__c>{ticket}, false);
                string ticketNum;
                Id recordId;
                string  TicketID;
                // Iterate through the results to check for success and retrieve IDs
                for(Database.SaveResult sr : insertResults) {
                    if(sr.isSuccess()) {
                        recordId = sr.getId();
                        ticketNum = [select id,name from case__c where id =:recordId].name;
                        TicketID = [select id,name from case__c where id =:recordId].id;
                        
                    } else {
                        
                        for(Database.Error err : sr.getErrors()) {
                            system.debug(err.getMessage());
                        }
                    }
                }
                
                
                messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                mail.setToAddresses(new list<string>{email.fromAddress});
                mail.setReplyTo('helpdesk@bankit.in');
                //  mail.setSenderDisplayNAme('Team Bankit');
                mail.setOrgWideEmailAddressId('0D2T1000000006TKAQ');
                
                mail.setSubject(email.subject);
                mail.setInReplyto(email.messageID);
                mail.setPlainTextBody('Thanks for contacting BANKIT! \n\n'+
                                      'This reply is just to let you know we received your request, and we’ll get back to you with a response as quickly as possible. During 9:00AM – 8:00PM (Monday-Saturday), we usually reply within a couple of hours, evenings and weekends may take us a little bit longer. \n\n'+
                                      'While you wait, you are welcome look at our Frequently Asked Questions in our Website https://www.bankit.in/Faq\'s (bankit.in) ,where you can find lots of guidance about Products. \n\n'+
                                      'Or, if your request is urgent, feel free to give us a call at 8142600000 or e-mail us at helpdesk@bankit.in. We look forward to getting you back in business! \n\n'+
                                      'Best Regards, \n\n'+
                                      'Team Bankit\n\n\n');                
                messaging.sendEmail(new list<messaging.singleEmailMessage>{mail});  
                
                list<case__c>TicketList2 = [select id,Description__c from case__c where id =:recordId];
                for(case__c tick :ticketList2){
                    tick.Description__c = '<strong> This is Auto Reply Sended on behalf of bankit to ' + email.fromAddress + ' on '  + Datetime.now().format('d/M/yyyy h:mm a')
                        +'<br/><br></strong>'+ email.subject + '<br/><br/>'  + 'Body: ' + 'Thanks for contacting BANKIT! <br><br>'+
                        'This reply is just to let you know we received your request, and we’ll get back to you with a response as quickly as possible. During 9:00AM – 8:00PM (Monday-Saturday), we usually reply within a couple of hours, evenings and weekends may take us a little bit longer. <br><br>'+
                        'While you wait, you are welcome look at our Frequently Asked Questions in our Website https://www.bankit.in/Faq\'s (bankit.in) ,where you can find lots of guidance about Products. <br><br>'+
                        'Or, if your request is urgent, feel free to give us a call at 8142600000 or e-mail us at helpdesk@bankit.in. We look forward to getting you back in business! <br><br>'+
                        'Best Regards, <br><br>'+
                        'Team Bankit<br><br>' +'<br/><br/>' + tick.Description__c;
                }
                update TicketList2;
                List<Attachment> atachlist = new List<Attachment>();
                system.debug('binaryAttachm: '+email.binaryAttachments);
                if(email.binaryAttachments !=null && email.binaryAttachments.size() > 0){
                    
                    for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                        Attachment attachment = new Attachment();
                        attachment.Name = bAttachment.fileName;
                        attachment.Body = bAttachment.body;
                        attachment.ParentId = TicketID;
                        atachlist.add(attachment);
                    }
                    insert atachlist;
                }
            }
        }
        
        return null;
    }
    
    
}