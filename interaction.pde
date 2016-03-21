ControlP5 cp5;
ControllerGroup lengthGroup;
ControllerGroup scalesGroup;

void setupGui() {
  cp5 = new ControlP5(this);

  createBottomButtons();
  createLengthGroup();
  createScalesGroup();
}

void mouseDragged() {
  if(stave.alteringLength) {
    stave.updateWidthFromAbs(mouseX);
    if(playhead.position > stave.staveWidth) {
      playhead.position = stave.staveWidth;
    }
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
                   .setBackgroundHeight(150)
                   .setBackgroundColor(color(0,128))
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

void createScalesGroup() {
  scalesGroup = cp5.addGroup("scalesGroup")
                   .setPosition(100,100)
                   .hideArrow()
                   .setCaptionLabel("Change Scale and Root")
                   .disableCollapse()
                   .setWidth(600)
                   .setBackgroundHeight(300)
                   .setBackgroundColor(color(0,128))
                   // .hide()
                   ;

  String[] bottomScaleButtons = {"C", "D", "E", "F", "G", "A", "B"};

  for (int i = 0; i < bottomScaleButtons.length; i++) {
    String buttonName = "scale" + bottomScaleButtons[i] + "But";
    cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((85 + (i*60)),100)
     .setSize(50,50)
     .setGroup(scalesGroup)
     .setCaptionLabel(bottomScaleButtons[i])
     .setBroadcast(true)
    ;
  }

  String[] topScaleButtons = {"C#", "Eb", "F#", "Ab", "Bb"};

  for (int i = 0; i < topScaleButtons.length; i++) {
    int skew = 0;
    if( i > 1) {
      skew = 65;
    }
    String functionSafeName = topScaleButtons[i].replace("#", "sharp").replace("b", "flat");
    String buttonName = "scale" + functionSafeName + "But";
    Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((115 + (i*60) + skew),40)
     .setSize(50,50)
     .setGroup(scalesGroup)
     .setCaptionLabel(topScaleButtons[i])
     .setBroadcast(true)
    ;

    but.getCaptionLabel().toUpperCase(false);
  }

  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};

  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";
    cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((30 + (i*60)),170)
     .setSize(50,50)
     .setGroup(scalesGroup)
     .setCaptionLabel(scaleTypes[i])
     .setBroadcast(true)
    ;
  }

  // cp5.addTextlabel("label")
  //    .setText("Drag the orange marker to create a loop.")
  //    .setPosition(10,20)
  //    .setWidth(40)
  //    .setGroup(scalesGroup);
  //    ;

  cp5.addButton("doneAlteringScalesBut").setBroadcast(false)
     .setPosition(210,250)
     .setSize(180,40)
     .setGroup(scalesGroup)
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