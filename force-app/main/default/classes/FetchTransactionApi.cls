public class FetchTransactionApi {
    public static list<Transaction__c> callgetTransaction (Date toDate, Date fromDate, String agentId)
    {
        System.debug('---- toDate: ' + toDate);
		System.debug('---- fromDate: ' + fromDate);
        List<Transaction__c> LstTransaction=new List<Transaction__c>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Adding custom metadata
        List<BANKIT_API__mdt> lstAPIMetadata = [SELECT Id, MasterLabel, DeveloperName, Active__c, API__c 
                                                FROM BANKIT_API__mdt 
                                                WHERE 
                                                DeveloperName = 'Transaction_Detail_API' AND Active__c = true];
		System.debug('--- lstAPIMetadata: ' + lstAPIMetadata);
		if(lstAPIMetadata != null && lstAPIMetadata.size() > 0 && lstAPIMetadata[0] != null && lstAPIMetadata[0].API__c != null)
            request.setEndpoint(lstAPIMetadata[0].API__c);
        else
            request.setEndpoint('http://45.114.245.112:7081/SafeGold/wallet/transactiondetails');
        
        request.setHeader('Content-Type','application/json');
        //request.setBody('{"searchtext": "amit.malu@bankit.in"}');
        //request.setBody('{"searchtext":"AG2190","fromDate":"2019-01-01","toDate":"2019-01-03"}');
        request.setBody('{"searchtext":"'+ agentId +'","fromDate":"'+fromDate+'","toDate":"'+toDate+'"}');
        request.setMethod('POST');
        request.setTimeout(120000);
        HttpResponse response = new HttpResponse(); 
        if(Test.isRunningTest())
        {
            response.setBody('{"transactionId":"19010215055906105005","transactionNo":"976960270V86332362","referenceId":"000064438910","dateOfTransaction":"2019-01-02","timeofTransaction":"15:05:59","amount":"70.0000","charge":"0.0000","commision":"0.0000","beforeBalace":"2629.6553","afterBalance":"2559.6553","action":"debit","status":"success","service":"cardTransfer-"}'); 
            response.setStatusCode(200);
        }
        else
        {
            System.debug('----- request: ' + request);
            System.debug('----- request.getBody(): ' + request.getBody());
            response=http.send(request);
        }
        system.debug('@@response.getBody(): ' +response.getBody());
        system.debug('statusCode:'+response.getStatusCode());
        String trimmedResponse = response.getBody().unescapeCsv().remove('\\');
        system.debug('@@@RESPONSE@@'+trimmedResponse);
        system.debug('getBody():'+response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());
        set<Transaction__c> TransactionList=new set<Transaction__c>();
        system.debug('@@@RESPONSE@@'+parser.nextToken());
        system.debug('@@@RESPONSE@@'+parser.getCurrentToken());
        system.debug('@@@RESPONSE@@'+parser.getText());
        if(response.getstatusCode() == 200 && response.getbody() != null)
        {
            while (parser.nextToken() != null) {
                
                system.debug('@@@RESPONSE@@'+parser.getCurrentToken());
                system.debug('@@@RESPONSE@@'+parser.getText());
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ){
                    Transaction__c trans;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'transactionId')) {
                        // Get the value.
                        parser.nextToken();
                        trans=new Transaction__c();
                        trans.Transaction_Id__c=parser.getText();
                        system.debug('parser.getText@@@' + parser.getText());
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'transactionNo')) {
                                // Get the value.
                                parser.nextToken();
                                // Compute the grand total price for all invoices.
                                trans.transactionNo__c=parser.getText();
                                //system.debug('trans.Mobile_No__c@@@' + trans.Mobile_No__c );
                            }
                        //Email
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'referenceId')) {
                                // Get the value.
                                parser.nextToken();
                                trans.ReferenceId__c=parser.getText();
                                // system.debug('trans.State__c@@@' + trans.State__c);
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'dateOfTransaction')) {
                                // Get the value.
                                parser.nextToken();
                                trans.Date_Of_Transaction__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'timeofTransaction')) {
                                // Get the value.
                                parser.nextToken();
                                trans.TimeofTransaction__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'amount')) {
                                // Get the value.
                                parser.nextToken();
                                trans.Amount__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'charge')) {
                                // Get the value.
                                parser.nextToken();
                                trans.charge__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'commision')) {
                                // Get the value.
                                parser.nextToken();
                                trans.Commision__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'beforeBalace')) {
                                // Get the value.
                                parser.nextToken();
                                trans.Before_Balance__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'afterBalance')) {
                                // Get the value.
                                parser.nextToken();
                                trans.After_Balance__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'action')) {
                                // Get the value.
                                parser.nextToken();
                                trans.action__c=parser.getText();
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'status')) {
                                // Get the value.
                                parser.nextToken();
                                trans.Status__c=parser.getText();
                                system.debug('trans.Status__c'+trans.Status__c);
                            }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'service')) {
                                // Get the value.
                                parser.nextToken();
                                trans.service__c=parser.getText();
                            }
                    }
                    TransactionList.add(trans); 
                }
                TransactionList.remove(null); 
            }
        }
        LstTransaction.AddAll(TransactionList);
        system.debug('ContList@@@@'+Json.serialize(LstTransaction));
        
        return LstTransaction;
    }
    
}