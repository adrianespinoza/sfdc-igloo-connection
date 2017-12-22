public class IglooItem {
  public String ntype;
    public String id;
    public String href;
    public Integer navType;
    public Boolean IsArchived;
    public Boolean IsScheduledForArchiving;
    public Object SpaceId;
    /*public String commentprivileges;*/
    public String title;
    public String name;
    public String content;
    public String description;
    public IglooCreated created;
    public IglooCreated modified;
    public String parentHref;
    public String parentId;
    public IglooStatistics statistics;
    public Boolean isPublished;
    public IglooPublished published;
    
    /*public Integer commentPrivileges;*/
    public String articleSummary;
    public String articleBody;    
    public Integer version;/*Wiki*/
    
    public String fileExtension;
    public Integer imageHeight;
    public Integer imageWidth;
    public Boolean isImage;
    public String mimeType;
    public Integer size;
    public Integer versionId;    
    
    public String ClassID;/*label*/
    
    public String getId() {
        return id;
    }
    
    public String getHref() {
        IglooSettings__c iglooSetttings = IglooSettings__c.getInstance();
        
        String partialHref = ((ntype.indexOf('Document') > -1) ? ('/download' + href + '?attachment=0') : href);         
        String realHref = iglooSetttings.communityurl__c + partialHref;
        
        return realHref;
    }
      
    public String getTitle() {
        return title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public String getContent() {
        Integer imgIndex = content.indexOf('<img');
        
        if (imgIndex > -1) {
            IglooSettings__c iglooSetttings = IglooSettings__c.getInstance();
            
            String regex = '/download/.attachments/';
            String replacement = iglooSetttings.communityurl__c + regex;
            
            if (content.indexOf(replacement) == -1) {
              content = content.replaceAll(regex, replacement);
            }
        }
        
        return content;
    }
    
    public IglooCreated getCreated() {
        return created;
    }
}