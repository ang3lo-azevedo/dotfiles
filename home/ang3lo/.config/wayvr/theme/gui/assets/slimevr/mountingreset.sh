#!/bin/bash

for i in 5 4 3 2 1; 
do
	notify-send "SlimeVR" "Mounting reset in ${i}"
sleep 1;
done
echo '{"type":"action","name":"mounting_calibrate"}' | websocat ws://127.0.0.1:21110

