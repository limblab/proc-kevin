#include <math.h>


// pin locations
#define solenoidSwitch          13
#define lightOne                2
#define signalOne               3
#define lightTwo                4
#define signalTwo               5
#define lightReward             6
#define signalReward            7


// timing values
#define touchTimeMax      500   // maximum amount of time he has to touch the buttons
#define touchTimeMin      200   // minimum " " " 
#define dispenseTimeMin   100   // minimum amount of time to dispense the water
#define dispenseTimeMax   250   // maximum " " "
#define interTrialTimeMin 1500  // minimum amount of time between trials
#define interTrialTimeMax 3000  // maximimum " " "


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


int state = stateReady;
long startStateTime = 0; // what it sounds like
long currStateTime = 0;

/* Set the timing and reward values for the first run through */
long touchTime = touchTimeMin;
long dispenseTime = dispenseTimeMin;
long interTrialTime = interTrialTimeMin;
int button = 1;
int numRewards = 0;


void setup() {
  // put your setup code here, to run once:
pinMode(lightOne,OUTPUT);
pinMode(lightTwo,OUTPUT);
pinMode(lightReward,OUTPUT);
pinMode(solenoidSwitch,OUTPUT);

pinMode(signalOne,INPUT);
pinMode(signalTwo,INPUT);
pinMode(signalReward,INPUT);

Serial.begin(9600);
Serial.println("Setup Complete");


randomSeed(millis()); // seeding with an unconnected analog value 

}

void loop() {
  // put your main code here, to run repeatedly:

//Serial.println(button);

switch(state) {
  case stateReady : // button is ready to be touched
    
    buttonLightOnOff(button,1); // turn the light on
    
    if(buttonPressed(button)){ // are they touching?
      state = stateTouch;
      startStateTime = millis();
    }else{
      state = stateReady;
    }
    break;

  case stateTouch : // if the monkey has been touching the button
    if(buttonPressed(button)){ // "are they still touching?"
      currStateTime = millis() - startStateTime; // how long have we been touching?

      if(currStateTime>touchTime){ //has he been touching long enough
        state = stateReadyDispense;
      }
    }else{ // if he isn't touching right now, go back to waiting
      state = stateReady;
    }// end of "is he touching?" 
    break;

  case stateReadyDispense : // ready for him to touch the reward proximity sensor

    buttonLightOnOff(button,0);  // turn off the task transducer
    digitalWrite(lightReward,1); // turn on the button for the reward
    state = stateDispense;
    break;

  case stateDispense:
    if(digitalRead(signalReward)){
      numRewards++;
      Serial.println("Dispensing...");
      delay(dispenseTime);
      digitalWrite(lightReward,0);
    
      /* Set the timing and reward values for the next run through */
      touchTime = random(touchTimeMin,touchTimeMax);
      dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
      interTrialTime = random(interTrialTimeMin,floor(numRewards/20)*interTrialTimeMax);
      if(numRewards>30){ // switch over to two button option if we've gotten more than 30 rewards
        button = (int)random(1,4);
      }else{
        button = (int)random(1,3);
      }

      

      Serial.print("Number of rewards: ");
      Serial.println(numRewards); 
      Serial.print("Transducer: Button ");
      Serial.println(button);
     
      Serial.print("Waiting between trials: ");
      Serial.println(interTrialTime);
      delay(interTrialTime);
      state = stateReady;
    }
    break;

  default:
    Serial.println("Something's wrong! You're outside the matrix NEO");
    state = stateReady;
    break;
 }



}


// -----------------------------------------------------------------------------------
void buttonLightOnOff(int buttonNumber,int onOff){
  // turn on or off the desired button and light
  switch(buttonNumber){
      
      case 1: // button 1
        digitalWrite(lightOne,onOff);
      break;
        
      case 2: // button 1
        digitalWrite(lightTwo,onOff);
      break;
        
      case 3: // button 1
        digitalWrite(lightOne,onOff);
        digitalWrite(lightTwo,onOff);
      break;
    }
}



// -----------------------------------------------------------------------------------
int buttonPressed(int buttonNumber){

// if the desired button is pressed, return a 1. Otherwise return a zero
    int pressed = 0;

    switch(buttonNumber){
      
      case 1: // button 1
        if(digitalRead(signalOne)){
          pressed = 1;
        }else{
          pressed = 0;
        }
        break;
        
      case 2: //button 2
        if(digitalRead(signalTwo)){
          pressed = 1;
        }else{
          pressed = 0;
        }
        break;
        
      case 3: //both buttons
        if(digitalRead(signalOne) & digitalRead(signalTwo)){
          pressed = 1;
        }else{
          pressed = 0;
        }
        break;
    }

    return(pressed);
}
