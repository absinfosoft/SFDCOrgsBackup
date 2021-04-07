({
    searchHelper  : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchOpportunity");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
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
            if (state === "SUCCESS") { 
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
             }
                
          });
          $A.enqueueAction(action);
         }
})