#include <SPI.h>
void setup() {
  SPI.begin(); // Initialize SPI - 4000000 Baud, MODE0 (default)
  Serial.begin(9600);
}

void loop() {
  const int CS_PIN = 10;
  byte firstByte, secondByte;
  int res;
  pinMode(CS_PIN, OUTPUT); // The CS_Pin should remain in a high impedance state (INPUT) when it is not in use.
  digitalWrite(CS_PIN, LOW); // Activate the CS line (CS is active LOW)
  firstByte = SPI.transfer(0x00); // Send dummy data to receive first byte
  secondByte = SPI.transfer(0x00); // Send dummy data to receive second byte
  uint16_t result = firstByte << 8 | secondByte;  // unsigned
  if (result<16383){ // adding offset to the neg value to make it positive int
    res = result - 32768;
    }
   else{
    res = result;
    }
  Serial.println( result ); 
  digitalWrite(CS_PIN, HIGH); // Enable internal pull-up
}
