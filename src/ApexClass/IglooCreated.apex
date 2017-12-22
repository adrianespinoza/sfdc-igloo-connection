public class IglooCreated {
  public String userId;
    public String ndate;
    public IglooUser user;
    
    public String getNdate() {
        return IglooApiHelper.convertUnixTimestampToDateString(ndate);
    }
}