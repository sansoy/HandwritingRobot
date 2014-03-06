import processing.serial.*;
import java.util.Map;
import cc.arduino.*;        
Arduino arduino;

String theWord = "DEUTSCH";  //ALL CAPS

float spacing = 0;
float canvasWidth  = 1500;           
float canvasHeight = 1000;
float distanceToScreen = 1200;

int minYaw = 45;
int maxYaw = 135;
int servoYawHalfAngle = 0;
int minServoYawDegrees = minYaw;
int maxServoYawDegrees = maxYaw;

int minPitch = 45;
int maxPitch = 135;
int servoPitchHalfAngle = 0;
int minServoPitchDegrees = minPitch;
int maxServoPitchDegrees = maxPitch;

int initialServoYaw, initialServoPitch;

int servoYaw, servoPitch;    // current servos positions -in servo range-
int laserOff = 0;      // laser is controlled (improperly) as a servo
int laserOn = 1;     // zero is not actually turned off, but is dimmer


float[][] letterA = {{ 0, 1, 0}, { 0, 1, 1}, { .5, 0, 1}, { 1, 1, 1}, { .25, .5, 0}, {.75, .5, 1},{.75, .5, 0}};  
float[][] letterB = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { .5, .75, 1}, { 0, .5, 1}, { .5, .25, 1}, { 0, 0, 1}, { 0, 0, 0}}; 
float[][] letterC = {{ 1, 0, 0}, { 1, 0, 1}, { 0, 0, 1}, { 0, 1, 1}, { 1, 1, 1}, { 1, 0, 0}};  
float[][] letterD = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 1, .5, 1},{ 0, 0, 1},{ 0, 0, 0}};  
float[][] letterE = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 0, 0, 0}, { 1, 0, 1}, {0,.5,0}, {1,.5,1}, {0,1,0}, {1,1,1}, {0,0,0}};  
float[][] letterF = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 0, 0, 0}, { 1, 0, 1}, {0,.5,0}, {1,.5,1}, {0,0,0}};  
float[][] letterG = {{ 1, 0, 0}, { 1, 0, 1}, { 0, 0, 1}, { 0, 1, 1},{ 1, 1, 1}, {1,.5,1 },{.5,.5,1},{.5,.5,0}};  
float[][] letterH = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 1, 0, 0},{ 1, 1, 1}, {0,.5,0 },{1,.5, 1 }, {1,.5, 0}};  
float[][] letterI = {{ 0, 0, 0}, { 0, 0, 1}, { 1, 0, 1}, { 0, 1, 0},{ 1, 1, 1}, {.5,0,0 },{.5,1,1 },{.5,1,0}};  
float[][] letterJ = {{ 0, 0, 0}, { 0, 0, 1}, { 1, 0, 1}, { .5, 0, 0},{ .5, 1, 1}, {.25,1,1 },{.25,.75,1},{.25,.75,0}};  
float[][] letterK = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 1, 0, 0},{ 0, .5, 1}, {1,1,1}, {1,1,0}};  
float[][] letterL = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 1, 1, 1}, { 1, 1, 0}};  
float[][] letterM = {{ 0, 1, 0}, { 0, 1, 1}, { 0, 0, 1}, { .5, 1, 1},{ 1, 0, 1}, {1,1,1}, {1,1,0}};  
float[][] letterN = {{ 0, 1, 0}, { 0, 1, 1}, { 0, 0, 1}, { 1, 1, 1},{ 1, 0, 1},{ 1, 0, 1}};  
float[][] letterO = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 0, 1}, { 0, 1, 1}, { 1, 1, 1}, { 1, 0, 1}, {0,0,1}, {0,0,0}};  
float[][] letterP = {{ 0, 1, 0}, { 0, 1, 1}, { 0, 0, 1}, { 1, 0, 1},{ 1, .5, 1},{0,.5,1},{0,.5,0}};  
float[][] letterQ = {{ 0, 0, 0}, { 0, 0, 1}, { 0, .8, 1}, { .8, .8, 1},{ .8, 0, 1},{0,0,1},{.5,.5,0}, {1,1,1}, {1,1,0}};  
float[][] letterR = {{ 0, 1, 0}, { 0, 1, 1}, { 0, 0, 1}, { 1, 0, 1},{ 1, .5, 1},{0,.5,1},{1,1,1},{1,1,0}};  
float[][] letterS = {{ 1, 0, 0}, { 1, 0, 1}, { 0, 0, 1}, { 0, .5, 1},{ 1, .5, 1},{1,1,1},{0,1,1},{0,1,0}}; 
float[][] letterT = {{ 0, 0, 0}, { 0, 0, 1}, { 1, 0, 1}, { .5, 0, 0}, { .5, 1, 1}, { .5, 1, 0}}; 
float[][] letterU = {{ 0, 0, 0}, { 0, 0, 1}, { 0, 1, 1}, { 1, 1, 1}, { 1, 0, 1}, { 1, 0, 0}};  
float[][] letterV = {{ 0, 0, 0}, { 0, 0, 1}, { .5, 1, 1}, { 1, 0, 1}, { 1, 0, 0}};  
float[][] letterW = {{ 0, 0, 0}, { 0, 0, 1}, { .25, 1, 1}, { .5, .5, 1}, { .75, 1, 1}, {1, 0, 1}, {1, 0, 0}};  
float[][] letterX = {{ 0, 0, 0}, { 0, 0, 1}, { 1, 1, 1}, { 1, 0, 0}, { 0, 1, 1}, { 0, 1, 0}};  
float[][] letterY = {{ 0, 0, 0}, { 0, 0, 1}, {.5, .5, 1}, { 1, 0, 1}, { .5, .5, 0}, {.5, 1, 1},{.5, 1, 0}};  
float[][] letterZ = {{ 0, 0, 0}, { 0, 0, 1}, {1, 0, 1}, { 0, 1, 1}, { 1, 1, 1}, { 1, 1, 0}};  

Alphabet englishABC;

int wordLength;
char currentChar;
int fontSize;
float kerning = .1;  //space between characters
int eachLetter = 0;
String currentLetter;
int numberOfStrokes;
int strokeNumber = 0;


void setup() {

  frameRate(6);  

  englishABC = new Alphabet();
  englishABC.addLetter("A", letterA, letterA.length);
  englishABC.addLetter("B", letterB, letterB.length);
  englishABC.addLetter("C", letterC, letterC.length);
  englishABC.addLetter("D", letterD, letterD.length);
  englishABC.addLetter("E", letterE, letterE.length);
  englishABC.addLetter("F", letterF, letterF.length);
  englishABC.addLetter("G", letterG, letterG.length);
  englishABC.addLetter("H", letterH, letterH.length);
  englishABC.addLetter("I", letterI, letterI.length);
  englishABC.addLetter("J", letterJ, letterJ.length);
  englishABC.addLetter("K", letterK, letterK.length);
  englishABC.addLetter("L", letterL, letterL.length);
  englishABC.addLetter("M", letterM, letterM.length);
  englishABC.addLetter("N", letterN, letterN.length);
  englishABC.addLetter("O", letterO, letterO.length);
  englishABC.addLetter("P", letterP, letterP.length);
  englishABC.addLetter("Q", letterQ, letterQ.length);
  englishABC.addLetter("R", letterR, letterR.length);
  englishABC.addLetter("S", letterS, letterS.length);
  englishABC.addLetter("T", letterT, letterT.length);
  englishABC.addLetter("U", letterU, letterU.length);
  englishABC.addLetter("V", letterV, letterV.length);
  englishABC.addLetter("W", letterW, letterW.length);
  englishABC.addLetter("X", letterX, letterX.length);
  englishABC.addLetter("Y", letterY, letterY.length);
  englishABC.addLetter("Z", letterZ, letterZ.length);

  wordLength = theWord.length();
  fontSize = int((canvasWidth / wordLength)*(1 - kerning));

  char firstChar = theWord.charAt(0);
  String firstLetter = String.valueOf(firstChar);
  Vec3 p = englishABC.getLetter(firstLetter).getPoint(0);
  
  //println("Point: " + p.x + ", " + p.y + ", " + p.z);

//  
//  Letter myLetter = (Letter)englishABC.getLetter("V");
//  println("Total: " + myLetter.getTotal());
//  int i, total = myLetter.getTotal();
//  for(i = 0; i < total; ++i) {
//    Vec3 vp = myLetter.getPoint(i);
//    println(i + ": " + vp.x + ", " +  vp.y + ", " +  vp.z);
//  }


  //YAW SERVO SETUP
  servoYawHalfAngle = int(atan((canvasWidth/2)/distanceToScreen) * 57.2957795);

  minServoYawDegrees = 90 - servoYawHalfAngle;
  if (minServoYawDegrees < minYaw ) minServoYawDegrees = 45;

  maxServoYawDegrees = 90 + servoYawHalfAngle;
  if (maxServoYawDegrees > maxYaw) maxServoYawDegrees = 135;


  //PITCH SERVO SETUP
  servoPitchHalfAngle = int(atan((canvasHeight/2)/distanceToScreen) * 57.2957795);

  minServoPitchDegrees = 90 - servoPitchHalfAngle;
  if (minServoPitchDegrees < minPitch ) minServoPitchDegrees = 45;

  maxServoPitchDegrees = 90 + servoPitchHalfAngle;
  if (maxServoPitchDegrees > maxPitch) maxServoPitchDegrees = 135;

  //println("maxPitch = " + maxServoPitchDegrees);
  
  size(int(canvasWidth), int(canvasHeight));
  smooth();
  background(0,0,0);
  

  
  initialServoYaw = int(map(round(p.x*fontSize+spacing),0,canvasWidth,minServoYawDegrees,maxServoYawDegrees));
  //initialServoPitch = int(map(round(p.y*fontSize+canvasHeight*.1),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));
  initialServoPitch = int(map(round(p.y*fontSize),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));

  ellipse(p.x*fontSize,p.y*fontSize,5,5);
 
  arduino = new Arduino(this, Arduino.list()[3], 57600);
  arduino.analogWrite(9,initialServoYaw);
  arduino.analogWrite(10,initialServoPitch);
  arduino.analogWrite(12,int(p.z)); //LASER STATE
  
 
}

void draw() {
 
   if(eachLetter < wordLength){
     
       currentChar = theWord.charAt(eachLetter);
       currentLetter = String.valueOf(currentChar);
       Letter myLetter = (Letter)englishABC.getLetter(currentLetter);
       numberOfStrokes = myLetter.getTotal();
       
     if(strokeNumber < numberOfStrokes){
       
       Vec3 p1 = englishABC.getLetter(currentLetter).getPoint(strokeNumber);
       servoYaw = int(map(round(p1.x*fontSize+spacing),0,canvasWidth,minServoYawDegrees,maxServoYawDegrees));
       //servoPitch = int(map(round(p1.y*fontSize+canvasHeight*.1),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));
       servoPitch = int(map(round(p1.y*fontSize),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));

       arduino.analogWrite(9,servoYaw);
       arduino.analogWrite(10,servoPitch);
       arduino.analogWrite(12,int(p1.z));
       ellipse(p1.x*fontSize+spacing,p1.y*fontSize,10,10);
       strokeNumber++;
     } else {
       spacing = spacing + fontSize*(1+kerning);
       eachLetter++;
       strokeNumber = 0;
       //clear();
     }
     
   }
   


 
}

