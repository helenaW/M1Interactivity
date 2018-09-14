
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
float locA;
float locB;
boolean pressed;
void setup() {
locA= width / 2;
locB= height / 2;
size(2000, 2000);
smooth(); 
//prints out serial ports
println(Serial.list()); 
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, "COM3", 57600);
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
  float weight = map(arduino.analogRead(3), 0, 1023, 0, 40);
  int speed = 10;
  //nudging ball in direction
  if(a<750){
    movA = -speed;
  }else if(a>880){
    movA = speed;
  }else{
    movA =0;
  }
  
   if(b<770){
    movB = -speed;
  }else if(b>920){
    movB = speed;
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
 
  ellipse(locA, locB, weight, weight);
  fill(78);
  stroke(78);
  println("x=" + a + " y=" + b);
  delay(5);
}
