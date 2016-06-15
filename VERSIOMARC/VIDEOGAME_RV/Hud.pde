class Hud {

  //Constants
  final int COUNT_DOWN_TIME = 100;   //in seconds 
  final int INITIAL_LIFE = 10;      //in seconds 
  final int MAX_LIFES = 10; 
  final int W = width;
  final int H = height;

  //Game variables
  int lifesSpider;
  int lifesBoy;
  boolean isStopped;
  int seconds;
  int startTime = 0;

  //Hud Image
  PImage hudImage;

  //Constructor
  Hud( PApplet thePApplet) {
    lifesSpider = INITIAL_LIFE;
    lifesBoy = INITIAL_LIFE;
    isStopped = true;

    //Load HUD image
    hudImage = loadImage("images/hud.png");
    hudImage.resize(W, H);
    
  }

  //Shows HUD image + punctuation + Time left
  void display() {
    pushMatrix();
    translate(width/2, height/2);
    image(hudImage, 0, 0);
    popMatrix();
    updateTime();  
    updateScores();
  }

  void updateScores() {
    fill(255);      
    rectMode(CENTER);  
    textSize(35);
    text(nf(lifesBoy, 2), W*0.24, H*0.12); 
    text(nf(lifesSpider, 2), W*0.71, H*0.12);
  }
  
  //Resets the timer countdown
  void resetAll() {
    isStopped = true;
    lifesSpider = INITIAL_LIFE;
    lifesBoy = INITIAL_LIFE;
    seconds = COUNT_DOWN_TIME;
  }

  void showGameOver() {
    seconds = 0;
    textSize(50); fill(0);
    if (lifesBoy>lifesSpider) text("TIME OVER: BUTT WINS", W/2 -220, H/2+200);
    else  text("TIME OVER: SPIDER WINS", W/2 -220, H/2+200);
    //isStopped = true;
  }
  
  
  //Starts countdown
  void startTimer() {
    isStopped = false;
    startTime = (millis() / 1000) + COUNT_DOWN_TIME;
    println("startime: "+ System.currentTimeMillis() % 1000 + " "+ COUNT_DOWN_TIME+" "+startTime + " " +millis());
  }

  //Refresh and shows the timer information
  void updateTime() {  
    if (!isStopped) {
      if (seconds < 0 || seconds == 0 || lifesSpider == 0 || lifesBoy == 0) {
        showGameOver();
      }
      if (seconds > 0) {               
        seconds = startTime - (millis() / 1000);
      }
    } else {
      seconds = COUNT_DOWN_TIME;
    }
    fill(0);
    textSize(25);
    text(nf((seconds/60 % 60), 2) + ":" + nf((seconds % 60), 2), W/2 - 35, (W/16) + 20);
  }
  
  
  void substractLifeSpider() {
    if (lifesSpider > 0 && !isStopped) lifesSpider--;
  }

  void substractLifeBoy() {
    if (lifesBoy > 0 && !isStopped) lifesBoy--;
  }
  
}//endClass
