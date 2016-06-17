public class Point{
  public char type;//'E':enabled, 'D':disabled, 'S':shortway
  public PVector position;
  
  public Point(char type, PVector position){
    this.type = type;
    this.position = position;
  }
  
 public void setPointDisabled(){
    this.type='D';
  }
  
  public void setPointEnabled(){
    this.type='E';
  }
  
}