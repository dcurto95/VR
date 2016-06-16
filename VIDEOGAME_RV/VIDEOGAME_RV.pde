//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;
import java.util.Map;
import java.util.Iterator;

import SimpleOpenNI.*;
//joer
//Constantes
final int NBR_BUTTERFLY = 24;
final int N_MAX_BUTTERFLIES_IN_NET = 3;
final int MILLIS_TO_FREE_BUTTERFLY = 5000;
final int NUMBER_OF_TOUCHES_TO_FREE_BUTTERFLY = 60;

int spiderId;

//Variables globales
FullScreen fs;
Net net;
Hud hud;
Background background;
Spider spider;
SpiderController spiderController;
ButterfliesController butterfliesController;
MusicController musicController;

int compte_segons;
int nButterfliesInNet;
boolean spiderPlayerReady, kidReady, gameReady;

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

    context.enableHand();

  context.enableUser();
  
 
  // disable mirror
  context.setMirror(true);
  
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
  X_SCALE_VALUE = (float)(displayWidth) / (float)(650);
  Y_SCALE_VALUE = (float)(displayHeight) / (float)(650);
        //hud.startTimer();
        
   nButterfliesInNet = 0; 

  musicController = new MusicController(this);   
}


//Draw function
void draw(){
  //KINNECT
    //image(context.depthImage(),0,0);
    context.update();
    spiderController.userList = context.getUsers();

    update();
      

    

    if(gameReady && spiderPlayerReady && kidReady){
      background(255);
   //   if (fondo){
      background.display();     //Displays background images
   //   }
     
      net.drawNet();            //Display spider net
     
      
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
  }else{
    
    println("sp: "+spiderPlayerReady+" kid: "+kidReady + " game: "+gameReady);
    if(spiderPlayerReady && !kidReady){
      println("Spider ready");
      
      PImage calibration = loadImage("images/spider_ready.png");
      calibration.resize(width, height);
      image(calibration, 0, 0);
            kidReady = true;
      //delay(2000);

      
      
    }else if(kidReady){
      println("kid ready");
      PImage calibration = loadImage("images/butterfly_ready.png");
      calibration.resize(width, height);
      image(calibration, 0, 0);
      //delay(5000);
      initGame();
    }else{
      PImage calibration = loadImage("images/calibration_screen.png");
      calibration.resize(width, height);
      image(calibration, 0, 0);
      
    }
  }
}

int tocado=0;
 void update(){
     //println("segons"+ compte_segons);
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
    dist = PVector.sub(butterfliesController.getButterfly(n).location, PVector.add(spider.screenPosition, new PVector(width/2, (height)/2)));
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
  if(!spiderPlayerReady){
    println("Activating spider");
    spiderPlayerReady = true;
  }else{
    println("kid?");
    if(!kidReady){
      println("Activating kid");
      kidReady = true;
    }
  }
/* initGame();
 fondo = !fondo;
 */
}


void initGame(){
  hud.startTimer();
  compte_segons = hud.seconds;
  //println("segons"+ compte_segons);
  gameReady = true;
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
    println("\tstart tracking skeleton" + spiderController.userList);
    if(spiderController.userList!= null && spiderController.userList.length==0){
      context.startTrackingSkeleton(userId);
      println("Antes de ready");
      spiderPlayerReady = true;
      //kidReady = true;
       println("Despues de ready");
       //spiderId=userId;
    }

    if(spiderController.userList!= null && spiderController.userList.length==1){
      println("Activate");
      context.startTrackingSkeleton(userId);
      
  
      kidReady = true;
      ArrayList<PVector> vecList = new ArrayList<PVector>();
      vecList.add(0,new PVector(0,0,0));
      handPathList.put(userId,vecList);
    }

  }
  
void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
      
  //context.stopTrackingSkeleton(userId);
  //spiderPlayerReady = false;
  //if(spiderId == userId) spiderId = 0;
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  println("onVisibleUser - userId: " + userId);
}




