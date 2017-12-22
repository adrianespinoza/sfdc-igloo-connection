/**
 * Igloo Controller class. Provide methods and properties that is used in the apex page
 * @author Adrian Espinoza
 *
 */
public class IglooController {
    private final ApexPages.StandardController controller;
    private List<IglooItem> blogArticles = new List<IglooItem>();
    private List<IglooItem> wikiArticles = new List<IglooItem>();
    private List<IglooItem> docuArticles = new List<IglooItem>();    
    
    private Opportunity sourceOpportunity;
    private String opportunityStage;
    
    private String opportunityDeliveryStatusLocal;
    private String mainCompetitorsLocal;
    private boolean hasCredentialsLocal;
    private String noCredentialsMessageLocal;
    
    public String opportunityDeliveryStatus {
        get { return opportunityDeliveryStatusLocal; }
        set { opportunityDeliveryStatusLocal = value; }
    }
    
    public String mainCompetitors {
        get { return mainCompetitorsLocal; }
        set { mainCompetitorsLocal = value; }
    }
    
    public boolean hasCredentials {
        get { return hasCredentialsLocal; }
        set { hasCredentialsLocal = value; }
    }
    
    public String noCredentialsMessage {
        get { return noCredentialsMessageLocal; }
        set { noCredentialsMessageLocal = value; }
    }
    
    public String base64Value { 
        get { return base64Value; }
        set {base64Value = value;}
    }
    
    private List<IglooCategory> categories = new List<IglooCategory>();
    
    DateTime t1;
    transient DateTime t2;

    public String getT1() {
        if (t1 == null) t1 = System.now();
        return '' + t1;
    }

    public String getT2() {
        if (t2 == null) t2 = System.now();
        return '' + t2;
    }
    
    /**
     * Default constructor.
     */
    public IglooController() {
    }
    
    /**
     * Custom controller.
     * @param controller The opportunity object controller.
     */
    public IglooController(ApexPages.StandardController controller) {
        this.controller = controller;
        
        try {            
            noCredentialsMessage = 'IGLOO credentials';
            IglooSettings__c iglooSetttings = IglooSettings__c.getInstance();
            IglooApiManager iglooApiManager = createIglooConnection(iglooSetttings);
            
            if ((iglooApiManager != null) && (iglooApiManager.isConnected)) {
                Sobject record = controller.getRecord();
                sourceOpportunity = [select id, StageName, DeliveryInstallationStatus__c, MainCompetitors__c from Opportunity where id = :record.Id limit 1];
                
                opportunityStage = sourceOpportunity.StageName;//label name
                opportunityDeliveryStatus = sourceOpportunity.DeliveryInstallationStatus__c;
                mainCompetitors = sourceOpportunity.MainCompetitors__c;
                
                loadSections(iglooApiManager, iglooSetttings);
                
                /*getting categories*/
                categories = iglooApiManager.getCategories();
                for (IglooCategory cat : categories) {
                    cat.labels = iglooApiManager.apiGetCategoryLabels(cat.id);
                }
                
                Blob base64Value3 = iglooApiManager.apiGetBinaryDocument('b04f2786-dbc1-4cbd-bd84-a9ec43f8a405');
                base64Value = base64Value3 + '';
            }
        } catch (Exception e) {
            noCredentialsMessage = e + '';
        }        
    }
    
    /**
     * Gets a list of Igloo categories.
     * @return A list of categories.
     */
    public List<IglooCategory> getCategories() {
        return categories;
    }
    
    /**
     * Gets a list of Igloo blog articles.
     * @return A list of blog articles.
     */
    public List<IglooItem> getBlogArticles() {
        return blogArticles;
    }
    
    /**
     * Gets a list of Igloo wiki articles.
     * @return A list of wiki articles.
     */
    public List<IglooItem> getWikiArticles () {
        return wikiArticles;
    }
    
    /**
     * Gets Igloo documents.
     * @return A list of documents as articles.
     */
    public List<IglooItem> getDocuArticles () {
        return docuArticles;
    }
        
    /**
     * Gets the opportunity stage field value.
     * @return A stage value.
     */
    public String getOpportunityStage() {
        return opportunityStage;
    }
    
    /**testing for the blog articles*/
    public String itemId {get; set;}
    public IglooItem itemDetail {get; set;}
    public boolean detailMode {get; set;}
    public PageReference processLinkClick() {
        detailMode = true;
        boolean wasFound = false;
        for (IglooItem item : blogArticles) {
            if (item.id == itemId) {
                itemDetail = item;
                wasFound = true;
                break;
            }
        }
        
        if (!wasFound) {
           for (IglooItem item : wikiArticles) {
            if (item.id == itemId) {
                itemDetail = item;
                wasFound = true;
                break;
            }
        } 
        }
        
        return null;
    }
    public PageReference goBackLinkClick() {
        detailMode = false;
        return null;
    }
    
    /**
     * Gets an Igloo label id.
     * @param labelName The label name to seek.
     * @param labels The list of labels available in Igloo.
     * @return A label id.
     */
    @TestVisible private String getLabelIds(String labelName, List<IglooLabel> labels) {
        String ids;
        if (labels != null) {
            for (IglooLabel label : labels) {
                if (label.name == labelName) {
                    ids = label.id;
                    break;
                }
            }
        }
        
        return ids;
    }
    
    /**
     * Creates a Igloo connection based on settings. 
     * @param iglooSetttings The custom setting that contains all Igloo user information.
     * @return A manger.
     */
    private IglooApiManager createIglooConnection(IglooSettings__c iglooSetttings) {
        hasCredentials = ((iglooSetttings != null) && (iglooSetttings.username__c != null) && (iglooSetttings.password__c != null));
        
        IglooApiManager iglooApiManager;
        
        if (hasCredentials) {            
            String username = iglooSetttings.username__c;
            String password = iglooSetttings.password__c;
            String communityUrl = iglooSetttings.communityurl__c;
            
            password = IglooCryptoMethod.decryptText(password);
            
            iglooApiManager = new IglooApiManager(username, password, communityUrl);
        }
        
        return iglooApiManager;
    }
    
    /**
     * Loads all sections based on settings and connection.
     * @param iglooApiManager The manager to get data from Igloo.
     * @param iglooSetttings he custom setting that contains all Igloo user information.
     */
    private void loadSections(IglooApiManager iglooApiManager, IglooSettings__c iglooSetttings) {
        List<IglooLabel> labels;
        String category;
        if (opportunityStage != null) {
            labels = iglooApiManager.apiGetCategoryLabels(iglooSetttings.bloglabelgroupid__c);/*'53689'*/
            category = getLabelIds(opportunityStage, labels);
            if (category != null) {
                blogArticles = iglooApiManager.searchApplication(category);
            }                
        }
        
        if (opportunityDeliveryStatus != null) {
            labels = iglooApiManager.apiGetCategoryLabels(iglooSetttings.wikilabelgroupid__c);/*'53923'*/
            category = getLabelIds(opportunityDeliveryStatus, labels);
            if (category != null) {
                wikiArticles = iglooApiManager.searchApplication(category);                    
            }
        }
        
        if (mainCompetitors != null) {
            labels = iglooApiManager.apiGetCategoryLabels(iglooSetttings.filelabelgroupid__c);/*'53925'*/
            category = getLabelIds(mainCompetitors, labels);
            if (category != null) {
                docuArticles = iglooApiManager.searchApplication(category);                    
            }
        }
    }
}