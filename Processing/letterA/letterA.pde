import processing.serial.*;
import cc.arduino.*;        
Arduino arduino;

int maxx=500;              // windows sizes
int maxy=500;

float dzx, dzy;

int maxservox=112;  // maximum servo excursions - to be redefined in recalibration
int minservox=67;
int maxservoy=112;
int minservoy=67;
int initialservox = 90;
int initialservoy = 90;
int servox, servoy;    // current servos positions -in servo range-
int laseroff = 0;      // laser is controlled (improperly) as a servo
int laseron = 1;     // zero is not actually turned off, but is dimmer

//array http://processing.org/reference/Array.html
int[][] letterA = {{ 0, 500, 0}, 
                    { 250, 0, 1}, 
                    { 500, 500, 1},
                    { 125, 250, 0},
                    { 375, 250, 1}};
                    
                    
int sizeofletterA = letterA.length;
int count=0;


void setup() {
  size(maxx,maxy);
  smooth();
  background(255);
  frameRate(7);
  arduino = new Arduino(this, Arduino.list()[3], 57600);
  arduino.analogWrite(9,initialservox);
  arduino.analogWrite(10,initialservoy);
  arduino.analogWrite(12,laseron);  // laser off
  //println(sizeofletterA);

}

void draw() {
 
  // Display circle at x location
  stroke(0);
  fill(0);
  ellipse(letterA[count][0],letterA[count][1],15,15);
  
  //move servo
  servox = int(map(letterA[count][0],0,maxx,minservox,maxservox));
  servoy = int(map(letterA[count][1],0,maxy,minservoy,maxservoy));
  arduino.analogWrite(9,servox);
  arduino.analogWrite(10,servoy);
 
  arduino.analogWrite(12,letterA[count][2]);


  count++;
  if(count == sizeofletterA) {
    count=0; //exit();
    clear();
    background(255);
  }
  
}

