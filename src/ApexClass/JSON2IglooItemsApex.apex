public class JSON2IglooItemsApex {
  public class Response {
    public String ntype;
    public Integer startIndex;
    public Integer count;
    public String totalCount;
    public List<IglooItem> items;
  }
    
  public Integer minRequestPeriod;
  public Object dictionary;
  public Response response;  
  
  public static JSON2IglooItemsApex parse(String json) {
    return (JSON2IglooItemsApex) System.JSON.deserialize(json, JSON2IglooItemsApex.class);
  }
}