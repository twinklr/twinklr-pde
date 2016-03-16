import java.util.Map;
import processing.sound.*;

class Soundbox { 
  String scaleType, scaleRoot;
  HashMap<String, int[]> scales;
  String[] allNotes, scaleNotes;
  SoundFile[] allSounds, scaleSounds;
  PApplet parent;
  int noteCount;

  Soundbox (int nc, PApplet parent) {  
    noteCount = nc;
    this.parent = parent;

    buildScales();
    setupAllSounds();

    scaleType = "major";
    scaleRoot = "c";

    loadScaleSounds(scaleType, scaleRoot);
  } 

  void loadScaleSounds(String t, String r) {
    scaleNotes = new String[0];
    scaleSounds = new SoundFile[0];
    
    String[] tempNotes = allNotes;
    SoundFile[] tempSounds = allSounds;

    // shuffle off any notes before our chosen root.
    while(!tempNotes[0].substring(0, tempNotes[0].length()-1).equals(r)) {
      tempNotes = subset(tempNotes,1);
      tempSounds = (SoundFile[]) subset(tempSounds,1);
    }

    String[] allNotesBeginningWithRoot = tempNotes;
    SoundFile[] allSoundsBeginningWithRoot = tempSounds;
    int[] scaleIntervals = scales.get(t);

    // put the first note in
    scaleNotes = append(scaleNotes, allNotesBeginningWithRoot[0]);
    scaleSounds = (SoundFile[]) append(scaleSounds, allSoundsBeginningWithRoot[0]);

    while(allNotesBeginningWithRoot.length > 0) {
      // if there's an interval to skip, skip it...

      for(int i = 0; i < scaleIntervals[0]; i++) {
        allNotesBeginningWithRoot = subset(allNotesBeginningWithRoot,1);
        allSoundsBeginningWithRoot = (SoundFile[]) subset(allSoundsBeginningWithRoot,1);
        if(allNotesBeginningWithRoot.length == 0) {
          break;
        }
      }

      if(allNotesBeginningWithRoot.length == 0) {
        break;
      }

      // and append the next note after the interval
      scaleNotes = append(scaleNotes, allNotesBeginningWithRoot[0]);
      scaleSounds = (SoundFile[]) append(scaleSounds, allSoundsBeginningWithRoot[0]);

      // rotate the intervals array
      int firstInterval = scaleIntervals[0];
      scaleIntervals = subset(scaleIntervals,1);
      scaleIntervals = append(scaleIntervals, firstInterval);

    }

    if(scaleNotes.length > noteCount) {
      scaleNotes = subset(scaleNotes,0,noteCount);
      scaleSounds = (SoundFile[]) subset(scaleSounds,0,noteCount);
    }
  }

  int getScaleIndexFromAbsolute(int i) {
    int scaleLength = scales.get(scaleType).length;
    return (i % scaleLength);
  }

  void playSound(int i) {
    if(i < scaleSounds.length) {
      scaleSounds[i].stop();
      scaleSounds[i].play();
    }
  }

  void cycleScale() {
    String curScale = scaleType;
    Object[] allScales = scales.keySet().toArray();

    // if it's the last one
    if(curScale == (String) allScales[allScales.length-1]) {
      scaleType = (String) allScales[0];
    } else {
      for(int i = 0; i < allScales.length; i++) {
        if(curScale == (String) allScales[i]) {
          scaleType = (String) allScales[i+1];
          break;
        }
      }
    }
    loadScaleSounds(scaleType, scaleRoot);
  }

  void cycleRoot() {
    String curRoot = scaleRoot;
    String[] notes = {"c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"};
    if(curRoot == notes[notes.length-1]) {
      scaleRoot = notes[0];
    } else {
      for(int i = 0; i < notes.length; i++) {
        if(curRoot == notes[i]) {
          scaleRoot = notes[i+1];
          break;
        }
      } 
    }
    loadScaleSounds(scaleType, scaleRoot);
  }

  private void setupAllSounds() {
    // now: calculate all possible notes
      
    int[] octaves = {3,4,5,6};
    String[] notes = {"c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"};

    allNotes = new String[0];
    allSounds = new SoundFile[0];

    for(int i = 0; i < octaves.length; i++) {
      for(int j = 0; j < notes.length; j++) {
        int octave = octaves[i];
        String note = notes[j];
        String[] frags = {note, str(octave)};
        String string = join(frags, "");
        
        allNotes = append(allNotes, string);
      }
    }

    while(!allNotes[0].equals("f3")) {
      allNotes = subset(allNotes,1);
    }

    while(!allNotes[allNotes.length-1].equals("f6")) {
      allNotes = shorten(allNotes);
    }

    println("all notes calculated");

    // now, let's load all sounds.
    for(int i = 0; i < allNotes.length; i++) {
      String fullPath = "sounds/plinks/".concat(allNotes[i].concat(".mp3")).replaceAll("#", "sharp");

      SoundFile soundFile = new SoundFile(this.parent, fullPath);

      allSounds = (SoundFile[]) append(allSounds, soundFile);
    }
  }
  
  private void buildScales() {
    scales = new HashMap<String, int[]>();

    int[] majorScale = {2, 2, 1, 2, 2, 2, 1};
    scales.put("major", majorScale);

    int[] minorScale = {2, 1, 2, 2, 1, 2, 2};
    scales.put("minor", minorScale);

    int[] dorianScale = {2, 1, 2, 2, 2, 1, 2};
    scales.put("dorian", dorianScale);

    int[] lydianScale = {2, 2, 2, 1, 2, 2, 1};
    scales.put("lydian", lydianScale);

    int[] mixolydianScale = {2, 2, 1, 2, 2, 1, 2};
    scales.put("mixolydian", mixolydianScale);

    int[] phrygianScale = {1, 2, 2, 2, 1, 2, 2};
    scales.put("phrygian", phrygianScale);

    int[] locrianScale = {1, 2, 2, 1, 2, 2, 2};
    scales.put("locrian", locrianScale);

    int[] pentatonicScale = {3, 2, 2, 3, 2};
    scales.put("pentatonic", pentatonicScale);

    int[] bluesScale = {3, 2, 1, 1, 3, 2};
    scales.put("blues", bluesScale);
  }
} 