//Test Class: GFINT_SalesPriceEntryTriggerHandlerTest
public class GFINT_SalesPriceTriggerHandler {
    
    public static void updateSalesPriceEntries(List<GFERP__Sales_Price__c> theSPList, Map<Id, GFERP__Sales_Price__c> theSPOldMap) {
        
        List<GFERP__Sales_Price__c> theAllAccountsSPList = new List<GFERP__Sales_Price__c>();
        List<GFERP__Sales_Price_Entry__c> theUpdateSPEList = new List<GFERP__Sales_Price_Entry__c>();
        
        for(GFERP__Sales_Price__c theSP : theSPList) {
            
            //if(theSP.GFERP__Pricing_Type__c != theSPOldMap.get(theSP.Id).GFERP__Pricing_Type__c  && theSP.GFERP__Pricing_Type__c == 'All Accounts') {
            //    theAllAccountsSPList.add(theSP);
            //}
            
        }
        
        List<GFERP__Sales_Price_Entry__c> theSPEList = [SELECT Id FROM GFERP__Sales_Price_Entry__c WHERE GFERP__Price_Book__c IN : theAllAccountsSPList];
        
        for(GFERP__Sales_Price_Entry__c theSPE : theSPEList) {
            
            theUpdateSPEList.add(theSPE);
            
        }
        
        if(!theUpdateSPEList.isEmpty()) update theUpdateSPEList;
        
    }
    
}