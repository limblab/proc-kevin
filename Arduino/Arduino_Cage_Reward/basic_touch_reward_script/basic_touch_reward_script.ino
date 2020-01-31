// define all of my initial variables
#define solenoidSwitch    13
#define greenLED          2
#define redLED            3
#define proxSensor        4

#define touchTimeMax      750   // maximum amount of time he has to touch the touchpad
#define touchTimeMin      250   // minimum " " " 
#define dispenseTimeMin   250   // minimum amount of time to dispense the water
#define dispenseTimeMax   500   // maximum " " "
#define interTrialTimeMin 1500  // minimum amount of time between trials
#define interTrialTimeMax 30000 // maxmimum " " "
#define flashTime         100   // when the LED is flashing, what is the speed ? (period/2)
/* ------------------------------------
States:
    0: waiting to be touched
    1: being touched
    2: dispensing reward
    3: between tasks - still touching
    4: between tasks - not touching
*/    
int state = 0;
long startTouch = 0; // what it sounds like
long currTouch = 0;

/* Set the timing and reward values for the first run through */
long touchTime = random(touchTimeMin,touchTimeMax);
long dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
long interTrialTime = random(interTrialTimeMin,interTrialTimeMax);


void setup() {
  // put your setup code here, to run once:
pinMode(solenoidSwitch,OUTPUT);
pinMode(greenLED,OUTPUT);
pinMode(redLED,OUTPUT);
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

switch(state) {
  case 0: // if the monkey hasn't been touching the pad
    digitalWrite(redLED,1);
    if(digitalRead(proxSensor)==1){
      startTouch = millis();
      state = 1;
    };
    break;
  case 1: // if the monkey has been touching the pad
    if(digitalRead(proxSensor)==1){ // "is he touching?"
      currTouch = millis() - startTouch; // how long have we been touching?

      Serial.print("StartTouch: ");
      Serial.println(startTouch);
      Serial.print("CurrTouch: ");
      Serial.println(currTouch);
      Serial.print("Current Time: ");
      Serial.println(millis());
      
      if(currTouch>touchTime){ //has he been touching long enough
        state = 2;
      }else{
        int flashVal = currTouch/flashTime;
        if((flashVal%2)==1){
          digitalWrite(redLED,1);
        }else{
          digitalWrite(redLED,0);
        } // end of flashing if statement
      } // end of time comparison
    }else{ // if he isn't touching right now, go back to state 0
      state = 0;
    }// end of "is he touching?" 
    break;

  case 2:
    Serial.println("we're in state 2");
    
    // turn off redLED, turn on green and dispense water
    digitalWrite(redLED,0);
    digitalWrite(greenLED,1);
    digitalWrite(solenoidSwitch,1);

    //wait desired delay time
   delay(dispenseTime);

    //turn stuff back off, switch to state 3
   digitalWrite(greenLED,0);
   digitalWrite(solenoidSwitch,0);
   state = 3;

   /* Set the timing and reward values for the next run through */
   touchTime = random(touchTimeMin,touchTimeMax);
   dispenseTime = random(dispenseTimeMin,dispenseTimeMax);
   interTrialTime = random(interTrialTimeMin,interTrialTimeMax);
   break;
   
  case 3:
    Serial.println("In state 3");
    if(digitalRead(proxSensor)==0){
      state = 4;
      startTouch = millis();
    }
    break;

  case 4:
    Serial.println("State 4");
    if(digitalRead(proxSensor)==1){
      state = 3;
    }else{
      if((millis-startTouch)>interTrialTime){
        state = 0;
        Serial.println("start a new trial");
      }
    }
    break;

  default:
    Serial.println("Something's wrong! You're outside the matrix NEO");
 }



}
