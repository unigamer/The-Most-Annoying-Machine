// The Most Annoying Machine
// Jonathan Jamieson
// www.jonathanjamieson.com

// This is the first version of the code. I knocked it up in an evening and it might (read WILL) be buggy. Oh, and there are few comments and the ones that do exist are probably wrong.


/*
Todo:
- comment code
- go into sleep when "off" mode is activated, maybe use an interrupt
- schematic for this code
- remove hard coded delays and change to variables
- a general tidy up
*/

#include <math.h>

int buttonState = 0;         // variable for reading the pushbutton status

int accel_flag = 0;
int in_rest = 0;
unsigned long time;
unsigned long  button_switch_time ;
unsigned long  accel_time ;
unsigned long button_delay ; 
double magnitude_accelerometer;
int previous_button_state = 1;

const int ledPin =  8; 
const int buzzerPin =  7; 
const int activateswitchPin =  4; 
const int buttonPin = 3;     // the number of the pushbutton pinconst int buttonPin = 2;     // the number of the pushbutton pin
const int  xpin = A0;
const int  ypin = A1;
const int  zpin = A2;

int state = 1; // 1 = active, 0, inactive where active means the thing is trying to flip the switch;

int x; // Acceleration in the x-direction
int y; // Acceleration in the y-direction
int z; // Acceleration in the z-direction

// These values are used to scale the acceleration that is read from the accelerometer. This is required because the voltage varies as the Lipo drains down.
    // Calibrate the accelerometer
const int   xMin = 270; 
const int   yMin = 265;
const int   zMin = 282;
const int   xMax = 405;
const int   yMax = 400;
const int   zMax = 416;

void setup(void) {
    pinMode(buttonPin, INPUT);  
    pinMode(buzzerPin, OUTPUT);  
    pinMode(activateswitchPin, OUTPUT);
    pinMode(ledPin, OUTPUT);
    pinMode(xpin, INPUT);
    pinMode(ypin, INPUT);
    pinMode(zpin, INPUT);

    Serial.begin(57600); 
 }
 
 void loop(void)
{

  buttonState = digitalRead(buttonPin);
  x = analogRead(xpin); delay(1); y = analogRead(ypin); delay(1); z = analogRead(zpin);
  
  if (buttonState == HIGH) {    
    // turn LED on:    
    if (previous_button_state==0) {      
      button_switch_time = millis();
    }
   digitalWrite(buzzerPin, HIGH);    
 digitalWrite(ledPin, HIGH);   
  
   previous_button_state = 1;
   in_rest = 0;
  
   
  } else {
    
    if (in_rest != 1) {
    
    if (previous_button_state == 1) {      
  button_delay = (millis()-button_switch_time);    
      button_delay = min((button_delay),3000);   
   
   Serial.println(button_delay);   
      previous_button_state = 0;    
      time = millis() + button_delay ;
      delay(30);
      
    }
    
     previous_button_state = 0;
    digitalWrite(buzzerPin, LOW);
    digitalWrite(ledPin, LOW);
    
    if (millis()>time) {
     digitalWrite(activateswitchPin, HIGH); 
     delay(30);
     digitalWrite(activateswitchPin, LOW); 
     delay(200);   
    }
    
    }
  }
 
  int xAng = map(x, xMin, xMax, -90, 90);
  int yAng = map(y, yMin, yMax, -90, 90);
  int zAng = map(z, zMin, zMax, -90, 90);

  magnitude_accelerometer = sqrt(pow(xAng,2)+pow(yAng,2)+pow(zAng,2)); // Determine the magnitude of the acceleration
  
 if (millis()>accel_time && accel_flag==1)
  if (magnitude_accelerometer<40) {
  
    digitalWrite(ledPin, LOW);
  digitalWrite(buzzerPin, LOW);
   in_rest = 1;
   previous_button_state=0;
  delay(5000);
  accel_flag = 0;
  } else {   
    accel_flag =0;   
  }
    
  if (magnitude_accelerometer<40 && accel_flag==0 && previous_button_state==1) {    
    accel_time = millis()+300;
    accel_flag = 1;  
  }
    
}


