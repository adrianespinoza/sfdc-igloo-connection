public class JSON2BlogArticlesApex {
  public class Response {
    public String ntype;
    public Integer startIndex;
    public Integer count;
    public String totalCount;
    public List<IglooBlogArticle> items;
  }
    
  public Integer minRequestPeriod;
  public Object dictionary;
  public Response response;  
  
  public static JSON2BlogArticlesApex parse(String json) {
    return (JSON2BlogArticlesApex) System.JSON.deserialize(json, JSON2BlogArticlesApex.class);
  }
}