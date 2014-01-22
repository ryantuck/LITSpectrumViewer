// LIT Spectrum Viewer

// ==== Setup ====================================
// Works with LITHeadband sketch.
// The first time you run this, Processing might tell you to open
// up terminal and type stuff in. Not sure what it does, but do it.
// In Headband constructor, ensure
//     fooManager = new ContinuousOutput()
// Baud rate
//  - currently it's set to 28800. See myPort = new Serial(blah blah)
//  - match this up in both the LITHeadband sketch setup() and in the
//    serial monitor itself.
// Hit run and enjoy.

// ==== Notes ====================================
// I've noticed that different baud rates produce different spectrum shapes
// Not sure why this happens or what is the optimal baud rate.
// We could definitely go for using running variance etc to figure stuff out.
// Processing could be helpful because we can take care of the calcs on the comp
// and see them changing in real time. It's super easy to write text etc to 
// the UI that you create in Processing. 

import processing.serial.*;

Serial myPort;

void setup()
{
  size(700,600); // size of window
  
  // set up the serial port bullshit 
  // Serial.list()[6] represents the sixth option in arduino>ports
  myPort = new Serial(this,Serial.list()[6],28800);
  myPort.bufferUntil('\n');
  
  background(0); // background color black
}

void draw()
{
  // similar to loop() in arduino
  // just has to be here
}

void serialEvent (Serial myPort)
{
  // read a row
  String wholeRow = myPort.readString();
  
  // reset the background
  background(0);
  
  // make sure we're not reading null garbage
  if (wholeRow != null)
  {
    // split the row into an array (comma-separated)
    String[] dataStrings = wholeRow.split(",");
    
    // convert the array of strings into ints
    int[] dataNums = new int[7];
    for (int n=0;n<7;n++)
    {
      dataNums[n] = int(dataStrings[n]);
    }
    
    // draw graph
    for (int n=0;n<7;n++)
    {
      // set coordinates
      // y value maps dataNums[n] in the range 0-1023 between height-0
      // does reverse mapping because y is zero at top of window
      int x = 50 + 100*n;
      float y = map(dataNums[n],0,1023,height,0);
      
      // draw rectangle
      rect(x,y,10,10);
    }
  }
}

