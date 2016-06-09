import sprites.*;

public class Spider{
  public PVector indexPosition; //Representa los indices de la matriz en el que esta la araña
  public PVector direction; // Representa un vector de movimiento sobre la matriz (hacia donde esta mirando la araña)
                                //  (0,1): ir en sentido anti horario
                                //  (1,0): ir hacia fuera
                                // (0,-1): ir en sentido horario
                                // (-1,0): ir hacia dentro
 
  public PVector screenDestination;
  public PVector screenPosition;
  private float angle = 0; //se usa para calcular la direccion en la que se mueve la araña
  private float angleInScreen;
  private boolean goingForward; //true si va hacia delante, false si va hacia atras (solo hacerle caso si isMoving=true)
  
  public boolean isMoving;
  public Sprite spiderSprite;
  
  
  public Spider(PVector positionInMatrix, PApplet thePApplet){
    this.indexPosition = positionInMatrix;
    angle = 0;
    direction = new PVector(sin(radians(angle)), cos(radians(angle)));
    screenPosition = net.getNetPoint((int)indexPosition.x, (int)indexPosition.y).position.get();
    screenDestination = screenPosition;
    isMoving = false;
    spiderSprite = new Sprite(thePApplet, "images/spider.png", 7, 4, 0);

    spiderSprite.setScale(3.5);
    
    //println("firstpos: "+position+ " first direct: "+direction);
    //println("irst drawing at: "+screenPosition);
    
  }
  
  public void turnLeft(){
    if(!isMoving){
      //println("lf");
      angle = angle + PI/2;//90;
      direction = new PVector(sin(/*radians(*/angle/*)*/), cos(/*radians(*/angle/*)*/));
      if(abs(direction.x)<0.5) direction.x=0;
      if(abs(direction.y)<0.5) direction.y=0;
      if(direction.x>0.5) direction.x=1;
      if(direction.x<-0.5) direction.x=-1;
      if(direction.y>0.5) direction.y=1;
      if(direction.y<-0.5) direction.y=-1;
      
   //   println("Dir: "+direction);

    }
  }
  
  public void turnRight(){
    if(!isMoving){
   //   println("righ");
      angle = angle - PI/2;
      direction = new PVector(sin(angle), cos(angle));
    if(abs(direction.x)<0.1) direction.x=0;
    if(abs(direction.y)<0.1) direction.y=0;
    if(direction.x>0.5) direction.x=1;
    if(direction.x<-0.5) direction.x=-1;
    if(direction.y>0.5) direction.y=1;
    if(direction.y<-0.5) direction.y=-1;
  //  println("Dir: "+direction);

    }
  }
  
  public void updateSpiderPositionInScreen(){
    if(isMoving){
      if((PVector.sub(screenPosition, screenDestination)).mag() > 1){
        PVector sub = PVector.sub(screenDestination, screenPosition);
        sub.normalize();
        sub.mult(1.5);
        screenPosition.add(sub);
        S4P.updateSprites(0.9f);      
      }else{
        screenPosition = screenDestination;
   //    println("pos: "+indexPosition);
        //indexPosition.add(direction);
        //println("pos: "+indexPosition);
        spiderSprite.setFrameSequence(7, 7,0.9f);
        S4P.updateSprites(0.9f); 
        isMoving = false;
        net.reactivateNetPointAtScreenPosition(screenPosition);
      
      }
    }
    
  }
  
  public void goToNextPointForward(){
    spiderSprite.setFrameSequence(7, 11,0.2f);
    if(!isMoving){
      //println("forward");
      //println("pos: "+indexPosition);
      net.reactivateNetPointAtScreenPosition(screenPosition);
      isMoving = true;
      goingForward = true;
      while(indexPosition.x<0){indexPosition.x = indexPosition.x + net.nRings;}
      while(indexPosition.y<0){indexPosition.y = indexPosition.y + 8;}
      indexPosition.y = indexPosition.y % 8;
      indexPosition.x = indexPosition.x % net.nRings;
      screenPosition = net.getNetPoint((int)(indexPosition.x),(int)(indexPosition.y)).position.get();
      PVector nextPointIndex = PVector.add(indexPosition, direction);
      // println("nextpos: "+nextPointIndex+" direc: "+direction);

     if(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      if(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % (net.nRings+1);
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.get();
      indexPosition=nextPointIndex.get();
      if(net.isShortcut((int)nextPointIndex.x,(int)nextPointIndex.y)){
        direction.x = -direction.x;
        direction.y = -direction.y;

        //println("new dir "+direction);
        indexPosition = net.getShortcutDestIndexes((int)nextPointIndex.x,(int)nextPointIndex.y);
      }
    }
 //   println("Dir "+direction);
  }
  
  public void goToNextPointBackWards(){
    spiderSprite.setFrameSequence(7, 11,0.03f);
    if(!isMoving){
      //println("back");
      net.reactivateNetPointAtScreenPosition(screenPosition);
      isMoving = true;
      goingForward = false;
      
      println("pos: "+indexPosition);
      if(indexPosition.x<0){indexPosition.x = indexPosition.x + net.nRings;}
      if(indexPosition.y<0){indexPosition.y = indexPosition.y + 8;}
      indexPosition.y = indexPosition.y % 8;
      indexPosition.x = indexPosition.x % net.nRings;
      screenPosition = net.getNetPoint((int)indexPosition.x,(int)indexPosition.y).position.get();
     
      PVector nextPointIndex = PVector.sub(indexPosition, direction);
     // println("nextpos: "+nextPointIndex+" direc: "+direction);

      while(nextPointIndex.x<0){nextPointIndex.x = nextPointIndex.x + net.nRings;}
      while(nextPointIndex.y<0){nextPointIndex.y = nextPointIndex.y + 8;}
      nextPointIndex.y = nextPointIndex.y % 8;
      nextPointIndex.x = nextPointIndex.x % (net.nRings+1);
      screenDestination = net.getNetPoint((int)nextPointIndex.x,(int)nextPointIndex.y).position.get();
      indexPosition=nextPointIndex.get();
      if(net.isShortcut((int)nextPointIndex.x,(int)nextPointIndex.y)){
        direction.x = -direction.x;
        direction.y = -direction.y;
        indexPosition = net.getShortcutDestIndexes((int)nextPointIndex.x,(int)nextPointIndex.y);
      }
    }
  }
  
  public void drawSpider(){
   if(!isMoving){
    
       angleInScreen = net.getAngleFrom2NetIndexes(indexPosition, PVector.add(indexPosition,direction));
    }else{
       PVector dest = PVector.sub(screenDestination,screenPosition);
       angleInScreen = degrees(dest.heading());   
    }
    pushMatrix();

   // println("Angle Spider: "+angle);
    translate(width/2+screenPosition.x, (height+150)/2+screenPosition.y);
    if(isMoving && !goingForward){
      rotate(radians(angleInScreen));//-90)); //+180 solo si va hacia delante, sino no
    }else{
      rotate(radians(angleInScreen+180));
    }
    rectMode(CENTER);
    fill(0,255,0);
    spiderSprite.setXY(0,0);//screenPosition.x,screenPosition.y);
    spiderSprite.draw();
    popMatrix();
 
  }

}

