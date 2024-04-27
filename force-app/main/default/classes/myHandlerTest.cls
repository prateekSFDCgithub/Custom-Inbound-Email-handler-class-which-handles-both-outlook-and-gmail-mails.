@isTest
private class myHandlerTest {
    //ttt

    @isTest
    static void testHandleInboundEmail_OurEmployeeWithExistingTicket() {

       Messaging.InboundEmail email = new Messaging.InboundEmail();
       email.plainTextBody = 'Test plain text body';
       email.subject = 'Re: Sandbox: Test Subject';
       email.fromAddress = 'test@example.com';
        email.toAddresses =new list<string>{'p@p.com'};

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.Filename = 'attachment.txt'; 
        attachment.Body = Blob.valueOf('Attachment content'); 
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{attachment};
        insert new User(FirstName = 'Test',
            LastName = 'User',
            Email = 'test024@example.com',
            Username = 'test024@example.com',
            Alias = 'testu',
            CommunityNickname = 'testuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = UserInfo.getProfileId());
        Case__c existingCase = new Case__c(Subject__c = 'Test Subject', From__c = 'test@example.com');
        insert existingCase;

        Test.startTest();
        myHandler handler = new myHandler();
        handler.handleInboundEmail(email, null);
        Test.stopTest();

        // Assertions
        // Add assertions based on the expected behavior of your code
    }

    @isTest
    static void testHandleInboundEmail_OurEmployeeWithoutExistingTicket() {
       Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'yy@yy.com';
        envelope.toAddress = 'yyy@yy.com';
        // Test data setup
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'Test plain text body';
        email.subject = 'Re: Sandbox: Test Subject';
        email.fromAddress = 'test@example.com';
         email.toAddresses =new list<string>{'p@p.com'};
        insert new User(FirstName = 'Test',
            LastName = 'User',
            Email = 'test024@example.com',
            Username = 'test024@example.com',
            Alias = 'testu',
            CommunityNickname = 'testuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = UserInfo.getProfileId());

        Test.startTest();
        myHandler handler = new myHandler();
        handler.handleInboundEmail(email, envelope);
        Test.stopTest();

        // Assertions
        // Add assertions based on the expected behavior of your code
    }

    @isTest
    static void testHandleInboundEmail_OurEmployeeWithNewSubject() {
        // Test data setup
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'Test plain text body';
        email.subject = 'New Subject';
        email.fromAddress = 'test@example.com';
         email.toAddresses =new list<string>{'p@pp.com'};
        insert new User(FirstName = 'Test',
            LastName = 'User',
            Email = 'test024@example.com',
            Username = 'test024@example.com',
            Alias = 'testu',
            CommunityNickname = 'testuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = UserInfo.getProfileId());
        Case__c existingCase = new Case__c(Subject__c = 'Test Subject', From__c = 'test@example.com');
        insert existingCase;

        Test.startTest();
        myHandler handler = new myHandler();
        handler.handleInboundEmail(email, null);
        Test.stopTest();

        // Assertions
        // Add assertions based on the expected behavior of your code
    }

    @isTest
    static void testHandleInboundEmail_NotOurEmployee() {
         Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'yy@yy.com';
        envelope.toAddress = 'yyy@yy.com';
        // Test data setup
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'Test plain text body';
        email.subject = 'Test Subject';
        email.fromAddress = 'test@example.com';
         email.toAddresses =new list<string>{'p@p.com'};

        Test.startTest();
        myHandler handler = new myHandler();
        handler.handleInboundEmail(email, envelope);
        Test.stopTest();

        // Assertions
        // Add assertions based on the expected behavior of your code
    }
}