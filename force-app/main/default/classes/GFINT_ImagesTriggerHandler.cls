public class GFINT_ImagesTriggerHandler {
    
    public static void uncheckUploadedComCloudFieldOnIUOM(List<Images__c> theImagesList , Map<Id,Images__c> theImagesOldMap) {
        
        for(Images__c theImage : theImagesList) {
            
            if(theImagesOldMap.get(theImage.Id).Uploaded_to_CC__c && theImagesOldMap.get(theImage.Id).Uploaded_to_CC_Date_Time__c != null) {
                theImage.Uploaded_to_CC__c = false;
                theImage.Uploaded_to_CC_Date_Time__c = null;
            }
            
        }
        
    }
    
}