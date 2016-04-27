public class Spider{
  public PVector position; //Representa los indices de la matriz en el que esta la araña
  public PVector direction; // Representa un vector de movimiento sobre la matriz (hacia donde esta mirando la araña)
                                //  (0,1): ir en sentido anti horario
                                //  (1,0): ir hacia fuera
                                // (0,-1): ir en sentido horario
                                // (-1,0): ir hacia dentro

  public PVector screenDestination;
  public PVector screenPosition;
  private int angle = 0;
  
  private float angleInScreen;
  public boolean isMoving;
  
  public Spider(PVector positionInMatrix){
    this.position = positionInMatrix;
    angle = 0;
    direction = new PVector(sin(radians(angle)), cos(radians(angle)));
    screenPosition = net.getNetPoint((int)position.x, (int)position.y).position.copy();
    screenDestination = screenPosition;
    isMoving = false;
    println("firstpos: "+position+ " first direct: "+direction);
      println("irst drawing at: "+screenPosition);
  }
  
  
  public void turnLeft(){
    if(!isMoving){
      println("lf");
      
      angle = angle + 90;
      direction = new PVector(sin(radians(angle)), cos(radians(angle)));
      /*if(net.get(position.x).get(position.y).type == 'D' ){
        turnRight();
      }*/
    }
  }
  
  public void turnRight(){
    if(!isMoving){
      println("righ");
      
      angle = angle - 90;
      direction = new PVector(sin(radians(angle)), cos(radians(angle)));
    /*if(net.get(position.x).get(position.y).type == 'D' ){
      turnLeftt();
    }*/
    }
  }
  
  public void updateSpiderPositionInScreen(){
    if(isMoving){
      if((PVector.sub(screenPosition, screenDestination)).mag() > 1){
        PVector sub = PVector.sub(screenDestination, screenPosition);
        sub.normalize();
        screenPosition.add(sub);
      }else{
        screenPosition = screenDestination;
        println("pos: "+position);
        //position.add(direction);
        //println("pos: "+position);
        isMoving = false;
      }
    }
  }
  
  
  public void goToNextPointForward(){
    if(!isMoving){
      println("forward");
      println("pos: "+position);
      
      isMoving = true;
      while(position.x<0){position.x = position.x + net.nRings;}
      while(position.y<0){position.y = position.y + 8;}
      position.y = position.y % 8;
      position.x = position.x % net.nRings;
      screenPosition = net.getNetPoint((int)(position.x),(int)(position.y)).position.copy();
      PVector nextPointIndex = PVector.add(position, direction);
       println("nextpos: "+nextPointIndex+" direc: "+direction);
     if(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      if(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % net.nRings;
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.copy();
      position=nextPointIndex.copy();
    }  
  }
  
  public void goToNextPointBackWards(){
    if(!isMoving){
      println("back");
      isMoving = true;
      println("pos: "+position);
      if(position.x<0){position.x = position.x + net.nRings;}
      if(position.y<0){position.y = position.y + 8;}
      position.y = position.y % 8;
      position.x = position.x % net.nRings;
      screenPosition = net.getNetPoint((int)position.x,(int)position.y).position.copy();
     /* PVector backDirection = direction.copy();
      backDirection.x = -backDirection.x;
      backDirection.y = -backDirection.y;*/
      
      PVector nextPointIndex = PVector.sub(position, direction);
      println("nextpos: "+nextPointIndex+" direc: "+direction);
      while(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      while(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % net.nRings;
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.copy();
      position=nextPointIndex.copy();
    }
  }
  
  public void drawSpider(){
    pushMatrix();
    rotate(radians(net.getAngleFrom2NetIndexes(position, PVector.add(position,direction))));
    rectMode(CENTER);
    fill(0,255,0);
   // translate(screenPosition.x, screenPosition.y);
   translate(width/2, height/2);
  // println("drawing at: "+screenPosition);
    rect(screenPosition.x, screenPosition.y,50,20);
    popMatrix();
    
  }
}