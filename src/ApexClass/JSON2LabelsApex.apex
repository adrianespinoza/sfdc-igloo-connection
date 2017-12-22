public class JSON2LabelsApex {
  public Integer minRequestPeriod;
  public Object dictionary;
  public Response response;

  public class Response {
    public String ntype;
    public Integer startIndex;
    public Integer count;
    public String totalCount;
    public List<IglooLabel> items;
  }

  
  public static JSON2LabelsApex parse(String json) {
    return (JSON2LabelsApex) System.JSON.deserialize(json, JSON2LabelsApex.class);
  }
}