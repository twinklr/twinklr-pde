class Playhead {
  int position;
  PApplet parent;
  Stave stave;

  Playhead (Stave s, PApplet p) {  
    this.parent = p;
    this.stave = s;

    position = 0;
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
  }
}