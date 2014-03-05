import processing.serial.*;
import cc.arduino.*;        
Arduino arduino;

float canvasWidth  = 800;           
float canvasHeight = 800;
float distanceToScreen = 800;


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
*/
int laserOff = 0;      // laser is controlled (improperly) as a servo
int laserOn = 1;     // zero is not actually turned off, but is dimmer

//array http://processing.org/reference/Array.html
             
//float[][] letter = {{ 0, 1, 0}, { .5, 0, 1}, { 1, 1, 1},{ .25, .5, 0},{ .75, .5, 1}};  // A
//float[][] letter = {{ 0, 1, 1}, { .5, .75, 1},{ 0, .5, 1},{ .5, .25, 1},{0, 0, 1}};  // B
//float[][] letter = {{ 1, 0, 1}, { 0, 0, 1}, { 0, 1, 1},{ 1, 1, 1},{1,0,0}};  // C
//float[][] letter = {{ 0, 0, 1}, { 0, 1, 1}, { 1, .5, 1},{ 0, 0, 1}};  // D
//float[][] letter = {{ 0, 0, 1}, { 0, 1, 1}, { 0, 0, 0}, { 1, 0, 1}, {0,.5,0}, {1,.5,1}, {0,1,0}, {1,1,1}, {0,0,0}  };  // E
//float[][] letter = {{ 0, 0, 1}, { 0, 1, 1}, { 0, 0, 0}, { 1, 0, 1}, {0,.5,0}, {1,.5,1}, {0,0,0}  };  // F
//float[][] letter = {{ 1, 0, 1}, { 0, 0, 1}, { 0, 1, 1},{ 1, 1, 1}, {1,.5,1 },{.5,.5,1 }};  // G
//float[][] letter = {{ 0, 0, 0}, { 0, 1, 1}, { 1, 0, 0},{ 1, 1, 1}, {0,.5,0 },{1,.5,1 }};  // H
//float[][] letter = {{ 0, 0, 0}, { 1, 0, 1}, { 0, 1, 0},{ 1, 1, 1}, {.5,0,0 },{.5,1,1 }};  // I
//float[][] letter = {{ 0, 0, 0}, { 1, 0, 1}, { .5, 0, 0},{ .5, 1, 1}, {.25,1,1 },{.25,.75,1 }};  // J
//float[][] letter = {{ 0, 0, 0}, { 0, 1, 1}, { 1, 0, 0},{ 0, .5, 1}, {1,1,1 }};  // K
//float[][] letter = {{ 0, 0, 0}, { 0, 1, 1}, { 1, 1, 1}};  // L
//float[][] letter = {{ 0, 1, 0}, { 0, 0, 1}, { .5, 1, 1},{ 1, 0, 1}, {1,1,1 }};  // M
//float[][] letter = {{ 0, 1, 0}, { 0, 0, 1}, { 1, 1, 1},{ 1, 0, 1}};  // N
//float[][] letter = {{ 0, 0, 0}, { 0, 1, 1}, { 1, 1, 1},{ 1, 0, 1},{0,0,1}};  // O
//float[][] letter = {{ 0, 1, 0}, { 0, 0, 1}, { 1, 0, 1},{ 1, .5, 1},{0,.5,1}};  // P
//float[][] letter = {{ 0, 0, 0}, { 0, .8, 1}, { .8, .8, 1},{ .8, 0, 1},{0,0,1},{.5,.5,0}, {1,1,1}};  // Q
//float[][] letter = {{ 0, 1, 0}, { 0, 0, 1}, { 1, 0, 1},{ 1, .5, 1},{0,.5,1},{1,1,1}};  // R
//float[][] letter = {{ 1, 0, 0}, { 0, 0, 1}, { 0, .5, 1},{ 1, .5, 1},{1,1,1},{0,1,1}};  // S
//float[][] letter = {{ 0, 0, 0}, { 1, 0, 1}, { .5, 0, 0}, { .5, 1, 1}};  // T
//float[][] letter = {{ 0, 0, 0}, { 0, 1, 1}, { 1, 1, 1}, { 1, 0, 1}};  // U
//float[][] letter = {{ 0, 0, 0}, { .5, 1, 1}, { 1, 0, 1}};  // V
//float[][] letter = {{ 0, 0, 0}, { .25, 1, 1}, { .5, .5, 1}, { .75, 1, 1}, {1, 0, 1}};  //W
//float[][] letter = {{ 0, 0, 0}, {.5, .5, 1}, { 1, 0, 1}, { .5, .5, 0}, {.5, 1, 1}};  //Y
float[][] letter = {{ 0, 0, 0}, {1, 0, 1}, { 0, 1, 1}, { 1, 1, 1}};  //Z



int sizeOfLetter = letter.length;
int count=0;


void setup() {
  
  servoYawHalfAngle = int(atan((canvasWidth/2)/distanceToScreen) * 57.2957795);
  
  minServoYawDegrees = 90 - servoHalfAngle;
  if(minServoYawDegrees < minYaw ) minServoYawDegrees = 45;
  
  maxServoYawDegrees = 90 + servoHalfAngle;
  if(maxServoYawDegrees > maxYaw) maxServoYawDegrees = 135;
 
  println("init theta =" + maxServoYawDegrees);

  size(canvasWidth,canvasHeight);
  smooth();
  background(255);
  frameRate(7);
  //arduino = new Arduino(this, Arduino.list()[3], 57600);
  //initialServoYaw = int(map(round(letter[count][0]*canvasWidth),0,canvasWidth,minServoYawDegrees,maxServoYawDegrees));
  //initialServoPitch = int(map(round(letter[count][1]*canvasHeight),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));
  
  //println("init yaw =" + initialServoYaw);

  //arduino.analogWrite(9,initialServoYaw);
  //arduino.analogWrite(10,initialServoPitch);
  //arduino.analogWrite(9,135); //YAW
  //arduino.analogWrite(10,0); //PITCH
  //arduino.analogWrite(12,laserOff);  // laser off

}
/*
void draw() {

  
  
  // Display circle at x location
  stroke(0);
  fill(0);
  ellipse(letter[count][0]*canvasWidth,letter[count][1]*canvasHeight,10,10);

  servoYaw = int(map(round(letter[count][0]*canvasWidth),0,canvasWidth,minServoYawDegrees,maxServoYawDegrees));
  servoPitch = int(map(round(letter[count][1]*canvasHeight),0,canvasHeight,minServoPitchDegrees,maxServoPitchDegrees));

  arduino.analogWrite(9,servoYaw);
  arduino.analogWrite(10,servoPitch);
 
  arduino.analogWrite(12,int(letter[count][2]));


  count++;
  if(count == sizeOfLetter) {
    count=0; //exit();
    clear();
    background(255);
  }
  
}
*/
