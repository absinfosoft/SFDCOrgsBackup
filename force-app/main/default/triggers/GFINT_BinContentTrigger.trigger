trigger GFINT_BinContentTrigger on GFERP__Bin_Content__c (after insert, after update, after delete, before insert , before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        for(GFERP__Bin_Content__c theBinContent : trigger.new) {
            
            if(theBinContent.OMS_Available__c < 0){
               theBinContent.addError('OMS avaialble cannot be less than 0');
            }
            
        }
    } 
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
         GFINT_BinContentTriggerHandler.updateItemUnitOfMeasure(trigger.new);
    }
    
    if(Trigger.isDelete) GFINT_BinContentTriggerHandler.updateItemUnitOfMeasure(trigger.old);
    
}