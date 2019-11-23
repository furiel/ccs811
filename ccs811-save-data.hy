(import time)
(import datetime)
(import serial)
(import argparse)
(import os)

(defn log [s log-dir]
  (setv
    day (.strftime (datetime.datetime.now) "%Y-%m-%d")
    current-time (.strftime (datetime.datetime.now) "%Y-%m-%dT%H:%M:%S")
    output-file (.format (os.path.join log-dir day)))

  (with [f (open output-file "a")]
    (.write f (.format "{} {}" current-time s))))

(defn main []
  (setv parser (argparse.ArgumentParser :description "Read data from serial"))
  (.add-argument parser "--serial"
                 :help "Serial port. For example /dev/ttyACM0"
                 :required True)
  (.add-argument parser "--logs"
                 :help "Directory for the logs"
                 :required True)

  (setv args (.parse_args parser)
        serial-port args.serial
        log-dir args.logs)

  (os.makedirs log-dir :exist-ok True)

  (setv c (.Serial serial "/dev/ttyACM0" 9600))
  (while 1
    (log (.decode (.readline c)) log-dir)))

(main)
