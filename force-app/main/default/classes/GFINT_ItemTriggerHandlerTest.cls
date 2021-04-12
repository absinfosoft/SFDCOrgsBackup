@isTest
public class GFINT_ItemTriggerHandlerTest {
    
    @testSetup
    public static void setup() {
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Unit_of_Measure__c> testUOMList = new List<GFERP__Unit_of_Measure__c>();
        
        GFERP__Unit_of_Measure__c UnitMeasureRecord = new GFERP__Unit_of_Measure__c(Name = 'EA',
                                                                                    GFERP__Type__c = 'Piece');
        
        testUOMList.add(UnitMeasureRecord);
        
        GFERP__Unit_of_Measure__c UnitMeasureRecord1 = new GFERP__Unit_of_Measure__c(Name = 'Pack',
                                                                                     GFERP__Type__c = 'Piece');
        testUOMList.add(UnitMeasureRecord1);
        
        insert testUOMList;
        
        GFERP__Item__c ItemRecord = new GFERP__Item__c(
            Name = '7002',
            GFERP__Description__c = 'Chocolate Cake',
            GFERP__Base_Unit_of_Measure__c = UnitMeasureRecord.Id,
            GFERP__Work_Center__c = false,
            GFERP__Blocked__c = false,
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
        insert ItemRecord;
        
        GFERP__Item_Unit_of_Measure__c ItemUnitMeasureRecord = new GFERP__Item_Unit_of_Measure__c(
            Name = 'EA',
            GFERP__Conversion__c = 1,
            GFERP__Item__c = ItemRecord.Id,
            GFERP__Unit_of_Measure__c = UnitMeasureRecord.Id,
            GFERP__Do_Not_Sell__c = false,
            Uploaded_to_CC_Item__c = true,
            Uploaded_to_CC_Item_Date_Time__c = System.now()
        );
        testItemUOMList.add(ItemUnitMeasureRecord);
        GFERP__Item_Unit_of_Measure__c ItemUnitMeasureRecord2 = new GFERP__Item_Unit_of_Measure__c(
            Name = 'Pack',
            GFERP__Conversion__c = 1,
            GFERP__Item__c = ItemRecord.Id,
            GFERP__Unit_of_Measure__c = UnitMeasureRecord1.Id,
            GFERP__Do_Not_Sell__c = false,
            Uploaded_to_CC_Item__c = true,
            Uploaded_to_CC_Item_Date_Time__c = System.now()
        );
        testItemUOMList.add(ItemUnitMeasureRecord2);
        insert testItemUOMList;    }
    
    @isTest
    public static void uncheckUploadedComCloudFieldTest() {
        
        List<GFERP__Item_Unit_of_Measure__c> testUpdateItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        GFERP__Item__c testItem = [SELECT Id, GFERP__Standard_Base_Price__c FROM GFERP__Item__c limit 1];
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = [SELECT Id, Uploaded_to_CC_Item_Date_Time__c, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c];
        
        test.startTest();
        testItem.GFERP__Standard_Base_Price__c = 100;
        for (GFERP__Item_Unit_of_Measure__c testItemUOM : testItemUOMList) {
            
            testItemUOM.Uploaded_to_CC_Item_Date_Time__c = System.today();
            testItemUOM.Uploaded_to_CC_Item__c = true;
            testUpdateItemUOMList.add(testItemUOM);
            
        }
        
        update testUpdateItemUOMList;
        update testItem;
        test.stopTest();
        
        List<GFERP__Item_Unit_of_Measure__c> testAssertItemUOMList = [SELECT Id, Uploaded_to_CC_Item_Date_Time__c, Uploaded_to_CC_Item__c FROM GFERP__Item_Unit_of_Measure__c];
        for (GFERP__Item_Unit_of_Measure__c testAssertItemUOM : testAssertItemUOMList) {
            
            System.assertEquals(null, testAssertItemUOM.Uploaded_to_CC_Item_Date_Time__c); 
            System.assertEquals(false, testAssertItemUOM.Uploaded_to_CC_Item__c);
            
        }
        
    }
}