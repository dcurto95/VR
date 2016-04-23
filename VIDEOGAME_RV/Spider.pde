class Spider{
  public Net web;
  public PVector position; //Representa los indices de la matriz en el que esta la araña
  public PVector direccion; // Representa un vector de movimiento sobre la matriz
                                // (0,1): 
                                // (1,0):
                                // (0,-1):
                                // (-1,0):

  public Spider(Net netInfo){
    //Constructor
    position = new PVector(1.0, random(1,8));
    direccion = new PVector(1.0, 0.0);
    web = netInfo;
  }
  
  void display(){
    PVector pos = new PVector(0.0,0.0);
    pos = web.getPosition(position);
    pushMatrix();
    translate(width/2, height/2);
    fill(255,0,0);
    ellipse((int)pos.x, (int)pos.y, 50, 50);    
    popMatrix();  
  }
  
  void setPosition(PVector destination){
    position = destination;
  }
  
  void moveSpider(int option){
    switch(option){
      case 1:print("UP"); break;
      case 2:print("RIGHT"); break;
      case 3:print("DOWN"); break;
      case 4:print("LEFT"); break;
      default:break;
    }
  
  }





}