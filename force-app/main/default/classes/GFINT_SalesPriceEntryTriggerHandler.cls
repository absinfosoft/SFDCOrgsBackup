//Test Class: GFINT_SalesPriceEntryTriggerHandlerTest
public class GFINT_SalesPriceEntryTriggerHandler {
    
    public static void updateItemUnitOfMeasure(List<GFERP__Sales_Price_Entry__c> theSPEList) {
        
        List<Id> theItemUOMIdList = new List<Id>();
        Map<Id, GFERP__Item_Unit_of_Measure__c> theUpdateItemUOMMap = new Map<Id, GFERP__Item_Unit_of_Measure__c>();
        Map<Id, GFERP__Sales_Price_Entry__c> theItemUOMId_SPEMap = new Map<Id, GFERP__Sales_Price_Entry__c>();
        
        for(GFERP__Sales_Price_Entry__c theSPE : theSPEList) {
            
            if(theSPE.GFERP__Active__c == true && theSPE.GFERP__Currency__c == 'KWD' && theSPE.GFERP__Ending_Date__c > System.today() && theSPE.GFERP__Starting_Date__c < System.today()) {
                theItemUOMIdList.add(theSPE.GFERP__Unit_of_Measure__c);
            }
            
        }
        
        List<GFERP__Sales_Price_Entry__c> theAllSPEList = [SELECT Id, GFERP__Sales_Price__c, GFERP__Unit_of_Measure__c , GFERP__Starting_Date__c, GFERP__Ending_Date__c FROM GFERP__Sales_Price_Entry__c 
                                                           WHERE GFERP__Unit_of_Measure__c IN : theItemUOMIdList AND GFERP__Currency__c =: 'KWD' AND GFERP__Active__c = true AND GFERP__Ending_Date__c > TODAY 
                                                           AND GFERP__Starting_Date__c < TODAY];
        
        //create Map of Item UOM with Lowest GFERP__Sales_Price__c SPE
        for(GFERP__Sales_Price_Entry__c theSPE : theAllSPEList) {
            
            if(theItemUOMId_SPEMap.containskey(theSPE.GFERP__Unit_of_Measure__c)) {
                if(theItemUOMId_SPEMap.get(theSPE.GFERP__Unit_of_Measure__c).GFERP__Sales_Price__c > theSPE.GFERP__Sales_Price__c) {
                    theItemUOMId_SPEMap.put(theSPE.GFERP__Unit_of_Measure__c, theSPE);
                }
            }
            else {
                theItemUOMId_SPEMap.put(theSPE.GFERP__Unit_of_Measure__c, theSPE);
            }
            
        }
        
        Map<Id, GFERP__Item_Unit_of_Measure__c> theItemUOMMap = new Map<Id, GFERP__Item_Unit_of_Measure__c>([SELECT Id, Uploaded_Sales_Price__c FROM GFERP__Item_Unit_of_Measure__c WHERE Id IN : theItemUOMIdList]);
        
        for(GFERP__Sales_Price_Entry__c theSPE : theItemUOMId_SPEMap.values()) {
            
            //update Item UOM only if Uploaded_Sales_Price__c is changed 
            if(theItemUOMMap.get(theSPE.GFERP__Unit_of_Measure__c).Uploaded_Sales_Price__c != theSPE.GFERP__Sales_Price__c) {
                GFERP__Item_Unit_of_Measure__c theItemUOM = theItemUOMMap.get(theSPE.GFERP__Unit_of_Measure__c);
                theItemUOM.Uploaded_Sales_Price__c = theSPE.GFERP__Sales_Price__c;
                theItemUOM.Uploaded_Online_Form_Date__c = theSPE.GFERP__Starting_Date__c;
                theItemUOM.Uploaded_Online_To_Date__c = theSPE.GFERP__Ending_Date__c;
                theItemUOM.Uploaded_to_CC_Sales_Price__c = false;
                theItemUOM.Uploaded_to_CC_Sales_Price_Date_Time__c = null;
                theUpdateItemUOMMap.put(theSPE.GFERP__Unit_of_Measure__c, theItemUOM);
            }
            
        }
        
        if(!theUpdateItemUOMMap.values().isEmpty()) update theUpdateItemUOMMap.values();
    }
}