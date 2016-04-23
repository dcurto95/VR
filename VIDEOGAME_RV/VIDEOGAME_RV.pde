//Library imports
import controlP5.*;

//Variables
Net web;
Hud hud;
Background background;
Spider spider;

void setup(){
  //size(1024,768);
  fullScreen(); 
  web = new Net(4);
  spider = new Spider(web);
  hud = new Hud(this);
  background = new Background();
}


//Draw function
void draw(){
  background(255);
  //background.display(); //Displays background images
  web.drawNet(); //Display spider net
  hud.display(); //Display hud info
  spider.display();
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
  if(key == 'r') hud.resetTimer();
  if(key == 's') hud.substractLifeSpider();
  if(key == 'b') hud.substractLifeBoy();
  if(keyCode == UP) spider.moveSpider(1);
  if(keyCode == RIGHT) spider.moveSpider(2);
  if(keyCode == DOWN) spider.moveSpider(3);
  if(keyCode == LEFT) spider.moveSpider(4);
}