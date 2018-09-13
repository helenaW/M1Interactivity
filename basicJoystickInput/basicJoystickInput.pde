
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
float locA= 500;
float locB= 500;
boolean pressed;
void setup() {
size(1023, 1023);
smooth(); 
//prints out serial ports
println(Serial.list()); 
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, "/dev/tty.usbmodem14141", 57600);
  arduino.pinMode(12, Arduino.INPUT);

}
void draw() {

  //background(0);
  frameRate(30);
  stroke(255);
  //input coordinates
  float a = (arduino.analogRead(0));
  float b = (arduino.analogRead(1));
  float movA = 0;
  float movB = 0;
  //nudging ball in direction
  if(a<480){
    movA = -10;
  }else if(a>530){
    movA = 10;
  }else{
    movA =0;
  }
  
   if(b<480){
    movB = -10;
  }else if(b>530){
    movB = 10;
  }else{
    movB=0;
  }
  // restricts ball going over the edge
  if(locA > 0 && locA < width){
    locA += movA;  
  } else if( locA <= 0 && movA >= 0 || locA >= width && movA <= 0){
    locA += movA;
  }
  
 if(locB > 0 && locB < height){
    locB += movB;  
  } else if( locB <= 0 && movB >= 0 || locB >= height && movB <= 0){
    locB += movB;
  }
 
  ellipse(locA, locB, 40, 40);
  fill(78);
  println("x=" + a + " y=" + b);
  delay(50);

}
