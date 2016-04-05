Playhead[] playheads;
PApplet parent;

class PlayheadManager {
  PlayheadManager (Stave s, PApplet p) {  
    playheads = new Playhead[4];
    parent = p;

    Playhead p1 = new Playhead(stave, parent, color(128,0,0), true);
    playheads[0] = p1;

    Playhead p2 = new Playhead(stave, parent, color(0,128,0), false);
    playheads[1] = p2;

    Playhead p3 = new Playhead(stave, parent, color(0,0,128), false);
    playheads[2] = p3;

    Playhead p4 = new Playhead(stave, parent, color(128,0,128), false);
    playheads[3] = p4;
  }

  void render() {
    for (Playhead p : playheads) {
      if(p.active) {
        p.render();
        p.renderIntersections();
      }
    }
  }

  void playNotes() {
    for (Playhead p : playheads) {
      if(p.active) {
        p.playNotes();
      }
    }
  }

  void modifyPositionBy(float amt) {
    for (Playhead p : playheads) {
      if(p.active) {
        p.modifyPositionBy(amt);
      }
    }
  }

  void updatePlayheadsToWidth() {
    for (Playhead p : playheads) {
      if(p.active) {
        if(p.position > stave.staveWidth) {
          p.position = stave.staveWidth;
        }
      }
    }
  }
}