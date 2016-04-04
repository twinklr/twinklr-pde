ControlP5 cp5;
ControllerGroup lengthGroup;
ControllerGroup scalesGroup;
ControllerGroup saveLoadGroup;

Storage store;
XML tuneXml;

int defaultBgColor = color(2,46,92);
int highlightColor = color(244,144,24);

void setupGui() {
  cp5 = new ControlP5(this);

  createBottomButtons();
  createLengthGroup();
  createScalesGroup();
  createSaveLoadGroup();
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

public void lengthButton(int theValue) {
  if(lengthGroup.isVisible()) {
    lengthGroup.hide();
    stave.stopAlteringLength();
  } else {
    scalesGroup.hide();
    saveLoadGroup.hide();
    lengthGroup.show();
    stave.startAlteringLength();
  }
}

public void scalesButton(int theValue) {
  if(scalesGroup.isVisible()) {
    scalesGroup.hide();
    saveLoadGroup.hide();
    stave.canEdit = true;
  } else {
    lengthGroup.hide();
    stave.stopAlteringLength();
    
    scalesGroup.show();
    stave.canEdit = false;
  }
}

public void saveLoadButton(int theValue) {
  if(saveLoadGroup.isVisible()) {
    saveLoadGroup.hide();
    stave.canEdit = true;
  } else {
    lengthGroup.hide();
    scalesGroup.hide();
    stave.stopAlteringLength();
    
    saveLoadGroup.show();
    stave.canEdit = false;
  }
}


public void doneAlteringLengthBut() {
  lengthGroup.hide();
  stave.stopAlteringLength();
}

public void doneAlteringScalesBut() {
  scalesGroup.hide();
  stave.canEdit = true;
  soundbox.updateScaleSounds();
}

public void closeSaveLoadButton() {
  saveLoadGroup.hide();
  stave.canEdit = true;
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

  cp5.addTextlabel("lengthLabel")
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

/*
 * Begin Scales Menu
 */

void createScalesGroup() {
  scalesGroup = cp5.addGroup("scalesGroup")
                   .setPosition(100,100)
                   .hideArrow()
                   .setCaptionLabel("Change Scale and Root")
                   .disableCollapse()
                   .setWidth(600)
                   .setBackgroundHeight(300)
                   .setBackgroundColor(color(0,128))
                   .hide()
                   ;

  String[] bottomScaleButtons = {"C", "D", "E", "F", "G", "A", "B"};

  for (int i = 0; i < bottomScaleButtons.length; i++) {
    String buttonName = "scale" + bottomScaleButtons[i] + "But";
    Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((85 + (i*60)),100)
     .setSize(50,50)
     .setGroup(scalesGroup)
     .setCaptionLabel(bottomScaleButtons[i])
     .setBroadcast(true)
    ;

    String normalizedScaleName = soundbox.normalizeScaleName(bottomScaleButtons[i]);
    if(normalizedScaleName.equals(soundbox.scaleRoot)) {
      but.setColorBackground(highlightColor);
    }
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

    String normalizedScaleName = soundbox.normalizeScaleName(topScaleButtons[i]);
    if(normalizedScaleName.equals(soundbox.scaleRoot)) {
      but.setColorBackground(highlightColor);
    }
  }

  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};

  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";
    Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((30 + (i*60)),170)
     .setSize(50,50)
     .setGroup(scalesGroup)
     .setCaptionLabel(scaleTypes[i])
     .setBroadcast(true)
    ;

    if(scaleTypes[i] == soundbox.scaleType) {
      but.setColorBackground(highlightColor);
    }
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

/*
 * End Scales group
 */

/*
 * Begin saveLoad group
 */

void createSaveLoadGroup() {
  saveLoadGroup = cp5.addGroup("saveLoadGroup")
                   .setPosition(100,100)
                   .hideArrow()
                   .setCaptionLabel("Save / Load")
                   .disableCollapse()
                   .setWidth(600)
                   .setBackgroundHeight(300)
                   .setBackgroundColor(color(0,128))
                   .hide()
                   ;

  // create SAVE header
  cp5.addTextlabel("saveLabel")
     .setText("SAVE")
     .setPosition(125,50)
     .setGroup(saveLoadGroup)
     ;

  // create Save Buttons
  for (int i = 0; i < 8; i++) {
    String buttonName = "save" + (i+1) + "But";
    int yPos = 100;
    int xIndex = i;
    if(i > 3) {
      yPos = 170;
      xIndex = i - 4;
    }
    Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((25 + (xIndex*60)),yPos)
     .setSize(50,50)
     .setGroup(saveLoadGroup)
     .setCaptionLabel(str(i+1))
     .setBroadcast(true)
    ;

    but.getCaptionLabel().setSize(12);
  }

  // create LOAD header
  cp5.addTextlabel("loadLabel")
     .setText("LOAD")
     .setPosition(425,50)
     .setGroup(saveLoadGroup)
     ;

  // create Load Buttons
  for (int i = 0; i < 8; i++) {
    String buttonName = "load" + (i+1) + "But";
    int yPos = 100;
    int xIndex = i;
    if(i > 3) {
      yPos = 170;
      xIndex = i - 4;
    }
    Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((300 + 25 + (xIndex*60)),yPos)
     .setSize(50,50)
     .setGroup(saveLoadGroup)
     .setCaptionLabel(str(i+1))
     .setBroadcast(true)
    ;

    but.getCaptionLabel().setSize(12);

    // TODO: adapt this to highlight already saved scales
    File f = new File(dataPath(str(i+1) + ".xml"));
    if (f.exists()) {
      but.setColorBackground(highlightColor);
    } 
  }

  // button to close without loading
  cp5.addButton("closeSaveLoadButton").setBroadcast(false)
     .setPosition(210,250)
     .setSize(180,40)
     .setGroup(saveLoadGroup)
     .setCaptionLabel("Close")
     .setBroadcast(true)
     ;
}

void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getName();
  switch(name) {
    case "scaleCBut":
      selectScaleButton(name);
      break;
    case "scaleCsharpBut":
      selectScaleButton(name);
      break;
    case "scaleDBut":
      selectScaleButton(name);
      break;
    case "scaleEflatBut":
      selectScaleButton(name);
      break;
    case "scaleEBut":
      selectScaleButton(name);
      break;
    case "scaleFBut":
      selectScaleButton(name);
      break;
    case "scaleFsharpBut":
      selectScaleButton(name);
      break;
    case "scaleGBut":
      selectScaleButton(name);
      break;
    case "scaleAflatBut":
      selectScaleButton(name);
      break;
    case "scaleABut":
      selectScaleButton(name);
      break;
    case "scaleBflatBut":
      selectScaleButton(name);
      break;
    case "scaleBBut":
      selectScaleButton(name);
      break;
    case "scaleTypemajorBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypeminorBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypedorianBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypelydianBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypemixolydianBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypephrygianBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypelocrianBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypepentatonicBut":
      selectScaleTypeButton(name);
      break;
    case "scaleTypebluesBut":
      selectScaleTypeButton(name);
      break;
    case "save1But":
      saveTune("data/1.xml");
      break;
    case "save2But":
      saveTune("data/2.xml");
      break;
    case "save3But":
      saveTune("data/3.xml");
      break;
    case "save4But":
      saveTune("data/4.xml");
      break;
    case "save5But":
      saveTune("data/5.xml");
      break;
    case "save6But":
      saveTune("data/6.xml");
      break;
    case "save7But":
      saveTune("data/7.xml");
      break;
    case "save8But":
      saveTune("data/8.xml");
      break;

    case "load1But":
      loadTune("data/1.xml");
      break;
    case "load2But":
      loadTune("data/2.xml");
      break;
    case "load3But":
      loadTune("data/3.xml");
      break;
    case "load4But":
      loadTune("data/4.xml");
      break;
    case "load5But":
      loadTune("data/5.xml");
      break;
    case "load6But":
      loadTune("data/6.xml");
      break;
    case "load7But":
      loadTune("data/7.xml");
      break;
    case "load8But":
      loadTune("data/8.xml");
      break;
  }
}

void saveTune(String filename) {
  store = new Storage(stave,soundbox);
  tuneXml = store.tuneToXml();
  saveXML(tuneXml, filename);
}

void loadTune(String filename) {
  store = new Storage(stave,soundbox);
  tuneXml = loadXML(filename);
  store.xmlToTune(tuneXml);
}

void deselectAllScaleButtons() {
  String[] allScaleButtons = {"C", "D", "E", "F", "G", "A", "B", "C#", "Eb", "F#", "Ab", "Bb"};
  for (int i = 0; i < allScaleButtons.length; i++) {
    String functionSafeName = allScaleButtons[i].replace("#", "sharp").replace("b", "flat");
    String buttonName = "scale" + functionSafeName + "But";
    controlP5.Controller but = cp5.getController(buttonName);
    but.setColorBackground(defaultBgColor);
  }
}

void deselectAllScaleTypeButtons() {
  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};
  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";
    controlP5.Controller but = cp5.getController(buttonName);
    but.setColorBackground(defaultBgColor);
  }
}

void selectScaleButton(String scaleButtonName) {
  controlP5.Controller but = cp5.getController(scaleButtonName);
  
  // deselect all Buttons
  deselectAllScaleButtons();
  // select this Button
  but.setColorBackground(highlightColor);
  // TODO: select this scale

  String shortName = scaleButtonName.replace("scale", "").replace("But", "").replace("sharp", "#").replace("flat", "b");
  String scaleRoot = soundbox.normalizeScaleName(shortName);
  soundbox.scaleRoot = scaleRoot;
}

void selectScaleTypeButton(String scaleTypeButtonName) {
  controlP5.Controller but = cp5.getController(scaleTypeButtonName);
  // deselect all Buttons
  deselectAllScaleTypeButtons();
  // select this Button
  but.setColorBackground(highlightColor);

  String scaleType = scaleTypeButtonName.replace("scaleType", "").replace("But", "");

  soundbox.scaleType = scaleType;
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

  Button saveLoadButton = cp5.addButton("saveLoadButton")
                                .setBroadcast(false)
                                .setValue(4)
                                .setPosition(600,440)
                                .setSize(200,40)
                                .setBroadcast(true)
                                ;

  saveLoadButton.setCaptionLabel("Save / Load");
}
