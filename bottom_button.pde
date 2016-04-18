class BottomButton {
  PApplet parent;
  int x,y,buttonWidth,buttonHeight,buttonNumber;
  String label;
  boolean selected;

  BottomButton (int buttonX, int bw, String labelText, int buttonNum, PApplet p) {  
    parent = p;

    x = buttonX;
    y = 440;
    buttonWidth = bw;
    buttonHeight = 40;
    selected = false;

    label = labelText;
    buttonNumber = buttonNum;
  }

  void click() {
    // for each button in the window, deselect them
    for (int i = 0; i < bottomButtons.length; i++ ) {
      if(bottomButtons[i] == this) {
        bottomButtons[i].selected = !bottomButtons[i].selected;
      } else {
        bottomButtons[i].selected = false;   
      }
    }
    handle(buttonNumber);
  }

  void render() {
    int regularColor = color(85,91,93);
    int selectedColor = color(163,181,187);

    // draw rect in appropriate colour
    if(this.selected) {
      fill(selectedColor);
    } else {
      fill(regularColor);
    }

    noStroke();
    rect(x,y,buttonWidth,buttonHeight);
    noFill();
    
    // draw text in inverse color
    if(this.selected) {
      fill(regularColor);
    } else {
      fill(selectedColor);
    }
    textFont(deja); // loaded in setup
    textAlign(CENTER, CENTER);
    text(label,x,y,buttonWidth,buttonHeight);
  }

  void handle(int bN) {
    switch (bN) {
      case 1:
        if(lengthMenuVisible) {
          removePuiLengthGroup();
          // pui.hide();
        } else {
          removePuiPlayheadsGroup();
          removePuiScalesGroup();
          createPuiLengthGroup();
        }
        break;
      case 2:
        // scales;
        if(scalesMenuVisible) {
          removePuiScalesGroup();
          // pui.hide();
        } else {
          removePuiPlayheadsGroup();
          removePuiLengthGroup();
          createPuiScalesGroup();
        }
        break;
      case 3:
        // playheads
        if(playheadsMenuVisible) {
          removePuiPlayheadsGroup();
          // pui.hide();
        } else {
          removePuiLengthGroup();
          removePuiScalesGroup();
          createPuiPlayheadsGroup();
        }
        break;
      case 4:
        // midi
        break;
      case 5:
        // save
        break;
      case 6:
        // load
        break;
    }
  }

}