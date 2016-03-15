class Note {
  int x, y;
  boolean playing;
  Ani growAni,shrinkAni;
  SoundFile soundfile;
  
  float diameter = 20;
  float startDiameter = 0;
  float radius = diameter / 2;
  
  Note(int xPos, int yPos) {
    x = xPos;
    y = yPos;
    playing = false;
    
    soundfile = new SoundFile(twinklr_test.this,"a3.mp3");
    
    growAni = new Ani(this, 0.1, "startDiameter", diameter, Ani.LINEAR);
    shrinkAni = new Ani(this, 0.1, "startDiameter", 0.0, Ani.LINEAR, "onEnd:remove");  
    
    growAni.start();
}

  void draw() {
    if(intersectedBy(playheadPos)) {
      strokeWeight(2);
      stroke(128,0,0);
    } else {
      noStroke();
    }
    fill(0,255,0); 
    
    ellipse(x+xPadding,y,startDiameter,startDiameter);
  }
  
  void play() {
    if(intersectedBy(playheadPos) && !playing) {
      playing = true;
      soundfile.play();
      println("SFDuration= " + soundfile.duration() + " seconds");
    }

  }
  
  void destroy() {
    shrinkAni.setBegin();
    shrinkAni.start();
  }
  
  void remove() {
    notes.remove(this);
  }
  
  boolean intersectedBy(int xPos) {
    if(((xPos) > (x-radius)) && ((xPos) < x+radius)) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean intersectedBy(int xPos, int yPos) {
    if(((xPos) > (x-radius)) && ((xPos) < x+radius)) {
      if(((yPos) > (y-radius)) && ((yPos) < y+radius)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}