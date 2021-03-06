import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
float locA;
float locB;
boolean pressed;
float movA = 0;
float movB = 0;
Box2DProcessing box2d;  
ArrayList<Box> boxes;
Box p;
void setup() {
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  boxes = new ArrayList<Box>();
  p = new Box(width / 2, height / 2);
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
  box2d.step(); 
  
  //background(0);
  frameRate(60);
  //stroke(255);
  //input coordinates
  float x1 = (arduino.analogRead(0));
  float y1 = (arduino.analogRead(1));
  float x2 = (arduino.analogRead(2));
  float y2 = (arduino.analogRead(3));
  float oldLocA = locA;
  float oldLocB = locB;
  float weight = map(arduino.analogRead(3), 0, 1023, 0, 40);
  int speed = 10;
  //nudging ball in direction
  if(x1<750){
    movA = -speed;
  }else if(x1>880){
    movA = speed;
  }else{
    movA =0;
  }
  
   if(x2<770){
    movB = -speed;
  }else if(x2>920){
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
  background(150);
  if (mousePressed) {
    
    //boxes.add(p);
    //println(boxes.length);
  }
//fill(256);
stroke(256);
 
  p.display();
  line(lerp(oldLocA, locA, .01), y1, width/2, 200); 
  line(lerp(oldLocB, locB, .01), y2, width/2, 200);
   
  
  //for (Box b: boxes) {
  //  b.display();
  //}
  strokeWeight(5);
  
  
  
  //ellipse(locA, locB, weight, weight);
  //fill(78);
  println("x=" + x1 + " y=" + x2);
  delay(1);
}
