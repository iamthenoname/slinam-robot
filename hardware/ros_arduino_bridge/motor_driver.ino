/***************************************************************
   Motor driver definitions
   
   Add a "#elif defined" block to this file to include support
   for a particular motor driver.  Then add the appropriate
   #define near the top of the main ROSArduinoBridge.ino file.
   
   *************************************************************/

#ifdef USE_BASE
   
#ifdef POLOLU_VNH5019
  /* Include the Pololu library */
  #include "DualVNH5019MotorShield.h"

  /* Create the motor driver object */
  DualVNH5019MotorShield drive;
  
  /* Wrap the motor driver initialization */
  void initMotorController() {
    drive.init();
  }

  /* Wrap the drive motor set speed function */
  void setMotorSpeed(int i, int spd) {
    if (i == LEFT) drive.setM1Speed(spd);
    else drive.setM2Speed(spd);
  }

  // A convenience function for setting both motor speeds
  void setMotorSpeeds(int leftSpeed, int rightSpeed) {
    setMotorSpeed(LEFT, leftSpeed);
    setMotorSpeed(RIGHT, rightSpeed);
  }
#elif defined POLOLU_MC33926
  /* Include the Pololu library */
  #include "DualMC33926MotorShield.h"

  /* Create the motor driver object */
  DualMC33926MotorShield drive;
  
  /* Wrap the motor driver initialization */
  void initMotorController() {
    drive.init();
  }

  /* Wrap the drive motor set speed function */
  void setMotorSpeed(int i, int spd) {
    if (i == LEFT) drive.setM1Speed(spd);
    else drive.setM2Speed(spd);
  }

  // A convenience function for setting both motor speeds
  void setMotorSpeeds(int leftSpeed, int rightSpeed) {
    setMotorSpeed(LEFT, leftSpeed);
    setMotorSpeed(RIGHT, rightSpeed);
  }
#elif defined(L298_MOTOR_DRIVER)
  void initMotorController() {
    // digitalWrite(RIGHT_MOTOR_ENABLE, HIGH);
    // digitalWrite(LEFT_MOTOR_ENABLE, HIGH);
    pinMode(MOTOR_A_PINA, OUTPUT);
    pinMode(MOTOR_A_PINB, OUTPUT);

    pinMode(MOTOR_B_PINA, OUTPUT);
    pinMode(MOTOR_B_PINB, OUTPUT);
  }
  
  void setMotorSpeed(int i, int spd) {
    if (i == LEFT) {
      analogWrite(MOTOR_A_PWM, spd);
      if (spd < 0) {
        digitalWrite(MOTOR_A_PINA, LOW);
        digitalWrite(MOTOR_A_PINB, HIGH);
        // ANTI-CLOCKWISE - (positive angles are anti-clockwise)
      } else if (spd > 0) {
        digitalWrite(MOTOR_A_PINA, HIGH);
        digitalWrite(MOTOR_A_PINB, LOW);
      } else { // 0 speed
        digitalWrite(MOTOR_A_PINA, LOW);
        digitalWrite(MOTOR_A_PINB, LOW);
      }
    } else if (i == RIGHT) {
      analogWrite(MOTOR_B_PWM, spd);
      if (spd < 0) {
        digitalWrite(MOTOR_B_PINA, HIGH);
        digitalWrite(MOTOR_B_PINB, LOW);
        // ANTI-CLOCKWISE - (positive angles are anti-clockwise)
      } else if (spd > 0) {
        digitalWrite(MOTOR_B_PINA, LOW);
        digitalWrite(MOTOR_B_PINB, HIGH);
      } else { // 0 speed
        digitalWrite(MOTOR_B_PINA, LOW);
        digitalWrite(MOTOR_B_PINB, LOW);
      }
    } else {
      Serial.println("what the fuck is happening");
    }

    unsigned char reverse = 0;
  
    if (spd < 0)
    {
      spd = -spd;
      reverse = 1;
    }
    if (spd > 255)
      spd = 255;
    
    // if (i == LEFT) { 
    //   if      (reverse == 0) { analogWrite(LEFT_MOTOR_FORWARD, spd); analogWrite(LEFT_MOTOR_BACKWARD, 0); }
    //   else if (reverse == 1) { analogWrite(LEFT_MOTOR_BACKWARD, spd); analogWrite(LEFT_MOTOR_FORWARD, 0); }
    // }
    // else /*if (i == RIGHT) //no need for condition*/ {
    //   if      (reverse == 0) { analogWrite(RIGHT_MOTOR_FORWARD, spd); analogWrite(RIGHT_MOTOR_BACKWARD, 0); }
    //   else if (reverse == 1) { analogWrite(RIGHT_MOTOR_BACKWARD, spd); analogWrite(RIGHT_MOTOR_FORWARD, 0); }
    // }

    #ifdef ARDUINO_ENC_COUNTER
      if (i == LEFT) {
        if (spd == 0) left_dir = STOPPED;
        else if (reverse == 0) left_dir = FORWARD;
        else left_dir = BACKWARD;
      } else {
        if (spd == 0) right_dir = STOPPED;
        else if (reverse == 0) right_dir = FORWARD;
        else right_dir = BACKWARD;
      }
    #endif
  }
  
  void setMotorSpeeds(int leftSpeed, int rightSpeed) {
    setMotorSpeed(LEFT, leftSpeed);
    setMotorSpeed(RIGHT, rightSpeed);
  }
#else
  #error A motor driver must be selected!
#endif

#endif
