class Stave {
  int noteCount, staveWidth, staveHeight, xPadding, yPadding;
  PApplet parent;

  Stave (int nc, PApplet parent) {  
    this.parent = parent;
    this.noteCount = nc;
    

    xPadding = 50;
    yPadding = 30;

    staveWidth = 0;
    staveHeight = 0;
  }

  void render() {
    staveWidth = width - (xPadding*2);
    staveHeight = height - (yPadding*2);

    int lineCount = noteCount - 1;

    int lineHeight = floor(staveHeight / lineCount);

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
    for (int i = 0; i < lineCount; i++) {
      int x1 = xPadding;
      int y1 = yPadding + (i* lineHeight);
      int x2 = x1 + staveWidth;
      int y2 = yPadding + (i* lineHeight);
      line(x1, y1, x2, y2);
    }
  }
}