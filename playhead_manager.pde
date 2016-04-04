Playhead[] playheads;
PApplet parent;

class PlayheadManager {
  PlayheadManager (Stave s, PApplet p) {  
    playheads = new Playhead[4];
    parent = p;

    Playhead p1 = new Playhead(stave, parent, color(128,0,0), true);
    playheads[0] = p1;

    Playhead p2 = new Playhead(stave, parent, color(0,128,0), true);
    p2.changeOffset(200);
    playheads[1] = p2;

    Playhead p3 = new Playhead(stave, parent, color(0,0,128), true);
    p3.changeOffset(300);
    p3.directionOffset = -1;
    p3.speed = 0.5;
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
    // if(intersectedBy(playhead.position) && !played) {
    //   // println(stave.indexOfNote(this));
    //   stave.soundBox.playSound(stave.indexOfNote(this));
    //   played = true;
    // }

    // TODO
    // if(intersectedBy(playhead.position)) {
    //   strokeWeight(3);
    //   stroke(128,0,0);
    // } else {
  }

  void modifyPositionBy(float amt) {
    for (Playhead p : playheads) {
      if(p.active) {
        p.modifyPositionBy(amt);
      }
    }
  }
}