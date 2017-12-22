public class IglooStatistics {
  public Rating rating;
    public Views views;
    public Contents contents;
    public Integer subscribed;
    
    public class Rating {
    public Integer votes;
    public Integer average;
    public Integer sum;
  }
    
    public class Views {
    public Integer views;
    public Integer downloads;
  }
    
    public class Contents {
    public Integer comments;
    public Integer children;
  }
}