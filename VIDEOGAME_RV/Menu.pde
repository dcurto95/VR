import controlP5.*;
class Menu{
    //Constructor 
    Menu(PApplet thePApplet){
        ControlP5 cp5;
        cp5 = new ControlP5(thePApplet);
        setButtons(cp5);
    }
    // Initial conditions
    int state; //first state
    Button play,options,exit,home;
    void draw(){
         background(0);
         play.show();
         options.show();
         exit.show();  
    }
    void hide(){
      play.hide();
      options.hide();
      exit.hide();
    }
    //Creamos los botones e inicializamos las caracteristicas
    public void setButtons(ControlP5 cp5){
        /*SET PLAY BUTTON*/
        play = cp5.addButton("Play")
           .setValue(0)
           .setPosition((width/2)-100,200)
           .setSize(200,19)
           ;
        /*SET EXIT BUTTON*/   
        exit=  cp5.addButton("Exit")
           .setValue(100)
           .setPosition((width/2)-100,300)
           .setSize(200,19)
           ;
        /*SET OPTIONS BUTTON*/
        options= cp5.addButton("Options")
           .setValue(100)
           .setPosition((width/2)-100,250)
           .setSize(200,19)
           ;
       //  PImage[] imgs = {loadImage("home.png"),loadImage("home.png"),loadImage("home.png")};
        home = cp5.addButton("Home")
           .setValue(128)
           .setPosition(10,10)
          // .setImages(imgs)
           .updateSize()
           .hide();
    }
   
}//end of Class
  