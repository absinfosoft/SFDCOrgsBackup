({
    saveCommon : function(component,event,getInputkeyWord) {
       
        var theTimeCardList;
        if(getInputkeyWord == 'LastWeek') {
            var theWrapper = component.get("v.theWrapper");
            theTimeCardList = theWrapper.thePreviousWeekTimeCard
        }
        else if(getInputkeyWord == 'SelectedWeek') {
           theTimeCardList = component.get("v.theSelectWeekTimeCardList");
        }
        
        var action = component.get("c.CopyPreviousCardData");
        action.setParams({
            theTimeCardListstr : JSON.stringify(theTimeCardList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                location.reload();
            }
        });
        $A.enqueueAction(action);
    }
})