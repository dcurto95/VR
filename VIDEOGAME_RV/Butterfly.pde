class Butterfly{

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector dir;
  float topspeed;
  boolean show;
  PVector pointDst;
  Sprite butterfly;
  int flagPapallona_engaged;

  Butterfly(Sprite butterfly, PVector pointDest) {
    location = new PVector(width*random(1), height+random(300));
   
    velocity = new PVector(0, 0);
    topspeed = 2;
    flagPapallona_engaged = 0;
    pointDst = new PVector();
    pointDst.x = width/2 - pointDest.x;
    pointDst.y = (height+150)/2 - pointDest.y; 
    
    dir = PVector.sub(pointDst, location);
    
    show = true;
    this.butterfly = butterfly;
    butterfly.setScale(1.75);

  }


  void update() {
    
    if(flagPapallona_engaged == 1){
      dir = PVector.sub(pointDst, location);
      dir.normalize();
      acceleration = dir;
    }else{
      acceleration = PVector.random2D();
      acceleration.mult(random(1));
    }
    
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    
    
  }

  void display() { 
    butterfly.setXY(location.x,location.y);
    butterfly.draw();
  }

  void checkEdges() {

    if (location.x > width) {
      location.x = 0;
    } 
    else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } 
    else if (location.y < 0) {
      location.y = height;
    }
  }
  
  private void selectButterfly(int random){
     switch(random) {
       case 1:
         butterfly.setFrameSequence(0,2,0.03f);
       break;
       case 2:
         butterfly.setFrameSequence(3,5,0.03f);
       break;
       case 3:
         butterfly.setFrameSequence(6,8,0.03f);
       break;
       case 4:
         butterfly.setFrameSequence(9,11,0.03f);
       break;
       case 5:
         butterfly.setFrameSequence(48,50,0.03f);
       break;
       case 6:
         butterfly.setFrameSequence(51,53,0.03f);
       break;
       case 7:
         butterfly.setFrameSequence(54,56,0.03f);
       break;
       case 8:
         butterfly.setFrameSequence(57,59,0.03f);
       break;
     }
  
  }
}

