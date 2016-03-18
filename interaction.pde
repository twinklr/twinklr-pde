void setupGui() {
  cp5 = new ControlP5(this);
  cp5.addButton("length")
   .setBroadcast(false)
   .setValue(1)
   .setPosition(0,440)
   .setSize(199,40)
   .setBroadcast(true)
   ;

  cp5.addButton("scales")
   .setBroadcast(false)
   .setValue(2)
   .setPosition(200,440)
   .setSize(199,40)
   .setBroadcast(true)
   ;

  cp5.addButton("midi")
   .setBroadcast(false)
   .setValue(3)
   .setPosition(400,440)
   .setSize(199,40)
   .setBroadcast(true)
  ;

  cp5.addButton("preferences")
   .setBroadcast(false)
   .setValue(4)
   .setPosition(600,440)
   .setSize(200,40)
   .setBroadcast(true)
  ;
}

void mouseDragged() {
  if(stave.alteringLength) {
    stave.updateWidthFromAbs(mouseX);
  }
}

void mouseReleased() {
  if(stave.insideStave(mouseX,mouseY)) {
    stave.click(mouseX, mouseY);
  }
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
    case 'l':
      stave.toggleAlterLength();
      break;
  }
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
}

public void scales(int theValue) {
  println("a button event from scales: "+theValue);
}