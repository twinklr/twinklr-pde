ControlP5 cp5;
ControllerGroup lengthGroup;

void setupGui() {
  cp5 = new ControlP5(this);

  createBottomButtons();
  createLengthGroup();
}

void mouseDragged() {
  if(stave.alteringLength) {
    stave.updateWidthFromAbs(mouseX);
  }
}

void mousePressed() {
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
  if(lengthGroup.isVisible()) {
    lengthGroup.hide();
  } else {
    lengthGroup.show();
  }

  stave.toggleAlterLength();
}

public void doneAlteringLengthBut() {
  lengthGroup.hide();
  stave.toggleAlterLength();
}

void createLengthGroup() {
  lengthGroup = cp5.addGroup("lengthGroup")
                   .setPosition(80,80)
                   .hideArrow()
                   .setCaptionLabel("Change Sequence Length")
                   .disableCollapse()
                   .setWidth(200)
                   .setBackgroundHeight(300)
                   .setBackgroundColor(color(0,140))
                   .hide()
                   ;

  cp5.addTextlabel("label")
     .setText("Drag the orange marker to create a loop.")
     .setPosition(10,20)
     .setWidth(40)
     .setGroup(lengthGroup);
     ;

  cp5.addButton("doneAlteringLengthBut").setBroadcast(false)
     .setValue(101)
     .setPosition(10,100)
     .setSize(180,40)
     .setGroup(lengthGroup)
     .setCaptionLabel("Done!")
     .setBroadcast(true)
     ;
}

void createBottomButtons() {
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