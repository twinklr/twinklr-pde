import de.looksgood.ani.*;
import processing.sound.*;

Stave stave;
Playhead playhead;

void setup() {
  size(800, 480);
  smooth();
  background(255);

  Ani.init(this);
  Ani.noAutostart();

  int noteCount = 15;

  Soundbox soundbox = new Soundbox(noteCount, this);
  stave = new Stave(noteCount, this);
  playhead = new Playhead(stave, this);
}

void draw() {
  background(255);
  stave.render();
  playhead.render();
  stave.drawNotes();
}

void mouseReleased() {
  stave.click(mouseX, mouseY);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  playhead.modifyPositionBy(e);
}