public class IglooCategory {
  public String n_type;
    public String id;
    public String href;
    public Integer navType;
    public String name;
    
    public List<IglooLabel> labels = new List<IglooLabel>();
    
    public String getName() {
        return name;
    }
    
    public String getId() {
        return id;
    }
    
    public List<IglooLabel> getLabels() {
        return labels;
    }
}