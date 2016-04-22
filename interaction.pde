import com.martinleopold.pui.*;

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
  pui = PUI.init(this).size(300, 300).hide();

  createBottomButtons();
}

com.martinleopold.pui.Slider speed1Slider, offset1Slider, speed2Slider, offset2Slider, speed3Slider, offset3Slider, speed4Slider, offset4Slider;
com.martinleopold.pui.Button playhead1Backwards, playhead1Forwards, playhead1Toggle, playhead2Backwards, playhead2Forwards, playhead2Toggle, playhead3Backwards, playhead3Forwards, playhead3Toggle, playhead4Backwards, playhead4Forwards, playhead4Toggle;
com.martinleopold.pui.Label scalesTitle;
com.martinleopold.pui.Label midiTitle;

boolean playheadsMenuVisible = false;
boolean lengthMenuVisible = false;
boolean scalesMenuVisible = false;
boolean saveMenuVisible = false;
boolean loadMenuVisible = false;
boolean midiMenuVisible = false;

void createPuiLengthGroup() {
  lengthMenuVisible = true;
  stave.canEdit = false;
  stave.startAlteringLength();

  pui = PUI.init(this).size(276, height-40).theme("Grayday");
  pui.padding(0.25, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font

  pui.addLabel("Change Stave Length").large();
  pui.addDivider();
  pui.newRow();
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
  int startX, startY;

  scalesMenuVisible = true;
  stave.canEdit = false;

  pui = PUI.init(this).size(660, height-40).theme("Grayday");
  // pui.toggleGrid();
  pui.padding(0.25, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font

  scalesTitle = pui.addLabel("");
  updateScalesTitle();
  pui.newRow();

  pui.newRow();

  // black notes

  startX = 12;
  startY = 11;

  String[] topScaleButtons = {"C#", "Eb", "F#", "Ab", "Bb"};
  for (int i = 0; i < topScaleButtons.length; i++) {
    String functionSafeName = topScaleButtons[i].replace("#", "sharp").replace("b", "flat");
    String buttonName = "scale" + functionSafeName + "But";

    com.martinleopold.pui.Button b = pui.addButton().label(topScaleButtons[i]).size(5,5).calls(buttonName);
    int offset = 0;
    if(i > 1) {
      offset = 7;
    }

    b.position(startX + (i*7) + offset,startY);
  }

  pui.newRow();

  // white notes

  String[] bottomScaleButtons = {"C", "D", "E", "F", "G", "A", "B"};
  startX = 9;
  startY = 19;

  for (int i = 0; i < bottomScaleButtons.length; i++) {
    String buttonName = "scale" + bottomScaleButtons[i] + "But";

    com.martinleopold.pui.Button b = pui.addButton().label(bottomScaleButtons[i].toUpperCase()).size(5,5).calls(buttonName);
    println("This button is at",b.positionX(),b.positionY());
    b.position(startX + (i*7),startY);
  }

  pui.columnWidth(100);
  pui.padding(1,1);

  startX = 2;
  startY = 31;

  String[] scaleTypes = { "major", "minor", "dorian", "lydian", "mixolydian", "phrygian", "locrian", "pentatonic", "blues"};

  for (int i = 0; i < scaleTypes.length; i++) {
    String buttonName = "scaleType" + scaleTypes[i] + "But";

    com.martinleopold.pui.Button b = pui.addButton().label(scaleTypes[i].toUpperCase()).size(5,5).calls(buttonName);
    b.position(startX + (i*7),startY);
  }
}

// PUI MIDI interactions

void removePuiMidiGroup() {
  pui.hide();
  midiMenuVisible = false;
  stave.canEdit = true; 
}

void createPuiMidiGroup() {
  midiMenuVisible = true;
  stave.canEdit = false;

  pui = PUI.init(this).size(300, height-40).theme("Grayday");
  pui.padding(1, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font
  pui.toggleGrid();

  pui.columnWidth(30);

  pui.addLabel("MIDI").large();
  pui.addDivider();

  midiTitle = pui.addLabel("");
  pui.newRow();

  if(midibox.currentBusName != null) {
    midiTitle.text("Current port: " + midibox.currentBusName);
  } else {
    midiTitle.text("Current port: NONE");
  }

  String[] outputNames = midibox.midiBus.availableOutputs();
  pui.addButton().label("NONE").size(5,5).calls("midiNone");
  for(int i = 0; i < 9; i ++) {
    if(i < outputNames.length) {
      println("midi" + str(i));
      pui.addButton().label(outputNames[i]).size(5,5).calls("midi" + str(i));
    }
  }
  pui.newRow();
  pui.addDivider();
  pui.newRow();
  pui.addButton().label("PANIC").size(5,5).calls("midiPanic");
}

void midiNone() {
  midibox.removeMidiBus();
  midiTitle.text("Current port: NONE");
}

void midiPanic() {
  midibox.panic();
}

void pickMidiPort(int port) {
  String string = midibox.midiBus.availableOutputs()[port];
  midibox.updateMidiBus(string);
  midiTitle.text("Current port: " + midibox.currentBusName);
}

void midi0() {
  pickMidiPort(0);
}

void midi1() {
  pickMidiPort(1);
}

void midi2() {
  pickMidiPort(2);
}

void midi3() {
  pickMidiPort(3);
}

void midi4() {
  pickMidiPort(4);
}

void midi5() {
  pickMidiPort(5);
}

void midi6() {
  pickMidiPort(6);
}

void midi7() {
  pickMidiPort(7);
}

void midi8() {
  pickMidiPort(8);
}

// PUI Save Load interactions

void createPuiSaveGroup() {
  saveMenuVisible = true;
  stave.canEdit = false;

  pui = PUI.init(this).size(170, height-40).theme("Grayday");
  pui.padding(1, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font
  // pui.toggleGrid();

  pui.addLabel("Save").large();
  pui.addDivider();

  int startX, startY, colSpacing;
  startX = 2;
  startY = 6;
  colSpacing = 8;

  // create Save Buttons
  for (int i = 0; i < 4; i++) {
    String buttonName = "save" + (i+1) + "But";
    com.martinleopold.pui.Button b = pui.addButton().label(str(i+1)).size(5,5).calls(buttonName);
    b.position(startX, startY + (i*colSpacing));
    File f = new File(dataPath(str(i+1) + ".xml"));
    if(f.exists()) {
      b.label(str(i+1));
    } else {
      b.label(str(i+1) + " (EMPTY)");
    }
  }  
  for (int i = 4; i < 8; i++) {
    String buttonName = "save" + (i+1) + "But";
    com.martinleopold.pui.Button b = pui.addButton().label(str(i+1)).size(5,5).calls(buttonName);
    b.position(startX+colSpacing, startY + ((i-4)*colSpacing));
    File f = new File(dataPath(str(i+1) + ".xml"));
    if(f.exists()) {
      b.label(str(i+1));
    } else {
      b.label(str(i+1) + " (EMPTY)");
    }
  }  
}

void removePuiSaveGroup() {
  pui.hide();
  saveMenuVisible = false;
  stave.canEdit = true; 
}

void createPuiLoadGroup() {
  loadMenuVisible = true;
  stave.canEdit = false;

  pui = PUI.init(this).size(170, height-40).theme("Grayday");
  pui.padding(1, 0.5); // set padding (in grid units)
  pui.font("deja.ttf"); // set font
  // pui.toggleGrid();

  pui.addLabel("Load").large();
  pui.addDivider();

  int startX, startY, colSpacing;
  startX = 2;
  startY = 6;
  colSpacing = 8;

  // create Load Buttons
  for (int i = 0; i < 4; i++) {
    String buttonName = "load" + (i+1) + "But";
    com.martinleopold.pui.Button b = pui.addButton().label(str(i+1)).size(5,5).calls(buttonName);
    b.position(startX, startY + (i*colSpacing));
    File f = new File(dataPath(str(i+1) + ".xml"));
    if(f.exists()) {
      b.label(str(i+1));
    } else {
      b.label(str(i+1) + " (EMPTY)");
      b.deactivate();
    }
  }  
  for (int i = 4; i < 8; i++) {
    String buttonName = "load" + (i+1) + "But";
    com.martinleopold.pui.Button b = pui.addButton().label(str(i+1)).size(5,5).calls(buttonName);
    b.position(startX+colSpacing, startY + ((i-4)*colSpacing));
    File f = new File(dataPath(str(i+1) + ".xml"));
    if(f.exists()) {
      b.label(str(i+1));
    } else {
      b.label(str(i+1) + " (EMPTY)");
      b.deactivate();
    }
  }  
}

void removePuiLoadGroup() {
  pui.hide();
  loadMenuVisible = false;
  stave.canEdit = true; 
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
    case 'p':
      midibox.panic();
      println("PANIC");
      break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  playheadManager.modifyPositionBy(e);
}

public void resetButton() {
  soundbox.reset();
  stave.reset();
}

void updateScalesTitle() {
  scalesTitle = scalesTitle.text("Current Scale: " + soundbox.currentScaleName()).large();
}

// begin scale root selection

void scaleCBut() {
  selectScaleButton("c");
}
void scaleCsharpBut() {
  selectScaleButton("c#");
}
void scaleDBut() {
  selectScaleButton("d");
}
void scaleEflatBut() {
  selectScaleButton("d#");
}
void scaleEBut() {
  selectScaleButton("e");
}
void scaleFBut() {
  selectScaleButton("f");
}
void scaleFsharpBut() {
  selectScaleButton("f#");
}
void scaleGBut() {
  selectScaleButton("g");
}
void scaleAflatBut() {
  selectScaleButton("g#");
}
void scaleABut() {
  selectScaleButton("a");
}
void scaleBflatBut() {
  selectScaleButton("a#");
}
void scaleBBut() {
  selectScaleButton("b");
}

// end scale root selection

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

// begin save/load buttons

void save1But(){
  saveTune("data/1.xml");
}
void save2But(){
  saveTune("data/2.xml");
}
void save3But(){
  saveTune("data/3.xml");
}
void save4But(){
  saveTune("data/4.xml");
}
void save5But(){
  saveTune("data/5.xml");
}
void save6But(){
  saveTune("data/6.xml");
}
void save7But(){
  saveTune("data/7.xml");
}
void save8But(){
  saveTune("data/8.xml");
}

void load1But(){
  loadTune("data/1.xml");
}
void load2But(){
  loadTune("data/2.xml");
}
void load3But(){
  loadTune("data/3.xml");
}
void load4But(){
  loadTune("data/4.xml");
}
void load5But(){
  loadTune("data/5.xml");
}
void load6But(){
  loadTune("data/6.xml");
}
void load7But(){
  loadTune("data/7.xml");
}
void load8But(){
  loadTune("data/8.xml");
}

// end save/load buttons

void saveTune(String filename) {
  store = new Storage(stave,soundbox);
  tuneXml = store.tuneToXml();
  saveXML(tuneXml, filename);
  removePuiSaveGroup();
  bottomButtons[0].deselectAll();
}

void loadTune(String filename) {
  store = new Storage(stave,soundbox);
  tuneXml = loadXML(filename);
  store.xmlToTune(tuneXml);
  removePuiLoadGroup();
  bottomButtons[0].deselectAll();
}

void selectScaleButton(String shortName) {
  String scaleRoot = soundbox.normalizeScaleName(shortName);
  println("Setting scale to", scaleRoot);
  soundbox.scaleRoot = scaleRoot;
  soundbox.updateScaleSounds();
  updateScalesTitle();
}

void selectScaleTypeButton(String scaleType) {
  println("Updating scales title to ", scaleType);

  soundbox.scaleType = scaleType;
  soundbox.updateScaleSounds();
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
