class Note {
  int x, y;
  boolean playing;
  Ani growAni, shrinkAni;
  PApplet parent;
  Stave stave;
  Playhead playhead;
  
  float diameter = 30;
  float startDiameter = 0;
  float radius = diameter / 2;
  
  Note(int xPos, int yPos, Stave s, Playhead pl, PApplet p) {
    x = xPos;
    y = yPos;
    this.stave = s;
    this.playhead = pl;
    this.parent = p;
    playing = false;
    
   
    growAni = new Ani(this, 0.1, "startDiameter", diameter, Ani.LINEAR);
    shrinkAni = new Ani(this, 0.1, "startDiameter", 0.0, Ani.LINEAR, "onEnd:remove");  
    
    growAni.start();
  }

  void draw() {
    if(intersectedBy(playhead.position)) {
      strokeWeight(3);
      stroke(128,0,0);
    } else {
      noStroke();
    }
    fill(0,255,0); 
    
    ellipse(x+stave.xPadding,y,startDiameter,startDiameter);
  }
  
  void play() {
    if(intersectedBy(playhead.position) && !playing) {
      //playing = true;
    }
  }
  
  void destroy() {
    shrinkAni.setBegin();
    shrinkAni.start();
  }
  
  void remove() {
    stave.notes.remove(this);
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