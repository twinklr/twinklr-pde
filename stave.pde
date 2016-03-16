class Stave {
  int noteCount, staveWidth, staveHeight, xPadding, yPadding, lineHeight, lineCount;
  Soundbox soundBox;
  PApplet parent;
  ArrayList<Note> notes;

  Stave (int nc, Soundbox s, PApplet parent) {  
    this.parent = parent;
    this.noteCount = nc;
    this.soundBox = s;
    this.notes = new ArrayList<Note>();
    
    xPadding = 50;
    yPadding = 30;

    staveWidth = 0;
    staveHeight = 0;
  }

  void render() {
    staveWidth = width - (xPadding*2);
    staveHeight = height - (yPadding*2);

    lineCount = noteCount - 1;

    lineHeight = floor(staveHeight / lineCount);

    // Draw gray box
    noFill();
    strokeWeight(1);
    stroke(40);
    rect(xPadding, yPadding, staveWidth, staveHeight);

    // draw thick block at beginning
    fill(40);
    rect(xPadding, yPadding, 3, staveHeight);

    // draw staves
    noFill();
    for (int i = 0; i < lineCount; i++) {
      int x1 = xPadding;
      int y1 = yPadding + (i* lineHeight);
      int x2 = x1 + staveWidth;
      int y2 = yPadding + (i* lineHeight);
      line(x1, y1, x2, y2);
    }
  }

  void drawNotes() {
    for (Note note : notes) {
      note.draw();
      note.play();
    }
  }

  void click(int x, int y) {
    boolean add = true;
    // first, for each note, is it inside?

    int localX = x - xPadding;
    int localY = y - yPadding;
    
     for (int i = 0; i < notes.size(); i++) {
       Note note = notes.get(i);
       if(note.intersectedBy(localX, localY)) {
         note.destroy();
         add = false;
      }
     }

    if(add) {
      Note n = new Note(localX, localY, this, playhead, parent);
    
      notes.add(n);
    }
  }

  int indexOfNote(Note n) {
    int lineIndex = (int) Math.floor((n.y + (lineHeight/2)) / lineHeight);
    // this is index from top downwards. so we have to flip it, because music goes bottom-to-top:
    return lineCount - lineIndex;
  }

  void directionChanged() {
    for (Note note : notes) {
      note.played = false;
    }
  }

  int getColorIndexForNote(Note n) {
    int noteIndex = indexOfNote(n);

    // now ask the current scale what that is in its terms
    return soundBox.getScaleIndexFromAbsolute(noteIndex);

  }
}