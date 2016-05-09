//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;
import SimpleOpenNI.*;

//Variables
final int NBR_BUTTERFLY = 20;
FullScreen fs;
Net net;
Hud hud;
Background background;
Spider spider;
Butterfly[] butterfly = new Butterfly[NBR_BUTTERFLY];
Sprite buterflySprite;
SimpleOpenNI  context;
SpiderController spiderController;

int rotating = 0;
int[] userList;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };

void setup(){
  
  size(1024,768);
  //fullScreen(); 
  //fs = new Fullscreen(this);
  //fs.enter();
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
  // enable skeleton generation for all joints
  context.enableUser();
 
  
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1), this);
  spiderController = new SpiderController();
  buterflySprite = new Sprite(this, "images/butterfly.png", 12, 8, 21);
    
  for (int i = 0; i <NBR_BUTTERFLY; i++) {
    butterfly[i] = new Butterfly(buterflySprite);
    butterfly[i].selectButterfly((int) random(1,8));
  }
}


//Draw function
void draw(){
  
  background(255);
  background.display();     //Displays background images
  net.drawNet();            //Display spider net
  
  //SPIDER
  spider.drawSpider();
  spider.updateSpiderPositionInScreen();
  
  hud.display();           //Display hud info   
  
  //BUTTERFLIES
/*  for (int i = 0; i < NBR_BUTTERFLY; i++) {
       if(butterfly[i].show == true){
         butterfly[i].update();
         butterfly[i].checkEdges(); 
         butterfly[i].display();
       }
   }*/
   S4P.updateSprites(0.01f);
   context.update();
  // image(context.depthImage(),0,0);
   spiderController.checkSpiderControls();
   
}

//Mouse click control
void mouseClicked() {
 print("info: MOUSE PRESSED\n");
 println("info: COORDINATES [" + mouseX + "," + mouseY + "]");
 hud.startTimer();
}

//Key control (variable key always returns the ASCI number of the pressed key, i think)
void keyPressed() {
  print("info: KEY PRESSED ( key = " + key + " )\n");
  if(key == 'r') hud.resetAll();
  if(key == 'm') hud.substractLifeSpider();
  if(key == 'n') hud.substractLifeBoy();
  if(key == 'a') spider.turnLeft();
  if(key == 'd') spider.turnRight();
  if(key == 'w') spider.goToNextPointForward();
  if(key == 's') spider.goToNextPointBackWards(); 
}

    
  
void onNewUser(SimpleOpenNI curContext, int userId)
  {
    println("onNewUser - userId: " + userId);
    println("\tstart tracking skeleton");
    if(spiderController.userList!= null && spiderController.userList.length==0){
      context.startTrackingSkeleton(userId);
    }
  }
  
  void onLostUser(SimpleOpenNI curContext, int userId)
  {
    println("onLostUser - userId: " + userId);
  }
  
  void onVisibleUser(SimpleOpenNI curContext, int userId)
  {
    //println("onVisibleUser - userId: " + userId);
  }






