// MyOvershoot.pde
// -*- mode: C++ -*-
// test new rig, try to remember this stuff
// API:  - sending commands via pyserial - letter, then ascii longint
//
// MS1 	    MS2 	MS3 	Microstep Resolution
// Low 	    Low 	Low 	Full step
// High     Low 	Low 	Half step
// Low 	    High 	Low 	Quarter step
// High     High 	Low 	Eighth step
// High     High 	High 	Sixteenth step
//
// EN set LOW == running 
// EN set HIGH == disabled
// MS2 (of MS1,2,3) is currently the only step-size setter, and for
// both drivers at the same time, so HIGH == quarter-step, LOW == full

#include <AccelStepper.h>
#include <Servo.h> 

// Define 2 steppers and other pins as run through pololu A4988 breakouts
byte DIR1 = 9;
byte STEP1 = 8;
byte DIR2 = 12;
byte STEP2 = 7;
byte MS2 = 6;            // it is either 1/4 or 'full' this way
byte EN = 4;
byte SERV1 = 11;           // 'because he used those special parts to make his robot friends...'
byte CROW = 10;
byte ONRESERVE = 32;      // max byte length of serial-delivered string
boolean DEBUG = true;

byte PROX_PIN = A3;         // unused for now
byte SensorPins[] = {3,5};  // sensor pins unused for now
byte senseHolder = 0;       // global holder of sensor pin states

long int use_dest = 500;        // 'use_..' - a user-changable value
int use_accel = 4000;
int use_speed = 1000;
int use_servpos = 0;                       // target servo position
long int builtnum = 0;                     // number built from bytes in command string (sent via serial)
unsigned long int sleep_ctr = 0;           // go to sleep if sitting around for a while
unsigned long int SLEEPDELAY = 96000000;   // how many mhz per loop?
byte ctrbit = 1;                           // zero or 1 for incrementing sleep_ctr
char command = 0;                          // single char parsed out of command string (sent via serial)
String inputString = "";    

// some internal boolean control switches
boolean stringComplete = false;
boolean STEP1MOVING = false;
boolean STEP2MOVING = false;
boolean ENSTARTED = LOW;

AccelStepper stepper(1, STEP1, DIR1);      // '1' indicates use of driver board instead of direct wired stepper
AccelStepper step2(1, STEP2, DIR2);
Servo myserv;
Servo myserv2;

void setup()
{ 
  pinMode(MS2, OUTPUT);
  pinMode(DIR1, OUTPUT);
  pinMode(DIR2, OUTPUT);
  pinMode(EN, OUTPUT);
  pinMode(STEP1, OUTPUT);
  pinMode(STEP2, OUTPUT);
  digitalWrite(DIR1, LOW);              // clockwise or counter-clockwise
  digitalWrite(DIR2, LOW);
  digitalWrite(EN, LOW);                // LOW == both running, HIGH == both disabled
  digitalWrite(MS2, HIGH);              // MS2 HIGH == quarter-steps                     
  stepper.setMaxSpeed(use_speed);
  stepper.setAcceleration(use_accel);
  stepper.moveTo(use_dest);
  step2.setMaxSpeed(use_speed);
  step2.setAcceleration(use_accel);
  step2.moveTo(use_dest);
  
  Serial.begin(115200);                // initialize serial & input holder:
  inputString.reserve(ONRESERVE);      // a few bytes extra too

  myserv.attach(SERV1);                // set up servo
  Serial.println("** I'm Alive **");
}

void loop()
{    
  stepper.run();
  step2.run();
  if ((STEP1MOVING) && (!stepper.distanceToGo())) {    // means just now came to stop
    Serial.println("ST1FIN");
    STEP1MOVING = false;
  }
  if ((STEP2MOVING) && (!step2.distanceToGo())) {      // means just now came to stop
    Serial.println("ST2FIN");
    STEP2MOVING = false;
  }
  if (stringComplete) {                      // A-TEN-hut!
    ENSTARTED = digitalRead(EN);
    digitalWrite(EN, LOW);
    sleep_ctr = 0;
    parseCommand(inputString);               // sets globals 'command' & 'builtnum'
    if (command != 0) {
      act(command, builtnum);                // act does all actions
      }
    inputString = "";                        // clear the input string:
    stringComplete = false;
    sleep_ctr = 0;
    ctrbit = 1;
  }
  else {
    sleep_ctr += ctrbit;
    if ((sleep_ctr > SLEEPDELAY) and (digitalRead(EN) == LOW)) {    // a long time since last command
      digitalWrite(EN, HIGH);                                       // disable driver boards
      ctrbit = 0;                                                   // stop counting (to avoid rollover)
      if (DEBUG) {Serial.println("Stepper Sleeps");}
      }
    }  
}
/*
  SerialEvent occurs whenever new data comes in to arduino via
 hardware serial RX.  Multiple bytes of data may be available.
 */
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
}
/* 
strictly for dealing with command strings like: 'char'+'int in ascii'
*/
void parseCommand(String inputString) {
  command = inputString[0];
  builtnum = inputString.substring(1).toInt();
  // builtnum = sub.toInt();
}

/* Big Switch Statement */
void act(char ch, int num) {
  switch (ch) {
    case 'a':        // all sensor data printed
      printsense();
      break;
    case 'b':        // stepper top speed
      stepper.setMaxSpeed(num);
      Serial.print("ST1SPD:");Serial.println(num);
      break;
    case 'c':        // stepper accel
      stepper.setAcceleration(num);
      Serial.print("ST1ACC:");Serial.println(num);
      break;
    case 'd':        // destination
      stepper.moveTo(num);
      STEP1MOVING = true;
      Serial.print("ST1DST:");Serial.println(num); 
      break;
    case 'e':        // zero at current pos, also stop dead?
      stepper.setCurrentPosition(0);
      Serial.print("ST1AT0:");Serial.println(stepper.currentPosition());
      break;   

    case 'm':        // toggle microstep2 
      digitalWrite(MS2, !digitalRead(MS2));
      Serial.print("MS2SET:");Serial.println(digitalRead(MS2)); 
      break;
    case 'z':
      digitalWrite(EN, !ENSTARTED);
      Serial.print("ZZZ:");Serial.println(digitalRead(EN));
      break;
 
    case 's':        // step2 top speed
      step2.setMaxSpeed(num);
      Serial.print("ST2SPD:");Serial.println(num);
      break;
    case 't':        // step2 accel
      step2.setAcceleration(num);
      Serial.print("ST2ACC:");Serial.println(num);
      break;
    case 'u':        // step2 destination
      step2.moveTo(num);
      STEP2MOVING = true;
      Serial.print("ST2DST:");Serial.println(num); 
      break;
    case 'v':        // zero at current pos, also stops
      step2.setCurrentPosition(0);
      Serial.print("ST2AT0:");Serial.println(stepper.currentPosition());
      break;
    case 'n':        // TOM SERVO angle
      myserv.write(num);
      Serial.print("SERANG:");Serial.println(myserv.read());
      break; 
    default:
      Serial.print("NOCMD:");Serial.println(ch);Serial.print("NONUM:");Serial.println(num);
      break;
      // do some default action
  }
}

/* print sensor data and other changeable vars */
void printsense() {
  Serial.println("a=show this");
  Serial.print("A3=");Serial.println(analogRead(A3));
  Serial.print("s1c=");Serial.println(stepper.currentPosition());
  Serial.print("s2c=");Serial.println(step2.currentPosition()); 
  Serial.print("b=spd1=");Serial.println(stepper.speed());
  Serial.println("c=acc1");
  Serial.print("d=set1=");Serial.println(stepper.targetPosition());
  Serial.print("e=zer1 d-g=");Serial.println(stepper.distanceToGo());
  Serial.print("m=ms2=");Serial.println(digitalRead(MS2));
  Serial.print("z=sleep=");Serial.println(digitalRead(EN));
  Serial.print("s=spd2=");Serial.println(step2.speed());
  Serial.println("t=acc2");
  Serial.print("u=set2=");Serial.println(step2.targetPosition());
  Serial.print("v=zer2 d-g=");Serial.println(step2.distanceToGo());
  Serial.print("n=serv1=");Serial.println(myserv.read());
}

/* array of interesting pins in one byte */
void DigitalCheck(){
  senseHolder = 0; // global
  for (int i = 0; i < 8; i++) {
    if (digitalRead(SensorPins[i]) == HIGH) {
       bitSet(senseHolder,i);
     //  Serial.print("senseHolder = ");
     //  Serial.println(senseHolder,BIN);
     }    
  }
}
