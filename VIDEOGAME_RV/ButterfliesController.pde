class ButterfliesController{
  public Butterfly[] butterflies;
  
  public ButterfliesController(PApplet thePApplet){
    butterflies = new Butterfly[NBR_BUTTERFLY];
    initButterflies(thePApplet);
  }
  
  void initButterflies(PApplet thePApplet){
    int numbut = 0;
    for (int i = 0; i <=net.nRings; i++) {
      for(int j = 0; j < 8; j++){    
      
      PVector destPoint = net.getNetPoint(i, j).position.get();
        if(i==0){//Atajo del medio

          }else if(i<4){
              destPoint = net.getPointNet(i,j);  
              butterflies[0] = new Butterfly(destPoint, thePApplet);
              butterflies[0].selectButterfly((int) random(1,8));
              numbut++;
         }
      }
    }  
  }

  
  void displayButterflies(){
      for (int i = 0; i < NBR_BUTTERFLY; i++) {
       if(butterflies[i].show == true){
             
           if(compte_segons - hud.seconds > random(24) && nButterfliesInNet<N_MAX_BUTTERFLIES_IN_NET){  
             compte_segons = hud.seconds;
             butterflies[i].setEngaged(); 
           }
           butterflies[i].update();  
           butterflies[i].checkEdges(); 
           butterflies[i].display();
           
       }
    }
  }
  
  public int checkButterfliesCollision(float x, float y){ //Devuelve indice de mariposa k colisiona, o -1 si no colisiona
  for (int i = 0; i < NBR_BUTTERFLY; i++){
     if (x > butterflies[i].location.x - 10 && y > butterflies[i].location.y -10 && x < butterflies[i].location.x + 10 && y < butterflies[i].location.y +10 ){    
          return i;
     }
   }
  return -1; 
  }
  
  public void hideButterfly(int index){
    butterflies[index].show = false;
  }
  
  
  
}


