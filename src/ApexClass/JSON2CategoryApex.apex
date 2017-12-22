global class JSON2CategoryApex {
  public Integer minRequestPeriod;
    public Object dictionary;
    public Response response;
    
    public class Response {
        public String n_type;
        public Integer startIndex;
        public Integer count;
        public String totalCount;
        public List<IglooCategory> items;
    }        
    
    global static JSON2CategoryApex parse(String json) {
        return (JSON2CategoryApex) System.JSON.deserialize(json, JSON2CategoryApex.class);
    }
}