({
    selectOpportunity : function(component, event, helper){      
        var getSelectOpp = component.get("v.oOpportunity");
        var compEvent = component.getEvent("oSelectedOpportunityEvent");
        compEvent.setParams({"OpportunityByEvent" : getSelectOpp});  
        compEvent.fire();
    },
})