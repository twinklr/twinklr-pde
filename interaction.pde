import com.martinleopold.pui.*;

ControlP5 cp5;
ControllerGroup lengthGroup;
ControllerGroup scalesGroup;
ControllerGroup saveLoadGroup;
BottomButton[] bottomButtons = new BottomButton[6];

Storage store;
XML tuneXml;

int defaultBgColor = color(2,46,92);
int highlightColor = color(244,144,24);

int xOffset;
int titleOffset;

float s;
int o;

PUI pui;

void setupGui() {
  cp5 = new ControlP5(this);
  pui = PUI.init(this).size(300, 300).hide();

  createBottomButtons();

  createScalesGroup();
  updateScalesGroup();

  createSaveLoadGroup();
  updateSaveLoadGroup();
}

com.martinleopold.pui.Slider speed1Slider, offset1Slider, speed2Slider, offset2Slider, speed3Slider, offset3Slider, speed4Slider, offset4Slider;
com.martinleopold.pui.Button playhead1Backwards, playhead1Forwards, playhead1Toggle, playhead2Backwards, playhead2Forwards, playhead2Toggle, playhead3Backwards, playhead3Forwards, playhead3Toggle, playhead4Backwards, playhead4Forwards, playhead4Toggle;
com.martinleopold.pui.Label scalesTitle;

boolean playheadsMenuVisible = false;
boolean lengthMenuVisible = false;
boolean scalesMenuVisible = false;

void createPuiLengthGroup() {
  lengthMenuVisible = true;
  stave.canEdit = false;
  stave.startAlteringLength();

  pui = PUI.init(this).size(276, height-40).theme("Grayday");
  pui.padding(0.25, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font

  pui.addLabel("Change Stave Length").large();
  pui.newRow();
  pui.addLabel("Drag the orange marker to"); 
  pui.addLabel("create a loop.");
  pui.addButton().label("DONE").size(16,5).calls("removePuiLengthGroup");
}

void removePuiLengthGroup() {
  stave.stopAlteringLength();
  pui.hide();
  lengthMenuVisible = false;
  stave.canEdit = true;
}

void createPuiPlayheadsGroup() {
  stave.canEdit = false;

  pui = PUI.init(this).size(710, height-40).theme("Grayday");
  pui.padding(0.25, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font

  // make controls for Playhead One

  pui.addLabel("1.").large();
  
  pui.newRow();
  
  // pair of buttons for direction
  pui.addLabel("Direction").medium();
  pui.addDivider();

  playhead1Backwards = pui.addButton().size(5,4).noLabel().calls("direction1Backwards").isPressed(false).deactivate();
  playhead1Forwards = pui.addButton().size(5,4).noLabel().calls("direction1Forwards").isPressed(true).deactivate();
  playhead1Forwards.label("FORWARDS");

  pui.newRow();
  pui.addLabel("Offset").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  offset1Slider = pui.addSlider().size(16,6).label("0").calls("offset1Value").min(0).max(400).value(0).deactivate();

  pui.newRow();
  pui.addLabel("Speed").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  speed1Slider = pui.addSlider().size(16,6).label(str(1)).min(0.25).max(4).value(1).deactivate();

  pui.newRow();

  playhead1Toggle = pui.addButton().label("ENABLED").size(16,5).isPressed(true).deactivate();
  
  // make controls for Playhead Two

  pui.newColumn();

  pui.addLabel("2.").large();
  
  pui.newRow();
  
  // pair of buttons for direction
  pui.addLabel("Direction").medium();
  pui.addDivider();

  playhead2Backwards = pui.addButton().size(5,4).noLabel().calls("direction2Backwards");
  playhead2Forwards = pui.addButton().size(5,4).noLabel().calls("direction2Forwards");
  if(playheadManager.playheads[1].isForwards()) {
    direction2Forwards();
  } else {
    direction2Backwards();
  }

  pui.newRow();

  pui.addLabel("Offset").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  offset2Slider = pui.addSlider().size(16,6).label(str((int)playheadManager.playheads[1].offset)).calls("offset2Value").min(0).max(400);
  offset2Slider.value(playheadManager.playheads[1].offset);
  pui.newRow();
  pui.addLabel("Speed").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  speed2Slider = pui.addSlider().size(16,6).label(str(playheadManager.playheads[1].speed)).calls("speed2Value").min(0.25).max(4);
  speed2Slider.value(playheadManager.playheads[1].speed);

  pui.newRow();

  playhead2Toggle = pui.addButton().noLabel().size(16,5).calls("togglePlayhead2");
  if(playheadManager.playheads[1].active) {
    playhead2Toggle.label("ENABLED");  
  } else {
    playhead2Toggle.label("");
  }
  


  // make controls for Playhead Three
  pui.newColumn();

  pui.addLabel("3.").large();
  
  pui.newRow();
  
  // pair of buttons for direction
  pui.addLabel("Direction").medium();
  pui.addDivider();

  playhead3Backwards = pui.addButton().size(5,4).noLabel().calls("direction3Backwards");
  playhead3Forwards = pui.addButton().size(5,4).noLabel().calls("direction3Forwards");

  if(playheadManager.playheads[2].isForwards()) {
    direction3Forwards();
  } else {
    direction3Backwards();
  }

  pui.newRow();

  pui.addLabel("Offset").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  offset3Slider = pui.addSlider().size(16,6).label(str((int)playheadManager.playheads[2].offset)).calls("offset3Value").min(0).max(400);
  offset3Slider.value(playheadManager.playheads[2].offset);
  pui.newRow();
  pui.addLabel("Speed").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  speed3Slider = pui.addSlider().size(16,6).label(str(playheadManager.playheads[2].speed)).calls("speed3Value").min(0.25).max(4);
  speed3Slider.value(playheadManager.playheads[2].speed);

  pui.newRow();

  playhead3Toggle = pui.addButton().noLabel().size(16,5).calls("togglePlayhead3");
  if(playheadManager.playheads[2].active) {
    playhead3Toggle.label("ENABLED");  
  } else {
    playhead3Toggle.label("");
  }

  // make controls for Playhead Four
  pui.newColumn();

  pui.addLabel("4.").large();
  
  pui.newRow();
  
  // pair of buttons for direction
  pui.addLabel("Direction").medium();
  pui.addDivider();

  playhead4Backwards = pui.addButton().size(5,4).noLabel().calls("direction4Backwards");
  playhead4Forwards = pui.addButton().size(5,4).noLabel().calls("direction4Forwards");

  if(playheadManager.playheads[3].isForwards()) {
    direction4Forwards();
  } else {
    direction4Backwards();
  }

  pui.newRow();

  pui.addLabel("Offset").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  offset4Slider = pui.addSlider().size(16,6).label(str((int)playheadManager.playheads[3].offset)).calls("offset4Value").min(0).max(400);
  offset4Slider.value(playheadManager.playheads[3].offset);
  pui.newRow();
  pui.addLabel("Speed").medium();
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  speed4Slider = pui.addSlider().size(16,6).label(str(playheadManager.playheads[3].speed)).calls("speed4Value").min(0.25).max(4);
  speed4Slider.value(playheadManager.playheads[1].speed);

  pui.newRow();

  playhead4Toggle = pui.addButton().noLabel().size(16,5).calls("togglePlayhead4");
  playhead4Toggle.isPressed(playheadManager.playheads[3].active);

  if(playheadManager.playheads[3].active) {
    playhead4Toggle.label("ENABLED");  
  } else {
    playhead4Toggle.label("");
  }

  playheadsMenuVisible= true;
}

void removePuiPlayheadsGroup() {
  playheadsMenuVisible= false;
  pui.hide();
  stave.canEdit = true;
  // pui.setLayout(new Layout(width, height, 0, 0, 0));

}

// PUI interactions for Playhead 2

void direction2Forwards() {
  setPlayheadDirection(2,1);
  playhead2Forwards.deactivate();
  playhead2Forwards.label("FORWARDS");
  playhead2Backwards.isPressed(false);
  playhead2Backwards.activate();
  playhead2Backwards.label("");
}

void direction2Backwards() {
  setPlayheadDirection(2,-1);
  playhead2Forwards.activate();
  playhead2Forwards.label("");
  playhead2Backwards.deactivate();
  playhead2Backwards.label("BACKWARDS");
}

void offset2Value(float v) {
  float newValue = (float)(Math.round(v));
  offset2Slider.value(newValue);
  updatePlayheadOffset(2, (int)newValue);
  offset2Slider.label(str((int)newValue));
}

void speed2Value(float v) {
  float newValue = (float)(Math.floor(v/0.25)) * 0.25;  
  speed2Slider.value(newValue);
  updatePlayheadSpeed(2, newValue);
  speed2Slider.label(str(newValue));
}

void togglePlayhead2() {
  enablePlayhead(2);  
  if(playheadManager.playheads[1].active) {
    playhead2Toggle.isPressed(true);
    playhead2Toggle.label("ENABLED");
  } else {
    playhead2Toggle.isPressed(false);
    playhead2Toggle.label("");
  }
}

// PUI interactions for Playhead 3

void direction3Forwards() {
  setPlayheadDirection(3,1);
  playhead3Forwards.deactivate();
  playhead3Forwards.label("FORWARDS");
  playhead3Backwards.isPressed(false);
  playhead3Backwards.activate();
  playhead3Backwards.label("");
}

void direction3Backwards() {
  setPlayheadDirection(3,-1);
  playhead3Forwards.activate();
  playhead3Forwards.label("");
  playhead3Backwards.deactivate();
  playhead3Backwards.label("BACKWARDS");
}

void offset3Value(float v) {
  float newValue = (float)(Math.round(v));
  offset3Slider.value(newValue);
  updatePlayheadOffset(3, (int)newValue);
  offset3Slider.label(str((int)newValue));
}

void speed3Value(float v) {
  float newValue = (float)(Math.floor(v/0.25)) * 0.25;  
  speed3Slider.value(newValue);
  updatePlayheadSpeed(3, newValue);
  speed3Slider.label(str(newValue));
}

void togglePlayhead3() {
  enablePlayhead(3);  
  if(playheadManager.playheads[2].active) {
    playhead3Toggle.isPressed(true);
    playhead3Toggle.label("ENABLED");
  } else {
    playhead3Toggle.isPressed(false);
    playhead3Toggle.label("");
  }
}

// PUI interactions for Playhead 4

void direction4Forwards() {
  setPlayheadDirection(4,1);
  playhead4Forwards.deactivate();
  playhead4Forwards.label("FORWARDS");
  playhead4Backwards.isPressed(false);
  playhead4Backwards.activate();
  playhead4Backwards.label("");
}

void direction4Backwards() {
  setPlayheadDirection(4,-1);
  playhead4Forwards.activate();
  playhead4Forwards.label("");
  playhead4Backwards.deactivate();
  playhead4Backwards.label("BACKWARDS");
}

void offset4Value(float v) {
  float newValue = (float)(Math.round(v));
  offset4Slider.value(newValue);
  updatePlayheadOffset(4, (int)newValue);
  offset4Slider.label(str((int)newValue));
}

void speed4Value(float v) {
  float newValue = (float)(Math.floor(v/0.25)) * 0.25;  
  speed4Slider.value(newValue);
  updatePlayheadSpeed(4, newValue);
  speed4Slider.label(str(newValue));
}

void togglePlayhead4() {
  enablePlayhead(4);  
  if(playheadManager.playheads[3].active) {
    playhead4Toggle.isPressed(true);
    playhead4Toggle.label("ENABLED");
  } else {
    playhead4Toggle.isPressed(false);
    playhead4Toggle.label("");
  }
}

// PUI Scales Interactions

void removePuiScalesGroup() {
  scalesMenuVisible = false;
  pui.hide();
  stave.canEdit = true;
}

void createPuiScalesGroup() {
  scalesMenuVisible = true;
  stave.canEdit = false;

  pui = PUI.init(this).size(660, height-40).theme("Grayday");
  // pui.toggleGrid();
  pui.padding(0.25, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font

  scalesTitle = pui.addLabel("");
  updateScalesTitle();

  pui.newRow();

  pui.columnWidth(100);
  pui.padding(1,1);


  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};

  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";

    pui.addButton().label(scaleTypes[i].toUpperCase()).size(5,5).calls(buttonName);
  }
}

// Mouse Interactions

void mouseDragged() {
  if(stave.alteringLength) {
    stave.updateWidthFromAbs(mouseX);
    playheadManager.updatePlayheadsToWidth();
  }
}

void mousePressed() {
  if(stave.insideStave(mouseX,mouseY)) {
    stave.click(mouseX, mouseY);
  }

  for (int i = 0; i < bottomButtons.length; i++ ) {
     if (mouseX > bottomButtons[i].x && mouseX < bottomButtons[i].x+bottomButtons[i].buttonWidth && 
      mouseY > bottomButtons[i].y && mouseY < bottomButtons[i].y + bottomButtons[i].buttonHeight) {
      bottomButtons[i].click();
    }
  }
}

void keyPressed() {
  switch (key) {
    case '1':
      if(lengthMenuVisible) {
        removePuiLengthGroup();
        // pui.hide();
      } else {
        createPuiLengthGroup();
      }
      break;
    case '3':
      if(playheadsMenuVisible) {
        removePuiPlayheadsGroup();
        // pui.hide();
      } else {
        createPuiPlayheadsGroup();
      }
      break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  playheadManager.modifyPositionBy(e);
}

public void scalesButton(int theValue) {
  if(scalesGroup.isVisible()) {
    scalesGroup.hide();
    saveLoadGroup.hide();
    stave.canEdit = true;
  } else {
    lengthGroup.hide();
    stave.stopAlteringLength();

    saveLoadGroup.hide();
    
    updateScalesGroup();
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
    
    updateSaveLoadGroup();
    saveLoadGroup.show();
    stave.canEdit = false;
  }
}

// public void playheadsButton(int theValue) {
//   if(playheadsGroup.isVisible()) {
//     playheadsGroup.hide();
//     stave.canEdit = true;
//   } else {
//     lengthGroup.hide();
//     scalesGroup.hide();
//     saveLoadGroup.hide();
//     stave.stopAlteringLength();
    
//     updatePlayheadsGroup();
//     playheadsGroup.show();
//     stave.canEdit = false;
//   }
// }



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

public void resetButton() {
  soundbox.reset();
  stave.reset();
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
    controlP5.Button but = cp5.addButton(buttonName).setBroadcast(false)
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
    controlP5.Button but = cp5.addButton(buttonName).setBroadcast(false)
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
    controlP5.Button but = cp5.addButton(buttonName).setBroadcast(false)
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
    controlP5.Button but = cp5.addButton(buttonName).setBroadcast(false)
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
    controlP5.Button but = cp5.addButton(buttonName).setBroadcast(false)
     .setPosition((300 + 25 + (xIndex*60)),yPos)
     .setSize(50,50)
     .setGroup(saveLoadGroup)
     .setCaptionLabel(str(i+1))
     .setBroadcast(true)
    ;

    but.getCaptionLabel().setSize(12);
  }

  // button to close without loading
  cp5.addButton("closeSaveLoadButton").setBroadcast(false)
     .setPosition(210,250)
     .setSize(180,40)
     .setGroup(saveLoadGroup)
     .setCaptionLabel("Close")
     .setBroadcast(true)
     ;

  cp5.addButton("resetButton").setBroadcast(false)
     .setPosition(495,250)
     .setSize(60,40)
     .setGroup(saveLoadGroup)
     .setCaptionLabel("Reset")
     .setBroadcast(true)
     ;
}

/*
 * end save/load group
 */

void updateScalesTitle() {
  scalesTitle = scalesTitle.text("Current Scale: " + soundbox.currentScaleName()).large();
}

void updateScalesGroup() {
  String[] scaleButtons = {"C", "D", "E", "F", "G", "A", "B", "C#", "Eb", "F#", "Ab", "Bb"};
  for (int i = 0; i < scaleButtons.length; i++) {
    String functionSafeName = scaleButtons[i].replace("#", "sharp").replace("b", "flat");
    String buttonName = "scale" + functionSafeName + "But";

    String normalizedScaleName = soundbox.normalizeScaleName(scaleButtons[i]);
    if(normalizedScaleName.equals(soundbox.scaleRoot)) {
      cp5.getController(buttonName).setColorBackground(highlightColor);
    } else {
      cp5.getController(buttonName).setColorBackground(defaultBgColor);
    }
  }

  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};

  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";
    if(scaleTypes[i].equals(soundbox.scaleType)) {
      cp5.getController(buttonName).setColorBackground(highlightColor);
    } else {
      cp5.getController(buttonName).setColorBackground(defaultBgColor); 
    }
  }
}

void updateSaveLoadGroup() {
  for (int i = 0; i < 8; i++) {
    File f = new File(dataPath(str(i+1) + ".xml"));
    String buttonName = "load" + (i+1) + "But";

    if (f.exists()) {
      cp5.getController(buttonName).setColorBackground(highlightColor);
    } else {
      cp5.getController(buttonName).setColorBackground(defaultBgColor);
    }
  } 
}

// begin scale type selection

void scaleTypemajorBut() {
  selectScaleTypeButton("major");
}
void scaleTypeminorBut() {
  selectScaleTypeButton("minor");
}
void scaleTypedorianBut() {
  selectScaleTypeButton("dorian");
}
void scaleTypelydianBut() {
  selectScaleTypeButton("lydian");
}
void scaleTypemixolydianBut() {
  selectScaleTypeButton("mixolydian");
}
void scaleTypephrygianBut() {
  selectScaleTypeButton("phrygian");
}
void scaleTypelocrianBut() {
  selectScaleTypeButton("locrian");
}
void scaleTypepentatonicBut() {
  selectScaleTypeButton("pentatonic");
}
void scaleTypebluesBut() {
  selectScaleTypeButton("blues");
}

// end scale type selection


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
  updateSaveLoadGroup();
}

void loadTune(String filename) {
  store = new Storage(stave,soundbox);
  tuneXml = loadXML(filename);
  store.xmlToTune(tuneXml);
  updateScalesGroup();
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
  // select this scale

  String shortName = scaleButtonName.replace("scale", "").replace("But", "").replace("sharp", "#").replace("flat", "b");
  String scaleRoot = soundbox.normalizeScaleName(shortName);
  soundbox.scaleRoot = scaleRoot;
  updateScalesGroup();
}

void selectScaleTypeButton(String scaleType) {
  println("Updating scales title to ", scaleType);

  soundbox.scaleType = scaleType;
  updateScalesTitle();
}

void enablePlayhead(int pN) {
  int index = pN - 1;

  Playhead p = playheadManager.playheads[index];
  if(p.active) {
    p.deactivate();
  } else {
    p.activate();
  }
}

void togglePlayheadDirection(int pN) {
  int index = pN - 1;

  Playhead p = playheadManager.playheads[index];
  if(p.directionOffset == 1) {
    p.directionOffset = -1;
    p.direction = 1 - p.direction;
  } else {
    p.directionOffset = 1;
    p.direction = 1 - p.direction;
  }
}

void setPlayheadDirection(int pN, int dirOff) {
  int index = pN - 1;

  Playhead p = playheadManager.playheads[index];
  p.directionOffset = dirOff;
  if(p.directionOffset > 0) {
    p.direction = 1;
  } else {
    p.direction = 0;
  }
}

void updatePlayheadOffset(int pN, int off) {
  int index = pN - 1;

  Playhead p = playheadManager.playheads[index];

  println("Setting offset to ", off);

  p.changeOffset(off, playheadManager.playheads[0].position);

  println("Playhead offset is now ", p.offset);
}

void updatePlayheadSpeed(int pN, float s) {
  int index = pN - 1;

  Playhead p = playheadManager.playheads[index];

  p.speed = s;
}

void createBottomButtons() {
  // create length button
  // create scalesbutton
  // create playheadsbutton
  // create midi button
  // create saveload button
  bottomButtons[0] = new BottomButton(0,159,"LENGTH",1, this);
  bottomButtons[1] = new BottomButton(160,159,"SCALES",2, this);
  bottomButtons[2] = new BottomButton(320,159,"PLAYHEADS",3, this);
  bottomButtons[3] = new BottomButton(480,159,"MIDI",4, this);
  bottomButtons[4] = new BottomButton(640,79,"SAVE",5, this);
  bottomButtons[5] = new BottomButton(720,80,"LOAD",6, this);
}
