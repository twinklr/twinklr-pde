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
    int xPos = position % stave.staveWidth;
    if(xPos < 0) {
      xPos = stave.staveWidth + xPos;
    }
    int x = xPos + stave.xPadding;
    line(x,0,x,height);
  }

  void modifyPositionBy(float amt) {
    position += amt;

    // notify stave if we've changed direction
    if((direction == 1) && (amt < 0)) {
      direction = 1 - direction;
      stave.directionChanged();
    }
    if((direction == 0) && (amt > 0)) {
      direction = 1 - direction;
      stave.directionChanged();
    }
  }
}