//Library imports
import controlP5.*;
import sprites.*;
import fullscreen.*;

//Variables
final int NBR_BUTTERFLY = 20;
FullScreen fs;
Net net;
Hud hud;
Background background;
Spider spider;
Butterfly[] butterfly = new Butterfly[NBR_BUTTERFLY];
Sprite buterflySprite;

void setup(){
  
  size(1024,768);
  //fullScreen(); 
  //fs = new Fullscreen(this);
  //fs.enter();
  
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
  for (int i = 0; i < NBR_BUTTERFLY; i++) {
       if(butterfly[i].show == true){
         butterfly[i].update();
         butterfly[i].checkEdges(); 
         butterfly[i].display();
       }
   }
   S4P.updateSprites(0.01f);
  
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
