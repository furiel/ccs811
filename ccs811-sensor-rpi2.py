#this example reads and prints CO2 equiv. measurement, TVOC measurement, and temp every 2 seconds

from time import sleep
from Adafruit_CCS811 import Adafruit_CCS811
import datetime

ccs =  Adafruit_CCS811()

while not ccs.available():
    pass

def log(s):
    day = datetime.datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    with open("/var/log/ccs811/{}.dat".format(day), "a") as f:
        f.write("{} {}\n".format(current_time, s))

def measure():
    try:
        if ccs.available():
            if not ccs.readData():
                result = {"CO2" : ccs.geteCO2(), "TVOC" : ccs.getTVOC()}
                log(str(result))
            else:
                log("Unknown error")
    except Exception as e:
        log(e)

while(1):
    measure()
    sleep(2)
