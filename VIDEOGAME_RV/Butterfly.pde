import sprites.*;

class Butterfly{

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector dir;
  float topspeed;
  PVector pointDst;
  
  boolean show;
  
  Sprite butterflySprite;
  Sprite cocoonSprite;
  
  boolean flagPapallona_engaged;
  boolean isFree; //Si isFree ya la has liberado y no puede re engancharse
  boolean atPoint;
  int colorIndex;
  
  
  Butterfly(PVector pointDest, PApplet thePApplet) {
    location = new PVector(width*random(1), height+random(300));
    atPoint = false;
    velocity = new PVector(0, 0);
    topspeed = 2;
    flagPapallona_engaged = false;
    pointDst = new PVector();
    pointDst.x = width/2 - pointDest.x;
    pointDst.y = (height+150)/2 - pointDest.y; 
    butterflySprite = new Sprite(thePApplet, "images/butterfly.png", 12, 8, 21);
    butterflySprite.setScale(4);
    cocoonSprite = new Sprite(thePApplet, "images/Cocoon.png",1, 1, 21);
    cocoonSprite.setScale(0.2);
    dir = PVector.sub(pointDst, location);
    colorIndex = (int)random(1,8);
    show = true;
    isFree=false;
  }


  void update() {
    
    if(flagPapallona_engaged){
      dir = PVector.sub(pointDst, location);
      dir.normalize();
      acceleration = dir;     
    }else{
      acceleration = PVector.random2D();
      acceleration.mult(random(1));      
    }
    if(isFree){
      dir = PVector.sub(new PVector(random(width),-10), location);
      dir.normalize();
      acceleration = dir;
    }
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    
    PVector aprox = new PVector();
    aprox.x = location.x - pointDst.x;
    aprox.y = location.y - pointDst.y;
    
    if(aprox.x > -0.9 && aprox.x < 0.9 && aprox.y > -0.9 && aprox.y < 0.9 && atPoint == false){
       atPoint = true;
       println("AT POINT");
       butterflySprite.setFrameSequence(0,0,0.03f);
       
    }
    selectButterfly(colorIndex);
  }

  void display() { 
    if(!this.atPoint || this.isFree){
      butterflySprite.setXY(location.x,location.y);
      butterflySprite.draw();
    }else{
      cocoonSprite.setXY(location.x,location.y);
      cocoonSprite.draw();
    }
    
    
  }

  void setEngaged(){
    if(!isFree){
      flagPapallona_engaged = true;
      nButterfliesInNet++;
    }
  }
  
  void freeButterfly(){
    flagPapallona_engaged = false;
    isFree = true;
    nButterfliesInNet--;
    atPoint = false;
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
      if(isFree) this.show = false;
    } 
    else if (location.x < 0) {
      location.x = width;
      if(isFree) this.show = false;
    }
    if (location.y > height) {
      location.y = 0;
      if(isFree) this.show = false;
    } 
    else if (location.y < 0) {
      location.y = height;
      if(isFree) this.show = false;
    }
  }
  
  public void selectButterfly(int random){
    int frame =0; 
    switch(random) {
       case 1:
         butterflySprite.setFrameSequence(0,2,0.03f);
         frame = 0;
       break;
       case 2:
         butterflySprite.setFrameSequence(3,5,0.03f);
         frame = 3;
       break;
       case 3:
         butterflySprite.setFrameSequence(6,8,0.03f);
         frame = 6;
       break;
       case 4:
         butterflySprite.setFrameSequence(9,11,0.03f);
         frame = 9;
       break;
       case 5:
         butterflySprite.setFrameSequence(48,50,0.03f);
         frame = 48;
       break;
       case 6:
         butterflySprite.setFrameSequence(51,53,0.03f);
         frame = 51;
       break;
       case 7:
         butterflySprite.setFrameSequence(54,56,0.03f);
         frame = 54;
       break;
       case 8:
         butterflySprite.setFrameSequence(57,59,0.03f);
         frame = 57;
       break;
     }
  }

}

