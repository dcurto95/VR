//Library imports
import controlP5.*;
//Constants
final int VIDEO_INICIAL = 0;
final int Home = 1;
final int GAME = 2;
final int OPTIONS = 3;
final int ENDGAME = 4;

//Variables
Net net;
Hud hud;
Background background;
Spider spider;
Menu menu;
int menuState;
float n,n1;//Variables for color fadein
int c1,c2; //My Colour palette
int myColor = color(0);
void setup(){
  menuState=0;
  size(1024,768);
  //fullScreen(); 
  net = new Net(4);
  //hud = new Hud(this);
  background = new Background();
  spider = new Spider(new PVector(1,1));
  menu = new Menu(this);
}


//Draw function
void draw(){
 
  background(myColor); 
  switch(menuState) {
    case VIDEO_INICIAL:
          //HISTORIA Y VIDEO INICIAL
      break;
      case Home:
          menu.draw();
      break;
      case GAME:
      background(255);
        //  background.display(); //Displays background images
          net.drawNet(); //Display spider net
         // hud.display(); //Display hud info
          spider.updateSpiderPositionInScreen();
          spider.drawSpider();
          menu.hide();
      break;
      case OPTIONS:
          myColor = lerpColor(c1,c2,n);
          n += (1-n)* 0.1;  
      break;
      case ENDGAME:
          exit();
      break; 
  }
 
}


//Mouse click control
void mouseClicked() {
 // print("info: MOUSE PRESSED\n");
 // println("info: COORDINATES [" + mouseX + "," + mouseY + "]");
 // hud.startTimer();
 
}
//Key control (variable key always returns the ASCI number of the pressed key, i think)
void keyPressed() {
  print("info: KEY PRESSED ( key = " + key + " )\n");
 // if(key == 'r') hud.resetTimer();
 // if(key == 's') hud.substractLifeSpider();
//  if(key == 'b') hud.substractLifeBoy();
  if(key == 'a') spider.turnLeft();
  if(key == 'd') spider.turnRight();
  if(key == 'w') spider.goToNextPointForward();
  if(key == 's') spider.goToNextPointBackWards(); 
}

//Callbacks starts when a menu Button is pressed 
   public void Home(){    menuState = 1; }
   public void Play(){    menuState = 2; }
   public void Options(){ menuState = 3; c2 = color(150,0,0); c2 = color(255,255,0);  }
   public void Exit(){    menuState = 4; }