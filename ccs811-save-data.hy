(import time)
(import datetime)
(import serial)
(import argparse)
(import os)
(import json)
(import ThingSpeak)
(import traceback)

(defn log [s log-dir]
  (setv
    day (.strftime (datetime.datetime.now) "%Y-%m-%d")
    current-time (.strftime (datetime.datetime.now) "%Y-%m-%dT%H:%M:%S")
    output-file (.format (os.path.join log-dir day)))

  (with [f (open output-file "a")]
    (.write f (.format "{} {}" current-time s))))

(defn process [line api-key]
  (try
    (setv data (json.loads line)
          thing-speak (ThingSpeak.ThingSpeak api-key))
    (.connect thing-speak)
    (.send-data thing-speak (.get data "CO2"))
    (.disconnect thing-speak)
    (except [e Exception]
      (traceback.print_exc))))

(defn main []
  (setv parser (argparse.ArgumentParser :description "Read data from serial"))
  (.add-argument parser "--serial"
                 :help "Serial port. For example /dev/ttyACM0"
                 :required True)
  (.add-argument parser "--logs"
                 :help "Directory for the logs"
                 :required True)
  (.add-argument parser "--api-key"
                 :help "thing speak api key"
                 :required False)

  (setv args (.parse_args parser)
        serial-port args.serial
        log-dir args.logs
        api-key args.api-key)

  (os.makedirs log-dir :exist-ok True)

  (setv c (.Serial serial "/dev/ttyACM0" 9600))
  (while 1
    (setv line (.decode (.readline c)))
    (process line api-key)
    (log line log-dir)))

(main)
