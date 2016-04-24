class Hud {

  //Constants
  final int COUNT_DOWN_TIME = 10; //in seconds 
  final int INITIAL_LIFE = 10; //in seconds 
  final int MAX_LIFES = 10; //in seconds 
  final int W = displayWidth;
  final int H = displayHeight;

  //Game variables
  int lifesSpider;
  int lifesBoy;
  boolean isStopped;
  int seconds;
  int startTime;

  //Hud Image
  PImage hudImage;

  //Constructor
  Hud( PApplet thePApplet) {
    lifesSpider = INITIAL_LIFE;
    lifesBoy = INITIAL_LIFE;
    isStopped = true;

    //Load HUD image
    hudImage =loadImage("images/hud.png");
    hudImage.resize(displayWidth, displayHeight);
  }

  void run() {
    display();
  }

  //Shows HUD image + punctuation + Time left
  void display() {
    image(hudImage, 0, 0);
    updateTime();  
    updateScores();
  }

  void substractLifeSpider() {
    if (lifesSpider > 0 && !isStopped) lifesSpider--;
  }

  void substractLifeBoy() {
    if (lifesBoy > 0 && !isStopped) lifesBoy--;
  }


  void updateScores() {
    fill(255);      
    textSize(50);
    text(nf(lifesBoy, 2), 410, 125); 
    text(nf(lifesSpider, 2), 1205, 125);
  }

  //Starts countdown
  void startTimer() {
    isStopped = false;
    startTime = millis()/1000 + COUNT_DOWN_TIME;
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
    textSize(60); fill(255, 0, 0);
    text("TIME OVER", W/2, H/2);
    textSize(80); fill(0);
    if (lifesBoy>lifesSpider) text("BUTT WINS", W/2 -220, H/2+200);
    else  text("SPIDER WINS", W/2 -220, H/2+200);
    //isStopped = true;
  }

  //Refresh and shows the timer information
  void updateTime() {  
    if (!isStopped) {
      if (seconds < 0 || seconds == 0 || lifesSpider == 0 || lifesBoy == 0) {
        showGameOver();
      }
      if (seconds > 0) {               
        seconds = startTime - millis()/1000;
      }
    } else {
      seconds = COUNT_DOWN_TIME;
    }
    fill(0);
    textSize(40);
    text(nf((seconds/60 % 60), 2) + ":" + nf((seconds % 60), 2), W/2 - 60, (W/16) + 20);
  }
}//endClass