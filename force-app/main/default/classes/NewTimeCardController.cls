/**********************************************************/
//Created by: Gram Bischof 04/05/2021
//Last Modified: Gram Bischof 04/07/2021
//Description:  Controller class of NewTimeCard LC.
//Test Class : NewTimeCardControllerTest
/**********************************************************/
public class NewTimeCardController {
    
    @AuraEnabled
    public static List<Opportunity> fetchOpportunity(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List <Opportunity> theOppList = [select id, Name from Opportunity where Name LIKE: searchKey];
        return theOppList;
    }
    
    @AuraEnabled
    public static String updateWeek(Integer theWeekShift) {
        String theWeek = '';
        Date myDate = date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        Integer theTotalStartDays = theWeekShift * 7;
        Integer theTotalEndDays = (theWeekShift * 7) + 6;
        if(theWeekShift == 0) {
            theWeek = weekStart.format()+'-'+weekStart.addDays(7).format();
        }
        else {
            theWeek = weekStart.addDays(theTotalStartDays).format() +' - '+ weekStart.addDays(theTotalEndDays).format();
        }
        return theWeek;
    }
    
    @AuraEnabled
    public static Wrapper fetchOppRecord(String theOppId) { 
        Opportunity theCurrentOpp;
        Date myDate = date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        User theCurrentUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        Wrapper theWrap = new Wrapper();
        if(theOppId != null){
            theCurrentOpp = [SELECT Id, Name FROM Opportunity WHERE Id =: theOppId];
            theWrap.theOpp = theCurrentOpp;
        }
        theWrap.theWeek = weekStart.format()+' - '+weekStart.addDays(6).format();
        theWrap.theUser = theCurrentUser;
        theWrap.theWeekShift = 0;
        return theWrap;
    }
    
    @AuraEnabled
    public static String saveTimeCard(String theTimeCardstr) {
        
        Date myDate = date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        Wrapper theTimeCardWrapper = (Wrapper)JSON.deserialize(theTimeCardstr, Wrapper.class);
        Time_Card__c theTimeCard = new Time_Card__c();
        if(theTimeCardWrapper.theOpp != null) theTimeCard.Opportunity__c = theTimeCardWrapper.theOpp.Id;
        if(theTimeCardWrapper.theWeekShift != 0) theTimeCard.Week_Start_Date__c = weekStart.addDays(theTimeCardWrapper.theWeekShift*7);
        else theTimeCard.Week_Start_Date__c = weekStart;
        theTimeCard.Hours_Logged__c = theTimeCardWrapper.theHour;
        insert theTimeCard;
        
        return theTimeCard.Id;
    }
    
    public class Wrapper{
        @AuraEnabled 
        public Opportunity theOpp;
        @AuraEnabled 
        public User theUser; 
        @AuraEnabled 
        public String theWeek;
        @AuraEnabled 
        public Integer theWeekShift;
        @AuraEnabled 
        public Integer theHour;
    }
}