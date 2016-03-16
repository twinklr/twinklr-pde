import de.looksgood.ani.*;
import processing.sound.*;

int noteDiameter = 20;

Stave stave;
Playhead playhead;

ArrayList<Note> notes = new ArrayList<Note>();

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
  drawNotes();
  //playNotes();
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
    Note n = new Note(mouseX-stave.xPadding,mouseY, stave, playhead, this);
  
    notes.add(n);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  playhead.modifyPositionBy(e);
}