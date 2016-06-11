//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;
import java.util.Map;
import java.util.Iterator;

import SimpleOpenNI.*;

//Constantes
final int NBR_BUTTERFLY = 24;
final int N_MAX_BUTTERFLIES_IN_NET = 3;
final int MILLIS_TO_FREE_BUTTERFLY = 5000;
final int NUMBER_OF_TOUCHES_TO_FREE_BUTTERFLY = 60;

//Variables globales
FullScreen fs;
Net net;
Hud hud;
Background background;
Spider spider;
SpiderController spiderController;
ButterfliesController butterfliesController;

int compte_segons;
int nButterfliesInNet;
boolean spiderPlayerReady, kidReady;

//Kinect
SimpleOpenNI  context;

boolean handDetected; 
//VAR CONTROL KINNECT
final int HAND_VEC_LIST_SIZE = 20;
PVector posHand, posHandToDraw;
    boolean tocat;
Map<Integer,ArrayList<PVector>>  handPathList = new HashMap<Integer,ArrayList<PVector>>();
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
float X_SCALE_VALUE, Y_SCALE_VALUE;

void setup(){
  
  size(displayWidth, displayHeight); 
  
   handDetected = false;
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
 //    exit();
  //   return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
  
  context.enableUser();
  context.enableHand();
//  context.startGesture(SimpleOpenNI.GESTURE_WAVE);
 
  
  
 
  // disable mirror
  context.setMirror(true);
// enable hands + gesture generation
  //context.enableGesture();
  
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1), this);
  spiderController = new SpiderController();
  butterfliesController = new ButterfliesController(this);

   //KINNECT Hand
  PVector p2d = new PVector();
  posHand = new PVector(0,0);
  posHandToDraw = new PVector(0,0);
  // set how smooth the hand capturing should be
  //context.setSmoothingHands(.5);
    // Create the fullscreen object
  fs = new FullScreen(this); 
  
  // enter fullscreen mode
  //fs.enter();
  
  //registerMethod("keyEvent", this);
  //kinect 640 x 480
  // pantalla width x height
  X_SCALE_VALUE = (float)(displayWidth) / (float)(640);
  Y_SCALE_VALUE = (float)(displayHeight) / (float)(480);
        //hud.startTimer();
        
   nButterfliesInNet = 0;     
}


//Draw function
void draw(){
  
  background(255);
  if (fondo){
    background.display();     //Displays background images
  }
  
  net.drawNet();            //Display spider net
 
  //KINNECT
  context.update();
  
  spiderController.checkSpiderControls();
  
  
 
  butterfliesController.displayButterflies();

  hud.display();
   S4P.updateSprites(0.01f);
    
    //SPIDER
  spider.drawSpider();
  spider.updateSpiderPositionInScreen();
  
  //TODO: cambiarlo por la posicion de la hand de la kinect
  posHandToDraw = posHand.get();
  posHandToDraw.x = posHandToDraw.x * X_SCALE_VALUE;
  posHandToDraw.y = posHandToDraw.y * Y_SCALE_VALUE;
  
  
  // draw the tracked hands
  if(handPathList.size() > 0)  
  {    
    Iterator itr = handPathList.entrySet().iterator(); 
    Map.Entry mapEntry = null;
    while(itr.hasNext()){    
      mapEntry = (Map.Entry)itr.next(); 
    }
    int handId =  (Integer)mapEntry.getKey();
    ArrayList<PVector> vecList = (ArrayList<PVector>)mapEntry.getValue();
    PVector p;
    PVector p2d = new PVector();
    
    if(vecList.size()>1){
      p2d = vecList.get(vecList.size()-1);
    }
    stroke(userClr[ (handId - 1) % userClr.length ]);
    strokeWeight(4);
    if(vecList.size()>0) {
      p = vecList.get(0);
      context.convertRealWorldToProjective(p,p2d);
      
      point(X_SCALE_VALUE*p2d.x,Y_SCALE_VALUE*p2d.y);
      hud.displayHand(new PVector(X_SCALE_VALUE*p2d.x,Y_SCALE_VALUE*p2d.y));//Display hud info 
  
      posHand = p2d;
    }
    //context.convertRealWorldToProjective(p,posHand);
  }
  
  update();
}

int tocado=0;
 void update(){
     if (posHand!=null){                  
        int indexCollidedButterfly = butterfliesController.checkButterfliesCollision(X_SCALE_VALUE*posHand.x, Y_SCALE_VALUE*posHand.y);  
        if(indexCollidedButterfly>-1){
          tocado++;
          if(butterfliesController.checkButterfliesCollision(X_SCALE_VALUE*posHand.x, Y_SCALE_VALUE*posHand.y)!=indexCollidedButterfly){
             tocado = 0;
           }else if(tocado>NUMBER_OF_TOUCHES_TO_FREE_BUTTERFLY){
             butterfliesController.freeButterflyWithIndex(indexCollidedButterfly);
             tocado=0;
             hud.substractLifeSpider();
           }
         }else{
         tocado=0;
       }
     }
       

   tryToEatButterfly();
 }

void tryToEatButterfly(){
  PVector dist;
  for (int n=0;n<butterfliesController.getNumberOfButterflies();n++){
    //println("Trying to eat ");
    dist = PVector.sub(butterfliesController.getButterfly(n).location, PVector.add(spider.screenPosition, new PVector(width/2, (height+150)/2)));
    if(abs(dist.x)<10 && abs(dist.y)<10){
      butterfliesController.removeButterfly(n);
      hud.substractLifeBoy();
    return;
    }     
  }
}

boolean fondo = false;
//Mouse click control
void mouseClicked() {
 print("info: MOUSE PRESSED\n");
 println("info: COORDINATES [" + mouseX + "," + mouseY + "]");
 initGame();
 fondo = !fondo;
 
}


void initGame(){
  hud.startTimer();
  compte_segons = hud.seconds;
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
      spiderPlayerReady = true;
    }
    if(spiderController.userList!= null && spiderController.userList.length==1){
      println("Activate");
      context.startTrackingSkeleton(userId);
    //  delay(5000);
   //   context.startGesture(SimpleOpenNI.GESTURE_WAVE);
      spiderPlayerReady = true;
       ArrayList<PVector> vecList = new ArrayList<PVector>();
    vecList.add(0,new PVector(0,0,0));
    handPathList.put(userId,vecList);
    }
  }
  
void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  spiderPlayerReady = false;
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
 if(!handDetected){
    ArrayList<PVector> vecList = new ArrayList<PVector>();
    vecList.add(pos);
    
    handPathList.put(handId,vecList);
    handDetected = true;
    kidReady = true;
  }
  
 
}

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  println("onTrackedHand - handId: " + handId + ", pos: " + pos );
  
  ArrayList<PVector> vecList = handPathList.get(handId);
  if(vecList != null)
  {
    vecList.add(0,pos);
    //println("log adso"+pos);
    if(vecList.size() >= HAND_VEC_LIST_SIZE)
      // remove the last point 
      vecList.remove(vecList.size()-1); 
  }  
}

void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("onLostHand - handId: " + handId);
  handPathList.remove(handId);
  handDetected = false;
  kidReady = false;
}

// -----------------------------------------------------------------
// gesture events

void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  
  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);
}


