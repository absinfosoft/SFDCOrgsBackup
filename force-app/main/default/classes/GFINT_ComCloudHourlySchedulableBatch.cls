//GFINT_ComCloudHourlySchedulableBatchTest
public class GFINT_ComCloudHourlySchedulableBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    
    Set<Id> theSelectedIUOM = new Set<Id>();
    Boolean IsForSelectedIUOM = false;
    
    public GFINT_ComCloudHourlySchedulableBatch() {
        
    }
    
    public GFINT_ComCloudHourlySchedulableBatch(Set<Id> theSelectedIdsOfIUOM, Boolean IsForOnlySelectedIUOM) {
        theSelectedIUOM = theSelectedIdsOfIUOM;
        IsForSelectedIUOM = IsForOnlySelectedIUOM;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String theQuery = 'SELECT Id, Name,  GFERP__Item__c, GFERP__Conversion__c, Product_Type__c, Uploaded_Available_Inventory__c, GFERP__Item__r.GFERP__UPC__c, GFERP__Item__r.Display_Name_English__c, GFERP__Item__r.GFERP__Base_Unit_of_Measure__r.Name';
        theQuery = theQuery + ', GFERP__Item__r.Visible__c, Standard_Base_Price__c, GFERP__Item__r.GFERP__Description__c, GFERP__Item__r.Display_Name_Arabic__c, GFERP__Item__r.Ending_Date__c, GFERP__Item__r.Starting_Date__c, GFERP__Item__r.Long_Description__c, Uploaded_Sales_Price__c, Uploaded_Online_Form_Date__c, Uploaded_Online_To_Date__c';
        theQuery = theQuery + ', GFERP__Item__r.Category__c, GFERP__Item__r.Subcategory__c, GFERP__Item__r.GFERP__Item_Category__c, Uploaded_to_CC_Item__c, Uploaded_to_CC_Sales_Price__c, Uploaded_to_CC_Inventory__c';
        theQuery = theQuery + ', GFERP__Item__r.adsBanners__c,  GFERP__Item__r.Name,  GFERP__Item__r.Offers__c';
        theQuery = theQuery + ', (SELECT Id, Variation_Value__c, Path__c, Title__c, Item__c, Item_Unit_of_Measure__c, View_Type__c, Image__c FROM SFCC_Images__r)';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Name,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Name,  GFERP__Item__r.GFERP__Item_Category__r.Name';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Online__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Online__c,  GFERP__Item__r.GFERP__Item_Category__r.Online__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Position__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Position__c,  GFERP__Item__r.GFERP__Item_Category__r.Position__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Rendering_Template__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Rendering_Template__c,  GFERP__Item__r.GFERP__Item_Category__r.Rendering_Template__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Title__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Title__c,  GFERP__Item__r.GFERP__Item_Category__r.Page_Title__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Short_Description__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Short_Description__c,  GFERP__Item__r.GFERP__Item_Category__r.GFERP__Description__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Description__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Description__c,  GFERP__Item__r.GFERP__Item_Category__r.Page_Description__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Image__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Image__c,  GFERP__Item__r.GFERP__Item_Category__r.Image__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Show_in_Menu__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Show_in_Menu__c,  GFERP__Item__r.GFERP__Item_Category__r.Show_in_Menu__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Keywords__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Keywords__c,  GFERP__Item__r.GFERP__Item_Category__r.Page_Keywords__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Thumbnail__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Thumbnail__c,  GFERP__Item__r.GFERP__Item_Category__r.Thumbnail__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Display_Name_Arabic__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Display_Name_Arabic__c,  GFERP__Item__r.GFERP__Item_Category__r.Display_Name_Arabic__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Category_Id__c,  GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Subcategory_Id__c,  GFERP__Item__r.GFERP__Item_Category__r.Fine_line_Id__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Country_of_Origin2__c, GFERP__Item__r.Searchable__c, GFERP__Item__r.GFERP__Brand__c, GFERP__Item__r.Manufacturer_SKU__c, GFERP__Item__r.Manufacturer_Name__c, GFERP__Item__r.Tax_Class_ID__c, GFERP__Item__r.GFERP__Item_Type__c';
        theQuery = theQuery + ', GFERP__Item__r.GFERP__Replenishment_System__c, GFERP__Item__r.GFERP__Inventory_Class__c, GFERP__Item__r.GFERP__Vendor__r.Name, GFERP__Item__r.GFERP__Vendor__c, GFERP__Item__r.Net_Weight__c, GFERP__Item__r.Capacity__c';
        theQuery = theQuery + ', GFERP__Item__r.Tags__c, GFERP__Item__r.GFERP__Base_Unit_of_Measure__c, GFERP__Item__r.isNew__c, GFERP__Item__r.GFERP__Lot_Tracked__c, GFERP__Item__r.Disabled_Shipping_Method__c';
        theQuery = theQuery + ', GFERP__Item__r.IsGiftVoucher__c';
        theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND (Uploaded_to_CC_Item__c != true OR Uploaded_to_CC_Sales_Price__c != true OR Uploaded_to_CC_Inventory__c != true)';
        if(IsForSelectedIUOM){
            theQuery = theQuery + ' AND Id IN :theSelectedIUOM';
        } 
        return Database.getQueryLocator(theQuery);
        
    }
    
    public void execute(Database.BatchableContext BC, List<GFERP__Item_Unit_of_Measure__c> theItemUOMList) {
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
        List<GFERP__Item_Unit_of_Measure__c> theUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            if(!theItemId_ItemUOMListMap.Containskey(theItemUOM.GFERP__Item__c))
                theItemId_ItemUOMListMap.put(theItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ theItemUOM });
            else {
                theItemId_ItemUOMListMap.get(theItemUOM.GFERP__Item__c).add(theItemUOM);
            }
        }
        
        //Create Product XML
        System.enqueueJob(new GFINT_CreateMasterCatalogXML(theItemId_ItemUOMListMap, theItemUOMList));
        
        //Update Item UOM
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            Boolean theUpdate = false;
            if(!theItemUOM.Uploaded_to_CC_Item__c) { 
                theItemUOM.Uploaded_to_CC_Item__c = true;
                theItemUOM.Uploaded_to_CC_Item_Date_Time__c = System.now();
                theUpdate = true;
            }
            if(!theItemUOM.Uploaded_to_CC_Sales_Price__c) {
                theItemUOM.Uploaded_to_CC_Sales_Price__c = true;
                theItemUOM.Uploaded_to_CC_Sales_Price_Date_Time__c = System.now();
                theUpdate = true;
            }
            if(!theItemUOM.Uploaded_to_CC_Inventory__c) {
                theItemUOM.Uploaded_to_CC_Inventory__c = true;
                theItemUOM.Uploaded_to_CC_Inventory_Date_Time__c = System.now();
                theUpdate = true;
            }
            if(theUpdate) theUpdateItemUOMList.add(theItemUOM);
            
        }
        
        //DML on Item UOM
        if(!theUpdateItemUOMList.isEmpty()) update theUpdateItemUOMList;
        
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    public void execute(SchedulableContext sc) {
        GFINT_UploadImageInCC theBatch = new GFINT_UploadImageInCC();
        Database.executeBatch(theBatch, 200);
    }
}