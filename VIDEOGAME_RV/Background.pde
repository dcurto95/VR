class Background{
  
  //Background images (diferent layers)
  PImage window;
  PImage spiderweb;
  PImage view;
  PImage view2;
  
  Background() {
    loadAllImages();  
  }

  void display() {
    pushMatrix();
    translate(width/2, height/2);
    //image(view, 0, 0);
    image(view2, 0, 0);
   // image(window, 0, 0);
    popMatrix();
  }

  void loadAllImages() {
    view = loadImage("images/trees-blurred.jpg");
    view.resize(width, height);
    view2 = loadImage("images/creepy-blurred.jpg");
    view2.resize(width, height);
    window = loadImage("images/window-alpha-blurred.png");
    window.resize(width, height);
  }


}//endClass
