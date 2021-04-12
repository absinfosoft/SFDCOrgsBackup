trigger GFINT_ImagesTrigger on Images__c (before update) {
    
    if(trigger.isBefore && trigger.isUpdate) {
        GFINT_ImagesTriggerHandler.uncheckUploadedComCloudFieldOnIUOM(trigger.new, trigger.oldMap);
    }    
    
}