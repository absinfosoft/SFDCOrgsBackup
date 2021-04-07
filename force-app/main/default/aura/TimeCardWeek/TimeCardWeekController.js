({
    doInit: function(component, event, helper) {
        var action = component.get('c.fetchTimeCard');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.theWrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    SelectWeek: function(component, event, helper) {
        
        var theSelectDate = component.get("v.theSelectDate");
        var action = component.get('c.fetchSelectWeekTimeCard');
        action.setParams({ 
            theStartDate : theSelectDate 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var theSelectWeekWrapper = response.getReturnValue();
                component.set('v.theSelectWeekTimeCardList', theSelectWeekWrapper.theSelectWeekTimeCardList);
                component.set('v.theSelectWeekEndDate', theSelectWeekWrapper.theEndDate);
                component.set('v.theSelectWeekStartDate', theSelectWeekWrapper.theStartDate);
            }
            else {
                console.log('theError');
            }
        });
        $A.enqueueAction(action);
    },
    
    updateTimeCard: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        component.set("v.Spinner", true); 
        var action = component.get('c.fetchTimeCardforEdit');
        action.setParams({ 
            theTimeCardId : id_str 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.selectedRecord', response.getReturnValue());
                component.set("v.Spinner", false);
                component.set("v.isOpen", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    SaveTimeCard : function(component, event, helper) {
        var theTimeCard = component.get("v.selectedRecord");
        var action = component.get("c.saveTimeCard");
        action.setParams({
            theTimeCardstr : JSON.stringify(theTimeCard)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    
    copyLastWeek : function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.saveCommon(component,event,'LastWeek');
    },
    
    copySelectedWeek: function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.saveCommon(component,event,'SelectedWeek');
    },
    
})