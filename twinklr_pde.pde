import de.looksgood.ani.*;
import processing.sound.*;

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

void keyPressed() {
  switch (key) {
    case 's':
      soundbox.cycleScale();
      print("Scale is now ");
      println(soundbox.scaleType);
      break;
    case 'r':
      soundbox.cycleRoot();
      print("Root is now ");
      println(soundbox.scaleRoot);
      break;
  }
}