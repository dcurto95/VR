//Library imports
import controlP5.*;

//Variables
Net net;
Hud hud;
Background background;
Spider spider;

void setup(){
  size(1024,768);
  //fullScreen(); 
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1));
}


//Draw function
void draw(){
  background(255);
  background.display(); //Displays background images
  net.drawNet(); //Display spider net
  hud.display(); //Display hud info
  spider.updateSpiderPositionInScreen();
  spider.drawSpider();
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
  if(key == 's') hud.substractLifeSpider();
  if(key == 'b') hud.substractLifeBoy();
  if(key == 'a') spider.turnLeft();
  if(key == 'd') spider.turnRight();
  if(key == 'w') spider.goToNextPointForward();
  if(key == 's') spider.goToNextPointBackWards();
  
}