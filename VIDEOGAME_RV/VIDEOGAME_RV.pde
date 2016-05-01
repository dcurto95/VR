//Library imports
import controlP5.*;
//Constants
final int VIDEO_INICIAL = 0;
final int GAME_MENU = 1;
final int GAME = 2;
final int OPTIONS = 3;
final int ENDGAME = 4;

//Variables
Net net;
Hud hud;
Background background;
Spider spider;
Menu menu;
int menuState=0;

void setup(){
  size(1024,768);
  //fullScreen(); 
  net = new Net(4);
  hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1));
  menu = new Menu(this);
  menu.draw();
  
}


//Draw function
void draw(){
 
  background(255); 
  switch(menuState) {
    case VIDEO_INICIAL:
          //HISTORIA Y VIDEO INICIAL
      break;
      case GAME_MENU:
       menu.draw();
      break;
      case GAME:
       background.display(); //Displays background images
       net.drawNet(); //Display spider net
       hud.display(); //Display hud info
       spider.updateSpiderPositionInScreen();
       spider.drawSpider();
       menu.hide();
      break;
      case OPTIONS:
        println("Options");
        background(40);
      break;
      case ENDGAME:
        println("Exit");
        exit();
      break; 
  }
  println(menuState);
}


//Mouse click control
void mouseClicked() {
 // print("info: MOUSE PRESSED\n");
 // println("info: COORDINATES [" + mouseX + "," + mouseY + "]");
  hud.startTimer();
 
}


//Key control (variable key always returns the ASCI number of the pressed key, i think)
void keyPressed() {
  print("info: KEY PRESSED ( key = " + key + " )\n");
  if(key == 'r') hud.resetTimer();
  if(key == 's') hud.substractLifeSpider();
  if(key == 'b') hud.substractLifeBoy();
  if(key == 'a') spider.turnLeft();
  if(key == 'd') spider.turnRight();
  if(key == 'w') spider.goToNextPointForward();
  if(key == 's') spider.goToNextPointBackWards(); 
}

//Callbacks starts when a menu Button is pressed 
   public void Home(){    menuState = 1; }
   public void Play(){    menuState = 2; }
   public void Options(){ menuState = 3; }
   public void Exit(){    menuState = 4; }