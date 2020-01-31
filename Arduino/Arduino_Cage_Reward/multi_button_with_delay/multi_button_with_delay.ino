#include <math.h>


// pin locations
#define solenoidSwitch          13
#define buttonOne               2
#define signalOne               3
#define buttonTwo               4
#define signalTwo               5
#define buttonThree             6
#define signalThree             7


// timing values
#define touchTimeMax      250  // maximum amount of time he has to touch the buttons
#define touchTimeMin      100   // minimum " " " 
#define dispenseTimeMin   250   // minimum amount of time to dispense the water
#define dispenseTimeMax   500   // maximum " " "
#define interTrialTimeMin 1500  // minimum amount of time between trials
#define interTrialTimeMax 3000 // maximimum " " "
#define waitDispense      500 // wait half a second before dispensing the reward - gives time to get to the sipper tu

/* ------------------------------------
States:
    0: waiting to be touched
    1: being touched
    2: ready to dispense reward
    3: dispensing reward
    4: between tasks
*/    
#define stateReady            0
#define stateTouch            1
#define stateReadyDispense    2
#define stateDispense         3
#define stateBetweenTasks     4


int state = 0;
long startStateTime = 0; // what it sounds like
long currStateTime = 0;

/* Set the timing and reward values for the first run through */
long touchTime = 0;
long dispenseTime = 0;
long interTrialTime = 0;
int button = 0;


void setup() {
  // put your setup code here, to run once:
pinMode(buttonOne,OUTPUT);
pinMode(buttonTwo,OUTPUT);
pinMode(buttonThree,OUTPUT);
pinMode(solenoidSwitch,OUTPUT);

pinMode(signalOne,INPUT);
pinMode(signalTwo,INPUT);
pinMode(signalThree,INPUT);

Serial.begin(9600);
Serial.println("Setup Complete");


randomSeed(analogRead(8)); // seeding with an unconnected analog value 
touchTime = random(touchTimeMin,touchTimeMax);
dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
button = (int)random(1,4);

}

void loop() {
  // put your main code here, to run repeatedly:

/*
Serial.print("state:");
Serial.write(state);
Serial.println();
Serial.println("-");
Serial.print("Prox Sensor:");
Serial.print(digitalRead(proxSensor));
Serial.println();
Serial.println("------------------------");*/

// set the appropriate LED and button input pins

int transOn = 0; // initialize transducer and signal values
int sensor = 0;
switch (button)
{
  case 1: //button 1
    transOn = buttonOne;
    sensor = signalOne;
    break;
//  case 2:
//    transOn = buttonTwo;
//    sensor = signalTwo;
//    break;
  case 3:
    transOn = buttonThree;
    sensor = signalThree;
    break;
  default:
    transOn = buttonOne;
    sensor = signalOne;
    break;
}  



Serial.println(button);

switch(state) {
  case stateReady : // button is ready to be touched
    digitalWrite(transOn,1);
    if(digitalRead(sensor)==1){
      startStateTime = millis();
      state = stateTouch;
    };
    break;
  case stateTouch : // if the monkey has been touching the button
    if(digitalRead(sensor)==1){ // "is he touching?"
      currStateTime = millis() - startStateTime; // how long have we been touching?

      if(currStateTime>touchTime){ //has he been touching long enough
        state = stateReadyDispense;
      }
    }else{ // if he isn't touching right now, go back to state 0
      state = stateReady;
    }// end of "is he touching?" 
    break;

  case stateReadyDispense : // ready for him to touch the reward proximity sensor

    digitalWrite(transOn,0);  // turn off the task transducer
    delay(waitDispense);
    state = stateDispense;
    
    break;

  case stateDispense:
    digitalWrite(solenoidSwitch,1); // turn on the solenoid

    
  //wait desired delay time
   Serial.println("Dispensing...");
   delay(dispenseTime);
  
   digitalWrite(solenoidSwitch,0);
  
   /* Set the timing and reward values for the next run through */
   touchTime = random(touchTimeMin,touchTimeMax);
   dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
   interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
   button = (int)random(1,4);
   Serial.print("Transducer: Button ");
   Serial.println(button);
   
    Serial.println("Waiting between trials");
    delay(interTrialTime);
    state = stateReady;
    break;

  default:
    Serial.println("Something's wrong! You're outside the matrix NEO");
    state = stateReady;
    break;
 }



}
