Net net;

void setup(){
  
  size(800,600);
  net = new Net(4);
}

void draw(){
  background(255);
  net.drawNet();
 
}

void mouseClicked() {
  println(mouseX +","+mouseY);
}
