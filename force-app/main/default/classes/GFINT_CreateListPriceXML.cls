//Test Class: GFINT_ComCloudItemInventoryBatchTest
public class GFINT_CreateListPriceXML implements Queueable, Database.AllowsCallouts {
    
    List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
    public GFINT_CreateListPriceXML(Map<Id , List<GFERP__Item_Unit_of_Measure__c>> itemUOMMap, List<GFERP__Item_Unit_of_Measure__c> itemUOMList) {
        theItemId_ItemUOMListMap = itemUOMMap;
        theAllItemUOMList = itemUOMList;
    }
    
    public void execute(QueueableContext context) {
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAllItemUOMList) {
            
            if(!theItemUOM.Uploaded_to_CC_Item__c) theItemUOMList.add(theItemUOM);
            
        }
        //get List Price XML
        String theListPriceDataFile = GFINT_AllXMLs.createListPriceXML(theItemUOMList, theItemId_ItemUOMListMap);
        
        //Upload XML
        if(theListPriceDataFile != '' && theListPriceDataFile != null) {
            GFINT_XMLAPItoSFCC.uploadFileAPI(theListPriceDataFile, 'kwd-m-list-prices','pricebooks','XML');
        }
        
        //call Sales Price XML
        if(!Test.isRunningTest())System.enqueueJob(new GFINT_CreateSalesPriceXML(theItemId_ItemUOMListMap, theAllItemUOMList));
    }
}