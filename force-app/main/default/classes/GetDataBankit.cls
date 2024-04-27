/*
API : 48.00
Author : RIjwan
Source : Kcloudtechnologies.com
Date : 14/02/2020
*/
public class GetDataBankit{
    @AuraEnabled 
    public static List<JSON2Apex> fetchAccountWrapper(String Mobileno,String agent){  
        System.debug('Mobileno==>'+Mobileno);
        System.debug('agent is==>'+agent);
        Http http = new Http();
        HttpRequest re = new HttpRequest();
        re.setEndpoint('https://services.bankit.in:8443/WalletV1/wallet/details');
        re.setBody('{"searchtext":'+Mobileno+'}');
        re.setMethod('POST');
        re.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response = http.send(re);
        System.debug('response is' +response);
        
        List<JSON2Apex> jsList = sdparse(response.getBody());
        System.debug('jsList is' +jsList);
        
        /********** Create Ticket **********************/
        if(jsList.isEmpty() && Mobileno!=null){
            JSON2Apex JS = new JSON2Apex();
            Call_History__c callHistory = new Call_History__c();
            callHistory.Receiver_Name__c = Userinfo.getUserId();
            callHistory.Type__c = 'Customer';
            callHistory.Customer_Type__c ='New';
            callHistory.Create_Case__c = 'Inquire';
            callHistory.Mobile_Phone__c = Mobileno;
            insert callHistory;
            
            JS.ticketId = '';
            JS.mobileNo = Mobileno;
            JS.callHistoryId = callHistory.id;
            JS.name = 'test';
            jsList.add(JS);
            
        }else if(jsList.size()==1 && Mobileno!=null){
            Call_History__c callHistory = new Call_History__c();
            callHistory.Receiver_Name__c = Userinfo.getUserId();
            callHistory.Type__c = 'Customer';
            callHistory.Customer_Type__c ='New';
            callHistory.Create_Case__c = 'Inquire';
            callHistory.Mobile_Phone__c = Mobileno;
            callHistory.Agent_Id__c = jsList[0].userId;
            callHistory.Email__c    = jsList[0].emailId;
            callHistory.Address1__c = jsList[0].address1;
            callHistory.Address2__c = jsList[0].address2;
            callHistory.City__c     = jsList[0].city;
            callHistory.Zone__c     = jsList[0].zone;
            callHistory.Serviced_By__c = jsList[0].serviceBy;
            callHistory.State__c       = jsList[0].state;
            callHistory.Country__c     = jsList[0].country;
            callHistory.PIN__c         = jsList[0].pin;
            callHistory.CP_Name__c     = jsList[0].name;
            //changes to map additional field on call history 
            callHistory.Transaction_status__c = jsList[0].transactionStatus;
            System.debug('js list transaction status is' +callHistory.Transaction_status__c +'  '+'jslist transaction status is' +jsList[0].transactionStatus);
            
            callHistory.Block_Status__c = jsList[0].blockStatsu;
            System.debug('js list transaction status is' +callHistory.Block_Status__c +' '+'js'+jsList[0].blockStatsu);
            
            callHistory.Date_of_Joining__c = jsList[0].registerationDate;
            System.debug('js list Block status is' +callHistory.Date_of_Joining__c + 'js ' +jsList[0].registerationDate);
            
            callHistory.Last_Transaction_Service_Used__c = jsList[0].service;
            System.debug('js list Last_Transaction_Service_Used__c status is' +callHistory.Last_Transaction_Service_Used__c +'js '+jsList[0].service);
            
            callHistory.Last_Transaction_date__c = jsList[0].transactionDate;
            System.debug('js list Last_Transaction_date__c is' +callHistory.Last_Transaction_date__c+'js'+' '+jsList[0].transactionDate);
            
            callHistory.Last_Transaction_amount__c = jsList[0].amount;
            System.debug('js list Last_Transaction_amount__c is' +callHistory.Last_Transaction_amount__c+'js'+' '+jsList[0].amount);
            
             callHistory.Login_Status__c = jsList[0].loginStatus;
            System.debug('js list login status value is' +callHistory.Login_Status__c+'js'+' '+jsList[0].loginStatus);
            
            insert callHistory;
            System.debug('inserted callHistory record is'+callHistory);
            
            jsList[0].mobileNo = Mobileno;
            jsList[0].ticketId = '';
            jsList[0].callHistoryId = callHistory.id;
            //sendRecordId(callHistory.id,agent);
        }
        /********* End Ticket Create ********************/
        
        return jsList; 
    }
    //@future (callout=true)
    @AuraEnabled 
    public static void sendRecordId(String recordId,String agent){
        Http http = new Http();
        HttpRequest re = new HttpRequest();
        re.setEndpoint('https://s5.ivrscloud.com/ConVoxCCS/Agent/get_salesforce_recordid.php?user_id='+agent+'&record_id='+recordId);
        //re.setEndpoint('https://s5.ivrscloud.com:8348/ConVoxCCS/Agent/get_salesforce_recordid.php?user_id='+agent+'&record_id='+recordId);
        re.setMethod('GET');
        System.debug('body==>'+re.getEndpoint());
        //re.setHeader('Content-Type', 'application/json;charset=UTF-8');
        if(!test.isRunningTest()){
            HttpResponse response = http.send(re);
            System.debug('===>'+response.getBody());
        }
        
    }
    
    @AuraEnabled 
    public static jsonDataa fetchTicketId(object res,String agentId){
        Map<String,Object> jsApex = (Map<String,Object>)JSON.deserializeUntyped(res.toString());
        System.debug('jsApex response is' +jsApex);
        Call_History__c callHistory = new Call_History__c();
        callHistory.Receiver_Name__c = Userinfo.getUserId();
        callHistory.Type__c = 'Customer';
        callHistory.Customer_Type__c ='New';
        callHistory.Create_Case__c = 'Inquire';
        callHistory.Mobile_Phone__c = String.valueof(jsApex.get('mobileNo'));
        callHistory.Agent_Id__c = String.valueof(jsApex.get('userId'));
        callHistory.Email__c    = String.valueof(jsApex.get('emailId'));
        callHistory.Address1__c = String.valueof(jsApex.get('address1'));
        callHistory.Address2__c = String.valueof(jsApex.get('address2'));
        callHistory.City__c     = String.valueof(jsApex.get('city'));
        callHistory.Zone__c     = String.valueof(jsApex.get('zone'));
        callHistory.Serviced_By__c = String.valueof(jsApex.get('serviceBy'));
        callHistory.State__c       = String.valueof(jsApex.get('state'));
        callHistory.Country__c     = String.valueof(jsApex.get('country'));
        callHistory.PIN__c         = String.valueof(jsApex.get('pin'));
        callHistory.CP_Name__c     = String.valueof(jsApex.get('name'));
        callHistory.Last_Transaction_amount__c = String.valueOf(jsApex.get('amount'));
        callHistory.Last_Transaction_date__c = String.valueOf(jsApex.get('transactionDate'));
        callHistory.Last_Transaction_Service_Used__c = String.valueOf(jsApex.get('service'));
        callHistory.Date_of_Joining__c = String.valueOf(jsApex.get('registerationDate'));
        callHistory.Block_Status__c = String.valueOf(jsApex.get('blockStatsu'));
        callHistory.Login_Status__c = String.valueOf(jsApex.get('loginStatus'));
        
        insert callHistory;
        jsonDataa jd = new jsonDataa();
        jd.ticketId = '';
        jd.callHistoryId = callHistory.id;
        return jd;
    }
    
    public class jsonDataa{
        @AuraEnabled public String ticketId;
        @AuraEnabled public String callHistoryId;
    }
    
    /* json class */
    public class JSON2Apex {
        @AuraEnabled public String emailId; 
        @AuraEnabled public String mobileNo;
        @AuraEnabled public String state;
        @AuraEnabled public String city;
        @AuraEnabled public String country;
        @AuraEnabled public String address1;
        @AuraEnabled public String address2;
        @AuraEnabled public String name;
        @AuraEnabled public String serviceBy;
        @AuraEnabled public String zone;
        @AuraEnabled public String userType;
        @AuraEnabled public String dob;
        @AuraEnabled public String registerationDate;
        @AuraEnabled public String gender;
        @AuraEnabled public String pin;
        @AuraEnabled public String balance;
        @AuraEnabled public String userId;
        @AuraEnabled public String roCount;
        @AuraEnabled public String dsCount;
        @AuraEnabled public String ticketId;
        @AuraEnabled public String callHistoryId;  
        //variables for extra fields mapping on callhistory
        @AuraEnabled public String transactionStatus;
        @AuraEnabled public String service;
        @AuraEnabled public String blockStatsu;
        @AuraEnabled public String transactionDate;
        @AuraEnabled public String amount; 
        @AuraEnabled public String loginStatus; 
    }
    
    public static List<JSON2Apex> sdparse(String json) {
        return (List<JSON2Apex>) System.JSON.deserialize(json, List<JSON2Apex>.class);
    }
}