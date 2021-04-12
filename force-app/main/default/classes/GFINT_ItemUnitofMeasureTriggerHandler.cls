//Test Class: GFINT_ItemUnitofMeasureTriHandlerTest
public class GFINT_ItemUnitofMeasureTriggerHandler {
    
    public static void uncheckUploadedComCloudFieldOnIUOM(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList , Map<Id,GFERP__Item_Unit_of_Measure__c> theItemUOMOldMap) {
        
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            if(theItemUOMOldMap.get(theItemUOM.Id).Uploaded_to_CC_Item__c && theItemUOMOldMap.get(theItemUOM.Id).Uploaded_to_CC_Item_Date_Time__c != null) {
                theItemUOM.Uploaded_to_CC_Item__c = false;
                theItemUOM.Uploaded_to_CC_Item_Date_Time__c = null;
            }
            
        }
        
    }
    
    public static void updateProductTypeForInsertUpdateUndelete(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList) {
        
        helperMethodToUpdateProductType(theItemUOMList, false);
        
    }
    
    public static void updateProductTypeForDelete(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList) {
        
        helperMethodToUpdateProductType(theItemUOMList, True);
        
    }
    
    public static void helperMethodToUpdateProductType(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Boolean IsDeleteTrigger) {
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMFutureUpdateList = new List<GFERP__Item_Unit_of_Measure__c>();
        Map<Id, List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id, List<GFERP__Item_Unit_of_Measure__c>>();
        Set<Id> theItemUOMIdSet = new Set<Id>();
        Set<Id> theItemIdSet = new Set<Id>();
        
        //create Map for new itemUOM
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            theItemUOMIdSet.add(theItemUOM.Id);
            theItemIdSet.add(theItemUOM.GFERP__Item__c);
            
        }
        
        String theQuery = 'SELECT Id, GFERP__Item__c, Product_Type__c, GFERP__Do_Not_Sell__c FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Item__c IN: theItemIdSet AND GFERP__Do_Not_Sell__c != True'; 
        if(IsDeleteTrigger) theQuery += '  AND Id NOT IN : theItemUOMIdSet';
        List<GFERP__Item_Unit_of_Measure__c> theAlreadyExistsItemUOMList = (List<GFERP__Item_Unit_of_Measure__c>) Database.query(theQuery);

        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAlreadyExistsItemUOMList) {
            
            if(!theItemId_ItemUOMListMap.containsKey(theItemUOM.GFERP__Item__c)) {
                theItemId_ItemUOMListMap.put(theItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{theItemUOM});
            }
            else {
                theItemId_ItemUOMListMap.get(theItemUOM.GFERP__Item__c).add(theItemUOM);
            }
        }
        
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theAlreadyExistsItemUOMList) {
            
            if(theItemId_ItemUOMListMap.Containskey(theItemUOM.GFERP__Item__c) && theItemId_ItemUOMListMap.get(theItemUOM.GFERP__Item__c).size() > 1) {
                
                if(theItemUOM.Product_Type__c != 'Variant') {
                    theItemUOM.Product_Type__c = 'Variant';
                    theItemUOMFutureUpdateList.add(theItemUOM);
                }
            }
            else if(theItemId_ItemUOMListMap.get(theItemUOM.GFERP__Item__c).size() == 1 && theItemUOM.Product_Type__c != 'Item') {
                theItemUOM.Product_Type__c = 'Item';
                theItemUOMFutureUpdateList.add(theItemUOM);
            }
        }
        
        if(!theItemUOMFutureUpdateList.isEmpty()) {
            if(System.isFuture() || System.isBatch()) {
                update theItemUOMFutureUpdateList;
            }else {
                updateVariantInsubItemUOMWithFuture(json.serialize(theItemUOMFutureUpdateList));
            }
        }
        
    }
    
    @future(Callout=true) 
    public static void updateVariantInsubItemUOMWithFuture(String jsonString) {
        
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList;
        if(!String.isEmpty(jsonString)) theItemUOMList = (List<GFERP__Item_Unit_of_Measure__c>)Json.deserialize(jsonString,List<GFERP__Item_Unit_of_Measure__c>.class);
        if(!theItemUOMList.isEmpty()) update theItemUOMList;
        
    }
    
    public static void updateProductTypeForDonotSell(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList) {
        
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            if(theItemUOM.GFERP__Do_Not_Sell__c) {
                theItemUOM.Product_Type__c = null;
            }
            
        }
        
    }
    
}