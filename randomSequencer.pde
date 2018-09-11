import themidibus.*;
import java.util.Random;

class randomSequencer {

  MidiBus seq;
  boolean isLeapMotionActivated=false;
  boolean isMIDIcontrollerActivated=false;
  boolean isMinimActivated=false;
  String noteSource="random";
  int barLength=1000;
  int barCounter=0;

  int rand=0;
  int tempo, var, range, lastMillis, lastNote;
  boolean firstOn, firstOff;
  int[] jonico= {
    0, 2, 4, 5, 7, 9, 11
  };
  int[] dorico= {
    0, 2, 3, 5, 7, 9, 10
  };
  int[] frigio= {
    0, 1, 3, 5, 7, 8, 10
  };
  int[] lidio= {
    0, 2, 4, 6, 7, 9, 11
  };
  int[] mixolidio= {
    0, 2, 4, 5, 7, 9, 10
  };
  int[] eolico= {
    0, 2, 3, 5, 7, 8, 10
  };
  int[] locrio= {
    0, 1, 3, 5, 6, 8, 10
  };
  int[] disminuido= {
    0, 1, 3, 5, 6, 8, 9
  };

  int[] probabilidad= {
    20, 7, 20, 6, 20, 7, 20
  }; //new int[7];
  int[] rangeArray= {
    0, 12, -12, 24, -24
  };

  int progLength=4;                   //largo de la progre

  float noise=0;                      //variables para ruido perlin
  float noise_inc=0.01;



  int primera, tercera, quinta, septima;

  int C=60, Csharp=61, D=62, Dsharp=63, E=64, F=65, Fsharp=66, G=67, Gsharp=68, A=69, Asharp=70, B=71;


  int[] miprogresion= {
    65, 65, 62, 67
  };                                  //ejemplo
  int[][] misescalas= new int[][] {
    jonico, lidio, dorico, mixolidio
  };
  float dur;


  int indice=1, lastIndice=0;                                                                       //indice = 2, en este caso estas sobre  D dorico
  String[] notas = {
    "C ", "F ", "D ", "G "
  };                                                          //inicializo el ejemplo!!!!!!
  String[] escalas = {
    "  j", "  L", "  d", "  m"
  };


  ///////////////////////////////////////////////////////////////////////////////////


  void siguiente() {
    if (indice!=progLength-1) indice++; 
    else if (indice==progLength-1) indice=0;
  }

  void anterior() {
    if (indice!=0) indice--;
  }

  void generateRandomNumber() {
    if (noteSource.equals("random")) {
      rand=int ( random(100) );
    } else {
      rand=floor(map(noise(noise), 0, 1, 0, 100));
    }

    noise+=noise_inc;
    int probAcu=0, offset=12;


    for (int i=0; i<=6; i++) {
      if ( (rand>=probAcu)&&(rand<=probabilidad[i]+probAcu)) {
        rand=i;
        break;
      } else probAcu=probAcu+probabilidad[i];
    }
  }


  int newRandomNote(int randomNum) {
    int newNote=0; 

    newNote=getTonica();    
    newNote=newNote+getEscala()[randomNum]; 

    newNote=newNote+rangeArray[int(random(range))] ;

    return newNote;
  }

  void sequence() {


    //nueva nota para mi progresion 



    generateRandomNumber();
    int newNote=newRandomNote(rand);  //originalmente decia +offset (ver generateRandomNumber())


    //println(newNote);
    if (millis() <= lastMillis + tempo) { 
      if (firstOn==true) {
        seq.sendNoteOn(0, newNote, 100);

        /*    midi.setMidiNoteIn(newNote);
         midi.patch(wave.frequency);        //minim
         if (isMinimActivated) wave.setAmplitude(1);                                                                          // si le pones 0 minim se calla
         */
        lastNote=newNote;
        firstOn=false;
      }
      if (millis() >= lastMillis + tempo/dur) {
        if (firstOff==true) {
          seq.sendNoteOff(0, lastNote, 100);

          //        wave.setAmplitude(0);      //minim

          firstOff=false;
        }
      }
    } else if (millis() >= lastMillis + tempo) {
      lastMillis = millis();
      seq.sendNoteOff(0, lastNote, 100);
      firstOn=true;
      firstOff=true;
    }
  }



  void newChord() {
  }


  int getTonica() {
    if (notas[indice].charAt(0)=='C'  &&  notas[indice].charAt(1)==' ') return 60;
    if (notas[indice].charAt(0)=='C'  &&  notas[indice].charAt(1)=='#') return 61;
    if (notas[indice].charAt(0)=='D'  &&  notas[indice].charAt(1)==' ') return 62;
    if (notas[indice].charAt(0)=='D'  &&  notas[indice].charAt(1)=='#') return 63;
    if (notas[indice].charAt(0)=='E'  &&  notas[indice].charAt(1)==' ') return 64;
    if (notas[indice].charAt(0)=='F'  &&  notas[indice].charAt(1)==' ') return 65;
    if (notas[indice].charAt(0)=='F'  &&  notas[indice].charAt(1)=='#') return 66;
    if (notas[indice].charAt(0)=='G'  &&  notas[indice].charAt(1)==' ') return 67;
    if (notas[indice].charAt(0)=='G'  &&  notas[indice].charAt(1)=='#') return 68;
    if (notas[indice].charAt(0)=='A'  &&  notas[indice].charAt(1)==' ') return 69;
    if (notas[indice].charAt(0)=='A'  &&  notas[indice].charAt(1)=='#') return 70;
    if (notas[indice].charAt(0)=='B'  &&  notas[indice].charAt(1)==' ') return 71;
    else return 0;
  }

  int[] getEscala() {
    int[] miescala=jonico;
    if (notas[indice].charAt(1)==' ') {
      if (escalas[indice].charAt(2)=='j') miescala=jonico;
      if (escalas[indice].charAt(2)=='d') miescala=dorico;
      if (escalas[indice].charAt(2)=='f') miescala=frigio;
      if (escalas[indice].charAt(2)=='L') miescala=lidio;
      if (escalas[indice].charAt(2)=='m') miescala=mixolidio;
      if (escalas[indice].charAt(2)=='e') miescala=eolico;
      if (escalas[indice].charAt(2)=='l') miescala=locrio;
    }
    if (notas[indice].charAt(1)=='#') {
      if (escalas[indice].charAt(3)=='j') miescala=jonico;
      if (escalas[indice].charAt(3)=='d') miescala=dorico;
      if (escalas[indice].charAt(3)=='f') miescala=frigio;
      if (escalas[indice].charAt(3)=='L') miescala=lidio;
      if (escalas[indice].charAt(3)=='m') miescala=mixolidio;
      if (escalas[indice].charAt(3)=='e') miescala=eolico;
      if (escalas[indice].charAt(3)=='l') miescala=locrio;
    }
    return miescala;
  }


  void nextChord() {
    if (indice==notas.length-1) indice=0; 
    else indice++;
  }

  void prevChord() {
    if (indice==0) indice=notas.length-1; 
    else indice--;
  }

  void changeVar() {
    //   var= int(fingerdist("indice", "derecha"));   //cambiar la variacion con la distancia entre el indice y el pulgar( MANO DERECHA!!!!)
    println(var);
    if (var<20) probabilidad=new int[] {
      50, 0, 0, 0, 50, 0, 0
    };                             //probabilidad de que nota va a ser disparada
    else if ( (var>15)&&(var<23) ) probabilidad=new int[] {
      33, 0, 33, 0, 33, 0, 0
    };
    else if ( (var>23)&&(var<30) ) probabilidad=new int[] {
      30, 0, 30, 0, 30, 0, 10
    };
    else if ( (var>30)&&(var<110) ) probabilidad=new int[] {
      20, 10, 20, 0, 20, 10, 20
    };
    else  probabilidad=new int[] {
      20, 7, 20, 6, 20, 7, 20
    };
  }

  void initialize(PApplet parent) {                                                                              //inicializa variables, minim y the midi bus
    firstOn=true;
    firstOff=true;
    smooth();
    tempo=300;  
    seq=  new MidiBus(parent, "nanoKONTROL2", "Klaus_seq");  
    probabilidad=new int[] {
      50, 0, 0, 0, 50, 0, 0
    };
    range=0;
  }

  void receiveMIDI(int channel, int number, int value) {
    if (isMIDIcontrollerActivated) {
      if (number==0) {
        tempo=value*3; 
        //  println(tempo);
      }
      if (number==1) {
        if (value<40) range=0;
        if ( (value>40)&&(value<80) ) range=3;
        if ( (value>80)&&(value<127) ) range=5;
      }
      if (number==2) {
        if (value<20) probabilidad=new int[] {
          50, 0, 0, 0, 50, 0, 0
        };
        if ( (value>20)&&(value<40) ) probabilidad=new int[] {
          33, 0, 33, 0, 33, 0, 0
        };
        if ( (value>40)&&(value<60) ) probabilidad=new int[] {
          30, 0, 30, 0, 30, 0, 10
        };
        if ( (value>60)&&(value<80) ) probabilidad=new int[] {
          20, 10, 20, 0, 20, 10, 20
        };
        if ( (value>80)&&(value<=100) ) probabilidad=new int[] {
          20, 7, 20, 6, 20, 7, 20
        };
      }
      if (number==3) {
        dur=value/15 +1.1;
      }
      if (number==4) {
        noise_inc=map(value, 0, 127, 0, 1);
      }
    }
  }
  void updateProg(){
   if(barCounter!=barLength) barCounter++; 
   else {
     siguiente();
     barCounter=0;
   }
  }
}



