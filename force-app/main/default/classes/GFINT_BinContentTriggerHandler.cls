//GFINT_BinContentTriggerHandlerTest
public class GFINT_BinContentTriggerHandler {
    
    public static void updateItemUnitOfMeasure(List<GFERP__Bin_Content__c> theBinContentList) {
        List<Id> theItemUOMIdList = new List<Id>();
        Map<Id, GFERP__Item_Unit_of_Measure__c> theUpdateItemUOMMap = new Map<Id, GFERP__Item_Unit_of_Measure__c>();
        
        Map<Id, List<GFERP__Bin_Content__c>> theItemUOMId_BinContentListMap = new Map<Id, List<GFERP__Bin_Content__c>>();
        
        for(GFERP__Bin_Content__c theBinContent : theBinContentList) {
            
            theItemUOMIdList.add(theBinContent.GFERP__Unit_of_Measure__c);	
            
        }
        
        List<GFERP__Bin_Content__c> theAllBinContent = [SELECT Id, OMS_Available__c, GFERP__Unit_of_Measure__c FROM GFERP__Bin_Content__c WHERE GFERP__Unit_of_Measure__c IN : theItemUOMIdList AND OMS_Available__c > 0];
        Map<Id, GFERP__Item_Unit_of_Measure__c> theItemUOMMap = new Map<Id, GFERP__Item_Unit_of_Measure__c>([SELECT Id, Uploaded_Available_Inventory__c FROM GFERP__Item_Unit_of_Measure__c WHERE Id IN : theItemUOMIdList]);
        
        for(GFERP__Bin_Content__c theBinContent : theAllBinContent) {
            
            if(!theItemUOMId_BinContentListMap.containsKey(theBinContent.GFERP__Unit_of_Measure__c)) {
                theItemUOMId_BinContentListMap.put(theBinContent.GFERP__Unit_of_Measure__c, new List<GFERP__Bin_Content__c>{theBinContent});
            } else {
                theItemUOMId_BinContentListMap.get(theBinContent.GFERP__Unit_of_Measure__c).add(theBinContent);
            }
            
        }
        
        for(GFERP__Bin_Content__c theNewBinContent : theBinContentList) {
            
            if(!theUpdateItemUOMMap.containsKey(theNewBinContent.GFERP__Unit_of_Measure__c)) {
                List<GFERP__Bin_Content__c> theRelatedBinContentList = theItemUOMId_BinContentListMap.get(theNewBinContent.GFERP__Unit_of_Measure__c);
                Decimal theTotalOMSAvailable = 0;

                if (theRelatedBinContentList != null) {
                    for (GFERP__Bin_Content__c theBinContent : theRelatedBinContentList) {

                        theTotalOMSAvailable = theTotalOMSAvailable + theBinContent.OMS_Available__c;
                        
                    }
                }
                
                //update Item UOM only if Uploaded_Available_Inventory__c is changed 
                if(theItemUOMMap.get(theNewBinContent.GFERP__Unit_of_Measure__c).Uploaded_Available_Inventory__c != theTotalOMSAvailable) {
                    GFERP__Item_Unit_of_Measure__c theItemUOM = theItemUOMMap.get(theNewBinContent.GFERP__Unit_of_Measure__c);
                    theItemUOM.Uploaded_Available_Inventory__c = theTotalOMSAvailable;
                    theItemUOM.Uploaded_to_CC_Inventory__c = false;
                    theItemUOM.Uploaded_to_CC_Inventory_Date_Time__c = null;
                    theUpdateItemUOMMap.put(theNewBinContent.GFERP__Unit_of_Measure__c, theItemUOM);
                }
            }
            
        }
        if(!theUpdateItemUOMMap.values().isEmpty()) update theUpdateItemUOMMap.values();
    }
    
}