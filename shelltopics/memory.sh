#!/bin/bash
Mem_Usage=$(free -m | awk '/Mem/{ print int($3)}')
Memory_Threshold=1500
message=""

if [ "$Mem_Usage" -ge "$Memory_Threshold" ] ;
then
	message+="the memeory usage is more increasing the Thresholdlimit $Memory_Threshold: memory usage $Mem_Usage"
else
	message+="memory usage is under thresholdlimit the threshold $Memory_Threshold: memory usage $Mem_Usage"
       	
fi

echo "message is: $message"
