import sprites.*;

public class Spider{
  public PVector position; //Representa los indices de la matriz en el que esta la araña
  public PVector direction; // Representa un vector de movimiento sobre la matriz (hacia donde esta mirando la araña)
                                //  (0,1): ir en sentido anti horario
                                //  (1,0): ir hacia fuera
                                // (0,-1): ir en sentido horario
                                // (-1,0): ir hacia dentro
 
  public PVector screenDestination;
  public PVector screenPosition;
  private float angle = 0;
  private float angleInScreen;
  public boolean isMoving;
  public Sprite spiderSprite;
  
  
  public Spider(PVector positionInMatrix, PApplet thePApplet){
    this.position = positionInMatrix;
    angle = 0;
    direction = new PVector(sin(radians(angle)), cos(radians(angle)));
    screenPosition = net.getNetPoint((int)position.x, (int)position.y).position.get();
    screenDestination = screenPosition;
    isMoving = false;
    spiderSprite = new Sprite(thePApplet, "images/spider.png", 7, 4, 0);
    
    println("firstpos: "+position+ " first direct: "+direction);
    println("irst drawing at: "+screenPosition);
  }
  
  public void turnLeft(){
    if(!isMoving){
      println("lf");
      angle = angle + PI/2;//90;
      direction = new PVector(sin(/*radians(*/angle/*)*/), cos(/*radians(*/angle/*)*/));
      if(abs(direction.x)<0.1) direction.x=0;
      if(abs(direction.y)<0.1) direction.y=0;
      println(direction);
    }
  }
  
  public void turnRight(){
    if(!isMoving){
      println("righ");
      angle = angle - PI/2;
      direction = new PVector(sin(angle), cos(angle));
    if(abs(direction.x)<0.1) direction.x=0;
    if(abs(direction.y)<0.1) direction.y=0;
    println(direction);
    }
  }
  
  public void updateSpiderPositionInScreen(){
    if(isMoving){
      if((PVector.sub(screenPosition, screenDestination)).mag() > 1){
        PVector sub = PVector.sub(screenDestination, screenPosition);
        sub.normalize();
        screenPosition.add(sub);
        S4P.updateSprites(0.01f);      
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
      screenPosition = net.getNetPoint((int)(position.x),(int)(position.y)).position.get();
      PVector nextPointIndex = PVector.add(position, direction);
      println("nextpos: "+nextPointIndex+" direc: "+direction);
     if(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      if(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % (net.nRings+1);
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.get();
      position=nextPointIndex.get();
      if(net.isShortcut((int)nextPointIndex.x,(int)nextPointIndex.y)){
        direction.x = -direction.x;
        direction.y = -direction.y;
        println("new dir "+direction);
        position = net.getShortcutDestIndexes((int)nextPointIndex.x,(int)nextPointIndex.y);
      }
    }
  }
  
  public void goToNextPointBackWards(){
    spiderSprite.setFrameSequence(7, 11,0.03f);
    if(!isMoving){
      println("back");
      isMoving = true;
      println("pos: "+position);
      if(position.x<0){position.x = position.x + net.nRings;}
      if(position.y<0){position.y = position.y + 8;}
      position.y = position.y % 8;
      position.x = position.x % net.nRings;
      screenPosition = net.getNetPoint((int)position.x,(int)position.y).position.get();
     
      PVector nextPointIndex = PVector.sub(position, direction);
      println("nextpos: "+nextPointIndex+" direc: "+direction);
      while(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      while(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % (net.nRings+1);
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.get();
      position=nextPointIndex.get();
      if(net.isShortcut((int)nextPointIndex.x,(int)nextPointIndex.y)){
        direction.x = -direction.x;
        direction.y = -direction.y;
        position = net.getShortcutDestIndexes((int)nextPointIndex.x,(int)nextPointIndex.y);
      }
    }
  }
  
  public void drawSpider(){
    
    pushMatrix();
    translate(width/2, height/2);
    rectMode(CENTER);    
    rotate(radians(net.getAngleFrom2NetIndexes(position, PVector.add(position,direction))));
    fill(255,0,0);
    rect(screenPosition.x, screenPosition.y,50,20);
    //spiderSprite.setXY(screenPosition.x,screenPosition.y);
    //spiderSprite.draw();
    popMatrix();
    
    
  }
}
