({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        if(pageRef != null && pageRef != 'undefined') {
            var state = pageRef.state; 
            var base64Context = state.inContextOfRef;
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            var theRecordId = addressableContext.attributes.recordId;
            component.set("v.parentRecordId", theRecordId);
        }
        
        var action = component.get("c.fetchOppRecord");
        var theOppId = component.get("v.recordId");
        action.setParams({theOppId:theOppId,
                          theParentIdFromRelatedList:theRecordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var theWrapper = response.getReturnValue();
                component.set("v.wrapperObj", theWrapper);
                if(theWrapper.theOpp != null) {
                    component.set("v.selectedRecord" , theWrapper.theOpp);
                    var forclose = component.find("lookup-pill");
                    $A.util.addClass(forclose, 'slds-show');
                    $A.util.removeClass(forclose, 'slds-hide');
                    
                    var forclose = component.find("searchRes");
                    $A.util.addClass(forclose, 'slds-is-close');
                    $A.util.removeClass(forclose, 'slds-is-open');
                    
                    var lookUpTarget = component.find("lookupField");
                    $A.util.addClass(lookUpTarget, 'slds-hide');
                    $A.util.removeClass(lookUpTarget, 'slds-show'); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    closeModel: function(component, event, helper) {
        window.history.back();
    },
    
    Save: function(component, event, helper) {
        var theinput = 'TimeCardSave';
        helper.saveCommon(component,event,theinput);
    },
    
    SaveAndNew: function(component, event, helper) {
        var theinput = 'TimeCardSaveandNew';
        helper.saveCommon(component,event,theinput);
    },
    
    SaveFromOpp: function(component, event, helper) {
        var theinput = 'TimeCardSaveFromOpp';
        helper.saveCommon(component,event,theinput);
    },
    
    SaveAndNewFromOpp: function(component, event, helper) {
        var theinput = 'TimeCardSaveNewFromOpp';
        helper.saveCommon(component,event,theinput);
    },
    
    keyPressController : function(component, event, helper) {
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,helper){
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        //get the selected Account record from the COMPONETN event 	 
        var selectedOpportunityGetFromEvent = event.getParam("OpportunityByEvent");
        component.set("v.selectedRecord" , selectedOpportunityGetFromEvent);
        
        var theWrapper = component.get("v.wrapperObj");
        theWrapper.theOpp = selectedOpportunityGetFromEvent;
        component.set("v.wrapperObj" , theWrapper);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
                    
    decrease :function(component, event, helper){
        var theWeekShift = component.get('v.theWeekShift');
        var theDecWeekShift = theWeekShift - 1;
        component.set('v.theWeekShift', theDecWeekShift);
        helper.updateWeek(component,event);
    },
    
    increase :function(component, event, helper){
        var theWeekShift = component.get('v.theWeekShift');
        var theIncWeekShift = theWeekShift + 1;
        component.set('v.theWeekShift', theIncWeekShift);
        helper.updateWeek(component,event);
    },
})