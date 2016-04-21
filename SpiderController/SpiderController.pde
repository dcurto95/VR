import controlP5.*;

/*Menu States*/
int state = 0; //The current state
final int VIDEO_INICIAL = 0;
final int GAME_MENU = 1;
final int GAME = 2;
final int OPTIONS = 3;
final int ENDGAME = 4;
Button play,options,exit,home;
Net net;
ControlP5 cp5;

void setup() {
size(800,600);
net = new Net(4);
setButtons();
   
}


void draw() {
  background(255,255,255);
  
   switch(state) {
      case VIDEO_INICIAL:
          //HISTORIA Y VIDEO INICIAL
      break;
      case GAME_MENU:
        //Game Menu Stuff BOTONES...
         println("Menu"); 
         play.show();
         options.show();
         exit.show();
         home.hide();
      break;
      case GAME:
        //Escondemos botones
        play.hide();
        options.hide();
        exit.hide();
        home.show();
        println("Game");
        //MOSTRAMOS EL JUEGO
        background(255);
        net.drawNet();
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
}


//Cuando se haga click en el button con el nombre PLAY se ejecutara la funcion PLAY()
public void PLAY(int theValue){
  state = 2;
}
//Cuando se haga click en el button con el nombre Options se ejecutara la funcion Options()

public void Options(int theValue){

  state = 3;
}
public void Exit(int theValue){
  
  state = 4;
}
public void Home(int theValue){
  println("home");
  state = 1;
}

//Creamos los botones e inicializamos las caracteristicas
void setButtons(){
  cp5 = new ControlP5(this);
  /*SET PLAY BUTTON*/
  play = cp5.addButton("PLAY")
     .setValue(0)
     .setPosition(400-100,200)
     .setSize(200,19)
     ;
  /*SET EXIT BUTTON*/   
  exit=  cp5.addButton("Exit")
     .setValue(100)
     .setPosition(400-100,300)
     .setSize(200,19)
     ;
  /*SET OPTIONS BUTTON*/
  options= cp5.addButton("Options")
     .setValue(100)
     .setPosition(400-100,250)
     .setSize(200,19)
     ;
    PImage[] imgs = {loadImage("home.png"),loadImage("home.png"),loadImage("home.png")};
  home = cp5.addButton("Home")
     .setValue(128)
     .setPosition(10,10)
     .setImages(imgs)
     .updateSize()
     .hide()
     ;
 
  

}
