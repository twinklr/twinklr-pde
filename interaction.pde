void setupGui() {
  cp5 = new ControlP5(this);
  Button lengthButton = cp5.addButton("lengthButton")
   .setBroadcast(false)
   .setValue(1)
   .setPosition(0,440)
   .setSize(199,40)
   .setBroadcast(true)
   ;

  lengthButton.setCaptionLabel("Length");

  Button scalesButton = cp5.addButton("scalesButton")
   .setBroadcast(false)
   .setValue(2)
   .setPosition(200,440)
   .setSize(199,40)
   .setBroadcast(true)
   ;

  scalesButton.setCaptionLabel("Scales");

  Button midiButton = cp5.addButton("midiButton")
   .setBroadcast(false)
   .setValue(3)
   .setPosition(400,440)
   .setSize(199,40)
   .setBroadcast(true)
  ;

  midiButton.setCaptionLabel("MIDI");

  Button preferencesButton = cp5.addButton("preferencesButton")
   .setBroadcast(false)
   .setValue(4)
   .setPosition(600,440)
   .setSize(200,40)
   .setBroadcast(true)
  ;

  preferencesButton.setCaptionLabel("Preferences");
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
      
      break;
  }
}

public void lengthButton(int theValue) {
  stave.toggleAlterLength();
}