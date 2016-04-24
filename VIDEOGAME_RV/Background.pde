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
    image(view, 0, 0);
    //image(view2, 0, 0);
    image(window, 0, 0);
    //image(spiderweb, 0, 0);
    //image(spiderweb2, 0, 0);
  }

  void loadAllImages() {
    view = loadImage("images/trees-blurred.jpg");
    view.resize(width, height);
    view2 = loadImage("images/creepy-blurred.jpg");
    view2.resize(width, height);
    window = loadImage("images/window-alpha-blurred.png");
    window.resize(width, height);
    /*spiderweb = loadImage("images/web-1-alpha.png");
    spiderweb.resize(displayWidth, displayHeight);*/
  }


}//endClass