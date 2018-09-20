import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int sx,sy,ex,ey,hx,hy, armsx, armsy;
int femurLength, tibiaLength,ua,la;
float uad, lad;
float grav1 = 0;
float grav2 = 0;
PVector loc1;
PVector loc2;
PVector kneeCenter;
PVector knee1;
PVector knee2;
boolean foot1Ground = false;
boolean foot2Ground = false;
int jumpHeight;

void setup(){
  arduino = new Arduino(this, "COM3", 57600);
  //size(3860,2560);
  fullScreen();
  smooth();
  init();
}

void init() {
  kneeCenter = new PVector(0, 0);
  femurLength = int(150);
  tibiaLength = int(100);
  loc1 = new PVector(0, height);
  loc2 = new PVector(0, height);
  knee1 = new PVector(0,0);
  knee2 = new PVector(0, 0);
  jumpHeight = 0; 
}

void draw(){
  //Get raw joystick data
  PVector V1 = new PVector(arduino.analogRead(0), arduino.analogRead(1));
  PVector V2 = new PVector(arduino.analogRead(2), arduino.analogRead(3));
  int speed = 20;
  
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
   // restricts feet going over the edge
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
  
  fill(255);
  rect(0,0,width,height);
  knee1 = leg(parseInt(loc1.x), parseInt(loc1.y));
  knee2 = leg(parseInt(loc2.x), parseInt(loc2.y));
  kneeCenter = PVector.lerp(knee1, knee2, 0.5);
  arm(parseInt(loc1.x + width / 15), parseInt(loc1.y - height / 2.5));
  arm(parseInt(loc2.x + width / 15), parseInt(loc2.y - height / 2.5));
  armsx = parseInt(lerp(abs(0 - sx), kneeCenter.x, 0.05));
  armsy = parseInt(lerp(height / 4.5, kneeCenter.y, 0.1));
  sx = parseInt(lerp(abs(0 - sx), kneeCenter.x, 0.05));
  sy = parseInt(lerp(height / 2, kneeCenter.y, 0.1));
}

PVector arm(int x, int y){
  
    int dx = x - armsx;
    int dy = y - armsy;
    float distance = sqrt(dx*dx+dy*dy);
    
    //Upper and lower arm length
    int a = height / 6;
    int b = height / 6;
    float c = min(distance, a + b);

    float B = -acos((b*b-a*a-c*c)/(-2*a*c));
    float C = -acos((c*c-a*a-b*b)/(-2*a*b));

    float D = atan2(dy,dx);
    float E = D + B + PI + C;
  
    float segment1 = degrees(E);
    float segment2 = degrees(D+B);
    
    ex = int((cos(E) * b)) + armsx;
    ey = int((sin(E) * b)) + armsy;
    hx = int((cos(D+B) * a)) + ex;
    hy = int((sin(D+B) * a)) + ey;
    //hy =+ parseInt(gravity);
    //println(hy);
    strokeWeight(10);
    fill(0);    
    //ellipse(sx,sy,25,25);
    //Head
    //ellipse(armsx, armsy - height / 3, 100, 100);
    ellipse(armsx,armsy,25,25);
    ellipse(ex,ey,25,25);
    ellipse(hx,hy,35,35);
    stroke(0);
    //line(sx,sy,ex,ey);
    //line(armsx,armsy - height / 3,armsx,armsy);
    line(armsx,armsy,ex,ey);
    line(ex,ey,hx,hy);
    fill(240,0,200,200);
    return new PVector(ex, ey, hy);
}

PVector leg(int x, int y){
  
    int dx = x - sx;
    int dy = y - sy;
    float distance = sqrt(dx*dx+dy*dy);
    
    //Upper and lower arm length
    int a = height / 4;
    int b = height / 4 ;
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
    //hy =+ parseInt(gravity);
    //println(hy);
    strokeWeight(10);
    fill(0);    
    //ellipse(sx,sy,25,25);
    //Head
    ellipse(sx, sy - height / 3, 120, 120);
    ellipse(sx,sy,25,25);
    ellipse(ex,ey,25,25);
    ellipse(hx,hy,35,35);
    stroke(0);
    //line(sx,sy,ex,ey);
    line(sx,sy - height / 3,sx,sy);
    line(sx,sy,ex,ey);
    line(ex,ey,hx,hy);
    fill(240,0,200,200);
    return new PVector(ex, ey, hy);
}

void keyPressed() {
  println("restart");
  init();
}
