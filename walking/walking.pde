import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int sx,sy,ex,ey,hx,hy;
int femurLength, tibiaLength,ua,la;
float uad, lad;
PVector loc1;
PVector loc2;
PVector anchor;
float locX1;
float locY1;
float locX2;
float locY2;


void setup(){
  arduino = new Arduino(this, "COM3", 57600);
  size(2000,1000);
  //fullScreen();
  anchor = new PVector(0, 0);
  femurLength = int(150);
  tibiaLength = int(100);
  loc1 = new PVector(width / 2, height / 2);
  loc2 = new PVector(width / 2, height / 2);
  locX1= width / 2;
  locY1= height / 2;
  locX2 = width / 2;
  locY2 = width / 2;
}

void draw(){
  PVector V1 = new PVector(arduino.analogRead(0), arduino.analogRead(1));
  PVector V2 = new PVector(arduino.analogRead(2), arduino.analogRead(3));
  float x1 = (arduino.analogRead(0));
  float y1 = (arduino.analogRead(1));
  float x2 = (arduino.analogRead(2));
  float y2 = (arduino.analogRead(3));
  int speed = 15;
  //nudging ball in direction
  PVector mov1 = new PVector(0, 0);
  PVector mov2 = new PVector(0, 0);
  float movX1 = 0;
  float movY1 = 0;
  float movX2 = 0;
  float movY2 = 0;
  //nudging ball in direction
  if(x1<750){
    movX1 = -speed;
  }else if(x1>880){
    movX1 = speed;
  }else{
    movX1 =0;
  }
  
   if(y1<770){
    movY1 = -speed;
  }else if(y1>920){
    movY1 = speed;
  }else{
    movY1=0;
  }
  if(x2<750){
    movX2 = -speed;
  }else if(x2>880){
    movX2 = speed;
  }else{
    movX2 =0;
  }
  
   if(y2<770){
    movY2 = -speed;
  }else if(y2>920){
    movY2 = speed;
  }else{
    movY2=0;
  }
  println("x1" + x1);
  println("x2" + x2);
   // restricts ball going over the edge
  if(locX1 > 0 && locX1 < width){
    locX1 += movX1;  
  } else if( locX1 <= 0 && movX1 >= 0 || locX1 >= width && movX1 <= 0){
    locX1 += movX1;
  }
  
 if(locY1 > 0 && locY1 < height){
    locY1 += movY1;  
  } else if( locY1 <= 0 && movY1 >= 0 || locY1 >= height && movY1 <= 0){
    locY1 += movY1;
  }
   // restricts ball going over the edge
  if(locX2 > 0 && locX2 < width){
    locX2 += movX2;  
  } else if( locX2 <= 0 && movX2 >= 0 || locX2 >= width && movX2 <= 0){
    locX2 += movX2;
  }
  
 if(locY2 > 0 && locY2 < height){
    locY2 += movY2;  
  } else if( locY2 <= 0 && movY2 >= 0 || locY2 >= height && movY2 <= 0){
    locY2 += movY2;
  }
  
  //locX1 += movX1;
  //locY1 += movY1;
  //locX2 += movX2;
  //locY2 += movY2;
  fill(255);
  rect(0,0,width,height);
  upperArm(parseInt(locX1), parseInt(locY1));
  upperArm(parseInt(locX2), parseInt(locY2));
  //sx = width / 2;
  //sy = height / 2;
  sx = width / 2;
  sy = height / 2;
}

void upperArm(int x, int y){
    //int dx = x - sx;
    //int dy = y - sy;
    int dx = x - sx;
    int dy = y - sy;
    float distance = sqrt(dx*dx+dy*dy);
    
    //print("dx= "+dx+" dy="+dy+" distance=" + distance + " ");
    
    //Upper and lower arm length
    int a = height / 3;
    int b = height / 3;
    float c = min(distance, a + b);

    float B = acos((b*b-a*a-c*c)/(-2*a*c));
    float C = acos((c*c-a*a-b*b)/(-2*a*b));

    float D = atan2(dy,dx);
    float E = D + B + PI + C;
  
    float segment1 = degrees(E);
    float segment2 = degrees(D+B);
  
    ex = int((cos(E) * b)) + sx;
    ey = int((sin(E) * b)) + sy;
    //print("UpperArm Angle= "+degrees(E)+" ");

    hx = int((cos(D+B) * a)) + ex;
    hy = int((sin(D+B) * a)) + ey;
    //println("LowerArm Angle= "+degrees((D+B)));
    strokeWeight(10);
    //stroke(255,0,0,100);
    fill(0);    
    ellipse(sx,sy,25,25);
    //text(segment1, sx, sy);
    ellipse(ex,ey,25,25);
    //text(segment2, ex, ey);
    ellipse(hx,hy,25,25);
    stroke(0);
    line(sx,sy,ex,ey);
    line(ex,ey,hx,hy);
  
    //println("ex="+ex+" ey"+ey);
  
    fill(240,0,200,200);
    //ellipse(dx,dy,10,10);
}
