/**
 * Igloo API Manager class. Provides methods to connect to Igloo and to get data from it.
 * @author Adrian Espinoza
 *
 */
public class IglooApiManager {
    private Map<string, string> iglooSessionInfo = new Map<string, string>();
    
    private String username;
    private String password;
    private String community;
        
    private String baseUrl;
    
    /*Igloo paths*/    
    private String authApiMethod = '/session/create';
    private String categoryPath = '/categories/classes/view';
    private String blogArticlesPath = '/blogchannels/{blogChannelId}/blogarticles/view';
    private String labelsApiMethod = '/categories/classes/{categoryId}/viewCategories';
    private String searchApiMethod = '/objects/search';
    private String objectChildrenPath = '/objects/{objectId}/children';
    private String binaryDocumentPath = '/documents/{documentId}/view_binary';
    private String documentPath = '/documents/{documentId}/view';    
    
    public boolean isConnected { 
        get { return isConnected; }
        set {isConnected = value;}
    }
    
    /**
     * Custom constructor.
     * @param username The Igloo username.
     * @param password The Igloo password.
     * @param communityUrl The Igloo community url.
     */
    public IglooApiManager(String username, String password, String communityUrl) {
        this.username = username;
        this.password = password;        
        this.community = communityUrl.replace('https://', '');        
        this.baseUrl = communityUrl + '/.api/api.svc';
        
        isConnected = connectToIgloo();
    }
    
    /**
     * Connects to Igloo site.
     * @return
     */
    private boolean connectToIgloo(){
        try {            
            String endpoint = makeAuthUrl();
            endpoint = IglooApiHelper.urlEncode(endpoint);
            
            String bodyParameters = 'appId=' + IglooConstants.API_ID + 
                '&appPass=' + IglooConstants.API_PASS + 
                '&username=' + EncodingUtil.urlEncode(username, IglooConstants.ENCODING_SCHEME) + 
                '&password=' + EncodingUtil.urlEncode(password, IglooConstants.ENCODING_SCHEME) + 
                '&community=' + community + 
                '&apiVersion=' + IglooConstants.API_VERSION;
                        
            HttpRequest req = new HttpRequest();                        
            req.setEndpoint(endpoint);
            req.setMethod('POST');            
            req.setHeader('content-length', '0');            
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');         
            req.setbody(bodyParameters);
            
            // Specify the required user name and password to access the endpoint
            // As well as the header and header information        
            
            //Blob headerValue = Blob.valueOf(username + ':' + password);
            //String authorizationHeader = 'BASIC ' +  EncodingUtil.base64Encode(headerValue);
            //req.setHeader('Authorization', authorizationHeader);
            
            // Create a new http object to send the request object
            // A response object is generated as a result of the request  
            
            Http httpProtocol = new Http();            
            HttpResponse response = httpProtocol.send(req);
                        
            iglooSessionInfo = IglooApiHelper.parseIglooSessionInfoToMap(response);
            
            System.debug('iglooSessionInfo: ' + iglooSessionInfo);         
            return (response.getStatusCode() == 200);
        } catch (Exception e) {
            System.debug(e);
            return false;
        }        
    }
    
    /**
     * Gets the categories from Igloo site.    
     * @return A list of categories.
     */
    public List<IglooCategory> getCategories() {
        try {
            String uri = baseUrl + categoryPath;            
            String json = doRequestWithParams(uri, IglooConstants.GET_METHOD);       
            
            JSON2CategoryApex categories = JSON2CategoryApex.parse(json);
            System.debug('categories: ' + categories);
            return categories.response.items;
        } catch (Exception e) {
            System.debug(e);
            return null;
        }        
    }
    
    /**
     * Gets Igloo blog articles based on channel id.
     * @param blogChannelId The blog channel id.
     * @return A list of blog articles.
     */
    public List<IglooBlogArticle> apiGetBlogArticles(String blogChannelId) {
        try {
            String uri = baseUrl + blogArticlesPath.replace('{blogChannelId}', blogChannelId);                       
            String json = doRequestWithParams(uri, IglooConstants.GET_METHOD);
                        
            JSON2BlogArticlesApex blogArticles = JSON2BlogArticlesApex.parse(json);        
            
            return blogArticles.response.items;            
        } catch (Exception e) {
            System.debug('Blog Error: ' + e);
            return null;
        }
    }
    
    /**
     * Gets Igloo labels for a specific category.
     * @param categoryId The category id.
     * @return A list of labels.
     */
    public List<IglooLabel> apiGetCategoryLabels(String categoryId) {
        try {//test categoryId = '53689'     
            String uri = IglooApiHelper.makeUriWithKey(baseUrl, labelsApiMethod, 'categoryId', categoryId, iglooSessionInfo);                               
            String json = doRequest(uri, IglooConstants.GET_METHOD);
            
            JSON2LabelsApex labels = JSON2LabelsApex.parse(json);
            
            return labels.response.items;
        } catch (Exception e) {
            System.debug('Label Error: ' + e);
            return null;
        }
    }
    
    /**
     * Gets any Igloo information using a category.
     * @param category The category to seek.
     * @return A list of Igloo information.
     */
    public List<IglooItem> searchApplication(String category) {        
        List<IglooItem> iglooData = new List<IglooItem>();
        try {
            String criteria = '';
            String queryParams = 'criteria=' + criteria +
                '&category=' + category;//'368752';
            
            String uri = baseUrl + searchApiMethod + '?' + queryParams;             
            String json = doRequestWithParams(uri, IglooConstants.GET_METHOD);
            System.debug('json: ' + json);
            JSON2IglooItemsApex blogArticles = JSON2IglooItemsApex.parse(json);        
            
            return blogArticles.response.items;
        } catch (Exception e) {
            System.debug('Search Error: ' + e);
            return null;
        }
    }
    
    /**
     * Gets Igloo wiki articles from a specific wiki channel.
     * @param wikiChannelId The wiki channel id to be used in the request.
     */
    public void apiGetWikiArticles(String wikiChannelId) {
        try {
            String queryParams = 'orderBy=CreatedDesc&maxcount=100&startindex=0';
            String uri = baseUrl + objectChildrenPath.replace('{objectId}', wikiChannelId) + '?' + queryParams;
            String json = doRequestWithParams(uri, IglooConstants.GET_METHOD);
            System.debug('WIKI - json: ' + json);
        } catch (Exception e) {
            System.debug('Search Error: ' + e);
        }
    }
    
    /**
     * Retrieve information about the document with the specified identifier.
     * @param documentId The GUID identifying the requested document.
     */
    public void apiGetDocument(String documentId) {
        try {
            String uri = baseUrl + documentPath.replace('{documentId}', documentId);                       
            String json = doRequestWithParams(uri, IglooConstants.GET_METHOD);
                        
      System.debug('Document json: ' + json);                        
        } catch (Exception e) {
            System.debug('Blog Error: ' + e);
        }
    }
    
    /**
     * Retrieves all or part of the binary associated with the document identified by the given guid..
     * @param documentId The identifier of the document whose binary you are requesting.
     */
    public Blob apiGetBinaryDocument(String documentId) {
        try {
            System.debug('Binary Document');
            String uri = baseUrl + binaryDocumentPath.replace('{documentId}', documentId);                       
            Blob resFile = doRequestWithParams2(uri, IglooConstants.GET_METHOD);
            
            /*Document doc = new Document();
            doc.name = 'logo.docx';
            doc.body = resFile;
            doc.folderId = UserInfo.getUserId();
            //insert d;*/
            
            return resFile;
        } catch (Exception e) {
            System.debug('Blog Error: ' + e);
            return null;
        }
    }
    
    /**
     * Request method that helps to do queries in a easy way.
     * @param uri The request uri.
     * @param method The request method.
     * @return A json response as string.
     */
    private String doRequestWithParams(String uri, String method) {
        try {
            Long nonce = IglooApiHelper.generateNonce();
            uri = IglooApiHelper.attachSession(uri, method, iglooSessionInfo.get(IglooConstants.SESSION_KEY), nonce, iglooSessionInfo.get(IglooConstants.SECRET_KEY));
            
            HttpRequest req = new HttpRequest();                        
            req.setEndpoint(uri);
            req.setMethod(method);
            req.setHeader('Accept', 'application/json');
            
            Http httpProtocol = new Http();            
            HttpResponse response = httpProtocol.send(req);
            
            System.debug('response: ' + response);
            
            String json = response.getBody();
            json = json.replace('"date":"', '"ndate":"');
            json = json.replace('"__type":"', '"ntype":"');
            
            return json;            
        } catch (Exception e) {
            System.debug('Request Error: ' + e);
            return null;
        }
    }
    
    /**
     * Request method that helps to do queries in a easy way.
     * @param uri The request uri.
     * @param method The request method.
     * @return A json response as string.
     */
    private Blob doRequestWithParams2(String uri, String method) {
        try {
            Long nonce = IglooApiHelper.generateNonce();
            uri = IglooApiHelper.attachSession(uri, method, iglooSessionInfo.get(IglooConstants.SESSION_KEY), nonce, iglooSessionInfo.get(IglooConstants.SECRET_KEY));
            
            HttpRequest req = new HttpRequest();                        
            req.setEndpoint(uri);
            req.setMethod(method);
            
            Http httpProtocol = new Http();            
            HttpResponse response = httpProtocol.send(req);
            
            System.debug('response: ' + response);
            System.debug(response.getBodyAsBlob());
            
            Blob fileAsBlob = response.getBodyAsBlob();
            /*blob image = response.getBodyAsBlob();
            Document d = new Document();
            d.name = 'logo.docx';
            d.body = image;
            d.folderId = UserInfo.getUserId();
            insert d;
            system.debug(d); 
            system.debug(d.id);*/
            return fileAsBlob;            
        } catch (Exception e) {
            System.debug('Request Error: ' + e);
            return null;
        }
    }
    
    /**
     * Request method that helps to do queries in a easy way.
     * @param uri The request uri.
     * @param method The request method.
     * @return A json response as string.
     */
    @TestVisible
    private String doRequest(String uri, String method) {
        try {
            HttpRequest req = new HttpRequest();                       
            req.setEndpoint(uri);
            req.setMethod(method);
            req.setHeader('Accept', 'application/json');
            
            Http httpProtocol = new Http();            
            HttpResponse response = httpProtocol.send(req);
            
            String json = response.getBody();
            json = json.replace('"date":"', '"ndate":"');
            json = json.replace('"__type":"', '"ntype":"');
            
            return json;
        } catch (Exception e) {
            System.debug('Request Error: ' + e);
            return null;
        }
    }
    
    /**
     * Helper method that return and endpoint url for authentication.
     * @return A authentication url.
     */
    private String makeAuthUrl() {
        String endpoint = baseUrl + authApiMethod;        
        return endpoint;
    }
}