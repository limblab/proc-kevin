#include <math.h>


// pin locations
#define solenoidSwitch          13
#define greenRewardLED          2
#define redRewardLED            3
#define buttonOneLED            4
#define buttonTwoLED            5
#define proxSensor              6
#define buttonOneSensor         7
#define buttonTwoSensor         8

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
long startTouch = 0; // what it sounds like
long currTouch = 0;

/* Set the timing and reward values for the first run through */
long touchTime = random(touchTimeMin,touchTimeMax);
long dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
long interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
long button = floor(random(1,2.1));


void setup() {
  // put your setup code here, to run once:
pinMode(solenoidSwitch,OUTPUT);
pinMode(greenRewardLED,OUTPUT);
pinMode(redRewardLED,OUTPUT);
pinMode(buttonOneLED,OUTPUT);
pinMode(buttonTwoLED,OUTPUT);

pinMode(buttonOneSensor,INPUT);
pinMode(buttonTwoSensor,INPUT);
pinMode(proxSensor,INPUT);

Serial.begin(9600);

randomSeed(analogRead(0)); // seeding with an unconnected analog value



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
int buttonSensor = 1;
int buttonLED = 1;

if(button==1){
  buttonSensor = buttonOneSensor;
  buttonLED = buttonOneLED;
}else if(button==2){
  buttonSensor = buttonTwoSensor;
  buttonLED = buttonTwoLED;
}

switch(state) {
  case stateReady : // button is ready to be touched
    digitalWrite(buttonLED,1);
    if(digitalRead(buttonSensor)==0){
      startTouch = millis();
      state = stateTouch;
    };
    break;
  case stateTouch : // if the monkey has been touching the button
    if(digitalRead(buttonSensor)==0){ // "is he touching?"
      currTouch = millis() - startTouch; // how long have we been touching?

      Serial.print("StartTouch: ");
      Serial.println(startTouch);
      Serial.print("CurrTouch: ");
      Serial.println(currTouch);
      Serial.print("Current Time: ");
      Serial.println(millis());
      
      if(currTouch>touchTime){ //has he been touching long enough
        state = stateReadyDispense;
      }
    }else{ // if he isn't touching right now, go back to state 0
      state = stateReady;
    }// end of "is he touching?" 
    break;

  case stateReadyDispense :
    Serial.println("we're in state 2");
    
    // turn off redLED, turn on green and dispense water
    digitalWrite(redRewardLED,1);
    digitalWrite(buttonLED,0);

    if(digitalRead(proxSensor)==1){
      delay(rewardTouch); // gives him time to get his mouth in front of the tube
      state = stateDispense; // try it requiring him to touch the whole time, because I don't wanna mess with another state right now.
    }
    break;

  case stateDispense:
    Serial.println("we're in state 3");
    digitalWrite(redRewardLED,0);
    digitalWrite(greenRewardLED,1);
    digitalWrite(solenoidSwitch,1);

    
    //wait desired delay time
   delay(dispenseTime);

    //turn stuff back off, switch to state 3
   digitalWrite(greenRewardLED,0);
   digitalWrite(solenoidSwitch,0);
   state = stateBetweenTasks;

   /* Set the timing and reward values for the next run through */
   touchTime = random(touchTimeMin,touchTimeMax);
   dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
   interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
   button = floor(random(1,2.1));
   break;
   
  case stateBetweenTasks: // since we only have the switches on when the LEDs are on, we won't be able to see if he's pressing the buttons when the LEDs are off.
    Serial.println("In state 4");
    delay(interTrialTime);
    state = 0;
    break;

  default:
    Serial.println("Something's wrong! You're outside the matrix NEO");
    state = 0;
    break;
 }



}
