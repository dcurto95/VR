public class Net{
  
  private ArrayList<ArrayList<Point>> net;
  public int nRings;
  private int radius;
  
  public Net(int nRings){
    this.nRings = nRings;
    radius = 100;
    net = new ArrayList<ArrayList<Point>>();
    for(int i=0;i<=nRings;i++){
      net.add(new ArrayList<Point>());
     
        float angle = 22.5;
        for(int j=0;j<8;j++){
          if(i==0){//Atajo del medio
              //println("ADDED SHORTWAY POS: ("+(1)+","+(j+4)%8+")");
              net.get(i).add(new Point('S',new PVector(1, (j+4)%8)));
          }else if(i<nRings){
              net.get(i).add(new Point('E',new PVector((i+1)*radius*cos(radians(angle)), (i+1)*radius*sin(radians(angle)))));
              //println("POS: "+i+","+j+": ("+(i+1)*radius*cos(radians(angle))+","+(i+1)*radius*sin(radians(angle))+")");
              angle = angle +45;
           }else{
              //println("ADDED SHORTWAY POS: ("+(nRings-1)+","+(j+4)%8+")");
              net.get(i).add(new Point('S',new PVector(nRings-1, (j+4)%8)));
           }
        }
    }
  }
  boolean isShortcut(int xIndex, int yIndex) {
     return (net.get(xIndex).get(yIndex).type=='S');
  }
  
  PVector getShortcutDestIndexes(int xIndex, int yIndex){
    return net.get(xIndex).get(yIndex).position.get();
  }
  
  Point getNetPoint(int xIndex, int yIndex){
    int x,y;
    
    if(xIndex<0){xIndex = xIndex + nRings;}
    if(yIndex<0){yIndex = yIndex + 8-1;}
      
    xIndex = xIndex%(nRings+1);
    yIndex = yIndex%8;
    
    if(net.get(xIndex).get(yIndex).type=='S'){
      x=(int)net.get(xIndex).get(yIndex).position.x;
      y=(int)net.get(xIndex).get(yIndex).position.y;
    }else{
      x=xIndex;
      y=yIndex;
    }
    return (net.get(x).get(y));
  }
  
  void hidePointWithScreenPosition(PVector position){
    PVector dist;
    position.sub(new PVector(width/2, (height+150)/2));
    for(int i=0;i<=nRings;i++){
      for(int j=0;j<8;j++){
        dist = PVector.sub(getNetPoint(i,j).position, position);
        if(abs(dist.x)<10 && abs(dist.y)<10){
          getNetPoint(i,j).setPointDisabled();
        }
      }
    }
  }
  
  void reactivateNetPointAtScreenPosition(PVector position){
    PVector dist;
    for(int i=0;i<=nRings;i++){
      for(int j=0;j<8;j++){
        dist = PVector.sub(getNetPoint(i,j).position, position);
        if(abs(dist.x)<10 && abs(dist.y)<10){
          getNetPoint(i,j).setPointEnabled();
        }
      }
    }
  }
  
  float getAngleFrom2NetIndexes(PVector originIndexes, PVector destinationIndexes){
    PVector direction = PVector.sub(getNetPoint((int)destinationIndexes.x,(int)destinationIndexes.y).position.get() , getNetPoint((int)originIndexes.x,(int)originIndexes.y).position.get());
    return degrees(direction.heading());
  }
  
  PVector getPointNet(int xIndex, int yIndex){
    PVector pAux = new PVector(); 
    pAux.x= net.get(xIndex).get(yIndex).position.x;
    pAux.y = net.get(xIndex).get(yIndex).position.y;
    return pAux;
  }
 
  void drawNet(){
    for(int i=0;i<=nRings;i++){
      for(int j=0;j<8;j++){
       Point p = net.get(i).get(j);

        if(p.type=='E'){
          
          pushMatrix();
          
          translate(width/2, (height+150)/2);
          
          fill(255);
          ellipse(p.position.x,p.position.y,15,15);
          popMatrix();
          Point pPrev = null;
          Point pCont = null;
          
           if (i>0) pPrev = net.get((i-1)).get(j);
           
           if(pPrev.type=='S'){
             pPrev = net.get((int)pPrev.position.x).get((int)pPrev.position.y);
           }
            pCont = net.get((i)).get((j+1)%8);
            if(pCont.type=='S'){
             pCont = net.get((int)pCont.position.x).get((int)pCont.position.y);
            }
            
            pushMatrix();
            translate(width/2, (height+150)/2);
            stroke(255);
            strokeWeight(3);
            if (pPrev != null && pPrev.type=='E') line(pPrev.position.x,pPrev.position.y,p.position.x,p.position.y);
            if(pCont.type=='E') line(pCont.position.x,pCont.position.y,p.position.x,p.position.y);
            popMatrix();
           
        }else{
          /*PVector pAux = net.get((int)p.position.x).get((int)p.position.y).position;
          pushMatrix();
          translate(width/2, height/2);
          fill(255,0,0);
          ellipse(pAux.x,pAux.y,5,5);
          popMatrix();*/
          //println("Drawing shortcut at index "+p.position+" at pos:"+pAux);
        }
      }
    }
  }
}
