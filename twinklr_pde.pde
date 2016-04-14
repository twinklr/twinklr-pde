import de.looksgood.ani.*;
import controlP5.*;
// import processing.io.*;

Stave stave;
PlayheadManager playheadManager;
Playhead playhead;
Soundbox soundbox;

PImage loadingImg;
boolean loaded = false;

void setup() {
  size(800, 480);;
  
  smooth();
  loadingImg = loadImage("twinklr-loading.jpg");
  background(loadingImg);  
  // GPIO.pinMode(pinA, GPIO.INPUT);
  // GPIO.attachInterrupt(pinA, this, "updatePinA", GPIO.CHANGE);
  
  // GPIO.pinMode(pinB, GPIO.INPUT);
  // GPIO.attachInterrupt(pinB, this, "updatePinB", GPIO.CHANGE);
}

void draw() {
  if(!loaded) {
    Ani.init(this);
    Ani.noAutostart();

    int noteCount = 15;

    soundbox = new Soundbox(noteCount, this);
    stave = new Stave(noteCount, soundbox, this);
    playheadManager = new PlayheadManager(stave, this);

    setupGui();
    loaded = true;
  }

  background(255);
  stave.render();
  playheadManager.render();
  stave.drawNotes();
  playheadManager.playNotes();
}
