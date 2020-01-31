#include <Dhcp.h>
#include <Dns.h>
#include <Ethernet.h>
#include <EthernetClient.h>
#include <EthernetServer.h>
#include <EthernetUdp.h>

#include <math.h>


// pin locations
#define solenoidSwitch          13
#define rewardProxOn            2
#define rewardProxSignal        3
#define buttonOn                4
#define buttonSignal            5
#define proxOn                  6
#define proxSignal              7


// timing values
#define touchTimeMax      250  // maximum amount of time he has to touch the buttons
#define touchTimeMin      100   // minimum " " " 
#define rewardTouch       100   // touches the touchpad for a quarter second before getting the reward
#define dispenseTimeMin   250   // minimum amount of time to dispense the water
#define dispenseTimeMax   500   // maximum " " "
#define interTrialTimeMin 1500  // minimum amount of time between trials
#define interTrialTimeMax 3000 // maximimum " " "

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
long touchTime = random(touchTimeMin,touchTimeMax);
long dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
long interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
int button = (int)random(1,3);


void setup() {
  // put your setup code here, to run once:
pinMode(rewardProxOn,OUTPUT);
pinMode(buttonOn,OUTPUT);
pinMode(proxOn,OUTPUT);
pinMode(solenoidSwitch,OUTPUT);

pinMode(rewardProxSignal,INPUT);
pinMode(buttonSignal,INPUT);
pinMode(proxSignal,INPUT);

Serial.begin(9600);
Serial.println("Setup Complete");

randomSeed(micros()); // seeding with an unconnected analog value



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
int transOn = buttonOn;
int sensor = buttonSignal;


if(button==1){
  transOn = buttonOn;
  sensor = buttonSignal;
}else if(button==2){
  transOn = proxOn;
  sensor = proxSignal;
}

//Serial.println(button);

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

    digitalWrite(rewardProxOn,1); //Turn on the reward pad
    digitalWrite(transOn,0);  // turn off the task transducer

    if(digitalRead(rewardProxSignal)==1){
      currStateTime = millis()-startStateTime;
      if(currStateTime>touchTime){
        state = stateDispense; // try it requiring him to touch the whole time, because I don't wanna mess with another state right now.
      }
    }else{
        startStateTime = millis();
        state = stateReadyDispense;
      }
    break;

  case stateDispense:
    digitalWrite(rewardProxOn,0); // turn off the reward touch pad
    digitalWrite(solenoidSwitch,1); // turn on the solenoid

    
    //wait desired delay time
   Serial.println("Dispensing...");
   delay(dispenseTime);
  
   digitalWrite(solenoidSwitch,0);

   /* Set the timing and reward values for the next run through */
   touchTime = random(touchTimeMin,touchTimeMax);
   dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
   interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
   button = (int)random(1,3);
   Serial.print("Transducer: ");
   if(button==1){
    Serial.println("Button");
   }else if(button==2){
    Serial.println("Proximity Sensor");
   }
   
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
