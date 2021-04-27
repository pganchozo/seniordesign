/* Perry The Smartwalker */

/* code below is a combination of our vibration motor and LiDAR code
 *  code for LiDAR section was adapted from arduino example. Thread can be found here:  https://forum.arduino.cc/index.php?topic=629752.0
 *  all credit to original creator
 *  
 *  code for vibration motor:
 *  vb motor will vibrate when LiDAR detects fast moving objects, any other vibration
 *  uses may be: low battery, on and off, confirmed bluetooth connection
 *  if lidar measurements become inaccurate try reconfiguring by unplugging from laptop, using large object, unplug and replug
*/


/*what is considered "fast"? According to calculations/testing, the distance should change on average about 7.2 inches every 0.25 seconds
 * when walking with an object about 144 inches away from the starting point, walking at a normal speed 
 * to give way for some error, as in slightly faster walkers, we will round up to about 8 inches every 0.25 seconds
 * with this, we will consider a difference larger than 8 inches to be large and therefore determine a fast moving object
 * change everything from inch to cm!!
*/

#include <SoftwareSerial.h>
#include <Wire.h>
#include "TFMini.h"
TFMini tfmini;

SoftwareSerial SerialTFMini(2, 3); //TX, RX

//digital pin setup, D5
#define VB 5

int new_dist = 0; //var to hold prev distance is initialized
int count = 0; //count to detect fast speed is initialized

void getTFminiData(int* distance, int* strength) {
  static char i = 0;
  char j = 0;
  int checksum = 0;
  static int rx[9];
  if(SerialTFMini.available())
  { 
    // Serial.println( "tfmini serial available" );
    rx[i] = SerialTFMini.read();
    if(rx[0] != 0x59) {
      i = 0;
    } 
    else if(i == 1 && rx[1] != 0x59) 
    {
      i = 0;
    } 
    else if(i == 8) 
    {
      for(j = 0; j < 8; j++) 
      {
        checksum += rx[j];
      }
      if(rx[8] == (checksum % 256)) 
      {
        *distance = rx[2] + rx[3] * 256;
        *strength = rx[4] + rx[5] * 256;
      }
      i = 0;
    } 
    else
    {
      i++;
    }
  } 
}


void setup() { 
  
  //Vibration motor setup
 // Serial.begin(9600); 
        //not sure how this will affect it; I commented this out bc for the LiDAR it has 115200
  pinMode(VB, OUTPUT);  
  digitalWrite(VB, LOW);  //start off by having the vibration be off

  //LiDAR setup
  pinMode(10, OUTPUT);//Used to trigger
  int ledPin = 10;
 
  // Step 1: Initialize hardware serial port (serial debug port)
  Serial.begin(115200);
  // wait for serial port to connect. Needed for native USB port only
  while (!Serial);
     
  Serial.println ("Initializing...");

  // Step 2: Initialize the data rate for the SoftwareSerial port
  SerialTFMini.begin(TFMINI_BAUDRATE);

  // Step 3: Initialize the TF Mini sensor
  tfmini.begin(&SerialTFMini);   
}



void loop()
{
  int distance = 0;
  int strength = 0;

  getTFminiData(&distance,&strength);
  while(!distance) {
    getTFminiData(&distance,&strength);
    if(distance) {
      if(distance > 0 && new_dist != 0){ //after the first positive distance is measured
        if((new_dist - distance)>5) //changed to 5 for testing purposes; larger distance for real life setting would be required
        { 
          count++; 
          Serial.print("count updated for"); //will print right before the distances it references
          Serial.print(new_dist);
          Serial.print("-");
          Serial.println(distance);
          Serial.println("Count: ");
          Serial.println(count);
          if(count == 3)
          { //try to fix so count must be incremented 3 times in a row
            Serial.println("Count: ");
            Serial.println(count);
            Serial.println("Fast"); //fast object detected, vibrate here for x seconds (refer to hardware updates doc)
            Serial.println("Vibration on!");  //testing purposes; shows that vibration is on
            digitalWrite(VB, HIGH);  //"fast" object detected 3 times in a row so turn on vibration!
            delay(3000);  //vibrates for 3 seconds; subject to change
            Serial.println("Vibration off!");
            digitalWrite(VB, LOW);  //turn back off
            count = 0; //reinitialize count to 0
            Serial.println(count); //confirm count has been set to 0, can take this print statement out later
          }
        }
        else  //distance is less than or equal to 20
        {
             count = 0;  //reset counter to 0 to make sure it is 3 times in a row
             Serial.println("Count: ");
             Serial.println(count);
             digitalWrite(VB, LOW);  //should stay off; would be off anyways, but just in case
        }
        //lines below print distance and previous distance
        Serial.print(distance);
        Serial.print("cm\t");
        Serial.print("prev distance: ");
        Serial.println(new_dist);
        new_dist = distance;
      }else if(distance > 0 && new_dist == 0) //runs in very beginning when distance is found but there is no prev distance
        new_dist = distance;
    }
  }
digitalWrite(VB, LOW);  //again, should be off, but just in case, off is default
delay(100); //changed from 100ms to half a second, can change as see fit
}
