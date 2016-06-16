import ddf.minim.*;

class MusicController{
  private Minim minim;
  private AudioPlayer music;
  private AudioPlayer fx;
  
  
  public MusicController(PApplet thePApplet){
    minim = new Minim(thePApplet);
    music = minim.loadFile("music1.mp3", 2048);
    music.loop();
    fx = minim.loadFile("crickets1.mp3", 2048);
    
  }
  
  void playCrickets(){
    fx.play();
  }
}
