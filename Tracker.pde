
/***************************************************************/

class JStuff {

  boolean moving=false;    //true si la velocidad es mayor que el umbral;
  boolean firstOn=false;
  boolean firstOff=false;

  int midiNote=0;
  randomSequencer sequencer;
//  MouseTracker mouseTracker;
  //  PApplet parent;

  float velThr=0.00001;
  float dynVelThr=0.000001;

  JStuff(PApplet parent) {
    sequencer=new randomSequencer();
    sequencer.initialize(parent);
    sequencer.isLeapMotionActivated=false;
    sequencer.isMIDIcontrollerActivated=false; 
    sequencer.isMinimActivated=false;
    sequencer.noteSource="random";                              //"random" o "perlin"  ("random" or else en realidad)
    // sequencer.barLength=400;
    sequencer.probabilidad = new int[] {
      20, 7, 20, 6, 20, 7, 20
    };
 //   mouseTracker=new MouseTracker(sequencer);
  }

  void initialize(PApplet parent) {            //al pedo porque esto lo hago en el constructor
    sequencer.initialize(parent);
    sequencer.isLeapMotionActivated=false;
    sequencer.isMIDIcontrollerActivated=false; 
    sequencer.isMinimActivated=false;
    sequencer.noteSource="random";                              //"random" o "perlin"  ("random" or else en realidad)
    // sequencer.barLength=400;
    sequencer.probabilidad = new int[] {
      20, 7, 20, 6, 20, 7, 20
    };
//    mouseTracker=new MouseTracker(sequencer);
  }

  void update() {
    /*   float mouseNormX = mouseX * invWidth;
     float mouseNormY = mouseY * invHeight;
     float mouseVelX = (mouseX - pmouseX) * invWidth;
     float mouseVelY = (mouseY - pmouseY) * invHeight;
     //  println(sequencer.indice);
     //  mouseTracker.update();
     mouseTracker.playSound();
     */
    
    
    //if (mouseTracker.moving)   addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY);
  }

  void playSound() {
    if (moving&&firstOn) {
      //ya se esta moviendo con sonido;

      /*
      dy=y0-posy;
       dy=abs(atan2(vely, velx)-atan2(vely0, velx0));
       println(dy);
       sequencer.seq.sendControllerChange(0, 0, int(64+constrain(dy, -2, 2)));
       
       */
    } else if (moving&&!firstOn) {
      sequencer.generateRandomNumber();
      midiNote=sequencer.newRandomNote(sequencer.rand);
      sequencer.seq.sendNoteOn(0, midiNote, 100);
      firstOn=true;
      /*
      y0=posy;
       velx0=velx;
       vely0=vely;
       */
    } else if (!moving&&firstOn) {
      sequencer.seq.sendNoteOff(0, midiNote, 100);
      firstOn=false;
      /**/
      sequencer.seq.sendControllerChange(0, 0, 64);
    } else if (!moving&&!firstOn) {
      //no se esta moviendo ni sonando

      /*
      dy=0;
       y0=0;
       velx0=0;
       vely0=0;
       */
    }
    
   
  }
}

