//Test Class: GFINT_ItemTriggerHandlerTest
public class GFINT_ItemTriggerHandler {
    
    public static void uncheckedItemUnitOfMeasure(List<GFERP__Item__c> theItemList) {
        
        List<GFERP__Item_Unit_of_Measure__c> theUpdateItemIUMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = [SELECT Id, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Item__c IN : theItemList];
        
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            if(theItemUOM.Uploaded_to_CC_Item__c) {
                theItemUOM.Uploaded_to_CC_Item__c = false;
                theItemUOM.Uploaded_to_CC_Item_Date_Time__c = null;
                theUpdateItemIUMList.add(theItemUOM);
            }
        }
        
        if(!theUpdateItemIUMList.isEmpty()) update theUpdateItemIUMList;
    }
    
}