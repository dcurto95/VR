public class Net{
  public ArrayList<ArrayList<Point>> net;
  private int nRings;
  private int radius;
  
  public Net(int nRings){
    this.nRings = nRings;
    radius = 80;
    net = new ArrayList<ArrayList<Point>>();
    for(int i=0;i<=nRings;i++){
      net.add(new ArrayList<Point>());
     
        float angle = 22.5;
        for(int j=0;j<8;j++){
           if(i<nRings){
              net.get(i).add(new Point('E',new PVector((i+1)*radius*cos(radians(angle)), (i+1)*radius*sin(radians(angle)))));
              println("POS: ("+(i+1)*radius*cos(radians(angle))+","+(i+1)*radius*sin(radians(angle))+")");
              angle = angle +45;
           }else{
              println("ADDED SHORTWAY POS: ("+(nRings-1)+","+(j+4)%8+")");
              net.get(i).add(new Point('S',new PVector(nRings-1, (j+4)%8)));
           }
        }
    }
  }
  
  void drawNet(){
    for(int i=0;i<=nRings;i++){
      for(int j=0;j<8;j++){
       Point p = net.get(i).get(j);
       
      
       // println(p);
      
        if(p.type=='E'){
          
          pushMatrix();
          translate(width/2, height/2);
          fill(0);
          ellipse(p.position.x,p.position.y,10,10);
          popMatrix();
          Point pPrev = null;
          Point pCont = null;
          
           if (i>0) pPrev = net.get((i-1)).get(j);
           
            pCont = net.get((i)).get((j+1)%8);
            
            pushMatrix();
            translate(width/2, height/2);
            fill(0);
            stroke(0);
            if (pPrev != null && pPrev.type=='E') line(pPrev.position.x,pPrev.position.y,p.position.x,p.position.y);
            if(pCont.type=='E') line(pCont.position.x,pCont.position.y,p.position.x,p.position.y);
            popMatrix();
           
        }else{
          PVector pAux = net.get((int)p.position.x).get((int)p.position.y).position;
          pushMatrix();
          translate(width/2, height/2);
          fill(255,0,0);
          ellipse(pAux.x,pAux.y,5,5);
          popMatrix();
        }
      }
    }
  }
}
