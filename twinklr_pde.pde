import de.looksgood.ani.*;
import controlP5.*;
// import processing.io.*;

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

  // GPIO.pinMode(pinA, GPIO.INPUT);
  // GPIO.attachInterrupt(pinA, this, "updatePinA", GPIO.CHANGE);
  
  // GPIO.pinMode(pinB, GPIO.INPUT);
  // GPIO.attachInterrupt(pinB, this, "updatePinB", GPIO.CHANGE);
}

void draw() {
  background(255);
  stave.render();
  playhead.render();
  stave.drawNotes();
}
