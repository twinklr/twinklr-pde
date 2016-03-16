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

  Soundbox soundbox = new Soundbox(this);
  stave = new Stave(15, this);
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