import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int sx,sy,ex,ey,hx,hy;
int femurLength, tibiaLength,ua,la;
float uad, lad;
PVector loc1;
PVector loc2;
PVector anchor;
PVector knee1;
PVector knee2;
boolean foot1Ground = false;
boolean foot2Ground = false;
void setup(){
  arduino = new Arduino(this, "COM3", 57600);
  size(2000,1000);
  //fullScreen();
  anchor = new PVector(0, 0);
  femurLength = int(150);
  tibiaLength = int(100);
  loc1 = new PVector(width / 2, height / 2);
  loc2 = new PVector(width / 2, height / 2);
  knee1 = new PVector(0,0);
  knee2 = new PVector(0, 0);
}

void draw(){
  PVector V1 = new PVector(arduino.analogRead(0), arduino.analogRead(1));
  PVector V2 = new PVector(arduino.analogRead(2), arduino.analogRead(3));
  int speed = 15;
  //nudging ball in direction
  PVector mov1 = new PVector(0, 0);
  PVector mov2 = new PVector(0, 0);
  if(V1.x<750){
    mov1.x = -speed;
  }else if(V1.x>880){
    mov1.x = speed;
  }else{
    mov1.x =0;
  }
   if(V1.x<770){
    mov1.y = -speed;
  }else if(V1.y>920){
    mov1.y = speed;
  }else{
    mov1.y = 0;
  }
  if(V2.x<750){
    mov2.x = -speed;
  }else if(V2.x>880){
    mov2.x = speed;
  }else{
    mov2.x =0;
  }
   if(V2.y<770){
    mov2.y = -speed;
  }else if(V2.y>920){
    mov2.y = speed;
  }else{
    mov2.y=0;
  }
   // restricts ball going over the edge
  if(loc1.x > 0 && loc1.x < width){
    loc1.x += mov1.x;  
  } else if( loc1.x <= 0 && mov1.x >= 0 || loc1.x >= width && mov1.x <= 0){
    loc1.x += mov1.x;
  }
  
 if(loc1.y > 0 && loc1.y < height){
    loc1.y += mov1.y;  
  } else if( loc1.y <= 0 && mov1.y >= 0 || loc1.y >= height && mov1.y <= 0){
    loc1.y += mov1.y;
  }
   // restricts ball going over the edge
  if(loc2.x > 0 && loc2.x < width){
    loc2.x += mov2.x;  
  } else if( loc2.x <= 0 && mov2.x >= 0 || loc2.x >= width && mov2.x <= 0){
    loc2.x += mov2.x;
  }
  
 if(loc2.y > 0 && loc2.y < height){
    loc2.y += mov2.y;  
  } else if( loc2.y <= 0 && mov2.y >= 0 || loc2.y >= height && mov2.y <= 0){
    loc2.y += mov2.y;
  }
  if(loc2.y >= height) {
    foot2Ground = true;
  }
  else {
    foot2Ground = false;
  }
  fill(255);
  rect(0,0,width,height);
  knee1 = upperArm(parseInt(loc1.x), parseInt(loc1.y));
  knee2 = upperArm(parseInt(loc2.x), parseInt(loc2.y));

  anchor = PVector.lerp(knee1, knee2, 0.5);
 // ellipse(anchor.x,anchor.y,25,25);
  //sx = width / 2;
  //sy = height / 2;
   sx = parseInt(lerp(sx, anchor.x, 0.5));
  sy = parseInt(lerp(height / 2, anchor.y, 0.5));
  println(sx);
  //sx = parseInt(anchor.x);
  //sy = parseInt(anchor.y);
  //pushMatrix();
  //translate(anchor.x, anchor.y);
  //popMatrix();
}

PVector upperArm(int x, int y){
    int dx = x - sx;
    int dy = y - sy;
    float distance = sqrt(dx*dx+dy*dy);
    
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
    hx = int((cos(D+B) * a)) + ex;
    hy = int((sin(D+B) * a)) + ey;
    strokeWeight(10);
    fill(0);    
    //ellipse(sx,sy,25,25);
    ellipse(sx,sy,25,25);
    ellipse(ex,ey,25,25);
    ellipse(hx,hy,25,25);
    stroke(0);
    //line(sx,sy,ex,ey);
    line(sx,sy,ex,ey);
    line(ex,ey,hx,hy);
    fill(240,0,200,200);
    return new PVector(ex, ey);
}
