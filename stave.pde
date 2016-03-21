class Stave {
  int noteCount, staveWidth, staveHeight, xPadding, topPadding, bottomPadding, lineHeight, lineCount;
  boolean canEdit, alteringLength;
  Soundbox soundBox;
  PApplet parent;
  ArrayList<Note> notes;

  Stave (int nc, Soundbox s, PApplet parent) {  
    this.parent = parent;
    this.noteCount = nc;
    this.soundBox = s;
    this.notes = new ArrayList<Note>();

    xPadding = 50;
    topPadding = 30;
    bottomPadding = 70;

    staveWidth = width - (xPadding*2);
    staveHeight = 0;

    canEdit = true;
    alteringLength = false;
  }

  void render() {
    // staveWidth is set on creation, and updated via a function
    // by contrast, staveHeight is consistent.
    staveHeight = height - (topPadding+bottomPadding);

    lineCount = noteCount - 1;

    lineHeight = floor(staveHeight / lineCount);

    // Draw gray box
    noFill();
    strokeWeight(1);
    stroke(40);
    rect(xPadding, topPadding, staveWidth, staveHeight);

    // draw thick block at beginning
    fill(40);
    rect(xPadding, topPadding, 3, staveHeight);

    // draw staves
    noFill();
    for (int i = 0; i < lineCount; i++) {
      int x1 = xPadding;
      int y1 = topPadding + (i* lineHeight);
      int x2 = x1 + staveWidth;
      int y2 = topPadding + (i* lineHeight);
      line(x1, y1, x2, y2);
    }

    // draw end
    if(alteringLength) {
      noStroke();
      fill(244,144,24);
      rect(staveWidth+xPadding, topPadding, 5, staveHeight);      
    }
  }

  void drawNotes() {
    for (Note note : notes) {
      note.draw();
      note.play();
    }
  }

  void click(int x, int y) {
    if(!canEdit) {
      return;
    }

    boolean add = true;
    // first, for each note, is it inside?

    int localX = x - xPadding;
    int localY = y - topPadding;
    
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

  void resetNotes() {
    for (Note note : notes) {
      note.played = false;
    }
  }

  int getColorIndexForNote(Note n) {
    int noteIndex = indexOfNote(n);

    // now ask the current scale what that is in its terms
    return soundBox.getScaleIndexFromAbsolute(noteIndex);

  }

  boolean insideStave(int x, int y) {
    int finger = 5;
    if(x < xPadding-finger) { return false; }
    if(x > staveWidth+finger) { return false; }
    if(y < topPadding-finger) { return false; }
    if(y > (topPadding+staveHeight+finger)) { return false; }
    return true;
  }

  void fadeOutNotes() {
    for (Note note : stave.notes) {
      note.fadeOut();
    }
  }

  void fadeInNotes() {
    for (Note note : stave.notes) {
      note.fadeIn();
    }
  }

  void toggleAlterLength() {
    if(alteringLength) {
      canEdit = true;
      alteringLength = false;

      removeNotesOutsideWidth();

      fadeInNotes();
    } else {
      canEdit = false;
      alteringLength = true;
      
      fadeOutNotes();
    }
  }

  void stopAlteringLength() {
    alteringLength = false;
    removeNotesOutsideWidth();
    fadeInNotes();
  }

  void startAlteringLength() {
    alteringLength = true;
    fadeOutNotes();
  }

  void updateWidthFromAbs(int x) {
    int minWidth = 250;
    int maxWidth = width - (xPadding*2);

    int relX = x - xPadding;
    if(x < (minWidth+xPadding)) {
      staveWidth = minWidth;
    } else if(x > (maxWidth+xPadding)) {
      staveWidth = maxWidth;
    } else {
      staveWidth = relX;
    }
  }

  void removeNotesOutsideWidth() {
    for (Note note : stave.notes) {
      if(note.x > staveWidth) {
        note.destroy();
      }
    }
  }
}