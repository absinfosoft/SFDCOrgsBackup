//Test Class: CommerceCloudItemInventoryBatchTest
public class GFINT_XMLAPItoSFCC {
    static XMLUploadToCommerce__c theAPIKeys = XMLUploadToCommerce__c.getValues('XMLUploadAPI');
    
    public static void uploadFileAPI(String theFileToAttached, String thefileName , String thePath, String fileType) {
        DateTime theFileDateTime = Datetime.now();
        String theActualDateTime = theFileDateTime.format();
        theActualDateTime = theActualDateTime.replace(' ','-');
        theActualDateTime = theActualDateTime.replace(':','-');
        theActualDateTime = theActualDateTime.replace(',','-');
        theActualDateTime = theActualDateTime.replace('/','-');
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setHeader('content-type', 'application/json');
        Blob headerValue = Blob.valueOf(theAPIKeys.Username__c + ':' + theAPIKeys.Password__c);
        String authorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        String theEndPoint;
        if(fileType == 'XML') theEndPoint = theAPIKeys.EndPoint__c + thePath + '/' + thefileName + '_' + theActualDateTime + '.xml';
        else if(fileType == 'JPG') theEndPoint = theAPIKeys.EndPoint__c + thePath + '/' +thefileName + '.jpg';
        req.setEndpoint(theEndPoint);
        Blob theBody;
        theBody = blob.valueOf(theFileToAttached);
        if(fileType == 'JPG') theBody = EncodingUtil.base64Decode(theFileToAttached);
        req.setBodyAsBlob(theBody);
        HttpResponse res = new Http().send(req);
    }
    
}