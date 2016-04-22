import themidibus.*; //Import the library

class Midibox { 
  PApplet parent;
  int transpose,gateDuration, channel, velocity;
  String[] allNotes;
  MidiBus midiBus; // The MidiBus
  String currentBusName;

  Midibox (PApplet parent) {  
    this.transpose = 0;
    this.gateDuration = 250;
    this.channel = 0;
    this.velocity = 100;;

    int[] octaves = {3,4,5,6};
    String[] notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    this.allNotes = new String[0];;

    for(int i = 0; i < octaves.length; i++) {
      for(int j = 0; j < notes.length; j++) {
        int octave = octaves[i];
        String note = notes[j];

        String string = note + str(octave);
        allNotes = append(allNotes, string.toLowerCase());
      }
    }

    // println(allNotes);
    MidiBus.list();
    // this.midiBus = new MidiBus(parent,-1,"Port 1");
  }

  void updateMidiBus(String busName) {
    if(this.midiBus != null) {
      this.midiBus.close();
    }
    this.midiBus = new MidiBus(parent,-1,busName);
    this.currentBusName = busName;
  } 

  void removeMidiBus() {
    this.midiBus.close();
    this.currentBusName = null;
  }

  int noteValue(String noteString) {
    int cThree = 60;

    for(int i = 0; i < allNotes.length; i++) {
      if(allNotes[i].equals(noteString.toLowerCase())) {
        return cThree + i + this.transpose;
      }
    }

    return 0;
  }

  void playNote(String noteString) {
    if(currentBusName == null) {
      return;
    }
    int noteValue = noteValue(noteString);
    if(noteValue > 0) {
      midiBus.sendNoteOn(channel, noteValue, velocity); // Send a Midi noteOn
      println("Sending note on on noteValue", noteValue);
      new NoteOffThread(channel,noteValue,velocity,gateDuration,midiBus).start();
    }
  }

  void panic() {
    if(midiBus != null) {
      for(int i = 0; i < allNotes.length; i++) {
        int noteValue = noteValue(allNotes[i]);
        if(noteValue > 0) {
          println("Note off",noteValue);
          midiBus.sendNoteOff(channel, noteValue, velocity); // Send a Midi noteOn
        }
      }
    }
  }
}

class NoteOffThread extends Thread{
 
   int noteValue, gateDuration, channel, velocity;
   MidiBus midiBus;
 
   public NoteOffThread(int channel, int noteValue, int velocity, int gateDuration, MidiBus midiBus){
      this.channel = channel;
      this.noteValue = noteValue;
      this.velocity = velocity;
      this.gateDuration = gateDuration;
      this.midiBus = midiBus;
   }
 
   public void run(){
    delay(gateDuration);
    // send noteOff
    println("Sending note off on noteValue", noteValue);
    midiBus.sendNoteOff(channel, noteValue, velocity); // Send a Midi noteOn
   }
}