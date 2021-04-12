//Test Class: GFINT_ComCloudItemInventoryBatchTest
public class GFINT_CreateInventoryXML implements Queueable, Database.AllowsCallouts {
    
    List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
    public GFINT_CreateInventoryXML(Map<Id , List<GFERP__Item_Unit_of_Measure__c>> itemUOMMap, List<GFERP__Item_Unit_of_Measure__c> itemUOMList) {
        theItemId_ItemUOMListMap = itemUOMMap;
        theAllItemUOMList = itemUOMList;
    }
    
    public void execute(QueueableContext context) {
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAllItemUOMList) {
            
            if(!theItemUOM.Uploaded_to_CC_Inventory__c) theItemUOMList.add(theItemUOM);
            
        }
        //get Inventory XML
        String theInventoryDataFile = GFINT_AllXMLs.createInventoryXML(theItemUOMList, theItemId_ItemUOMListMap);
        
        //Upload XML
        if(theInventoryDataFile != '' && theInventoryDataFile != null) {
            GFINT_XMLAPItoSFCC.uploadFileAPI(theInventoryDataFile, 'drops_inventory', 'inventory-lists', 'XML');
        }
        
        //Call List Price XML
        if(!Test.isRunningTest())System.enqueueJob(new GFINT_CreateListPriceXML(theItemId_ItemUOMListMap, theAllItemUOMList));
    }
}