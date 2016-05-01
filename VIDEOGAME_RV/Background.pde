class Background{
  
  //Background images (diferent layers)
  PImage window;
  PImage spiderweb;
  PImage spiderweb2;
  PImage view;
  
  Background() {
    loadAllImages();  
  }

  void display() {
    image(view, 0, 0);
    image(window, 0, 0);
    //image(spiderweb, 0, 0);
    //image(spiderweb2, 0, 0);
  }

  void loadAllImages() {
    view = loadImage("images/trees.jpg");
    view.resize(width, height);
    window = loadImage("images/window-alpha.png");
    window.resize(width, height);
    spiderweb = loadImage("images/web-1-alpha.png");
    spiderweb.resize(displayWidth, displayHeight);
    spiderweb2 = loadImage("images/web-2.png");
    spiderweb2.resize(displayWidth, displayHeight);
  }


}//endClass