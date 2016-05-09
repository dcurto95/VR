//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;
import java.util.Map;
import java.util.Iterator;
import sprites.*;
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
Sprite SpiderSprite;

//VAR CONTROL KINNECT
int handVecListSize = 20;
PVector posHand;
    boolean tocat;
Map<Integer,ArrayList<PVector>>  handPathList = new HashMap<Integer,ArrayList<PVector>>();
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
 
  // disable mirror
  context.setMirror(true);
// enable hands + gesture generation
  //context.enableGesture();
  context.enableHand();
  context.startGesture(SimpleOpenNI.GESTURE_WAVE);
 
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
  
   //KINNECT Hand
  PVector p2d = new PVector();
  PVector posHand = new PVector(0,0);

  // set how smooth the hand capturing should be
  //context.setSmoothingHands(.5);
    // Create the fullscreen object
  fs = new FullScreen(this); 
  
  // enter fullscreen mode
  fs.enter();
  
  //spiderSprite = new Sprite(this, "images/spider.png", 7, 4, 21);
  //registerMethod("keyEvent", this);
  
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
  for (int i = 0; i < NBR_BUTTERFLY; i++) {
       if(butterfly[i].show == true){
         butterfly[i].update();
         butterfly[i].checkEdges(); 
         butterfly[i].display();
       }
   }
   S4P.updateSprites(0.01f);
   //KINNECT
   context.update();
  // image(context.depthImage(),0,0);
   spiderController.checkSpiderControls();
    
    update();
  if (!tocat){
    
     //spiderSprite.setXY(x,y);
     
     ///piderSprite.draw();
     for (int i = 0; i < NBR_BUTTERFLY; i++) {
       if(butterfly[i].show == true){
         butterfly[i].update();
         butterfly[i].checkEdges(); 
         butterfly[i].display();
       }
     }
     S4P.updateSprites(0.01f);
    ///mage(img,200,200);
  }
    
  // draw the tracked hands
  if(handPathList.size() > 0)  
  {    
    Iterator itr = handPathList.entrySet().iterator();     
    while(itr.hasNext())
    {
      Map.Entry mapEntry = (Map.Entry)itr.next(); 
      int handId =  (Integer)mapEntry.getKey();
      ArrayList<PVector> vecList = (ArrayList<PVector>)mapEntry.getValue();
      PVector p;
      PVector p2d = new PVector();
      
        stroke(userClr[ (handId - 1) % userClr.length ]);
        noFill(); 
        strokeWeight(1);        
        Iterator itrVec = vecList.iterator(); 
         beginShape();
          while( itrVec.hasNext() ) 
          { 
            p = (PVector) itrVec.next(); 
            
            context.convertRealWorldToProjective(p,p2d);
            vertex(p2d.x*2,p2d.y);
          }
        endShape();   
  
        stroke(userClr[ (handId - 1) % userClr.length ]);
        strokeWeight(4);
        p = vecList.get(0);
        context.convertRealWorldToProjective(p,p2d);
        point(p2d.x*2,p2d.y);
        
        posHand = p2d;
        //context.convertRealWorldToProjective(p,posHand);
 
    }        
  }
}


 void update(){
   for (int i = 0; i < NBR_BUTTERFLY; i++){
     if (posHand!=null && posHand.x > butterfly[i].location.x - 10 && posHand.y > butterfly[i].location.y -10 && posHand.x < butterfly[i].location.x + 10 && posHand.y < butterfly[i].location.y +10 ){    
          butterfly[i].show = false;
     }
   }  
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





// -----------------------------------------------------------------
// hand events

void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  println("onNewHand - handId: " + handId + ", pos: " + pos);
 
  ArrayList<PVector> vecList = new ArrayList<PVector>();
  vecList.add(pos);
  
  handPathList.put(handId,vecList);
}

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  //println("onTrackedHand - handId: " + handId + ", pos: " + pos );
  
  ArrayList<PVector> vecList = handPathList.get(handId);
  if(vecList != null)
  {
    vecList.add(0,pos);
    if(vecList.size() >= handVecListSize)
      // remove the last point 
      vecList.remove(vecList.size()-1); 
  }  
  

  
  
}

void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("onLostHand - handId: " + handId);
  handPathList.remove(handId);
}

// -----------------------------------------------------------------
// gesture events

void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  
  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);
}


