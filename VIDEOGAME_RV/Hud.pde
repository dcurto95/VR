class Hud {

  //Constants
  final int COUNT_DOWN_TIME = 120; //in seconds 
  final int INITIAL_LIFE = 10; //in seconds 
  final int MAX_LIFES = 10; //in seconds 
  final int W = width;
  final int H = height;

  //Game variables
  int lifesSpider;
  int lifesBoy;
  boolean isPaused;
  int seconds;
  int startTime;

  //Hud Image
  PImage hudImage;

  //Sliders 
  ControlP5 cp5;
  Slider sliderSpider, sliderBoy;
  Knob time;


  //Constructor
  Hud( PApplet thePApplet) {
    lifesSpider = INITIAL_LIFE;
    lifesBoy = INITIAL_LIFE;
    isPaused = true;

    //Load HUD image
    hudImage =loadImage("images/hud.png");
    hudImage.resize(W, H);

    //Configuration all sliders and knobs
    cp5 = new ControlP5(thePApplet);  
    sliderBoy = cp5.addSlider("SBLIFE")
      .setPosition(W-(W-115), H-(H-62))
      .setSize(130, 10)
      .setRange(1, MAX_LIFES)
      .setValue(INITIAL_LIFE)
      .setColorCaptionLabel(color(255, 255, 255))
      .setColorValueLabel(color(0, 0, 0))
      .setColorActive(color(0, 0, 255))
      .setColorBackground(color(0, 0, 0))
      .setColorForeground(color(0, 0, 255))
      .lock();    
    sliderSpider = cp5.addSlider(" ")
      .setPosition(W-244, H-(H-62))
      .setSize(130, 10)
      .setRange(1, MAX_LIFES)
      .setValue(MAX_LIFES - INITIAL_LIFE)
      .setColorCaptionLabel(color(255, 255, 255))
      .setColorValueLabel(color(0, 0, 255))
      .setColorActive(color(0, 0, 255))
      .setColorBackground(color(0, 0, 255))
      .setColorForeground(color(0, 0, 0))
      .lock(); 
    time = cp5.addKnob("TIME")
      .setRange(0, COUNT_DOWN_TIME)
      .setValue(COUNT_DOWN_TIME/2-20)
      .setPosition(W/2-40, 40)
      .setRadius(40)
      .setDragDirection(Knob.VERTICAL)
      .setColorBackground(color(0, 0, 0))
      .setColorForeground(color(255, 255, 255))
      .lock();
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
    if (lifesSpider > 0)lifesSpider--;
  }

  void substractLifeBoy() {
    if (lifesBoy > 0)lifesBoy--;
  }


  void updateScores() {
    fill(255);      
    textSize(50);
    text(nf(lifesBoy, 2), (W - (W - 35)), 100); 
    text(nf(lifesSpider, 2), (W - 100), 100);
    sliderBoy.setValue(lifesBoy);
    sliderSpider.setValue(MAX_LIFES- lifesSpider);
  }


  //Starts countdown
  void startTimer() {
    isPaused = false;
    startTime = millis()/1000 + COUNT_DOWN_TIME;
  }


  //Resets the timer countdown
  void resetTimer() {
    isPaused = true;
    seconds = COUNT_DOWN_TIME;
  }


  //Refresh and shows the timer information
  void updateTime() {  
    if (!isPaused) {
      if (seconds < 0 || seconds == 0 || lifesSpider == 0 || lifesBoy == 0) {
        seconds = 0;
        textSize(60);
        fill(255, 0, 0);
        text("TIME OVER", W/3 -120, H/2);
        textSize(80);
        fill(255);
        if (lifesBoy>lifesSpider) text("BUTT WINS", W/3, H/2+200);
        else  text("SPIDER WINS", W/2 -220, H/2+200);
      }
      if (seconds > 0) {               
        seconds = startTime - millis()/1000;
      }
    } else {
      seconds = COUNT_DOWN_TIME;
    }
    textSize(25);
    text(nf((seconds/60 % 60), 2) + ":" + nf((seconds % 60), 2), W/2 - 40, 160); 
    time.setValue(seconds);
  }
  
  
  
}//endClass