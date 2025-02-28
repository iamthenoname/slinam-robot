/***************************************************************
   Motor driver function definitions - by James Nugen
   *************************************************************/

#ifdef L298_MOTOR_DRIVER
  #define MOTOR_A_PWM 9
  #define MOTOR_A_PINA 4
  #define MOTOR_A_PINB 5

  #define MOTOR_B_PWM 10
  #define MOTOR_B_PINA 6
  #define MOTOR_B_PINB 7

  // #define RIGHT_MOTOR_BACKWARD 7
  // #define LEFT_MOTOR_BACKWARD  5
  // #define RIGHT_MOTOR_FORWARD  6
  // #define LEFT_MOTOR_FORWARD   4
  // #define RIGHT_MOTOR_ENABLE 10
  // #define LEFT_MOTOR_ENABLE 9
#endif

void initMotorController();
void setMotorSpeed(int i, int spd);
void setMotorSpeeds(int leftSpeed, int rightSpeed);
