class Playhead {
  int position;
  int direction;
  PApplet parent;
  Stave stave;

  Playhead (Stave s, PApplet p) {  
    this.parent = p;
    this.stave = s;

    position = 0;
    direction = 1;
  }

  void render() {
    strokeWeight(2);
    stroke(128,0,0);  

    int x = position + stave.xPadding;
    
    line(x,0,x,height);
  }

  void modifyPositionBy(float amt) {
    position += amt;

    // notify stave if we've changed direction
    if((direction == 1) && (amt < 0)) {
      direction = 1 - direction;
      stave.resetNotes();
    }
    if((direction == 0) && (amt > 0)) {
      direction = 1 - direction;
      stave.resetNotes();
    }

    if(position > stave.staveWidth) {
      position = position % stave.staveWidth;
      stave.resetNotes();
    }
    if(position < 0) {
      position = stave.staveWidth + position;
      
    }
  }
}