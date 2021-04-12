//GFINT_ComCloudItemInventoryBatchTest
public class GFINT_ForceSendXMLToSFCCController {
    private ApexPages.StandardSetController standardSetController;
    public Integer theItemCount { get; set; }
    Set<Id> itemSelectedIds;
    
    public GFINT_ForceSendXMLToSFCCController(ApexPages.StandardSetController controller) {
        theItemCount = 0;
        standardSetController = controller;
        itemSelectedIds = new Set<Id>();
        for (GFERP__Item__c theItem : (GFERP__Item__c[]) standardSetController.getSelected()) {
            itemSelectedIds.add(theItem.Id);
            theItemCount += 1;
        }
    }
    
    public pagereference callNightlyBatch() {
        List<GFERP__Item_Unit_of_Measure__c> theSelectedIUOMList = [SELECT Id FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Item__c IN: itemSelectedIds];
        
        if(!theSelectedIUOMList.isEmpty()) {
            GFINT_ComCloudNightlySchedulableBatch theNightlyBatchObj = new GFINT_ComCloudNightlySchedulableBatch(theSelectedIUOMList);
            Database.executeBatch(theNightlyBatchObj);
        }
        
        return new ApexPages.Action('{!List}').invoke();
    }
    
    public PageReference returnBack() {
        return new ApexPages.Action('{!List}').invoke();
    }
}