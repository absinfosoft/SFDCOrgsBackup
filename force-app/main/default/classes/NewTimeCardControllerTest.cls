/**********************************************************/
//Created by: Gram Bischof 04/07/2021
//Last Modified: Gram Bischof 04/07/2021
//Description:  Test class of NewTimeCardController.apxc
//Class : NewTimeCardControllerTest
/**********************************************************/
@istest
public class NewTimeCardControllerTest {
    
    @isTest
    public static void fetchOpportunityTest() {
        List<Opportunity> testOppList = new List<Opportunity>();
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'testOppName';
        testOpp.CloseDate = system.today();
        testOpp.StageName = 'Prospecting';
        testOppList.add(testOpp);
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'testOppName1';
        testOpp1.CloseDate = system.today();
        testOpp1.StageName = 'Prospecting';
        testOppList.add(testOpp1);
        insert testOppList;
        
        test.startTest();
        List<Opportunity> testReturnOppList = NewTimeCardController.fetchOpportunity('testOpp');
        test.stopTest();
        
        system.assertEquals(2, testReturnOppList.Size());
    }
    
    @isTest
    public static void updateWeekForWeekShiftZeroTest() {
        Date myDate = date.today();
        Date weekStart = myDate.toStartofWeek().addDays(1);
        String testExpectedResult = weekStart.format()+'-'+weekStart.addDays(7).format();
        test.startTest();
        String testReturnString = NewTimeCardController.updateWeek(0);
        test.stopTest();
        
        system.assertEquals(testExpectedResult, testReturnString);
    }
    
    @isTest
    public static void updateWeekForWeekShiftnotzeroTest() {
        Date myDate = date.today();
        Integer theWeekShift = 1;
        Date weekStart = myDate.toStartofWeek().addDays(1);
        Integer theTotalStartDays = theWeekShift * 7;
        Integer theTotalEndDays = (theWeekShift * 7) + 6;
        String testExpectedResult = weekStart.addDays(theTotalStartDays).format() +' - '+ weekStart.addDays(theTotalEndDays).format();
        
        test.startTest();
        String testReturnString = NewTimeCardController.updateWeek(theWeekShift);
        test.stopTest();
        
        system.assertEquals(testExpectedResult, testReturnString);
    }
    
    @isTest
    public static void fetchOppRecordTest() {
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'testOppName';
        testOpp.CloseDate = system.today();
        testOpp.StageName = 'Prospecting';
        insert testOpp;
        
        test.startTest();
        NewTimeCardController.Wrapper testWrapperReturn = NewTimeCardController.fetchOppRecord(testOpp.Id);
        test.stopTest();
        system.assertEquals(Userinfo.getUserId(), testWrapperReturn.theUser.Id);
    }
    
    @isTest
    public static void saveTimeCardForNonZeroTest() {
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'testOppName';
        testOpp.CloseDate = system.today();
        testOpp.StageName = 'Prospecting';
        insert testOpp;
        
        NewTimeCardController.Wrapper testWrapper = new NewTimeCardController.Wrapper();
        testWrapper.theOpp = testOpp;
        testWrapper.theHour = 50;
        testWrapper.theWeekShift = 1;
        String testJson = JSON.serialize(testWrapper);
        
        test.startTest();
        String testTimeCardId = NewTimeCardController.saveTimeCard(testJson);
        test.stopTest();
        
        Time_Card__c testTimeCard = [SELECT Id, Name FROM Time_Card__c];
        system.assertEquals(testTimeCardId, testTimeCard.Id);
    }
    
    @isTest
    public static void saveTimeCardForZeroTest() {
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'testOppName';
        testOpp.CloseDate = system.today();
        testOpp.StageName = 'Prospecting';
        insert testOpp;
        
        NewTimeCardController.Wrapper testWrapper = new NewTimeCardController.Wrapper();
        testWrapper.theOpp = testOpp;
        testWrapper.theHour = 50;
        testWrapper.theWeekShift = 0;
        String testJson = JSON.serialize(testWrapper);
        
        test.startTest();
        String testTimeCardId = NewTimeCardController.saveTimeCard(testJson);
        test.stopTest();
        
        Time_Card__c testTimeCard = [SELECT Id, Name FROM Time_Card__c];
        system.assertEquals(testTimeCardId, testTimeCard.Id);
    }
}