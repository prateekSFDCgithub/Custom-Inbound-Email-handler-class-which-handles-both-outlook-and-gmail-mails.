({
    sendHelper: function (component, getEmail,getEmailCC,getEmailBCC, getSubject, getbody, leadId,DocName,customInputValueSplitted) {
        component.set("v.showSpinner", true);
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        var templateId = component.get("v.templateIDs");
        // set the 3 params to sendMailMethod method   
        action.setParams({
            'mMail': getEmail,
            'cc':getEmailCC,
            'bcc':getEmailBCC,
            'mSubject': getSubject,
            'mbody': getbody,
            'leadId': leadId,
            'folderId': component.get("v.folderId1"),
            'templateId': component.get("v.templateIDs"),
            'DocName':DocName,
            'customInputValueSplitted':customInputValueSplitted
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                console.log('selectedValues:@2 '+component.get("v.selectedValues"));
                component.set("v.mailStatus", true);
                sessionStorage.removeItem('DocNameList');
            }
            component.set("v.showSpinner", false);
            
        });
        $A.enqueueAction(action);
    },
    
    getEmailTemplateHelper: function (component, event) {
        
        var action = component.get("c.getEmailTempaltes");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                component.set("v.emailfolderVSTemplateList", response.getReturnValue());
                // component.set('v.loaded', !component.get('v.loaded'));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
        
    },
})