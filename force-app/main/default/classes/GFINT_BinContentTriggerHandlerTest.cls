@isTest
public class GFINT_BinContentTriggerHandlerTest {
    @testSetup
    public static void setup() {
        GFERP.CompanyMgmt.systemCall = true;
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
        
        Account AccountRecord = new Account();
        AccountRecord.Name = 'Test Account';
        insert AccountRecord;
        
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
        
        GFERP__Bin_Type__c binTypeInTrainsitRecord = new GFERP__Bin_Type__c(Name = 'In-Transit', GFERP__Ship__c = true, GFERP__Put_Away__c = true, GFERP__Receive__c = true, GFERP__Pick__c = true);
        insert binTypeInTrainsitRecord;
        
        GFERP__Warehouse__c WareHouseRecord = new GFERP__Warehouse__c(
            Name = 'White'
        );
        insert WarehouseRecord;
        
        GFERP__Bin__c binRecord = new GFERP__Bin__c(
            Name = 'Ship',
            GFERP__Bin_Type__c = binTypeInTrainsitRecord.Id,
            GFERP__Warehouse__c = WareHouseRecord.Id
        );
        insert binRecord;
        
        GFERP__Item_Lot__c ItemLotRecord = new GFERP__Item_Lot__c(
            Name = 'Lot10987',
            GFERP__Item__c = ItemRecord.Id,
            GFERP__Test_Status__c = 'Accept',
            GFERP__Expiration_Date__c = Date.Today().addDays(7),
            GFERP__Manufacture_Date__c = Date.Today()
        );
        insert ItemLotRecord;
        
        GFERP__Bin_Content__c binContentRecord = new GFERP__Bin_Content__c(
            GFERP__Item__c = ItemRecord.Id,
            GFERP__Unit_of_Measure__c = ItemUnitMeasureRecord.Id,
            GFERP__Warehouse__c = WarehouseRecord.Id,
            GFERP__Bin__c = binRecord.Id,
            GFERP__Item_Lot__c = ItemLotRecord.Id
        );
        insert binContentRecord;
        
        GFERP__Numbering_Series__c NumberingSeriesRecord = new GFERP__Numbering_Series__c(
            Name = 'Sales Order',
            GFERP__Prefix__c = 'Sales Order',
            GFERP__Separator__c = '-',
            GFERP__Last_Number_Used__c = 10000);
        insert NumberingSeriesRecord;
        
        GFERP__Payment_Term__c paymentTermRecord = new GFERP__Payment_Term__c(
            Name = '14 DAYS',
            GFERP__Discount_Pct__c = 0,
            GFERP__Discount_Date_Calculation__c = 0,
            GFERP__Due_Date_Calculation__c = 0);
        insert paymentTermRecord;
        
        GFERP__Tax_Area__c taxAreaRecord = new GFERP__Tax_Area__c ();
        taxAreaRecord.Name = 'NJ';
        insert taxAreaRecord;
        
        GFERP__Warehouse_Entry__c WarehouseEntryRecord = new GFERP__Warehouse_Entry__c (
            GFERP__Bin_Content__c = BinContentRecord.Id,
            GFERP__Bin__c = BinRecord.Id,
            GFERP__Item__c = ItemRecord.Id,
            GFERP__Unit_of_Measure__c = ItemUnitMeasureRecord.Id,
            GFERP__Item_Lot__c = ItemLotRecord.Id,
            GFERP__Warehouse__c = WarehouseRecord.Id,
            GFERP__Quantity__c = 100,
            GFERP__Qty_Base__c = 100,
            GFERP__Conversion__c = 1,
            GFERP__Document_No__c = '123',
            GFERP__Activity_Type__c = 'Shipment',
            GFERP__Posting_Date__c = Date.Today());
        insert WarehouseEntryRecord;
        
        GFERP__Sales_Order__c SalesOrderRecord = new GFERP__Sales_Order__c();
        SalesOrderRecord.GFERP__Order_Date__c = Date.newInstance(2020, 01, 01);
        SalesOrderRecord.GFERP__Sell_to_Customer__c = AccountRecord.id;
        SalesOrderRecord.GFERP__Warehouse__c = WarehouseRecord.Id;
        SalesOrderRecord.GFERP__Currency__c = CurrencyRecord.Id;
        SalesOrderRecord.GFERP__Payment_Term__c = PaymentTermRecord.Id;
        SalesOrderRecord.GFERP__Requested_Shipment_Date__c = Date.today().addDays(2);
        SalesOrderRecord.GFERP__Bill_to_Customer__c = AccountRecord.Id;
        SalesOrderRecord.GFERP__Tax_Area__c = TaxAreaRecord.Id;
        insert SalesOrderRecord;
        
        GFERP__Sales_Line__c  SalesLineRecord = new GFERP__Sales_Line__c();
        SalesLineRecord.GFERP__Line_No__c = 1;
        SalesLineRecord.GFERP__Description__c = 'Test item';
        SalesLineRecord.GFERP__Sales_Order__c = SalesOrderRecord.id;
        SalesLineRecord.GFERP__Quantity__c = 1100;
        SalesLineRecord.GFERP__Qty_Base__c = 1100;
        SalesLineRecord.GFERP__Shipped_Qty__c = 60;
        SalesLineRecord.GFERP__Shipped_Qty_base__c = 60;
        SalesLineRecord.GFERP__Invoiced_Qty__c = 60;
        SalesLineRecord.GFERP__Invoiced_Qty_Base__c = 60;
        SalesLineRecord.GFERP__Conversion__c = 1;
        SalesLineRecord.GFERP__Unit_Price__c = 10;
        SalesLineRecord.GFERP__Item__c = ItemRecord.Id;
        SalesLineRecord.GFERP__Unit_of_Measure__c = ItemUnitMeasureRecord.Id;
        SalesLineRecord.GFERP__Warehouse__c = WarehouseRecord.Id;
        SalesLineRecord.GFERP__Purchasing_Type__c = 'Special Order';
        SalesLineRecord.GFERP__Shipment_Date__c = Date.today().addDays(7);
        SalesLineRecord.GFERP__Tax_Pct__c = 10;
        insert SalesLineRecord;
        
        OMS_Allocation__c testOSM = new OMS_Allocation__c();
        testOSM.Bin_Content__c = binContentRecord.Id;
        testOSM.Allocated__c = 100;
        testOSM.Sales_Line__c = SalesLineRecord.Id;
        insert testOSM;
        
    }
    
    @isTest
    public static void UploadedBInInventoryTest() {
        
        //Assertion
        GFERP__Item_Unit_of_Measure__c testAssertItemUOM  = [SELECT Id, Uploaded_Available_Inventory__c, Uploaded_Online_Form_Date__c, Uploaded_Online_To_Date__c FROM GFERP__Item_Unit_of_Measure__c limit 1];
        System.assertEquals(0, testAssertItemUOM.Uploaded_Available_Inventory__c);
        
    }
    
    @isTest
    public static void binValidationErrorTest() {
        OMS_Allocation__c testOSMAll = [SELECT Id, Allocated__c FROM OMS_Allocation__c];
        GFERP.CompanyMgmt.systemCall = true;
        test.startTest();
        testOSMAll.Allocated__c = 200;
        
        try {
            update testOSMAll;
        }
        catch(Exception testEx) {
            System.assert(testEx.getMessage().contains('OMS avaialble cannot be less than 0'));
        }
        test.stopTest();
    }
}