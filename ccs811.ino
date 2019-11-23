/* -*- mode: c -*- */
#include "Adafruit_CCS811.h"

#define unsigned int boolean
#define TRUE 1
#define FALSE 0

Adafruit_CCS811 ccs;

void
setup() {
  Serial.begin(9600);

  while (!ccs.begin())
    {
      Serial.println("Failed to start sensor! Please check your wiring.");
      delay(1000);
    }

  while(!ccs.available())
    {
      Serial.println("Waiting for sensor to be available");
      delay(1000);
    }
}

static boolean
wait_for_data()
{
  if (ccs.available())
    return TRUE;

  delay(1000);
  if (ccs.available())
    return TRUE;

  Serial.println("CCS unavailable");
  return FALSE;
};

void
loop() {
  if (!wait_for_data())
    {
      delay(1000);
      return;
    }

  if(!ccs.readData())
    {
      static char result[100];
      snprintf(result, sizeof(result), "{\"CO2\" : %hu, \"TVOC\" : %hu}", ccs.geteCO2(), ccs.getTVOC());
      Serial.println(result);
    }
  else
    {
      Serial.println("Error while reading data");
    }

  delay(1000);
}
