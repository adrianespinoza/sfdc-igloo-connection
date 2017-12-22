public class IglooUser {
  public String id;
    public String href;
    public Integer navType;
    public Name name;
    public String namespace;
    public Boolean isActivated;
    public Onlinestatus onlinestatus;
    public Status status;
    public String anonymousname;
    public Boolean hasPhoto;
    
    public class Name {
    public String firstName;
    public String lastName;
    public String fullName;
  }
    
    public class Onlinestatus {
    public String lastvisit;
    public String statusText;
  }
    
    public class Status {
  }
}