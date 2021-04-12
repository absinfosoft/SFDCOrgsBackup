//Test Class: GFINT_ComCloudItemInventoryBatchTest
public class GFINT_CreateStorefrontCatalogXML implements Queueable, Database.AllowsCallouts{
    
    List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    Map<Id, List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id, List<GFERP__Item_Unit_of_Measure__c>>();
    public GFINT_CreateStorefrontCatalogXML(Map<Id , List<GFERP__Item_Unit_of_Measure__c>> itemUOMMap, List<GFERP__Item_Unit_of_Measure__c> itemUOMList) {
        theItemId_ItemUOMListMap = itemUOMMap;
        theAllItemUOMList = itemUOMList;
    }
    
    public void execute(QueueableContext context) { 
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAllItemUOMList) {
            
            if(!theItemUOM.Uploaded_to_CC_Item__c) theItemUOMList.add(theItemUOM);
            
        }
        
        //get Catalog XML
        String theCatalogProductDataFile = GFINT_AllXMLs.createStorefrontCatalogXML(theItemUOMList, theItemId_ItemUOMListMap);
        
        //API Call
        if(theCatalogProductDataFile != '' && theCatalogProductDataFile != null) {
            GFINT_XMLAPItoSFCC.uploadFileAPI(theCatalogProductDataFile, 'drops_storefront_catalog','catalogs','XML');
        }
        
    }   
}