class Playhead {
  int position;
  int direction;
  int directionOffset; // 1 or -1
  int offset; // in integer pixels
  float speed; // where 1.0 is same as default
  boolean active;
  int col;

  ArrayList<Integer> playedNotes;

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

    clearPlayed();
  }

  void activate() {
    active = true;
    render();
  }

  void deactivate() {
    active = false;
  }

  void toggle() {
    active = !active;
  }

  boolean isForwards() {
    return directionOffset > 0; 
  }

  boolean isBackwards() {
    return directionOffset < 0;
  }

  void changeOffset(int o, int reference) {
    offset = o;
    position = reference + o;
    if(position > stave.staveWidth) {
      position = position % stave.staveWidth;
    }
    if(position < 0) {
      position = stave.staveWidth + position;
    }
  }

  void render() {
    strokeWeight(2);
    stroke(col);

    int x = position + stave.xPadding;
    
    line(x,0,x,height);
  }

  void renderIntersections() {
    for (Note n : stave.notes) {
      if(n.intersectedBy(position)) {
        noStroke();
        fill(col);
        int absX = n.x + stave.xPadding;
        int absY = n.y + stave.topPadding;
        float dia = n.diameter + 8;
        ellipse(absX, absY,dia,dia);
      }
    }
  }

  void modifyPositionBy(float amt) {
    position += (amt * directionOffset * speed);

    // notify stave if we've changed direction
    if((direction == 1) && (amt < 0)) {
      direction = 1 - direction;
      clearPlayed();
    }
    if((direction == 0) && (amt > 0)) {
      direction = 1 - direction;
      clearPlayed();
    }

    if(position > stave.staveWidth) {
      position = position % stave.staveWidth;
      clearPlayed();
    }
    if(position < 0) {
      position = stave.staveWidth + position;
      clearPlayed();
    }
  }

  void playNotes() {
    for (Note n : stave.notes) {
      if(n.intersectedBy(position)) {
        // println("I should play " + n);
        if(playedNotes.indexOf(n.hashCode()) < 0) {
          println("Note not in played list");
          n.play();
          playedNotes.add(n.hashCode());
          println(playedNotes.indexOf(n.hashCode()));
        } else {
          // println("But I won't: Note in played list at index ", playedNotes.indexOf(n.hashCode()));
        }
      }
    }
  }

  void clearPlayed() {
    playedNotes = new ArrayList<Integer>();
  }

}