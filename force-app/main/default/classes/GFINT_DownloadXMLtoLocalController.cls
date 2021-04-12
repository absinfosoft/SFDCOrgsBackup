//GFINT_DownloadXMLtoLocalConTest
public class GFINT_DownloadXMLtoLocalController {
    
    public List<GFERP__Item_Unit_of_Measure__c> theAllItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
    public Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
    
    private ApexPages.StandardSetController standardSetController;
    public Integer theItemCount { get; set; }
    public String itemSelectedIds { get; set; }
    
    public GFINT_DownloadXMLtoLocalController (Set<String> theSelectedItemIdList) {
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
        //theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND (Uploaded_to_CC_Item__c != true OR Uploaded_to_CC_Sales_Price__c != true OR Uploaded_to_CC_Inventory__c != true) AND GFERP__Item__c IN :theSelectedItemIdList';
        //Force to download all Item Units of Measure
        theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND GFERP__Item__c IN :theSelectedItemIdList';
        List<GFERP__Item_Unit_of_Measure__c> theItemUOMList = Database.Query(theQuery);
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap2 = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();

        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            if(!theItemId_ItemUOMListMap2.Containskey(theItemUOM.GFERP__Item__c))
                theItemId_ItemUOMListMap2.put(theItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ theItemUOM });
            else {
                theItemId_ItemUOMListMap2.get(theItemUOM.GFERP__Item__c).add(theItemUOM);
            }
        }
        
        theAllItemUOMList = theItemUOMList;
        theItemId_ItemUOMListMap = theItemId_ItemUOMListMap2;
    }
    
    public GFINT_DownloadXMLtoLocalController(ApexPages.StandardSetController controller) {
        theItemCount = 0;
        standardSetController = controller;
        List<String> itemSelectedIdList = new List<String>();
        for (GFERP__Item__c theItem : (GFERP__Item__c[]) standardSetController.getSelected()) {
            itemSelectedIdList.add(theItem.Id);
            theItemCount += 1;
        }
        itemSelectedIds = JSON.serialize(itemSelectedIdList);
    }
    
    public PageReference returnBack() {
        return new ApexPages.Action('{!List}').invoke();
    }
    
    @RemoteAction
    public static Map<String, String> createXMLFiles(string theItemIdsStr) {
        
        Set<String> theItemIdSet = (Set<String>)JSON.deserialize(theItemIdsStr, Set<String>.class);
        Map<String, String> theXMLZipData = new Map<String, String>();
        List<String> theXMLList1 = new List<String>();
        Map<String, String> theNewMap = new Map<String, String>();
        List<String> theXMLFileName1 = new List<String>();
        GFINT_DownloadXMLtoLocalController theApexController = new GFINT_DownloadXMLtoLocalController(theItemIdSet);
        String theProductXMLfile = theApexController.createProductXML();
        String theInventoryXMLfile = theApexController.createInventoryXML();
        String theListPriceXMLfile = theApexController.createListPriceXML();
        String theSalesPriceXMLfile = theApexController.createSalesPriceXML(); 
        String theStoreFrontCatalogFile = theApexController.createCatalogXML();
        theNewMap.put('master_catalog.xml', theProductXMLfile);
        theNewMap.put('drops_inventory.xml', theInventoryXMLfile);
        theNewMap.put('kwd-m-list-prices.xml', theListPriceXMLfile);
        theNewMap.put('kwd-m-sale-prices.xml', theSalesPriceXMLfile);
        theNewMap.put('drops_storefront_catalog',theStoreFrontCatalogFile);
        return theNewMap;
    }
    
    public String createProductXML() {
        //get Master Catalog XML 
        String theProductDataFile = GFINT_AllXMLs.createMasterCatalogXML(theAllItemUOMList, theItemId_ItemUOMListMap);
        return theProductDataFile;
    }
    
    public String createInventoryXML() {
        //get Inventory XML
        String theInventoryDataFile = GFINT_AllXMLs.createInventoryXML(theAllItemUOMList, theItemId_ItemUOMListMap);
        return theInventoryDataFile;
    }
    
    public String createListPriceXML() {
        //get List Price XML
        String theListPriceDataFile = GFINT_AllXMLs.createListPriceXML(theAllItemUOMList, theItemId_ItemUOMListMap);
        return theListPriceDataFile;    
    }
    
    public String createSalesPriceXML() {
        //get Sales Price XML
        String theSalesPriceDataFile = GFINT_AllXMLs.createSalesPriceXML(theAllItemUOMList, theItemId_ItemUOMListMap);
        return theSalesPriceDataFile;
    }
    
    public String createCatalogXML() {
        //get Catalog XML
        String theCatalogProductDataFile = GFINT_AllXMLs.createStorefrontCatalogXML(theAllItemUOMList, theItemId_ItemUOMListMap);
        return theCatalogProductDataFile;
    }
}