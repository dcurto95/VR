import SimpleOpenNI.*;

public class SpiderController{
  
  private int rotating = 0;
  public int[] userList;
  private color userClr = color(255,0,0);
  private  PVector posRHand, posLHand;
  private PVector posLShoulder,posRShoulder, posRElbow, posLElbow;
  private final float MIN_FIABILITY = 0.7;
  
  public SpiderController(){
    posLHand  = new PVector();
    posRHand = new PVector();
    posLShoulder = new PVector();
    posRShoulder = new PVector();
    posRElbow = new PVector();
    posLElbow = new PVector();
    userList = context.getUsers();
  }
  
  // -----------------------------------------------------------------
  // SimpleOpenNI events
  // -----------------------------------------------------------------
  
  // draw the skeleton with the selected joints
  void drawSkeleton(int userId) {
    
    // to get the 3d joint data
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
  
  
  int getJointPositions(int i){ //Devuelve la fiabilidad de los puntos detectados:
                                //0: no fiable
                                //1:hombros fiables, resto no
                                //2:todo fiable
      float shoulderFiability, otherJointsFiability;
      boolean otherJointsKO = false; //true si otherJointsFiability < MIN_FIABILITY
      //Coger posiciones del esqueleto que nos interesan
      otherJointsFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND,posLHand);
      if(otherJointsFiability<MIN_FIABILITY){ otherJointsKO = true;}
      otherJointsFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND,posRHand);
      if(otherJointsFiability<MIN_FIABILITY){ otherJointsKO = true;}
      otherJointsFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_ELBOW,posLElbow);
      if(otherJointsFiability<MIN_FIABILITY){ otherJointsKO = true;}
      otherJointsFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_ELBOW,posRElbow);
      if(otherJointsFiability<MIN_FIABILITY){ otherJointsKO = true;}
      shoulderFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_SHOULDER,posLShoulder);
      if(shoulderFiability<MIN_FIABILITY){ return 0;}
      shoulderFiability = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_SHOULDER,posRShoulder);
      if(shoulderFiability<MIN_FIABILITY){return 0;}
      if(otherJointsKO){return 1;}
      
      return 2;//Todo OK
  }
  
  void convertCoordinatesTo2D(){
    //Convertir posiciones a coordenadas en 2D (pantalla)
      context.convertRealWorldToProjective(posRHand, posRHand);
      context.convertRealWorldToProjective(posLHand, posLHand);
      context.convertRealWorldToProjective(posLElbow, posLElbow);
      context.convertRealWorldToProjective(posRElbow, posRElbow);
      context.convertRealWorldToProjective(posLShoulder, posLShoulder);
      context.convertRealWorldToProjective(posRShoulder, posRShoulder);  
      
  }
  
  void checkMoving(){
    float shoulderAngleL,shoulderAngleR;
    PVector vertical = new PVector(0,1,0);
    shoulderAngleL = degrees(PVector.angleBetween(vertical, PVector.sub(posLElbow,posLShoulder)));
    shoulderAngleR = degrees(PVector.angleBetween(vertical, PVector.sub(posRElbow,posRShoulder)));
    
    //Comprobar que los brazos estan abiertos (como en cruz con el cuerpo)
    if(shoulderAngleL<110 && shoulderAngleL>70 && shoulderAngleR<110 && shoulderAngleL>70){
      float elbowAngleL,elbowAngleR;
      elbowAngleL = degrees(PVector.angleBetween(posLShoulder, PVector.sub(posLHand,posLElbow)));
      elbowAngleR = degrees(PVector.angleBetween(posRShoulder, PVector.sub(posRHand,posRElbow)));
      
      //Comprobar si manos arriba
      PVector diffHands = PVector.sub(posLHand, posRHand);
      PVector diffHandShoulderL = PVector.sub(posLHand, posLShoulder);
      PVector diffHandShoulderR = PVector.sub(posRHand, posRShoulder);
      if(abs(diffHands.y)<10 && (diffHandShoulderL.y<50 || (diffHandShoulderL.y<50))){
          spider.goToNextPointForward();
      }
      
    }else{
       //println("Arms angles: "+shoulderAngleL+"    "+shoulderAngleR);
    }
    
  }
  
  void checkRotation(float yDifferenceInShoulders){
      //A partir de diferencia de alturas entre los hombros decidir si giramos o no   
      if(rotating<0){  //Evita que lo compruebe en cada vuelta del draw -> sino la araña gira casi constantemente y es dificil pararla 
        if(abs(yDifferenceInShoulders) > 120){
          if(yDifferenceInShoulders>0){
            spider.turnRight();
          }else{
            spider.turnLeft();
          }
          rotating = 20;
        }   
      }
  }
  
  void checkSpiderControls(){
    rotating=rotating-1;
  //println("El valor de rotating es " + rotating);
    if(rotating<-10) rotating = 20;
    userList = context.getUsers();
    for(int i=0;i<userList.length;i++) {
      if(context.isTrackingSkeleton(userList[i])){
        if(i == 0){
        //if(spiderId>0 && userList[i]==spiderId){
          //Pintar esqueleto para saber lo que esta captando
          stroke(userClr);
          if(skeleton)drawSkeleton(userList[i]);
          int confidence = getJointPositions(i);
          
          float yDifferenceInShoulders = posLShoulder.y - posRShoulder.y;
        
          convertCoordinatesTo2D();
          
          if(confidence>0){
            checkRotation(yDifferenceInShoulders);
          }else{
            rotating = 20;
          }
          if(confidence==2){
            checkMoving();
          }   
        }
      }
    }
  }
  
  
}