@isTest
public class GFINT_ComCloudHourlySchedulableBatchTest {
    
    @testSetup
    public static void setup() {
        
        XMLUploadToCommerce__c testCommerceCloud = new XMLUploadToCommerce__c();
        testCommerceCloud.Name = 'XMLUploadAPI';
        testCommerceCloud.Username__c = 'ashish.aggarwal@goldfinchcloudsolutions.com';
        testCommerceCloud.Password__c = 'Abs@1234';
        testCommerceCloud.EndPoint__c = 'https://bgkv-001.sandbox.us01.dx.commercecloud.salesforce.com/on/demandware.servlet/webdav/Sites/impex/src/uploads/fromGoldFinch/';
        insert testCommerceCloud;
        
        GFERP__Unit_of_Measure__c UnitMeasureRecord1 = new GFERP__Unit_of_Measure__c( Name = 'CS', GFERP__Type__c = 'Piece' );
        insert UnitMeasureRecord1;
        
        GFERP__Unit_of_Measure__c UnitMeasureRecord2 = new GFERP__Unit_of_Measure__c( Name = 'EA', GFERP__Type__c = 'Piece' );
        insert UnitMeasureRecord2;
        
        List<GFERP__Item__c> theItemList = new List<GFERP__Item__c>();
        
        Category__c testCategory = new Category__c();
        testCategory.Display_Name__c = 'Grains';
        insert testCategory;
        
        Subcategory__c testSubCategory = new Subcategory__c();
        testSubCategory.Display_Name__c = 'SUB Grains';
        testSubCategory.Parent__c = testCategory.Id;
        insert testSubCategory;
        
        GFERP__Item_Category__c ItemCategoryRecord = new GFERP__Item_Category__c ();
        testSubCategory.Display_Name__c = 'Fine Grains';
        //ItemCategoryRecord.Category__c = testCategory.Id;
        ItemCategoryRecord.Parent__c = testSubCategory.Id;
        ItemCategoryRecord.Name = 'Fine Grains';
        insert ItemCategoryRecord;
        
        for(Integer i = 0; i<100; i++) {
            
            GFERP__Item__c ItemRecord = new GFERP__Item__c(
                Name = '700'+i,
                GFERP__Item_Category__c = ItemCategoryRecord.Id,
                GFERP__Description__c = 'Chocolate Cake'+i,
                GFERP__Base_Unit_of_Measure__c = UnitMeasureRecord1.Id,
                GFERP__Work_Center__c = false,
                GFERP__Blocked__c = false,
                Starting_Date__c = System.today(),
                Net_Weight__c = '10',
                Capacity__c = '1',
                Tags__c = 'Test Tag',
                Ending_Date__c = System.today().addDays(10),
                GFERP__Replenishment_System__c = 'Work Order',
                GFERP__Costing_Method__c = 'Standard',
                GFERP__Inventory_Class__c = 'Finished Goods',
                GFERP__Standard_Base_Cost__c = 1,
                GFERP__Standard_Material_Base_Cost__c = 1,
                GFERP__Standard_Base_Price__c = 10,
                GFERP__Item_Type__c = 'Inventory',
                GFERP__Long_Description__c = '<image src="https://autodesk.i.lithium.com/t5/image/serverpage/image-id/516281i74784B88B7BE4B86/image-size/large?v=1.0&px=999"/>',
                GFERP__UPC__c = '888444555444'
            );
            theItemList.add(ItemRecord);
        }
        insert theItemList;  
        
        List<GFERP__Item_Unit_of_Measure__c> testItemUnitMeasureList = new List<GFERP__Item_Unit_of_Measure__c>();
        for(GFERP__Item__c ItemRecord : theItemList) {
            
            GFERP__Item_Unit_of_Measure__c  ItemUnitMeasureRecord = new GFERP__Item_Unit_of_Measure__c(
                Name = 'CS',
                GFERP__Conversion__c = 1,
                GFERP__Item__c = ItemRecord.Id,
                GFERP__Unit_of_Measure__c = UnitMeasureRecord1.Id,
                GFERP__Do_Not_Sell__c = false
            );
            testItemUnitMeasureList.add(ItemUnitMeasureRecord);
            
            GFERP__Item_Unit_of_Measure__c  ItemUnitMeasureRecord1 = new GFERP__Item_Unit_of_Measure__c(
                Name = 'EA',
                GFERP__Conversion__c = 1,
                GFERP__Item__c = ItemRecord.Id,
                GFERP__Unit_of_Measure__c = UnitMeasureRecord2.Id,
                GFERP__Do_Not_Sell__c = false
            );
            testItemUnitMeasureList.add(ItemUnitMeasureRecord1);
            
        }
        insert testItemUnitMeasureList;
       
    }
    
    @isTest
    public Static void nightlyBatchTest() {
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        GFINT_ComCloudNightlySchedulableBatch testApex = new GFINT_ComCloudNightlySchedulableBatch();
        Database.executeBatch(testApex, 200);
        test.stopTest(); 
        
        //Assertion
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = [SELECT Id, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c];
        for (GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            System.assertEquals(true, testItemUOM.Uploaded_to_CC_Item__c);
        }
        
    }
    
    @isTest
    public Static void InventorySchedulableBatchTest() {
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        GFINT_ComCloudHourlySchedulableBatch testApex = new GFINT_ComCloudHourlySchedulableBatch();
        testApex.execute(null);
        //GFINT_ComCloudHourlySchedulableBatch.runHourlyBatch();
        test.stopTest(); 
        
        //Assertion
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = [SELECT Id, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c];
        for (GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            System.assertEquals(true, testItemUOM.Uploaded_to_CC_Item__c);
        }
    }
    
    @isTest
    public Static void nightlySchedulableBatchTest() {
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        GFINT_ComCloudNightlySchedulableBatch testApex = new GFINT_ComCloudNightlySchedulableBatch();
        testApex.execute(null);
        //GFINT_ComCloudNightlySchedulableBatch.runHourlyBatch();
        test.stopTest(); 
        
        //Assertion
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = [SELECT Id, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c];
        for (GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            System.assertEquals(true, testItemUOM.Uploaded_to_CC_Item__c);
        }
    }
    
    @isTest
    public Static void sendXMLToSFCCControllerTest() {
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        
        List<GFERP__Item__c> testItemUOMList = [SELECT Id FROM GFERP__Item__c limit 20];
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(testItemUOMList);
        stdSetController.setSelected(testItemUOMList);
        GFINT_ForceSendXMLToSFCCController testApex = new GFINT_ForceSendXMLToSFCCController(stdSetController);
        testApex.returnBack();
        testApex.callNightlyBatch();
        test.stopTest(); 
     
    }
    
    @isTest
    public Static void createSalesPriceXMLTest() {
        
        String theQuery = 'SELECT Id, Name, GFERP__Item__c, GFERP__Item__r.Name, Uploaded_to_CC_Sales_Price__c';
        theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND (Uploaded_to_CC_Item__c != true OR Uploaded_to_CC_Sales_Price__c != true OR Uploaded_to_CC_Inventory__c != true)';
        
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> testItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Item_Unit_of_Measure__c> testUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        testItemUOMList = DataBase.query(theQuery);
        
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            
            testItemUOM.Uploaded_Sales_Price__c = 100;
            testItemUOM.Uploaded_Online_Form_Date__c = System.today().addDays(-1);
            testItemUOM.Uploaded_Online_To_Date__c = System.today().addDays(+7);
            testUpdateItemUOMList.add(testItemUOM);
            
        }
        if(!testUpdateItemUOMList.isEmpty()) update testUpdateItemUOMList;
        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            if(!testItemId_ItemUOMListMap.Containskey(testItemUOM.GFERP__Item__c))
                testItemId_ItemUOMListMap.put(testItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ testItemUOM });
            else {
                testItemId_ItemUOMListMap.get(testItemUOM.GFERP__Item__c).add(testItemUOM);
            }
        }
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        System.enqueueJob(new GFINT_CreateSalesPriceXML(testItemId_ItemUOMListMap, testItemUOMList));
        test.stopTest(); 
        
    }
    
    @isTest
    public Static void CreateInventoryXMLTest() {
        
        String theQuery = 'SELECT Id, Name, GFERP__Item__c, GFERP__Item__r.Name, Uploaded_Available_Inventory__c, Uploaded_to_CC_Inventory__c, GFERP__Item__r.IsGiftVoucher__c';
        theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND (Uploaded_to_CC_Item__c != true OR Uploaded_to_CC_Sales_Price__c != true OR Uploaded_to_CC_Inventory__c != true)';
        
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> testItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Item_Unit_of_Measure__c> testUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        testItemUOMList = DataBase.query(theQuery);
        
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            
            testItemUOM.Uploaded_Available_Inventory__c = 100;
            testUpdateItemUOMList.add(testItemUOM);
            
        }
        if(!testUpdateItemUOMList.isEmpty()) update testUpdateItemUOMList;
        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            if(!testItemId_ItemUOMListMap.Containskey(testItemUOM.GFERP__Item__c))
                testItemId_ItemUOMListMap.put(testItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ testItemUOM });
            else {
                testItemId_ItemUOMListMap.get(testItemUOM.GFERP__Item__c).add(testItemUOM);
            }
        }
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        System.enqueueJob(new GFINT_CreateInventoryXML(testItemId_ItemUOMListMap, testItemUOMList));
        test.stopTest(); 
        
    }
    
    @isTest
    public Static void createListPriceXMLTest() { 
    
        String theQuery = 'SELECT Id, Name, GFERP__Item__c, GFERP__Item__r.Name, Standard_Base_Price__c, Uploaded_to_CC_Item__c';
        theQuery = theQuery + ' FROM GFERP__Item_Unit_of_Measure__c WHERE GFERP__Do_Not_Sell__c != true AND (Uploaded_to_CC_Item__c != true OR Uploaded_to_CC_Sales_Price__c != true OR Uploaded_to_CC_Inventory__c != true)';
        
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> testItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Item_Unit_of_Measure__c> testUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        testItemUOMList = DataBase.query(theQuery);
        
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            
            testItemUOM.Standard_Base_Price__c = 100;
            testUpdateItemUOMList.add(testItemUOM);
            
        }
        if(!testUpdateItemUOMList.isEmpty()) update testUpdateItemUOMList;
        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            if(!testItemId_ItemUOMListMap.Containskey(testItemUOM.GFERP__Item__c))
                testItemId_ItemUOMListMap.put(testItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ testItemUOM });
            else {
                testItemId_ItemUOMListMap.get(testItemUOM.GFERP__Item__c).add(testItemUOM);
            }
        }
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        System.enqueueJob(new GFINT_CreateListPriceXML(testItemId_ItemUOMListMap, testItemUOMList));
        test.stopTest(); 
        
    }
    
    @isTest
    public Static void CreateStorefrontCatalogXMLTest() {
       
        
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
        
        Map<Id , List<GFERP__Item_Unit_of_Measure__c>> testItemId_ItemUOMListMap = new Map<Id , List<GFERP__Item_Unit_of_Measure__c>>();
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Item_Unit_of_Measure__c> testUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        testItemUOMList = DataBase.query(theQuery);
        
        //Map of ItemId and List of Item UOM
        for(GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            if(!testItemId_ItemUOMListMap.Containskey(testItemUOM.GFERP__Item__c))
                testItemId_ItemUOMListMap.put(testItemUOM.GFERP__Item__c , new List<GFERP__Item_Unit_of_Measure__c>{ testItemUOM });
            else {
                testItemId_ItemUOMListMap.get(testItemUOM.GFERP__Item__c).add(testItemUOM);
            }
        }
        
        Test.setMock(HttpCalloutMock.class, new FTPAPIUploadMockHttp());
        test.startTest();
        System.enqueueJob(new GFINT_CreateStorefrontCatalogXML(testItemId_ItemUOMListMap, testItemUOMList));
        test.stopTest(); 
        
    }
    
    public class FTPAPIUploadMockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    } 
}