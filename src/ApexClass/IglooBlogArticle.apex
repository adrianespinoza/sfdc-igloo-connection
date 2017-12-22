public class IglooBlogArticle {
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

    public String getHref() {
        IglooSettings__c iglooSetttings = IglooSettings__c.getInstance();
        return iglooSetttings.communityurl__c + href;
    }
      
    public String getTitle() {
        return title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public String getContent() {
        return content;
    }
    
    public IglooCreated getCreated() {
        return created;
    }
}
