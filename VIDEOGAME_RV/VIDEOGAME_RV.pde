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
//  context.enableRGB();
  // enable skeleton generation for all joints
  context.enableUser();
 
  
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1), this);
 
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
   image(context.depthImage(),0,0);
   checkSpiderControls();
   
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

void checkSpiderControls(){
  rotating=rotating-1;
  PVector posTorso,posNeck,torsoOrientation, posRHand, posLHand;
  PVector posLShoulder,posRShoulder, posRElbow, posLElbow;
  posTorso = new PVector();
  posNeck = new PVector();
  torsoOrientation = new PVector();
  posLHand  = new PVector();
  posRHand = new PVector();
  posLShoulder = new PVector();
  posRShoulder = new PVector();
  posRElbow = new PVector();
  posLElbow = new PVector();
  
  
  userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      //Pintar esqueleto para saber lo que esta captando
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
      
      //Coger posiciones del esqueleto que nos interesan
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_TORSO,posTorso);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_NECK,posNeck);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND,posLHand);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND,posRHand);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_ELBOW,posLElbow);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_ELBOW,posRElbow);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_SHOULDER,posLShoulder);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_SHOULDER,posRShoulder);
      
      
      float yDifferenceInShoulders = posLShoulder.y - posRShoulder.y;
    
      //Convertir posiciones a coordenadas en 2D (pantalla)
      context.convertRealWorldToProjective(posTorso, posTorso);
      context.convertRealWorldToProjective(posNeck, posNeck);
      context.convertRealWorldToProjective(posRHand, posRHand);
      context.convertRealWorldToProjective(posLHand, posLHand);
      context.convertRealWorldToProjective(posLElbow, posLElbow);
      context.convertRealWorldToProjective(posRElbow, posRElbow);
      context.convertRealWorldToProjective(posLShoulder, posLShoulder);
      context.convertRealWorldToProjective(posRShoulder, posRShoulder);  
      
      //Calcular orientacion del torso 
      torsoOrientation = PVector.sub(posNeck, posTorso);
      float shoulderAngleL,shoulderAngleR;
      PVector vertical = new PVector(0,1,0);
      shoulderAngleL = degrees(PVector.angleBetween(vertical, PVector.sub(posLElbow,posLShoulder)));
      shoulderAngleR = degrees(PVector.angleBetween(vertical, PVector.sub(posRElbow,posRShoulder)));
      
      //Comprobar que los brazos estan abiertos (como en cruz con el cuerpo)
/*      if(shoulderAngleL<120 && shoulderAngleL>60 && shoulderAngleR<120 && shoulderAngleL>60){
        println("Arms ok");
        float elbowAngleL,elbowAngleR;
        elbowAngleL = degrees(PVector.angleBetween(posLShoulder, PVector.sub(posLHand,posLElbow)));
        elbowAngleR = degrees(PVector.angleBetween(posRShoulder, PVector.sub(posRHand,posRElbow)));
        //Comprobar angulo del codo
        if(elbowAngleL>60 && elbowAngleR>60 && elbowAngleL<120 && elbowAngleR<120 ){
          println("BACK ");
          spider.goToNextPointForward(); 
        }else if(elbowAngleL<180 && elbowAngleL>120 && elbowAngleR<180 && elbowAngleR>120){
          println("FRONT ");
          spider.goToNextPointBackWards();
        }else{
          println("ELBOW angles: "+elbowAngleL+"    "+elbowAngleR);
        }
      
      }else{
        println("Arms angles: "+shoulderAngleL+"    "+shoulderAngleR);
      }
  */    
  
    println("Shoulder diff:"+yDifferenceInShoulders);   
    if(rotating<0){
      if(abs(yDifferenceInShoulders)>150){
        if(yDifferenceInShoulders>0){
          println("Right");
          spider.turnRight();
        }else{
          println("Left");
          spider.turnLeft();
        }
        rotating = 20;
      }
      
    }
      //A partir de la orientacion del torso decidir si giramos o no
     /* float angleTorso = degrees(PVector.angleBetween(vertical, torsoOrientation));
      println(angleTorso);
      if(rotating<0){
        if(angleTorso<160){
           if(torsoOrientation.x>0){
             println("right");
            spider.turnRight();
           }else{
            println("left");
            spider.turnLeft();
           }
        rotating=20;
        }else{
          angleTorso=300;
        }
        
      }*/ 
    }    
  }
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  if(userList!= null && userList.length==0){
    curContext.startTrackingSkeleton(userId);
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


// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

