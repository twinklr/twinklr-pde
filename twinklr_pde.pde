import de.looksgood.ani.*;
import processing.sound.*;
import controlP5.*;

Stave stave;
Playhead playhead;
Soundbox soundbox;

void setup() {
  size(800, 480);
  smooth();
  background(255);

  Ani.init(this);
  Ani.noAutostart();

  int noteCount = 15;

  soundbox = new Soundbox(noteCount, this);
  stave = new Stave(noteCount, soundbox, this);
  playhead = new Playhead(stave, this);

  setupGui();
}

void draw() {
  background(255);
  stave.render();
  playhead.render();
  stave.drawNotes();
}
