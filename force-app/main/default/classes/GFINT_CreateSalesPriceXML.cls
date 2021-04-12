//Test Class: GFINT_ComCloudItemInventoryBatchTest
public class GFINT_CreateSalesPriceXML implements Queueable, Database.AllowsCallouts{
    
    List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
    public GFINT_CreateSalesPriceXML(Map<Id , List<GFERP__Item_Unit_of_Measure__c>> itemUOMMap, List<GFERP__Item_Unit_of_Measure__c> itemUOMList) {
        theItemId_ItemUOMListMap = itemUOMMap;
        theAllItemUOMList = itemUOMList;
    }
    
    public void execute(QueueableContext context) {
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAllItemUOMList) {
            
            if(!theItemUOM.Uploaded_to_CC_Sales_Price__c) theItemUOMList.add(theItemUOM);
            
        }
        //get Sales Price XML
        String theSalesPriceDataFile = GFINT_AllXMLs.CreateSalesPriceXML(theItemUOMList, theItemId_ItemUOMListMap);
        
        //Upload XML
        if(theSalesPriceDataFile != '' && theSalesPriceDataFile != null) {
            GFINT_XMLAPItoSFCC.uploadFileAPI(theSalesPriceDataFile, 'kwd-m-sale-prices','pricebooks','XML');
        }
        
        //call Catalog XML
        if(!Test.isRunningTest()) System.enqueueJob(new GFINT_CreateStorefrontCatalogXML(theItemId_ItemUOMListMap, theAllItemUOMList));
    }
}