@isTest(seeAllData=true)
public class IglooControllerTest {
  public static testMethod void testRatingChangeAndSave() { 
        Account acct = new Account(name='Test');
        insert acct;
        List<Opportunity> childOpps = new List<Opportunity>();
        for (Integer i = 0; i < 4; i++) {
          childOpps.add(new Opportunity( AccountId=acct.Id, Name='Test Opp' + i, StageName='Prospecting', CloseDate=Date.Today()));
        }
        childOpps[0].StageName = 'Closed Won'; 
        childOpps[1].StageName = 'Closed Lost'; 
        insert childOpps;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMockImplTest());
        ApexPages.StandardController std = new ApexPages.standardController(childOpps[0]);
        IglooController sce = new IglooController(std);
        
        String opportunityDeliveryStatus = sce.opportunityDeliveryStatus;
        String mainCompetitors = sce.mainCompetitors;
        
        sce.getCategories();
        sce.getBlogArticles();
        sce.getDocuArticles();
        sce.getOpportunityStage();
        sce.getWikiArticles();
        
        List<IglooLabel> labels = new List<IglooLabel>();
        IglooLabel lbl = new IglooLabel();
        lbl.id = '123';
        lbl.name = 'test label';
        
        labels.add(lbl);
        
        sce.getLabelIds('test label', labels);
        Test.stopTest();
    }
}