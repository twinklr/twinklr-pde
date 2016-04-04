class Playhead {
  int position;
  int direction;
  int directionOffset; // 1 or -1
  int offset; // in integer pixels
  float speed; // where 1.0 is same as default
  boolean active;
  int col;

  PApplet parent;
  Stave stave;

  Playhead (Stave s, PApplet p, int c, boolean a) {  
    this.parent = p;
    this.stave = s;

    position = 0;
    direction = 1;
    directionOffset = 1;
    offset = 0;
    speed = 1.0;
    active = a;
    col = c;
  }

  void changeOffset(int offset) {
    position += offset;
  }

  void render() {
    strokeWeight(2);
    stroke(col);

    int x = position + stave.xPadding;
    
    line(x,0,x,height);
  }

  void modifyPositionBy(float amt) {
    position += (amt * directionOffset * speed);

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
      stave.resetNotes();
    }
  }
}