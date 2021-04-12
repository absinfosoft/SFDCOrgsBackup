//Test Class: GFINT_ComCloudItemInventoryBatchTest
public class GFINT_CreateMasterCatalogXML implements Queueable, Database.AllowsCallouts {
    
    List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
    public GFINT_CreateMasterCatalogXML(Map<Id , List<GFERP__Item_Unit_of_Measure__c>> itemUOMMap, List<GFERP__Item_Unit_of_Measure__c> itemUOMList) {
        theItemId_ItemUOMListMap = itemUOMMap;
        theAllItemUOMList = itemUOMList;
    }
    
    public void execute(QueueableContext context) { 
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAllItemUOMList) {
            
            if(!theItemUOM.Uploaded_to_CC_Item__c) {
                theItemUOMList.add(theItemUOM);
            }
            
        }
        //get Product XML 
        String theProductDataFile = GFINT_AllXMLs.createMasterCatalogXML(theItemUOMList, theItemId_ItemUOMListMap);
        
        //Upload XML
        if(theProductDataFile != '' && theProductDataFile != null) {
            GFINT_XMLAPItoSFCC.uploadFileAPI(theProductDataFile, 'master_catalog','catalogs','XML');
        }
        
        //call Inventory XML
        if(!Test.isRunningTest()) System.enqueueJob(new GFINT_CreateInventoryXML(theItemId_ItemUOMListMap, theAllItemUOMList));
    }
    
}