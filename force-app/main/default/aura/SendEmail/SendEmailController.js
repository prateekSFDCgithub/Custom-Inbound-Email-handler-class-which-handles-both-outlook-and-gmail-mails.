({
    doInit: function (component, event, helper) {
        console.log('doInit Runing');

        
        sessionStorage.removeItem('DocNameList');
        var leadId = component.get("v.recordId");
        console.log('leadID: '+leadId);
        var action = component.get("c.getLeadRec");
        action.setParams({
            "leadId": leadId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() != null && response.getReturnValue() != "" && response.getReturnValue() != undefined) {
                    component.set("v.email", response.getReturnValue().Email);
                }
            }
        });
        $A.enqueueAction(action);
        helper.getEmailTemplateHelper(component, event);
        var action = component.get("c.UserEmailListClass");
        action.setParams({
            "leadId": leadId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var emailMap = response.getReturnValue();
                var options = Object.keys(emailMap).map(function(key) {
                    return {
                        label: emailMap[key],
                        value: emailMap[key]
                    };
                });
                component.set("v.options", options);
                console.log('VVVOptions: '+options);
                component.set("v.CCoptions", options);
                component.set("v.BCCoptions", options);
            } else {
                console.error('Failed to fetch user emails: ' + response.getError()[0].message);
            }
        });
        
        $A.enqueueAction(action);
        
        var action = component.get("c.getCurrentSubject");
        action.setParams({
            "ticketId": leadId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.subject",response.getReturnValue());
            }
            else {
                console.error('Failed to fetch user emails: ' + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    showDropdown: function(component, event, helper) {
        component.set("v.showDropdown", true);
        component.set("v.CCShowOptions", false);
        component.set("v.BCCShowOptions", false);
    },
    
    hideDropdown: function(component, event, helper) {
        component.set("v.showDropdown", false);
    }, 
    handleInputChange: function(component, event, helper) {
        component.set("v.CCShowOptions", false);
        component.set("v.BCCShowOptions", false);
        component.set("v.ShowOptions", true);
        console.log('handleInputChange runing');
        component.set("v.searchOptions", ""); // Reset selected value when input changes
        var inputValue = component.get("v.inputValue");
        if (inputValue && inputValue.trim() !== "") {
             var options = component.get("v.options");
        
        var filteredOptions = [];
        
        options.forEach(function(option) {
            if (option.label.includes(inputValue.toLowerCase())){
                filteredOptions.push(option);
            }
        });
        
        component.set("v.searchOptions", filteredOptions);
        }
        else{
            component.set("v.ShowOptions", false);
        }
       
    },
    
    selectOption: function(component, event, helper) {
        var empList = [];
        component.set("v.searchOptions", empList);
        component.set("v.inputValue", "");
        
        console.log('select option runing');
        var selectedOption = event.currentTarget.dataset.value;
        console.log('selectedOption: '+selectedOption);
        var selectedValues = component.get("v.selectedValues");
        if (!selectedValues.includes(selectedOption)) {
            selectedValues.push(selectedOption);
            component.set("v.selectedValues", selectedValues);
            component.set("v.showDropdown", false);
            component.set("v.ShowOptions", false);
            console.log('selected email list: ' + component.get("v.selectedValues"));
        }
        
        else{
            alert ('email already selected');
            return;
        }
        
    },
    
    removeSelectedValue: function(component, event, helper) {
        var selectedValueToRemove = event.getSource().get("v.value");
        var selectedValues = component.get("v.selectedValues");
        var index = selectedValues.indexOf(selectedValueToRemove);
        if (index !== -1) {
            selectedValues.splice(index, 1);
            component.set("v.selectedValues", selectedValues);
        }
    },
    CCshowDropdown: function(component, event, helper) {
        component.set("v.CCshowDropdown", true);
        component.set("v.ShowOptions", false);
        component.set("v.BCCShowOptions", false);
    },
    
    CChideDropdown: function(component, event, helper) {
        component.set("v.CCshowDropdown", false);
    }, 
    CChandleInputChange: function(component, event, helper) {
        component.set("v.CCShowOptions", true);
        component.set("v.ShowOptions", false);
        component.set("v.BCCShowOptions", false);
        console.log('CChandleInputChange runing');
        component.set("v.CCsearchOptions", ""); // Reset selected value when input changes
        var inputValue = component.get("v.CCinputValue");
        if (inputValue && inputValue.trim() !== "") {
            var options = component.get("v.CCoptions");
        
        var filteredOptions = [];
        
        options.forEach(function(option) {
            if (option.label.includes(inputValue)){
                filteredOptions.push(option);
            }
        });
        
        component.set("v.CCsearchOptions", filteredOptions);
        }
        else{
            component.set("v.CCShowOptions", false);
        }
        
    },
    
    CCselectOption: function(component, event, helper) {
        var empList = [];
        component.set("v.CCsearchOptions", empList);
        component.set("v.CCinputValue", "");
        console.log('select option runing');
        var selectedOption = event.currentTarget.dataset.value;
        console.log('CCselectedOption: '+selectedOption);
        var selectedValues = component.get("v.CCselectedValues");
        if (!selectedValues.includes(selectedOption)) {
            selectedValues.push(selectedOption);
            component.set("v.CCselectedValues", selectedValues);
            console.log('CC selected email list: ' + component.get("v.CCselectedValues"));
        }
        
        else{
            alert ('email already selected');
            return;
        }
        
    },
    
    CCremoveSelectedValue: function(component, event, helper) {
        var selectedValueToRemove = event.getSource().get("v.value");
        var selectedValues = component.get("v.CCselectedValues");
        var index = selectedValues.indexOf(selectedValueToRemove);
        if (index !== -1) {
            selectedValues.splice(index, 1);
            component.set("v.CCselectedValues", selectedValues);
        }
    },
    BCCshowDropdown: function(component, event, helper) {
        component.set("v.BCCshowDropdown", true);
        component.set("v.ShowOptions", false);
        component.set("v.CCShowOptions", false);
    },
    
    BCChideDropdown: function(component, event, helper) {
        component.set("v.BCCshowDropdown", false);
    }, 
    BCChandleInputChange: function(component, event, helper) {
        console.log('BCChandleInputChange runing');
        component.set("v.BCCShowOptions", true);
        component.set("v.ShowOptions", false);
        component.set("v.CCShowOptions", false);
        component.set("v.BCCsearchOptions", ""); 
        var inputValue = component.get("v.BCCinputValue");
        if (inputValue && inputValue.trim() !== "") {
            var options = component.get("v.BCCoptions");
        
        var filteredOptions = [];
        
        options.forEach(function(option) {
            if (option.label.includes(inputValue)){
                filteredOptions.push(option);
            }
        });
        
        component.set("v.BCCsearchOptions", filteredOptions);
        }
        else{
            component.set("v.BCCShowOptions", false);
        }
        
    },
    
    BCCselectOption: function(component, event, helper) {
        var empList = [];
        component.set("v.BCCsearchOptions", empList);
        component.set("v.BCCinputValue", "");
        console.log('select option runing');
        var selectedOption = event.currentTarget.dataset.value;
        console.log('BCCselectedOption: '+selectedOption);
        var selectedValues = component.get("v.BCCselectedValues");
        if (!selectedValues.includes(selectedOption)) {
            selectedValues.push(selectedOption);
            component.set("v.BCCselectedValues", selectedValues);
            console.log('CC selected email list: ' + component.get("v.BCCselectedValues"));
        }
        
        else{
            alert ('email already selected');
            return;
        }
        
    },
    
    BCCremoveSelectedValue: function(component, event, helper) {
        var selectedValueToRemove = event.getSource().get("v.value");
        var selectedValues = component.get("v.BCCselectedValues");
        var index = selectedValues.indexOf(selectedValueToRemove);
        if (index !== -1) {
            selectedValues.splice(index, 1);
            component.set("v.BCCselectedValues", selectedValues);
        }
    },
    
    sendMail: function (component, event, helper) {
        
        // when user click on Send button 
        // First we get all 3 fields values 
        var getEmail = component.get("v.selectedValues") || [];
        var getEmailCC = component.get("v.CCselectedValues") || [];
        var getEmailBCC = component.get("v.BCCselectedValues") || [];
        var getSubject = component.get("v.subject") || '';
        var getbody = component.get("v.emailbody") || '';
        var leadId = component.get("v.recordId");
        var DocName = component.get("v.DocNameListFinal");
        
        var isValid = true;
        if (getEmail === null || getEmail === "" || getEmail.length === 0 ){
            alert ('To Email Addresses cannot be empty');
            return;
        }
        getEmail.forEach(function(email) {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                isValid = false;
                console.log('Invalid email address: ' + email);
            }
        });
        
        console.log('runing@@@#'+getEmailCC);
        getEmailCC.forEach(function(email) {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                console.log('isRuning@@@@##!!!');
                isValid = false;
                console.log('Invalid email address: ' + email);
            }
        });
        
        
        getEmailBCC.forEach(function(email) {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                console.log('isRuning@@!!!');
                isValid = false;
                console.log('Invalid email address: ' + email);
            }
        });
        if(getSubject === null||getSubject === "" || getSubject.length === 0){
            alert('Subject cannot be empty.');
            return;
        }
        
        
        
        
        if (!isValid) {
            alert('One or more email addresses are invalid');
            return;
        }
        
        console.log('selectedValues:@2 '+component.get("v.selectedValues"));
         var customInputValueSplitted = [];
        
        if(component.get("v.CustomInputvalue")!== ""){
            console.log('CustomInputvalue@22222: '+component.get("v.CustomInputvalue"));
        var customInputValueSplittedF = component.get("v.CustomInputvalue").split(',');
            
            console.log('customInputValueSplittedF: ' + customInputValueSplittedF);
           
        customInputValueSplittedF.forEach(function(email) {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                console.log('runing1');
                alert('Invalid email address format in custom addresses: ' + email);
                isValid = false;
                return;
            } else if (customInputValueSplitted.includes(email)) {
                 console.log('runing2');
                alert('Duplicate email address in custom addresses: ' + email);
                isValid = false;
                return;
            } else {
                customInputValueSplitted.push(email);
                console.log('runing3');
                isValid=true;
                
            }
            
            
        });
            console.log('customInputValueSplitted@@: '+customInputValueSplitted);
           
        }
        if (!isValid) {
           
            return;
        }
        
        helper.sendHelper(component, getEmail, getEmailCC, getEmailBCC, getSubject, getbody, leadId, DocName,customInputValueSplitted);
    }
    
    ,
    
    // when user click on the close buttton on message popup ,
    // hide the Message box by set the mailStatus attribute to false
    // and clear all values of input fields.   
    closeMessage: function (component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.selectedValues", []);
        component.set("v.BCCselectedValues", []);
        component.set("v.CCselectedValues", []);
        component.set("v.inputValue", "");
        component.set("v.CCinputValue", "");
        component.set("v.BCCinputValue", "");
        component.set("v.emailbody", null);
        component.set("v.subject", null);
        component.set("v.DocNameListFinal",[]);
        component.set("v.AttachmentsStorage",[]); 
        component.set("v.docNameRealTemp",[]);
        component.set("v.docNameReal",[]);
        component.set("v.ShowOptions", false);
        component.set("v.CCShowOptions", false);
        component.set("v.BCCShowOptions", false);
         component.set("v.CustomInputvalue", "");
        
        $A.get('e.force:refreshView').fire();
    },
    
    onSelectEmailFolder: function (component, event, helper) {
        var folderId = event.target.value;
        component.set("v.folderId1", folderId);
        if (folderId != null && folderId != '' && folderId != 'undefined') {
            var emailfolderVSTemplateList = component.get("v.emailfolderVSTemplateList");
            emailfolderVSTemplateList.forEach(function (element) {
                if (element.folderId == folderId) {
                    component.set("v.emailTemplateList", element.emailtemplatelist);
                }
            });
        } else {
            var temp = [];
            component.set("v.emailTemplateList", temp);
        }
    },
    
    onSelectEmailTemplate: function (component, event, helper) {
        var emailTempId = event.target.value;
        var emailbody = '';
        var emailSubject = '';
        component.set("v.templateIDs", emailTempId);
        if (emailTempId != null && emailTempId != '' && emailTempId != 'undefined') {
            var emailTemplateList = component.get("v.emailTemplateList");
            emailTemplateList.forEach(function (element) {
                if (element.emailTemplateId == emailTempId && element.emailbody != null) {
                    emailbody = element.emailbody;
                    emailSubject = element.emailSubject;
                }
            });
        }
        component.set("v.emailbody", emailbody);
        component.set("v.subject", emailSubject);
        
    },
    
    closeModal: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    openmodal: function (component, event, helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var docNameList = component.get("v.AttachmentsStorage") || []; // Get the existing list from sessionStorage or initialize to an empty array if it doesn't exist
        
        for (var i = 0; i < uploadedFiles.length; i++) {
            var docName = uploadedFiles[i].name;
            
            console.log('fileId@@: '+docName);
            var fileName = docName.split('.').slice(0, -1).join('.'); // Extract filename without extension
            console.log('docNameAfterSplit: ' + fileName);
            docNameList.push(fileName); // Append the new filename to the existing list
            
            
        }
        
        console.log('DocNameList: ' + JSON.stringify(docNameList));
        component.set("v.AttachmentsStorage", docNameList);
        component.set("v.DocNameListFinal", docNameList);
        
        
        console.log('DocNameListFinal: ' + JSON.stringify(component.get("v.DocNameListFinal")));
    },
    removeAttachment: function (component, event, helper) {
        var attachmentToRemove = event.getSource().get("v.value");
        var DocNameListFinal = component.get("v.DocNameListFinal");
        var AttachmentsStorage = component.get("v.AttachmentsStorage");
        var index = DocNameListFinal.indexOf(attachmentToRemove);
        var index2 = DocNameListFinal.indexOf(attachmentToRemove);
        if (index !== -1) {
            DocNameListFinal.splice(index, 1);
            component.set("v.DocNameListFinal", DocNameListFinal);
            console.log('DocNameListFinal: ' + JSON.stringify(component.get("v.DocNameListFinal")));
        }
        if (index2 !== -1) {
            AttachmentsStorage.splice(index2, 1);
            component.set("v.AttachmentsStorage", AttachmentsStorage);
            console.log('AttachmentsStorage: ' + JSON.stringify(component.get("v.AttachmentsStorage")));
        }
        
        
        
    }
    
})