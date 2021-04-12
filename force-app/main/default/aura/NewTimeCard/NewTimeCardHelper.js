({
    searchHelper  : function(component,event,getInputkeyWord) {
        var action = component.get("c.fetchOpportunity");
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    updateWeek:function(component,event){
        
        var theWeekCount = component.get("v.theWeekShift");
        var action = component.get("c.updateWeek");
        action.setParams({
            theWeekShift : theWeekCount
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var theWeek = response.getReturnValue();
                var theWrapper = component.get("v.wrapperObj");
                theWrapper.theWeek = theWeek;
                theWrapper.theWeekShift = theWeekCount;
                component.set("v.wrapperObj", theWrapper);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveCommon:function(component,event,theinput){
        component.set("v.Spinner", true); 
        var theWrapper = component.get("v.wrapperObj");
        var action = component.get("c.saveTimeCard");
        action.setParams({
            theTimeCardstr : JSON.stringify(theWrapper)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var theErrorString = response.getReturnValue();
            var theFirstWord = theErrorString.split(" ")[0];
            if (state === "SUCCESS" && theFirstWord != 'Error') { 
                if(theinput == 'TimeCardSave') {
                    setTimeout(() => {
                        component.set("v.Spinner", false); 
                        window.open('/'+response.getReturnValue(), "_self");}, 
                        3000);
                  }else if(theinput == 'TimeCardSaveandNew') {
                        setTimeout(() => {  
                        component.set("v.Spinner", false);
                        location.reload();
                    }, 3000);
                  }else if(theinput == 'TimeCardSaveFromOpp'){
                        setTimeout(() => {  
                        location.reload();
                    }, 3000);
                    }else if(theinput == 'TimeCardSaveNewFromOpp'){
                        setTimeout(() => {  
                        component.set("v.Spinner", false);
                        var a = component.get('c.doInit');
                        $A.enqueueAction(a);
                    }, 3000);
                    }
                    }else if(theFirstWord == 'Error') {
                        component.set("v.Spinner", false);
                        theErrorString = theErrorString.substr(6);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        title : 'Error',
                        duration:'5000',
                        message: theErrorString,
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                }
                
                
          });
          $A.enqueueAction(action);
         },
          
})