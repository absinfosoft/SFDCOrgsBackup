public class TimeCardWeekController {
    
    @AuraEnabled
    public static Wrapper fetchTimeCard() {
        String theUserId = UserInfo.getUserId();
        User theCurrentUser = [SELECT Id, Name FROM User WHERE Id =: theUserId];
        List<Time_Card__c> theCurrentWeekData = new List<Time_Card__c>();
        List<Time_Card__c> thePreviousWeekData = new List<Time_Card__c>();
        List<Time_Card__c> theTimeCardList = [SELECT Id, Week_Start_Date__c, Hours_Logged__c, Opportunity__c, Opportunity__r.Name, Status__c, Name FROM Time_Card__c WHERE OwnerId =: theUserId];
        
        Date myDate = Date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        Date weekEnd = weekStart + 7;
        Date PreviousweekStart = weekStart - 7;
        Date PreviousweekEnd = weekStart;
        for(Time_Card__c theTimeCard : theTimeCardList) {
            
            if(theTimeCard.Week_Start_Date__c >= weekStart && theTimeCard.Week_Start_Date__c < weekEnd) {
                theCurrentWeekData.add(theTimeCard);
            }else if(theTimeCard.Week_Start_Date__c >= PreviousweekStart && theTimeCard.Week_Start_Date__c < PreviousweekEnd) {
                thePreviousWeekData.add(theTimeCard);
            }
            
        }
        
        Wrapper theWrap = new Wrapper();
        theWrap.theCurrentWeekTimeCard = theCurrentWeekData;
        theWrap.thePreviousWeekTimeCard = thePreviousWeekData;
        theWrap.theUser = theCurrentUser;
        return theWrap;
    }
    
    @AuraEnabled
    public static SelectWeekWrapper fetchSelectWeekTimeCard(String theStartDate) {
        String theUserId = UserInfo.getUserId();
        Date theSelectedDate = Date.valueOf(theStartDate);
        Date theWeekStartDate = theSelectedDate.toStartofWeek().addDays(1);
        Date theWeekEndDate = theWeekStartDate.addDays(7);
        
        List<Time_Card__c> theTimeCardList = [SELECT Id, Week_Start_Date__c, Hours_Logged__c, Opportunity__r.Name, Status__c, Name FROM Time_Card__c 
                                              WHERE OwnerId =: theUserId AND Week_Start_Date__c >=: theWeekStartDate AND Week_Start_Date__c <: theWeekEndDate];
        
        SelectWeekWrapper theWrapper = new SelectWeekWrapper();
        theWrapper.theSelectWeekTimeCardList = theTimeCardList;
        theWrapper.theStartDate = theWeekStartDate;
        theWrapper.theEndDate = theWeekEndDate;
        return theWrapper;
    }
    
    @AuraEnabled
    public static Time_Card__c fetchTimeCardforEdit(String theTimeCardId) {
        Time_Card__c theTimeCard = [SELECT Id, Week_Start_Date__c, Hours_Logged__c, Opportunity__r.Name, Status__c, Name FROM Time_Card__c 
                                    WHERE Id =: theTimeCardId];
        return theTimeCard;
    }
    
    @AuraEnabled
    public static void saveTimeCard(String theTimeCardstr) {
        Time_Card__c theTimeCard = (Time_Card__c)JSON.deserialize(theTimeCardstr, Time_Card__c.class);
        update theTimeCard;
    }
    
    @AuraEnabled
    public static void CopyPreviousCardData(String theTimeCardListstr) {
        
        Date myDate = Date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        
        List<Time_Card__c> theTimeCardList = (List<Time_Card__c>)JSON.deserialize(theTimeCardListstr, List<Time_Card__c>.class);
        List<Time_Card__c> theUpdatedTimeCardList = new List<Time_Card__c>();
        Map<Id, Time_Card__c> theOpp_TimeCardMap = new Map<Id, Time_Card__c>();
        
        List<Time_Card__c> theCurrentWeekTimeCard = fetchTimeCard().theCurrentWeekTimeCard;
        System.debug('theCurrentWeekTimeCard==>'+theCurrentWeekTimeCard);
        
        for(Time_Card__c theCurrentTC : theCurrentWeekTimeCard) {
            
            if(theCurrentTC.Opportunity__c != null) theOpp_TimeCardMap.put(theCurrentTC.Opportunity__c, theCurrentTC);
            
        }
        
        for(Time_Card__c theNewTC : theTimeCardList) {
            if(theOpp_TimeCardMap.containsKey(theNewTC.Opportunity__c)) {
                Time_Card__c theUpdatedTC = new Time_Card__c();
                theUpdatedTC.Id = theOpp_TimeCardMap.get(theNewTC.Opportunity__c).Id;
                theUpdatedTC.Hours_Logged__c = theNewTC.Hours_Logged__c;
                theUpdatedTimeCardList.add(theUpdatedTC);
            }else {
                Time_Card__c theUpdatedTC = new Time_Card__c();
                theUpdatedTC.Hours_Logged__c = theNewTC.Hours_Logged__c;
                theUpdatedTC.Opportunity__c = theNewTC.Opportunity__c;
                theUpdatedTC.Week_Start_Date__c = weekStart;
                theUpdatedTimeCardList.add(theUpdatedTC);
            }
        }
        
        if(!theUpdatedTimeCardList.isEmpty()) upsert theUpdatedTimeCardList;
    }
    
    public class Wrapper{
        @AuraEnabled 
        public List<Time_Card__c> theCurrentWeekTimeCard;
        @AuraEnabled 
        public List<Time_Card__c> thePreviousWeekTimeCard;
        @AuraEnabled 
        public User theUser;
    }
    
    public class SelectWeekWrapper{
        @AuraEnabled 
        public List<Time_Card__c> theSelectWeekTimeCardList;
        @AuraEnabled 
        public Date theStartDate;
        @AuraEnabled 
        public Date theEndDate;
    }
}