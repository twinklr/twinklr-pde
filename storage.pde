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

    return xml;
  }

  void xmlToTune(XML tuneXml) {
    soundbox.scaleType = tuneXml.getString("scaletype");
    soundbox.scaleRoot = tuneXml.getString("scaleroot");

    soundbox.updateScaleSounds();

    stave.staveWidth = tuneXml.getInt("stavewidth");

    stave.removeAll();

    XML[] childNotes = tuneXml.getChildren("note");

    for (int i = 0; i < childNotes.length; i ++ ) {
      int x = childNotes[i].getInt("x");
      int y = childNotes[i].getInt("y");

      Note n = new Note(x, y, stave, stave.parent);
    
      stave.notes.add(n);      
    }
  }
}
