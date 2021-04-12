@isTest
public class GFINT_SalesPriceEntryTriggerHandlerTest {
    @testSetup
    public static void setup() {
        
        GFERP__Demand_Planning_Setup__c DemandPlanningSetupRecord = new GFERP__Demand_Planning_Setup__c(
            Name = 'Default',
            GFERP__Periods_to_Re_Forecast__c = 4,
            GFERP__Periods_to_Forecast__c = 12,
            GFERP__Inventory_Period_Type__c = 'By Week',
            GFERP__Periods_to_Run_Supply_Plan__c = 6
        );
        insert DemandPlanningSetupRecord;
        
        List<GFERP__Item_Unit_of_Measure__c> testItemUOMList = new List<GFERP__Item_Unit_of_Measure__c>();
        List<GFERP__Unit_of_Measure__c> testUOMList = new List<GFERP__Unit_of_Measure__c>();
        List<GFERP__Sales_Price_Entry__c> testSalesPriceEntryRecordList = new List<GFERP__Sales_Price_Entry__c>();
        
        GFERP__Currency__c CurrencyRecord = new  GFERP__Currency__c(
            Name = 'KWD'
        );
        insert CurrencyRecord;
        
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
        insert testItemUOMList;
        
        GFERP__Sales_Price__c SalesPriceRecord = new  GFERP__Sales_Price__c (
            GFERP__Sales_Pricing_Group__c = '',
            GFERP__Active__c = true,
            GFERP__Starting_Date__c = System.today().addDays(-1),
            GFERP__Pricing_Type__c = 'All Accounts',
            GFERP__Ending_Date__c = System.today().addDays(7),
            GFERP__Currency__c = CurrencyRecord.Id
        );
        insert SalesPriceRecord;
        
        for(GFERP__Item_Unit_of_Measure__c ItemUOMRecord : testItemUOMList) {
            
            GFERP__Sales_Price_Entry__c SalesPriceEntryRecord = new GFERP__Sales_Price_Entry__c();
            SalesPriceEntryRecord.GFERP__Item__c = ItemUOMRecord.GFERP__Item__c;
            SalesPriceEntryRecord.GFERP__Minimum_Quantity__c = 2;
            SalesPriceEntryRecord.GFERP__Sales_Price__c = 200;
            SalesPriceEntryRecord.GFERP__Unit_of_Measure__c = ItemUOMRecord.Id;
            SalesPriceEntryRecord.GFERP__Price_Book__c = SalesPriceRecord.Id;
            testSalesPriceEntryRecordList.add(SalesPriceEntryRecord);
            
            GFERP__Sales_Price_Entry__c SalesPriceEntryRecord2 = new GFERP__Sales_Price_Entry__c();
            SalesPriceEntryRecord2.GFERP__Item__c = ItemUOMRecord.GFERP__Item__c;
            SalesPriceEntryRecord2.GFERP__Minimum_Quantity__c = 2;
            SalesPriceEntryRecord2.GFERP__Sales_Price__c = 100;
            SalesPriceEntryRecord2.GFERP__Unit_of_Measure__c = ItemUOMRecord.Id;
            SalesPriceEntryRecord2.GFERP__Price_Book__c = SalesPriceRecord.Id;
            testSalesPriceEntryRecordList.add(SalesPriceEntryRecord2);
            
        }
        
        insert testSalesPriceEntryRecordList;   
        
    }
    
    @isTest
    public static void UploadedSalesPriceTest() {
        
        GFERP__Sales_Price_Entry__c testItemUOM = [SELECT Id, GFERP__Minimum_Quantity__c FROM GFERP__Sales_Price_Entry__c limit 1];
        
        //Assertion
        GFERP__Item_Unit_of_Measure__c testAssertItemUOM  = [SELECT Id, Uploaded_Sales_Price__c, Uploaded_Online_Form_Date__c, Uploaded_Online_To_Date__c FROM GFERP__Item_Unit_of_Measure__c limit 1];
        System.assertEquals(100, testAssertItemUOM.Uploaded_Sales_Price__c);
        System.assertEquals(System.today().addDays(-1), testAssertItemUOM.Uploaded_Online_Form_Date__c);
        System.assertEquals(System.today().addDays(7), testAssertItemUOM.Uploaded_Online_To_Date__c);
        
    }
    
}