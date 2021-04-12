@isTest
public class GFINT_DownloadXMLtoLocalConTest {
    
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
    public Static void downloadableXMLtoLocalControllerTest() {
        
        List<GFERP__Item__c> testItemUOMList = [SELECT Id FROM GFERP__Item__c limit 20];
        
        Set<Id> testItemIdSet = new Set<Id>();
        
        for(GFERP__Item__c testItem : testItemUOMList) {
            testItemIdSet.add(testItem.Id);
        }
        
        test.startTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(testItemUOMList);
        stdSetController.setSelected(testItemUOMList);
        GFINT_DownloadXMLtoLocalController testApex = new GFINT_DownloadXMLtoLocalController(stdSetController);
        testApex.returnBack();
        GFINT_DownloadXMLtoLocalController.createXMLFiles(JSON.serialize(testItemIdSet));
        test.stopTest(); 
        
    }
}