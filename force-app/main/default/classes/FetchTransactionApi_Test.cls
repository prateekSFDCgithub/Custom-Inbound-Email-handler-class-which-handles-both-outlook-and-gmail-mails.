@IsTest
public class FetchTransactionApi_Test
{
    public static TestMethod void testMethod1()
    {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://uat.bankit.in:9012/SafeGoldAPI/wallet/details');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"access_token":"bar"}'; 
        FetchTransactionApi.callgetTransaction(System.today(), System.today() - 2, 'AG02491');   
        test.stopTest();
    }
    
}