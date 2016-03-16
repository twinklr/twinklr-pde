import de.looksgood.ani.*;
import processing.sound.*;

int playheadPos = 0;

int noteDiameter = 20;

Stave stave;

ArrayList<Note> notes = new ArrayList<Note>();

void setup() {
  size(800, 480);
  smooth();
  background(255);

  Ani.init(this);
  Ani.noAutostart();

  Soundbox soundbox = new Soundbox(this);
  stave = new Stave(15, this);

}

void draw() {
  background(255);
  stave.render();
  drawPlayHead();
  // drawNotes();
  //playNotes();
}



void drawPlayHead() {
  strokeWeight(2);
  stroke(128,0,0);  
  int absPos = playheadPos % stave.staveWidth;
  if(absPos < 0) {
    absPos = stave.staveWidth + absPos;
  }
  int x = absPos + stave.xPadding;
  line(x,0,x,height);
}

void drawNotes() {
  for (Note note : notes) {
    note.draw();
    note.play();
  }
}

void playNotes() {
}

void mouseReleased() {
  boolean add = true;
  // first, for each note, is it inside?
  
   for (int i = 0; i < notes.size(); i++) {
     Note note = notes.get(i);
     if(note.intersectedBy(mouseX-stave.xPadding,mouseY)) {
       note.destroy();
       add = false;
    }
   }

  if(add) {
    Note n = new Note(mouseX-stave.xPadding,mouseY, stave, this);
  
    notes.add(n);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  playheadPos += e;
  //println(e);
}