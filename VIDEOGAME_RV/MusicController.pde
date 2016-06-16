import ddf.minim.*;

class MusicController{
  private Minim minim;
  private AudioPlayer music;
  private AudioPlayer fx;
  private AudioPlayer fxFreeButterfly;
  private AudioPlayer fxEatBut;
  
  
  
  public MusicController(PApplet thePApplet){
    minim = new Minim(thePApplet);
    music = minim.loadFile("music1.mp3", 2048);
    music.loop();
    fxFreeButterfly = minim.loadFile("boing.mp3", 2048);
    fxEatBut = minim.loadFile("eat.mp3", 2048);
  }
  
  void playSpiderEats(){
    fxEatBut.rewind();
    fxEatBut.play();
  }
  
  void playFreeBut(){
    fxFreeButterfly.rewind();
    fxFreeButterfly.play();
  }
}
