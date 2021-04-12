public class GFINT_UploadImageInCC implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    Set<Id> theSelectedIUOM = new Set<Id>();
    Boolean IsForSelectedIUOM = false;
    String theBaseQuery = '';
    
    public GFINT_UploadImageInCC() {
        theBaseQuery = 'SELECT Id, Name, Image__c, Item_Unit_of_Measure__c, Item_Unit_of_Measure__r.Name, Item__r.Name FROM Images__c WHERE Uploaded_to_CC__c = false';
    }
    
    public GFINT_UploadImageInCC(Set<Id> theSelectedIdsOfIUOM, Boolean IsForOnlySelectedIUOM) {
        theBaseQuery = 'SELECT Id, Name, Image__c, Item_Unit_of_Measure__c, Item_Unit_of_Measure__r.Name, Item__r.Name FROM Images__c';
    }
        
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String theQuery = theBaseQuery;
        return Database.getQueryLocator(theQuery);
    }
    
    public void execute(Database.BatchableContext BC, List<Images__c> theImageList) {
        
        List<Images__c> theUpdateImageList = new List<Images__c>();
        
        for(Images__c theImage : theImageList) {
            
            String itemImage = theImage.Image__c.substringBetween('<img', 'img>');
            String imgsrc = itemImage.substringBetween('src="', '"');
            imgsrc = imgsrc.replace('amp;', '');
            PageReference page = new PageReference(imgsrc);
            Blob imgblob = page.getContent();
            String strBase64  = EncodingUtil.base64Encode(imgblob);
            if(strBase64 != '' && strBase64 != null) {
            
                String theProductName = '';
                
                if(theImage.Item__c != null) theProductName = theProductName+ theImage.Item__r.Name+'_';
                if(theImage.Item_Unit_of_Measure__c != null) theProductName = theProductName+ theImage.Item_Unit_of_Measure__r.Name+'_';
                theProductName = theProductName + theImage.Name;
                
                GFINT_XMLAPItoSFCC.uploadFileAPI(strBase64, theProductName, 'SFCC-Image','JPG');
            }
            
            theImage.Uploaded_to_CC__c = true;
            theImage.Uploaded_to_CC_Date_Time__c = System.now();
            theUpdateImageList.add(theImage);
        }
        
        if(!theUpdateImageList.isEmpty()) update theUpdateImageList;
        
    }
    
    public void finish(Database.BatchableContext BC) {
        GFINT_ComCloudHourlySchedulableBatch theBatch = new GFINT_ComCloudHourlySchedulableBatch(theSelectedIUOM, IsForSelectedIUOM);
        Database.executeBatch(theBatch, 200);
    }
    
}