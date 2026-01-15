#!/bin/bash

for i in 3 2 1; 
do
	notify-send "SlimeVR" "Yaw reset in ${i}"
sleep 1;
done
echo '{"type":"action","name":"calibrate"}' | websocat ws://127.0.0.1:21110

