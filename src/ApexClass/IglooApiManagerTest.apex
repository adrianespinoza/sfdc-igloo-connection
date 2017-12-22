@isTest(seeAllData=true)
public class IglooApiManagerTest {
  static testMethod void myTest() {
        Test.startTest();
        // This causes a fake response to be generated
        Test.setMock(HttpCalloutMock.class, new WebServiceMockImplTest());
        
      IglooApiManager testManager = new IglooApiManager('av.espinoza@gmail.com', 'test123', 'https://aveh.igloocommunities.com');
        testManager.getCategories();
        testManager.apiGetCategoryLabels('123456');
        testManager.searchApplication('368752');
        testManager.apiGetWikiArticles('12asd-sdf1232a-asdfrtye789sd-dsfg');
        testManager.apiGetBlogArticles('12asd-sdf1232a-asdfrtye789sd-dsfg');
        testManager.doRequest('https://developer.salesforce.com/docs/', 'GET');
        Test.stopTest();
    }
}