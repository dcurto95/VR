class Background{
  
  PImage window;
  PImage background1;
  PImage background2;
  
  Background() {
    loadAllImages();  
  }

  void display() {
    pushMatrix();
    translate(width/2, height/2);
    image(background2, 0, 0);
    popMatrix();
  }

  void loadAllImages() {
    background1 = loadImage("images/trees-blurred.jpg");
    background1.resize(width, height);
    background2 = loadImage("images/creepy-blurred.jpg");
    background2.resize(width, height);
    window = loadImage("images/window-alpha-blurred.png");
    window.resize(width, height);
  }
  
}//endClass