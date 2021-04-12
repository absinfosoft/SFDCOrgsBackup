public class GFINT_AllXMLs {
    
    public static String createMasterCatalogXML(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap) {
        Set<Id> theItemIdSet = new Set<Id>();
        String theProductDataFile = '';
        Map<Id, List<Images__c>> theItemId_ImageListMap = new Map<Id, List<Images__c>>();
        
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            for(Images__c theImage : theItemUOM.SFCC_Images__r) {
                
                if(!theItemId_ImageListMap.containsKey(theImage.Item__c)) {
                    theItemId_ImageListMap.put(theImage.Item__c, new List<Images__c>{theImage});
                } else {
                    theItemId_ImageListMap.get(theImage.Item__c).add(theImage);
                }
                
            }
            
        }
        if(theItemUOMList.size() > 0) {
            //Create XML
            DOM.Document doc = new DOM.Document();
            dom.XmlNode Catalog = doc.createRootElement('catalog', null, null);
            Catalog.setAttribute('xmlns','http://www.demandware.com/xml/impex/catalog/2006-10-31'); 
            Catalog.setAttribute('catalog-id','master-catalog');
            
            //Create XML Body
            for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
                
                if(!theItemIdSet.Contains(theItemUOM.GFERP__Item__c)) {
                    if(theItemUOM.Product_Type__c != 'Variant') {
                        Catalog = createProductInXML(Catalog, theItemUOM, null, 'Item', theItemId_ImageListMap);
                    }
                    else {
                        Catalog = createProductInXML(Catalog, theItemUOM, theItemId_ItemUOMListMap.get(theItemUOM.GFERP__Item__c), 'Variant', theItemId_ImageListMap);
                    }
                    theItemIdSet.add(theItemUOM.GFERP__Item__c);
                }
                
            }
            
            theProductDataFile = doc.toXmlString();
        }
        return theProductDataFile;
    }
    
    public static String createInventoryXML(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap) { 
        String theInventoryDataFile = '';
        if(theItemUOMList.size() > 0) {
            //Create XML
            DOM.Document doc = new DOM.Document();
            dom.XmlNode inventory = doc.createRootElement('inventory', null, null);
            inventory.setAttribute('xmlns','http://www.demandware.com/xml/impex/inventory/2007-05-31'); 
            dom.XmlNode inventory_list = inventory.addChildElement('inventory-list', null, null);
            
            //Header
            dom.XmlNode theHeader = inventory_list.addChildElement('header', null, null);
            theHeader.setAttribute('list-id', 'drops_inventory'); 
            theHeader.addChildElement('default-instock', null, null).addTextNode('false');
            theHeader.addChildElement('description', null, null).addTextNode('Product Sku inventory');
            theHeader.addChildElement('use-bundle-inventory-only', null, null).addTextNode('false');
            theHeader.addChildElement('on-order', null, null).addTextNode('false');
            
            //Body
            dom.XmlNode records = inventory_list.addChildElement('records', null, null);
            for (GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
                
                dom.XmlNode record = records.addChildElement('record', null, null);
                record.setAttribute('product-id', theItemUOM.GFERP__Item__r.Name+'_'+ theItemUOM.Name);
                if (theItemUOM.GFERP__Item__r.isGiftVoucher__c == true){
                    record.addChildElement('perpetual', null, null).addTextNode('true');
                }
                //allocation
                if(theItemUOM.Uploaded_Available_Inventory__c != null) {
                    record.addChildElement('allocation', null, null).addTextNode(String.valueOf(theItemUOM.Uploaded_Available_Inventory__c));
                }
                
            }
            theInventoryDataFile = doc.toXmlString();
        }
        return theInventoryDataFile;
    }
    
    public static String createSalesPriceXML(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap) { 
        String theSalesPriceDataFile = '';
        if(theItemUOMList.size() > 0) {
            //Create XML
            DOM.Document doc = new DOM.Document();
            dom.XmlNode pricebooks = doc.createRootElement('pricebooks', null, null);
            pricebooks.setAttribute('xmlns','http://www.demandware.com/xml/impex/pricebook/2006-10-31'); 
            dom.XmlNode pricebook = pricebooks.addChildElement('pricebook', null, null);
            
            //Header
            dom.XmlNode theHeader = pricebook.addChildElement('header', null, null);
            theHeader.setAttribute('pricebook-id', 'kwd-m-sale-prices'); 
            theHeader.addChildElement('currency', null, null).addTextNode('KWD');
            dom.XmlNode display_name = theHeader.addChildElement('display-name', null, null);
            display_name.setAttribute('xml:lang', 'x-default');
            display_name.addTextNode('Sale Prices');
            theHeader.addChildElement('online-flag', null, null).addTextNode('true');
            theHeader.addChildElement('parent', null, null).addTextNode('kwd-m-list-prices');
            
            //Body
            dom.XmlNode price_tables = pricebook.addChildElement('price-tables', null, null);
            for (GFERP__Item_Unit_of_Measure__c  theItemIUOM : theItemUOMList) {
                
                if(theItemIUOM.Uploaded_Sales_Price__c != null) {
                    dom.XmlNode price_table = price_tables.addChildElement('price-table', null, null);
                    price_table.setAttribute('product-id', theItemIUOM.GFERP__Item__r.Name + '_' + theItemIUOM.Name);
                    dom.XmlNode amount = price_table.addChildElement('amount', null, null);
                    amount.setAttribute('quantity', '1');
                    //Sales Price
                    amount.addTextNode(String.valueof(theItemIUOM.Uploaded_Sales_Price__c));
                    //online-from
                    if(theItemIUOM.Uploaded_Online_Form_Date__c !=null) {
                        DateTime DT = DateTime.newInstance(theItemIUOM.Uploaded_Online_Form_Date__c.year(), theItemIUOM.Uploaded_Online_Form_Date__c.month(), theItemIUOM.Uploaded_Online_Form_Date__c.day());
                        dom.XmlNode online_from = price_table.addChildElement('online-from', null, null);
                        online_from.addTextNode(dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
                    }
                    //online-to
                    if(theItemIUOM.Uploaded_Online_To_Date__c !=null) {
                        DateTime DT = DateTime.newInstance(theItemIUOM.Uploaded_Online_To_Date__c.year(),theItemIUOM.Uploaded_Online_To_Date__c.month(), theItemIUOM.Uploaded_Online_To_Date__c.day());
                        dom.XmlNode online_to = price_table.addChildElement('online-to', null, null);
                        online_to.addTextNode(dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
                    }
                }
                
            }
            theSalesPriceDataFile = doc.toXmlString();
        }
        return theSalesPriceDataFile;
    }
    
    public static String createListPriceXML(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap) { 
        String theListPriceDataFile = '';
        if(theItemUOMList.size() > 0) {
            DOM.Document doc = new DOM.Document();
            dom.XmlNode pricebooks = doc.createRootElement('pricebooks', null, null);
            pricebooks.setAttribute('xmlns','http://www.demandware.com/xml/impex/pricebook/2006-10-31'); 
            dom.XmlNode pricebook = pricebooks.addChildElement('pricebook', null, null);
            
            //Header
            dom.XmlNode theHeader = pricebook.addChildElement('header', null, null);
            theHeader.setAttribute('pricebook-id', 'kwd-m-list-prices'); 
            theHeader.addChildElement('currency', null, null).addTextNode('KWD');
            dom.XmlNode display_name = theHeader.addChildElement('display-name', null, null);
            display_name.setAttribute('xml:lang', 'x-default');
            display_name.addTextNode('List Prices');
            theHeader.addChildElement('online-flag', null, null).addTextNode('true');
            
            //Body
            dom.XmlNode price_tables = pricebook.addChildElement('price-tables', null, null);
            for (GFERP__Item_Unit_of_Measure__c theItemUOM :theItemUOMList) {
                
                if(theItemUOM.Standard_Base_Price__c != null) { 
                    dom.XmlNode IUOMprice_table = price_tables.addChildElement('price-table', null, null);
                    IUOMprice_table.setAttribute('product-id', theItemUOM.GFERP__Item__r.Name+'_'+theItemUOM.Name);
                    dom.XmlNode IUOMamount = IUOMprice_table.addChildElement('amount', null, null);
                    IUOMamount.setAttribute('quantity', '1');
                    IUOMamount.addTextNode(String.valueof(theItemUOM.Standard_Base_Price__c));
                }
                
            }
            theListPriceDataFile = doc.toXmlString();
        }
        return theListPriceDataFile;
    }
    
    public static String createStorefrontCatalogXML(List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, Map<Id , List<GFERP__Item_Unit_of_Measure__c>> theItemId_ItemUOMListMap) { 
        String theCatalogProductDataFile = '';
        Set<Id> theItemIdSet = new Set<Id>();
        Map<Id, CategoryWrapper> theCategory_IdMap = new Map<Id, CategoryWrapper>();
        Map<Id, Set<Id>> theSubCategory_fineLineListMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> theCategory_SubCatListMap = new Map<Id, Set<Id>>();
        Map<String, Set<Id>> theBrand_SubCatListMap = new Map<String, Set<Id>>();
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            if(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c != null) {
                if(!theSubCategory_fineLineListMap.containsKey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c)) {
                    theSubCategory_fineLineListMap.put(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c, new Set<Id>{theItemUOM.GFERP__Item__r.GFERP__Item_Category__c});
                }
                else {
                    theSubCategory_fineLineListMap.get(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c).add(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c);
                }
                
                if(!theCategory_SubCatListMap.containsKey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c)) {
                    theCategory_SubCatListMap.put(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c, new Set<Id>{theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c});
                }
                else {
                    theCategory_SubCatListMap.get(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c).add(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c);
                }
                
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c)) {
                    CategoryWrapper theFINECategeoryWrapper = new CategoryWrapper();
                    theFINECategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__c;
                    theFINECategeoryWrapper.CategoryType = 'GFERP__Item_Category__c';
                    theFINECategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Fine_Line_Id__c;
                    theFINECategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Name;
                    theFINECategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Display_Name_Arabic__c; 
                    theFINECategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.GFERP__Description__c;
                    theFINECategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Online__c);
                    theFINECategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Position__c);
                    theFINECategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Thumbnail__c;
                    theFINECategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Image__c;
                    //theFINECategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Rendering_Template__c;
                    theFINECategeoryWrapper.parent = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Name;
                    theFINECategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Title__c;
                    theFINECategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Description__c;
                    theFINECategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Keywords__c;
                    theFINECategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Show_in_Menu__c);
                    //theFINECategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Slot_Banner_Image__c;
                    //theFINECategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Alternative_URL__c;
                    //theFINECategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Size_Chart_ID__c;
                    //theFINECategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    theCategory_IdMap.put(theFINECategeoryWrapper.CategoryId, theFINECategeoryWrapper);
                }
                
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c)) {
                    CategoryWrapper theSubCategeoryWrapper = new CategoryWrapper();
                    theSubCategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c;
                    theSubCategeoryWrapper.CategoryType = 'Subcategory__c';
                    theSubCategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Subcategory_Id__c;
                    theSubCategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Name;
                    theSubCategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Display_Name_Arabic__c;
                    theSubCategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Short_Description__c;
                    theSubCategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Online__c);
                    theSubCategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Position__c);
                    theSubCategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Thumbnail__c;
                    theSubCategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Image__c;
                    //theSubCategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Rendering_Template__c;
                    theSubCategeoryWrapper.parent = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Name;
                    theSubCategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Title__c;
                    theSubCategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Description__c;
                    theSubCategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Keywords__c;
                    theSubCategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Show_in_Menu__c);
                    //theSubCategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Slot_Banner_Image__c;
                    //theSubCategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Alternative_URL__c;
                    //theSubCategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Size_Chart_ID__c;
                    //theSubCategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    theCategory_IdMap.put(theSubCategeoryWrapper.CategoryId, theSubCategeoryWrapper);
                }
                
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c)) {
                    CategoryWrapper theMainCategeoryWrapper = new CategoryWrapper();
                    theMainCategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c;
                    theMainCategeoryWrapper.CategoryType = 'Subcategory__c';
                    theMainCategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Category_Id__c;
                    theMainCategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Name;
                    theMainCategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Display_Name_Arabic__c;
                    theMainCategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Short_Description__c;
                    theMainCategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Online__c);
                    theMainCategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Position__c);
                    theMainCategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Thumbnail__c;
                    theMainCategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Image__c;
                    //theMainCategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Rendering_Template__c;
                    theMainCategeoryWrapper.parent = 'PRODUCTS';
                    theMainCategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Title__c;
                    theMainCategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Description__c;
                    theMainCategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Keywords__c;
                    theMainCategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Show_in_Menu__c);
                    //theMainCategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Slot_Banner_Image__c;
                    //theMainCategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Alternative_URL__c;
                    //theMainCategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Size_Chart_ID__c;
                    //theMainCategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    theCategory_IdMap.put(theMainCategeoryWrapper.CategoryId, theMainCategeoryWrapper);
                }
            }
            
        }
        for(GFERP__Item_Unit_of_Measure__c theItemUOM : theItemUOMList) {
            
            if(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c != null) {
                if(!theSubCategory_fineLineListMap.containsKey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c)) {
                    theSubCategory_fineLineListMap.put(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c, new Set<Id>{theItemUOM.GFERP__Item__r.GFERP__Item_Category__c});
                }
                else {
                    theSubCategory_fineLineListMap.get(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c).add(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c);
                }
                
                if(!theCategory_SubCatListMap.containsKey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c)) {
                    theCategory_SubCatListMap.put(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c, new Set<Id>{theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c});
                }
                else {
                    theCategory_SubCatListMap.get(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c).add(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c);
                }
           
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__c)) {
                    CategoryWrapper theFINECategeoryWrapper = new CategoryWrapper();
                    theFINECategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__c;
                    theFINECategeoryWrapper.CategoryType = 'GFERP__Item_Category__c';
                    theFINECategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Id;
                    theFINECategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Name;
                    theFINECategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Display_Name_Arabic__c; 
                    theFINECategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.GFERP__Description__c;
                    theFINECategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Online__c);
                    theFINECategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Position__c);
                    theFINECategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Thumbnail__c;
                    theFINECategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Image__c;
                    //theFINECategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Rendering_Template__c;
                    theFINECategeoryWrapper.parent = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Name;
                    theFINECategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Title__c;
                    theFINECategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Description__c;
                    theFINECategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Page_Keywords__c;
                    theFINECategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Show_in_Menu__c);
                    //theFINECategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Slot_Banner_Image__c;
                    //theFINECategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Alternative_URL__c;
                    //theFINECategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Size_Chart_ID__c;
                    //theFINECategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    
                    theCategory_IdMap.put(theFINECategeoryWrapper.CategoryId, theFINECategeoryWrapper);
                }
                
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c)) {
                    CategoryWrapper theSubCategeoryWrapper = new CategoryWrapper();
                    theSubCategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__c;
                    theSubCategeoryWrapper.CategoryType = 'Subcategory__c';
                    theSubCategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Subcategory_Id__c;
                    theSubCategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Name;
                    theSubCategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Display_Name_Arabic__c;
                    theSubCategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Short_Description__c;
                    theSubCategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Online__c);
                    theSubCategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Position__c);
                    theSubCategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Thumbnail__c;
                    theSubCategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Image__c;
                    //theSubCategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Rendering_Template__c;
                    theSubCategeoryWrapper.parent = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Name;
                    theSubCategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Title__c;
                    theSubCategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Description__c;
                    theSubCategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Page_Keywords__c;
                    theSubCategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Show_in_Menu__c);
                    //theSubCategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Slot_Banner_Image__c;
                    //theSubCategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Alternative_URL__c;
                    //theSubCategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Size_Chart_ID__c;
                    //theSubCategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    theCategory_IdMap.put(theSubCategeoryWrapper.CategoryId, theSubCategeoryWrapper);
                }
                
                if(!theCategory_IdMap.containskey(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c)) {
                    CategoryWrapper theMainCategeoryWrapper = new CategoryWrapper();
                    theMainCategeoryWrapper.CategoryId = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__c;
                    theMainCategeoryWrapper.CategoryType = 'Subcategory__c';
                    theMainCategeoryWrapper.Category = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Category_Id__c;
                    theMainCategeoryWrapper.display_name = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Name;
                    theMainCategeoryWrapper.display_name_Arabic = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Display_Name_Arabic__c;
                    theMainCategeoryWrapper.short_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Short_Description__c;
                    theMainCategeoryWrapper.online_flag = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Online__c);
                    theMainCategeoryWrapper.Position = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Position__c);
                    theMainCategeoryWrapper.Thumbnail = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Thumbnail__c;
                    theMainCategeoryWrapper.Image = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Image__c;
                    //theMainCategeoryWrapper.template = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Rendering_Template__c;
                    theMainCategeoryWrapper.parent = 'PRODUCTS';
                    theMainCategeoryWrapper.page_title = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Title__c;
                    theMainCategeoryWrapper.page_description = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Description__c;
                    theMainCategeoryWrapper.page_keywords = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Page_Keywords__c;
                    theMainCategeoryWrapper.showInMenu = String.valueof(theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Show_in_Menu__c);
                    //theMainCategeoryWrapper.slotBannerImage = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Slot_Banner_Image__c;
                    //theMainCategeoryWrapper.alternativeUrl = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Alternative_URL__c;
                    //theMainCategeoryWrapper.sizeChartID = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Parent__r.Parent__r.Size_Chart_ID__c;
                    //theMainCategeoryWrapper.adsBanners = theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.adsBanners__c;
                    theCategory_IdMap.put(theMainCategeoryWrapper.CategoryId, theMainCategeoryWrapper);
            
                }
            }
            
        }
        if(theCategory_SubCatListMap.keyset().size() > 0) {
            //create XML
            DOM.Document doc = new DOM.Document();
            dom.XmlNode Catalog = doc.createRootElement('catalog', null, null);
            Catalog.setAttribute('xmlns','http://www.demandware.com/xml/impex/catalog/2006-10-31'); 
            Catalog.setAttribute('catalog-id','drops-storefront-catalog');
            
            //category root
            dom.XmlNode theRoot = Catalog.addChildElement('category', null, null);
            theRoot.setAttribute('category-id','root'); 
            //root display-name
            dom.XmlNode rootDisplayname = theRoot.addChildElement('display-name', null, null);
            rootDisplayname.setAttribute('xml:lang','x-default');
            rootDisplayname.addTextNode('Storefront Catalog - EN');
            //root display-name_Arabic
            dom.XmlNode rootDisplaynameArabic = theRoot.addChildElement('display-name', null, null);
            rootDisplaynameArabic.setAttribute('xml:lang','ar-AE'); 
            rootDisplaynameArabic.addTextNode('كتالوج واجهة المتجر');
            
            //root online-flag
            theRoot.addChildElement('online-flag', null, null).addTextNode('true');
            //root page-attributes
            theRoot.addChildElement('page-attributes', null, null);
            
            //category PRODUCT
            dom.XmlNode thePRODUCT = Catalog.addChildElement('category', null, null);
            thePRODUCT.setAttribute('category-id','PRODUCTS'); 
            //PRODUCT display-name
            dom.XmlNode thePRODUCTDisplayname = thePRODUCT.addChildElement('display-name', null, null);
            thePRODUCTDisplayname.setAttribute('xml:lang','x-default');
            thePRODUCTDisplayname.addTextNode('Products');
            
            //PRODUCT online-flag
            thePRODUCT.addChildElement('online-flag', null, null).addTextNode('true');
            //PRODUCT Parent
            thePRODUCT.addChildElement('parent', null, null).addTextNode('root');
            //PRODUCT Position
            thePRODUCT.addChildElement('position', null, null).addTextNode('1.0');
            //PRODUCT template
            //thePRODUCT.addChildElement('template', null, null).addTextNode('rendering/category/catLanding');
            
            //PRODUCT page-attributes
            dom.XmlNode thePage_attributes =  thePRODUCT.addChildElement('page-attributes', null, null);
            //PRODUCT page-title
            dom.XmlNode thePage_title =  thePage_attributes.addChildElement('page-title', null, null);
            thePage_title.setAttribute('xml:lang','x-default');
            thePage_title.addTextNode('Products');
            //PRODUCT page-description
            dom.XmlNode thePage_description =  thePage_attributes.addChildElement('page-description ', null, null);
            thePage_description.setAttribute('xml:lang','x-default');
            thePage_description.addTextNode('Shop all Products');
            
            //PRODUCT custom-attributes
            dom.XmlNode thecustom_attributes = thePRODUCT.addChildElement('custom-attributes', null, null);
            //PRODUCT custom-attribute
            dom.XmlNode thecustom_attribute = thecustom_attributes.addChildElement('custom-attribute', null, null);
            thecustom_attribute.setAttribute('attribute-id','showInMenu');
            thecustom_attribute.addTextNode('true');
            
            List<String> theCategoryList = new List<String>();
            theCategoryList.add('Category__c');//Level 1
            theCategoryList.add('Subcategory__c');//Level 2
            theCategoryList.add('GFERP__Item_Category__c');//Level 3
            
            //create Category
            for (String theMainCategory : theCategory_SubCatListMap.keyset()) {
                
                Catalog = createCategoryInXML(Catalog, theCategory_IdMap.get(theMainCategory));
                for(String theSubCategory : theCategory_SubCatListMap.get(theMainCategory)) {
                    
                    Catalog = createCategoryInXML(Catalog, theCategory_IdMap.get(theSubCategory));
                    for(String theFineLine : theSubCategory_fineLineListMap.get(theSubCategory)) { 
                        
                        Catalog = createCategoryInXML(Catalog, theCategory_IdMap.get(theFineLine));
                        for (GFERP__Item_Unit_of_Measure__c theItemUOM :  theItemUOMList) {
                            
                            if(!theItemIdSet.contains(theItemUOM.GFERP__Item__c) && theItemUOM.GFERP__Item__r.GFERP__Item_Category__c == theFineLine && theItemUOM.GFERP__Item__r.GFERP__Item_Category__c != null) {
                                dom.XmlNode category_assignment = Catalog.addChildElement('category-assignment', null, null);
                                category_assignment.setAttribute('category-id',theItemUOM.GFERP__Item__r.GFERP__Item_Category__r.Name); 
                                category_assignment.setAttribute('product-id', theItemUOM.GFERP__Item__r.Name); 
                                category_assignment.addChildElement('primary-flag', null, null).addTextNode('true');
                                theItemIdSet.add(theItemUOM.GFERP__Item__c);
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            theCatalogProductDataFile = doc.toXmlString();
        }
        return theCatalogProductDataFile;
    }
    
    //method helps to create Master product with variant product when Product Type is Variant else create Item only
    public static dom.XmlNode createProductInXML(dom.XmlNode Catalog, GFERP__Item_Unit_of_Measure__c theItemUOM, List<GFERP__Item_Unit_of_Measure__c> theItemUOMList, String theProductType, Map<Id, List<Images__c>> theItemId_ImageListMap) {
         dom.XmlNode thebody = Catalog.addChildElement('Product', null, null);
        //product-id
        String theProductName = theItemUOM.GFERP__Item__r.Name;
        if(theProductType == 'Item') theProductName = theProductName +'_'+ theItemUOM.Name;
        thebody.setAttribute('product-id', theProductName);
        
        //UPC
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__UPC__c)) thebody.addChildElement('upc', null, null).addTextNode(theItemUOM.GFERP__Item__r.GFERP__UPC__c);
        
        //Unit
        if(String.isNotEmpty(String.valueOf(theItemUOM.GFERP__Item__r.GFERP__Base_Unit_of_Measure__c))) thebody.addChildElement('unit', null, null).addTextNode(theItemUOM.GFERP__Item__r.GFERP__Base_Unit_of_Measure__r.Name);
        
        //min-order-quantity
        dom.XmlNode min_order_quantity = thebody.addChildElement('min-order-quantity', null, null);
        min_order_quantity.addTextNode('1');
        
        //step-quantity
        dom.XmlNode step_quantity = thebody.addChildElement('step-quantity', null, null).addTextNode('1');
        
        //display-name
        if(String.isNotEmpty(String.valueOf(theItemUOM.GFERP__Item__r.Display_Name_English__c))){ 
            dom.XmlNode display_name = thebody.addChildElement('display-name', null, null);
            display_name.setAttribute('xml:lang', 'x-default');
            display_name.addTextNode(theItemUOM.GFERP__Item__r.Display_Name_English__c);
        }
        //display-name_Arabic
        if(String.isNotEmpty(String.valueOf(theItemUOM.GFERP__Item__r.Display_Name_Arabic__c))) {
            dom.XmlNode display_name_Arabic = thebody.addChildElement('display-name', null, null);
            display_name_Arabic.setAttribute('xml:lang', 'ar-AE');
            display_name_Arabic.addTextNode(theItemUOM.GFERP__Item__r.Display_Name_Arabic__c);
        }
        //short-description
        if(String.isNotEmpty(String.valueOf(theItemUOM.GFERP__Item__r.GFERP__Description__c))) {
            dom.XmlNode short_description = thebody.addChildElement('short-description', null, null);
            short_description.setAttribute('xml:lang', 'x-default');
            short_description.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Description__c);
        }
        //long-description
        if(String.isNotEmpty(String.valueOf(theItemUOM.GFERP__Item__r.Long_Description__c))) {
            dom.XmlNode long_description = thebody.addChildElement('long-description', null, null);
            long_description.setAttribute('xml:lang', 'x-default');
            long_description.addTextNode(theItemUOM.GFERP__Item__r.Long_Description__c);
        }
        //online-flag
        thebody.addChildElement('online-flag', null, null).addTextNode(String.valueOf(theItemUOM.GFERP__Item__r.Visible__c));
        //online-from
        if(theItemUOM.GFERP__Item__r.Starting_Date__c !=null) {
            DateTime DT = DateTime.newInstance(theItemUOM.GFERP__Item__r.Starting_Date__c.year(), theItemUOM.GFERP__Item__r.Starting_Date__c.month(), theItemUOM.GFERP__Item__r.Starting_Date__c.day());
            dom.XmlNode online_from = thebody.addChildElement('online-from', null, null);
            online_from.addTextNode(dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        }
        //online-to
        if(theItemUOM.GFERP__Item__r.Ending_Date__c !=null) {
            DateTime DT = DateTime.newInstance(theItemUOM.GFERP__Item__r.Ending_Date__c.year(), theItemUOM.GFERP__Item__r.Ending_Date__c.month(), theItemUOM.GFERP__Item__r.Ending_Date__c.day());
            dom.XmlNode online_to = thebody.addChildElement('online-to', null, null);
            online_to.addTextNode(dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        }
        
        //searchable-flag
        thebody.addChildElement('searchable-flag', null, null).addTextNode(String.valueOf(theItemUOM.GFERP__Item__r.Searchable__c));
        
        //brand
        dom.XmlNode Brand = thebody.addChildElement('brand', null, null);
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Brand__c)) Brand.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Brand__c);
        
        //manufacturer-name
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Manufacturer_Name__c)) {
            thebody.addChildElement('manufacturer-name', null, null).addTextNode(theItemUOM.GFERP__Item__r.Manufacturer_Name__c);
        }
        
        //offer
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Offers__c)) {
            thebody.addChildElement('Offers', null, null).addTextNode(theItemUOM.GFERP__Item__r.Offers__c);
        } 
        
        //gfItemNumber
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Name)) {
            thebody.addChildElement('gfItemNumber', null, null).addTextNode(theItemUOM.GFERP__Item__r.Name);
        } 
        
        //adsBanners
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.adsBanners__c)) {
            thebody.addChildElement('adsBanners', null, null).addTextNode(theItemUOM.GFERP__Item__r.adsBanners__c);
        }
        
        //manufacturer-sku
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Manufacturer_SKU__c)) {
            thebody.addChildElement('manufacturer-sku', null, null).addTextNode(theItemUOM.GFERP__Item__r.Manufacturer_SKU__c);
        }
        
        //tax-class-id
        if(theProductType != 'Item') {
            dom.XmlNode tax_class_id = thebody.addChildElement('tax-class-id', null, null);
            tax_class_id.addTextNode('standard'); 
        }
        dom.XmlNode custom_attributes;
        
        //custom-attributes
        if(theItemUOM.GFERP__Item__r.GFERP__Item_Type__c != null || theItemUOM.GFERP__Item__r.GFERP__Replenishment_System__c != null || theItemUOM.GFERP__Item__r.GFERP__Inventory_Class__c != null
           || theItemUOM.GFERP__Item__r.GFERP__Country_of_Origin2__c != null || theItemUOM.GFERP__Item__r.GFERP__Vendor__c != null || theItemUOM.GFERP__Item__r.Net_Weight__c != null
           || theItemUOM.GFERP__Item__r.Capacity__c != null || theItemUOM.GFERP__Item__r.Tags__c != null)  {
               custom_attributes = thebody.addChildElement('custom-attributes', null, null);
           }
        //itemType
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Item_Type__c)) {
            dom.XmlNode itemType = custom_attributes.addChildElement('custom-attribute', null, null);
            itemType.setAttribute('attribute-id', 'itemType');
            itemType.setAttribute('xml:lang', 'x-default');
            itemType.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Item_Type__c);
        }
        //replenishmentSystem
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Replenishment_System__c)) {
            dom.XmlNode Replenishment_System = custom_attributes.addChildElement('custom-attribute', null, null);
            Replenishment_System.setAttribute('attribute-id', 'replenishmentSystem');
            Replenishment_System.setAttribute('xml:lang', 'x-default');
            Replenishment_System.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Replenishment_System__c);
        }
        //inventoryClass
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Inventory_Class__c)) {
            dom.XmlNode Inventory_Class = custom_attributes.addChildElement('custom-attribute', null, null);
            Inventory_Class.setAttribute('attribute-id', 'inventoryClass');
            Inventory_Class.setAttribute('xml:lang', 'x-default');
            Inventory_Class.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Inventory_Class__c);
        }
        //countryOfOrigin
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Country_of_Origin2__c)) {
            dom.XmlNode Country_of_Origin = custom_attributes.addChildElement('custom-attribute', null, null);
            Country_of_Origin.setAttribute('attribute-id', 'countryOfOrigin');
            Country_of_Origin.setAttribute('xml:lang', 'x-default');
            Country_of_Origin.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Country_of_Origin2__c);
        }
        //vendor
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Vendor__c)) {
            dom.XmlNode Vendor = custom_attributes.addChildElement('custom-attribute', null, null);
            Vendor.setAttribute('attribute-id', 'vendor');
            Vendor.setAttribute('xml:lang', 'x-default');
            Vendor.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Vendor__r.Name);
        }
        //netWeight
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Net_Weight__c)) {
            dom.XmlNode netWeight = custom_attributes.addChildElement('custom-attribute', null, null);
            netWeight.setAttribute('attribute-id', 'netWeight');
            netWeight.setAttribute('xml:lang', 'x-default');
            netWeight.addTextNode(theItemUOM.GFERP__Item__r.Net_Weight__c);
        }
        //capacity
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Capacity__c)) {
            dom.XmlNode Capacity = custom_attributes.addChildElement('custom-attribute', null, null);
            Capacity.setAttribute('attribute-id', 'capacity');
            Capacity.setAttribute('xml:lang', 'x-default');
            Capacity.addTextNode(theItemUOM.GFERP__Item__r.Capacity__c);
        }
        //tags
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Tags__c)) {
            dom.XmlNode Capacity = custom_attributes.addChildElement('custom-attribute', null, null);
            Capacity.setAttribute('attribute-id', 'tags');
            Capacity.setAttribute('xml:lang', 'x-default');
            Capacity.addChildElement('value', null, null).addTextNode(theItemUOM.GFERP__Item__r.Tags__c);
        }
        
        //Images
        dom.XmlNode images = thebody.addChildElement('images', null, null);
        //dom.XmlNode image_group = images.addChildElement('image-group', null, null);
        if(theProductType == 'Item') {
            for(Images__c theImage : theItemUOM.SFCC_Images__r) {
                if (theImage.Image__c != null && theImage.Item_Unit_of_Measure__c == null) {
                    dom.XmlNode image_group = images.addChildElement('image-group', null, null);
                    if (theImage.View_Type__c != null) image_group.setAttribute('view-type', theImage.View_Type__c);
                    dom.XmlNode image = image_group.addChildElement('image', null, null);
                    //if(theImage.Variation_Value__c != null) image.setAttribute('variation-value', theImage.Variation_Value__c);
                    if (theImage.Path__c != null) image.setAttribute('path', theImage.Path__c);
                    //if(theImage.Title__c != null) image.setAttribute('title', theImage.Title__c);
                }
                
            }
        } else {
            //?????????
            if(theItemId_ImageListMap.ContainsKey(theItemUOM.GFERP__Item__c)) {
                for(Images__c theImage : theItemId_ImageListMap.get(theItemUOM.GFERP__Item__c)) {
                    if (theImage.Image__c != null) {
                        dom.XmlNode image_group = images.addChildElement('image-group', null, null);
                        if (theImage.View_Type__c != null) image_group.setAttribute('view-type', theImage.View_Type__c);
                        dom.XmlNode image = image_group.addChildElement('image', null, null);
                        //if(theImage.Variation_Value__c != null) image.setAttribute('variation-value', theImage.Variation_Value__c);
                        if (theImage.Path__c != null) image.setAttribute('path', theImage.Path__c);
                        //if(theImage.Title__c != null) image.setAttribute('title', theImage.Title__c);
                    }
                }
            }
        }
        //salesOfUnit
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.GFERP__Base_Unit_of_Measure__c)) {
            dom.XmlNode salesOfUnit = custom_attributes.addChildElement('custom-attribute', null, null);
            salesOfUnit.setAttribute('attribute-id', 'salesOfUnit');
            salesOfUnit.setAttribute('xml:lang', 'x-default');
            salesOfUnit.addTextNode(theItemUOM.GFERP__Item__r.GFERP__Base_Unit_of_Measure__r.Name);
        } 
        
        //isNew
        dom.XmlNode isNew = custom_attributes.addChildElement('custom-attribute', null, null);
        isNew.setAttribute('attribute-id', 'isNew');
        isNew.addTextNode(String.valueof(theItemUOM.GFERP__Item__r.isNew__c));
        
        //lotTracked
        dom.XmlNode lotTracked = custom_attributes.addChildElement('custom-attribute', null, null);
        lotTracked.setAttribute('attribute-id', 'lotTracked');
        lotTracked.addTextNode(String.valueof(theItemUOM.GFERP__Item__r.GFERP__Lot_Tracked__c));
        
        //disabledShippingMethod
        if(String.isNotEmpty(theItemUOM.GFERP__Item__r.Disabled_Shipping_Method__c)) {
            dom.XmlNode disabledShippingMethod = custom_attributes.addChildElement('custom-attribute', null, null);
            disabledShippingMethod.setAttribute('attribute-id', 'disabledShippingMethod');
            disabledShippingMethod.setAttribute('xml:lang', 'x-default');
            disabledShippingMethod.addTextNode(theItemUOM.GFERP__Item__r.Disabled_Shipping_Method__c);
        } 
        
        if(theProductType != 'Item') {
            //Create Variants in Master
            dom.XmlNode variations = thebody.addChildElement('variations', null, null);
            if (theItemUOM.GFERP__Item__r.isGiftVoucher__c == true) {
                //attributes
                dom.XmlNode attributes = variations.addChildElement('attributes', null, null);
                
                
                for (GFERP__Item_Unit_of_Measure__c theIUOM : theItemUOMList) {
                    
                    //gvAmount
                    dom.XmlNode gvAmount = attributes.addChildElement('custom-attribute', null, null);
                    gvAmount.setAttribute('attribute-id', 'gvAmount');
                    gvAmount.addTextNode(theIUOM.Name);
                    //isGiftVoucher
                    dom.XmlNode isGiftVoucher = attributes.addChildElement('custom-attribute', null, null);
                    isGiftVoucher.setAttribute('attribute-id', 'isGiftVoucher');
                    isGiftVoucher.addTextNode('true');
                    //variation-attribute-values
                    dom.XmlNode variation_attribute_values = attributes.addChildElement('variation-attribute-values', null, null);
                    
                    //variation-attribute-value
                    dom.XmlNode variation_attribute_value = variation_attribute_values.addChildElement('variation-attribute-value', null, null);
                    variation_attribute_value.setAttribute('value', theIUOM.Name);
                    //display-value
                    dom.XmlNode display_value = variation_attribute_value.addChildElement('variation-attribute-value', null, null);
                    display_value.setAttribute('xml:lang', 'x-default');
                    display_value.addTextNode(theIUOM.Name);
                    
                }
            }
            dom.XmlNode variants = variations.addChildElement('variants', null, null);
            for (GFERP__Item_Unit_of_Measure__c theIUOM : theItemUOMList) {
                
                //Create Variants in Master
                variants.addChildElement('variants', null, null).setAttribute('product-id', theIUOM.GFERP__Item__r.Name + '_' + theIUOM.Name);
                //Create variant product
                dom.XmlNode VariantProduct = Catalog.addChildElement('Product', null, null);
                VariantProduct.setAttribute('product-id', theIUOM.GFERP__Item__r.Name + '_' + theIUOM.Name);
                //VariantUPC
                if (String.isNotEmpty(theIUOM.GFERP__Item__r.GFERP__UPC__c)) VariantProduct.addChildElement('upc', null, null).addTextNode(theIUOM.GFERP__Item__r.GFERP__UPC__c);
                //Variant min-order-quantity
                dom.XmlNode VariantMin_order_quantity = VariantProduct.addChildElement('min-order-quantity', null, null).addTextNode('1');
                //Variant step-quantity
                dom.XmlNode Variantstep_quantity = VariantProduct.addChildElement('step-quantity', null, null).addTextNode('1');
                //Variant online-flag
                VariantProduct.addChildElement('online-flag', null, null).addTextNode(String.valueOf(theIUOM.GFERP__Item__r.Visible__c));
                //Variant searchable-flag
                VariantProduct.addChildElement('searchable-flag', null, null).addTextNode(String.valueOf(theIUOM.GFERP__Item__r.Searchable__c));
                //Variant tax-class-id
                VariantProduct.addChildElement('tax-class-id', null, null).addTextNode('standard');
                
              /*  //Giftamount attributes
                if (theItemUOM.GFERP__Item__r.isGiftVoucher__c == true) {
                    custom_attributes = VariantProduct.addChildElement('custom-attributes', null, null);
                    //gvAmount
                    dom.XmlNode gvAmount = custom_attributes.addChildElement('custom-attribute', null, null);
                    gvAmount.setAttribute('attribute-id', 'gvAmount');
                    gvAmount.addTextNode(theIUOM.Name);
                    //isGiftVoucher
                    dom.XmlNode isGiftVoucher = custom_attributes.addChildElement('custom-attribute', null, null);
                    isGiftVoucher.setAttribute('attribute-id', 'isGiftVoucher');
                    isGiftVoucher.addTextNode('true');
                }*/

                //Variant  Image
                dom.XmlNode theVaraintImages = VariantProduct.addChildElement('images', null, null);
                for(Images__c theImage : theIUOM.SFCC_Images__r) {
                    
                    dom.XmlNode variantImage = theVaraintImages.addChildElement('image-group', null, null);
                    if(theImage.View_Type__c != null) variantImage.setAttribute('view-type', theImage.View_Type__c);
                    dom.XmlNode image = variantImage.addChildElement('image', null, null);
                    //if(theImage.Variation_Value__c != null) variantImage.setAttribute('variation-value', theImage.Variation_Value__c);
                    if(theImage.Path__c != null) image.setAttribute('path', theImage.Path__c);
                    //if(theImage.Title__c != null) variantImage.setAttribute('title', theImage.Title__c);
                    
                }
            }
        }
        
        return Catalog;
    }
    
    //method helps to create Category in XML
    public static dom.XmlNode createCategoryInXML(dom.XmlNode Catalog, CategoryWrapper theCatWrapper) {
        //Category__c
        dom.XmlNode theCategory = Catalog.addChildElement('category', null, null);
        
        //category-id
        if(theCatWrapper.Category != null) theCategory.setAttribute('category-id', theCatWrapper.Category);
        
        //display-name
        if(theCatWrapper.display_name != null) {
            dom.XmlNode display_name = theCategory.addChildElement('display-name', null, null);
            display_name.setAttribute('xml:lang', 'x-default');
            display_name.addTextNode(theCatWrapper.display_name);
        }
        
        //display-name_Arabic
        if(theCatWrapper.display_name_Arabic != null) {
            dom.XmlNode display_name_Arabic = theCategory.addChildElement('display-name', null, null);
            display_name_Arabic.setAttribute('xml:lang', 'ar-AE');
            display_name_Arabic.addTextNode(theCatWrapper.display_name_Arabic);
        }
        
        //adsBanners
        //if(theCatWrapper.adsBanners != null) {
          //  theCategory.addChildElement('adsBanners', null, null).addTextNode(theCatWrapper.adsBanners);
        //}
        
        //online-flag
        if(theCatWrapper.online_flag != null) theCategory.addChildElement('online-flag', null, null).addTextNode(theCatWrapper.online_flag);
        
        //position
        if(theCatWrapper.Position != null) theCategory.addChildElement('position', null, null).addTextNode(theCatWrapper.Position);
        
        //Thumbnail
        if(theCatWrapper.Thumbnail != null) theCategory.addChildElement('thumbnail', null, null).addTextNode(theCatWrapper.Thumbnail);
        
        //Image
        if(theCatWrapper.Image != null) theCategory.addChildElement('image', null, null).addTextNode(theCatWrapper.Image);
        
        //template
        //if(theCatWrapper.template != null) theCategory.addChildElement('template', null, null).addTextNode(theCatWrapper.template);
        
        //parent
        if(theCatWrapper.parent != null) theCategory.addChildElement('parent', null, null).addTextNode(theCatWrapper.parent);
        
        //page-attributes
        dom.XmlNode page_attributes;
        if(theCatWrapper.page_title != null || theCatWrapper.page_description != null || theCatWrapper.page_keywords != null ) page_attributes = theCategory.addChildElement('page-attributes', null, null);
        
        //page-title
        if(theCatWrapper.page_title != null) {
            dom.XmlNode page_title = page_attributes.addChildElement('page-title', null, null);
            page_title.setAttribute('xml:lang', 'x-default');
            page_title.addTextNode(theCatWrapper.page_title);
        }
        
        //page-description
        if(theCatWrapper.page_description != null) {
            dom.XmlNode page_description = page_attributes.addChildElement('page-description', null, null);
            page_description.setAttribute('xml:lang', 'x-default');
            page_description.addTextNode(theCatWrapper.page_description);
        }
        
        //page-keywords
        if(theCatWrapper.page_keywords != null) {
            dom.XmlNode page_keyWord = page_attributes.addChildElement('page-keywords', null, null);
            page_keyWord.setAttribute('xml:lang', 'x-default');
            page_keyWord.addTextNode(theCatWrapper.page_keywords);
        }
        
        //custom-attributes
        dom.XmlNode custom_attributes;
        if(theCatWrapper.showInMenu != null) {
            custom_attributes = theCategory.addChildElement('custom-attributes', null, null);
            
            //showInMenu
            dom.XmlNode showInMenu = custom_attributes.addChildElement('custom-attribute', null, null);
            showInMenu.setAttribute('attribute-id', 'showInMenu');
            showInMenu.addTextNode(theCatWrapper.showInMenu);
        }
        
        /* //slotBannerImage
        if(theCatWrapper.slotBannerImage != null) {
            dom.XmlNode slotBannerImage = custom_attributes.addChildElement('custom-attribute', null, null);
            slotBannerImage.setAttribute('attribute-id', 'slotBannerImage');
            slotBannerImage.addTextNode(theCatWrapper.slotBannerImage);
        }
        
        //alternativeUrl
        if(theCatWrapper.alternativeUrl != null) {
            dom.XmlNode alternativeUrl = custom_attributes.addChildElement('custom-attribute', null, null);
            alternativeUrl.setAttribute('attribute-id', 'alternativeUrl');
            alternativeUrl.addTextNode(theCatWrapper.alternativeUrl);
        }
        
        
        //sizeChartID
        if(theCatWrapper.sizeChartID != null) {
            dom.XmlNode sizeChartID = custom_attributes.addChildElement('custom-attribute', null, null);
            sizeChartID.setAttribute('attribute-id', 'sizeChartID');
            sizeChartID.addTextNode(theCatWrapper.sizeChartID);
        }*/
        
        return Catalog;
    }
    
    //Catalog Wrapper
    public Class CategoryWrapper {
        public string CategoryId;
        public string CategoryType;
        public string Category;
        public string display_name;
        public string display_name_Arabic;
        public string short_description;
        public string online_flag;
        public string Position;
        public string Thumbnail;
        public string Image;
        //public string template;
        public string parent;
        public string page_title;
        public string page_description;
        public string page_keywords;
        public string showInMenu;
        public string slotBannerImage;
        public string alternativeUrl;
        public string sizeChartID;
        public string adsBanners;
    }
}