class Storage {
  Stave stave;
  Soundbox soundbox;

  Storage (Stave s, Soundbox sb) {  
    this.stave = s;
    this.soundbox = sb;
  }

  XML tuneToXml() {
    XML xml = new XML("tune");

    // first, set the config data

    xml.setString("scaletype", soundbox.scaleType);
    xml.setString("scaleroot", soundbox.scaleRoot);
    xml.setInt("stavewidth", stave.staveWidth);

    // for each note, store that note data
    for (Note note : stave.notes) {
      XML noteChild = xml.addChild("note");
      noteChild.setInt("x", note.x);
      noteChild.setInt("y", note.y);
    }


    XML playheadsChild = xml.addChild("playheads");
    for (int i = 1; i < playheadManager.playheads.length; i ++ ) {
      playhead = playheadManager.playheads[i];

      if(!playhead.active) {
        continue;
      }

      playhead = playheadManager.playheads[i];
      XML p = playheadsChild.addChild("playhead");
      p.setInt("index", i);
      p.setInt("offset", playhead.offset);
      p.setInt("directionOffset", playhead.directionOffset);
      p.setFloat("speed", playhead.speed);
    }

    return xml;
  }

  void xmlToTune(XML tuneXml) {
    // set up up Tune related stuff
    soundbox.scaleType = tuneXml.getString("scaletype");
    soundbox.scaleRoot = tuneXml.getString("scaleroot");

    soundbox.updateScaleSounds();

    stave.staveWidth = tuneXml.getInt("stavewidth");

    // clear out any notes we've got
    stave.removeAll();

    // now, get all the notes and set them up
    XML[] childNotes = tuneXml.getChildren("note");

    for (int i = 0; i < childNotes.length; i ++ ) {
      int x = childNotes[i].getInt("x");
      int y = childNotes[i].getInt("y");

      Note n = new Note(x, y, stave, stave.parent);
    
      stave.notes.add(n);      
    }

    // now, get all the playheads and set them up.
    XML playheadsGroup = tuneXml.getChild("playheads");

    XML[] playheads = playheadsGroup.getChildren("playhead");

    // disable all existing playheads > 0
    for (int i = 1; i < playheadManager.playheads.length; i ++ ) {
      playheadManager.playheads[i].deactivate();
    }

    // set default playhead to beginning
    playheadManager.playheads[0].position = 0;

    for (int i = 0; i < playheads.length; i ++ ) {
      XML playheadXml = playheads[i];
      int off = playheadXml.getInt("offset");
      int dirOff = playheadXml.getInt("directionOffset");
      float sp = playheadXml.getFloat("speed");

      playheadManager.playheads[i+1].speed = sp;
      playheadManager.playheads[i+1].directionOffset = dirOff;
      playheadManager.playheads[i+1].changeOffset(off, 0);

      if(dirOff == -1) {
        playheadManager.playheads[i+1].direction = 0;
      }

      playheadManager.playheads[i+1].activate();
    }
  }
}
