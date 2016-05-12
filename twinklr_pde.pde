import de.looksgood.ani.*;
// import processing.io.*;

Stave stave;
PlayheadManager playheadManager;
Playhead playhead;
Soundbox soundbox;
Midibox midibox;

PImage loadingImg;
boolean loaded = false;
PFont deja;

void setup() {
  size(800, 480);
  //fullScreen();
  //noCursor();
  smooth();
  
  loadingImg = loadImage("twinklr-loading.jpg");
  deja = createFont("deja.ttf",14);
  background(loadingImg);  

  // begin RPi mode
  // noInterrupts();
  // delay(10);

  // GPIO.pinMode(pinA, GPIO.INPUT);
  // delay(10);
  // GPIO.releaseInterrupt(pinA);
  // delay(10);
  // GPIO.attachInterrupt(pinA, this, "updatePinA", GPIO.CHANGE);
  // delay(10);
  
  // GPIO.pinMode(pinB, GPIO.INPUT);
  // delay(10);
  // GPIO.releaseInterrupt(pinB);
  // delay(10);
  // GPIO.attachInterrupt(pinB, this, "updatePinB", GPIO.CHANGE);
  // delay(10);
  // interrupts();
  // delay(10);
}

void draw() {
  if(!loaded) {
    Ani.init(this);
    Ani.noAutostart();

    int noteCount = 15;

    midibox = new Midibox(this);

    soundbox = new Soundbox(noteCount, midibox, this);
    stave = new Stave(noteCount, soundbox, this);
    playheadManager = new PlayheadManager(stave, this);



    setupGui();
    prepareExitHandler();
    loaded = true;
  }

  background(255);

  stave.render();
  playheadManager.render();
  stave.drawNotes();
  playheadManager.playNotes();

  for (int i = 0; i < bottomButtons.length; i++ ) {
    bottomButtons[i].render();
  }
}

private void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      System.out.println("SHUTDOWN HOOK");

      // application exit code here
      if(midibox.currentBusName != null) {
        midibox.midiBus.clearAll();
      }
    }
  }));
}