class ButterfliesController{
  
  private ArrayList<Butterfly> butterflies;
  private final int ALLOWED_ERROR = 30;
  
  public ButterfliesController(PApplet thePApplet){
    butterflies = new ArrayList<Butterfly>();
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
              println("size before="+butterflies.size());
              butterflies.add(new Butterfly(destPoint, thePApplet));
              println("size after add="+butterflies.size());
              butterflies.get(numbut).selectButterfly((int) random(1,8));
              numbut++;
         }
      }
    }  
  }

  int getNumberOfButterflies(){
    return butterflies.size();
  }
  void freeButterflyWithIndex(int index){
    butterflies.get(index).freeButterfly();
    net.hidePointWithScreenPosition(new PVector((float)butterfliesController.butterflies.get(index).cocoonSprite.getX(),(float)butterfliesController.butterflies.get(index).cocoonSprite.getY()));
  }
  void displayButterflies(){
      for (int i = 0; i < butterflies.size(); i++) {
       if(butterflies.get(i).show == true){
             
           if(compte_segons - hud.seconds > random(24) && nButterfliesInNet<N_MAX_BUTTERFLIES_IN_NET){  
             compte_segons = hud.seconds;
             butterflies.get(i).setEngaged(); 
           }
           butterflies.get(i).update();  
           butterflies.get(i).checkEdges(); 
           butterflies.get(i).display();
           
       }
    }
  }
  
  public int checkButterfliesCollision(float x, float y){ //Devuelve indice de mariposa k colisiona, o -1 si no colisiona
  
  for (int i = 0; i < butterflies.size(); i++){
  //  println("Comparing "+butterflies[i].location+" with "+x+","+y);
     if (butterflies.get(i).atPoint && x > butterflies.get(i).location.x - ALLOWED_ERROR && y > butterflies.get(i).location.y -ALLOWED_ERROR && x < butterflies.get(i).location.x + ALLOWED_ERROR && y < butterflies.get(i).location.y +ALLOWED_ERROR ){    
          return i;
     }
   }
  return -1; 
  }
  public Butterfly getButterfly(int index){
    return butterflies.get(index);
  }
  
  public void hideButterfly(int index){
    butterflies.get(index).show = false;
  }
  public void removeButterfly(int index){
    butterflies.remove(index);
  }
  
}


