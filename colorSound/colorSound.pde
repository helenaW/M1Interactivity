import processing.sound.*;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
color bg;
SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

void setup() {  
  size(1000, 1000);
  //colorMode(HSV, width)
  noStroke();
  colorMode(HSB, width);

  

  //background(255);
  println(Serial.list());
  arduino = new Arduino(this, "/dev/tty.usbmodem14131", 57600);
  arduino.pinMode(12, Arduino.INPUT);

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {
     bg = color(arduino.analogRead(0), 4000 ,arduino.analogRead(1));
  background(bg);
  //background((arduino.analogRead(0)+ arduino.analogRead(1)/2)/256 *64);
  //Map mouseY from 0 to 1
  float yoffset = map(arduino.analogRead(0), 0, height, 0, 1);
  //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
  float frequency = pow(1000, yoffset) + 150;
  //Use mouseX mapped from -0.5 to 0.5 as a detune argument
  float detune = map(arduino.analogRead(1), 0, width, -0.5, 0.5);

  for (int i = 0; i < numSines; i++) { 
    sineFreq[i] = frequency * (i + 1 * detune);
    // Set the frequencies for all oscillators
    sineWaves[i].freq(sineFreq[i]);
  }
}
