import de.looksgood.ani.*;
import processing.sound.*;

int xPadding = 50;
int yPadding = 30;
int count = 14;
int playheadPos = 0;

int staveWidth = 0;
int staveHeight = 0;
int lineHeight = 0;

int noteDiameter = 20;

ArrayList<Note> notes = new ArrayList<Note>();

void setup() {
  size(640, 360);
  smooth();
  background(255);
  Ani.init(this);
  Ani.noAutostart();

}

void draw() {
  background(255);
  drawStave();
  drawPlayHead();
  drawNotes();
  //playNotes();
}

void drawStave() {
  staveWidth = width - (xPadding*2);
  staveHeight = height - (yPadding*2);

  lineHeight = floor(staveHeight / count);

  // Draw gray box
  noFill();
  strokeWeight(1);
  stroke(40);
  rect(xPadding, yPadding, staveWidth, staveHeight);

  // draw thick block at beginning
  fill(40);
  rect(xPadding, yPadding, 3, staveHeight);

  // draw staves
  noFill();
  for (int i = 0; i < count; i++) {
    int x1 = xPadding;
    int y1 = yPadding + (i* lineHeight);
    int x2 = x1 + staveWidth;
    int y2 = yPadding + (i* lineHeight);
    line(x1, y1, x2, y2);
  }
}

void drawPlayHead() {
  strokeWeight(2);
  stroke(128,0,0);  
  int absPos = playheadPos % staveWidth;
  if(absPos < 0) {
    absPos = staveWidth + absPos;
  }
  int x = absPos + xPadding;
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
     if(note.intersectedBy(mouseX-xPadding,mouseY)) {
       note.destroy();
       add = false;
    }
   }

  if(add) {
    Note n = new Note(mouseX-xPadding,mouseY);
  
    notes.add(n);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  playheadPos += e;
  //println(e);
}