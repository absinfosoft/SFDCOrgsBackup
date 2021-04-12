//GFINT_ComCloudHourlySchedulableBatchTest
public class GFINT_ComCloudNightlySchedulableBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    Set<Id> theSelectedIdsOfIUOM = new Set<Id>();
    String theBaseQuery = 'SELECT Id, Name FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true';
    String theFinalQuery ;
    Boolean IsForOnlySelectedIUOM = false;
    
    public GFINT_ComCloudNightlySchedulableBatch() {
        theFinalQuery = theBaseQuery;
    }
    
    public GFINT_ComCloudNightlySchedulableBatch(List<GFERP__Item_Unit_of_Measure__c> theSelectedIUOMList) {
        theSelectedIdsOfIUOM = (new Map<Id,GFERP__Item_Unit_of_Measure__c>(theSelectedIUOMList)).keySet();
        theFinalQuery = theBaseQuery;
        theFinalQuery += ' AND Id IN :theSelectedIdsOfIUOM';
        IsForOnlySelectedIUOM = true;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator(theFinalQuery);
        
    }
    
    public void execute(Database.BatchableContext BC, List<GFERP__Item_Unit_of_Measure__c> theItemUOMList) {
        GFERP.CompanyMgmt.systemCall = true;
        List<GFERP__Item_Unit_of_Measure__c> theUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Bin_Content__c> theUpdateBCList = new List<GFERP__Bin_Content__c>();
        List<GFERP__Sales_Price_Entry__c> theUpdateSPEList = new List<GFERP__Sales_Price_Entry__c>();
     
        List<GFERP__Bin_Content__c> theBinContentList = [SELECT Id FROM GFERP__Bin_Content__c WHERE GFERP__Unit_of_Measure__c IN: theItemUOMList AND OMS_Available__c > 0];
        List<GFERP__Sales_Price_Entry__c> theSPEList = [SELECT Id FROM GFERP__Sales_Price_Entry__c WHERE GFERP__Unit_of_Measure__c IN: theItemUOMList AND GFERP__Active__c = true];
        
        //Update Item UOM
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            theItemUOM.Uploaded_to_CC_Item__c = false;
            theItemUOM.Uploaded_to_CC_Sales_Price__c = false;
            theItemUOM.Uploaded_to_CC_Inventory__c = false;
            theItemUOM.Uploaded_Available_Inventory__c = 0;
            theItemUOM.Uploaded_Online_Form_Date__c = null;
            theItemUOM.Uploaded_Online_To_Date__c = null;
            theItemUOM.Uploaded_Sales_Price__c = 0;
            theUpdateItemUOMList.add(theItemUOM);
            
        }
        
        //Update Sales Price Entry
        for(GFERP__Sales_Price_Entry__c theSPE : theSPEList) {
            //theSPE.Refresh_Date_Time__c = System.now();
            theUpdateSPEList.add(theSPE);
            
        }
        
        //Update Bin Content
        for(GFERP__Bin_Content__c theBC : theBinContentList) {
            //theBC.Refresh_Date_Time__c = System.now();
            theUpdateBCList.add(theBC);
            
        }
        
        //DMLs
        if(!theUpdateItemUOMList.isEmpty()) update theUpdateItemUOMList;
        if(!theUpdateSPEList.isEmpty()) update theUpdateSPEList;
        if(!theUpdateBCList.isEmpty()) update theUpdateBCList;
        
    }
    
    public void finish(Database.BatchableContext BC) {
        GFINT_UploadImageInCC theBatch = new GFINT_UploadImageInCC(theSelectedIdsOfIUOM, IsForOnlySelectedIUOM);
        Database.executeBatch(theBatch, 200);
        
    }
    
     public void execute(SchedulableContext sc) {
        GFINT_ComCloudHourlySchedulableBatch theBatch = new GFINT_ComCloudHourlySchedulableBatch();
        Database.executeBatch(theBatch, 200);
    }
}