trigger GFINT_ItemTrigger on GFERP__Item__c (after update) {
    
    GFINT_ItemTriggerHandler.uncheckedItemUnitOfMeasure(trigger.new);
    
}