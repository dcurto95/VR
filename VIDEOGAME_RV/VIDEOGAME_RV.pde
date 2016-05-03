//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;

//Variables
FullScreen fs;
Net net;
Hud hud;
Background background;
Spider spider;

void setup(){
  
  size(1024,768);
  //fullScreen(); 
  //fs = new Fullscreen(this);
  //fs.enter();
  
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1), this);
  
}


//Draw function
void draw(){
  background(255);
  background.display();     //Displays background images
  net.drawNet();            //Display spider net
  spider.drawSpider();
  spider.updateSpiderPositionInScreen();
  hud.display();           //Display hud info   
  
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

//Callbacks starts when a menu Button is pressed 
  /* public void Home(){    menuState = 1; }
   public void Play(){    menuState = 2; }
   public void Options(){ menuState = 3; c2 = color(150,0,0); c2 = color(255,255,0);  }
   public void Exit(){    menuState = 4; }*/
