#!/bin/bash
Mem_Usage=$(free -m | awk '/Mem/{ print int($3)}')
Memory_Threshold=100
message=""

if [ "$Mem_Usage" -ge "$Memory_Threshold" ] ;
then
	message+="the memeory usage is more increasing the Thresholdlimit $Memory_Threshold: memory usage $Mem_Usage"
else
	message+="memory usage is under thresholdlimit the threshold $Memory_Threshold: memory usage $Mem_Usage"
       	
fi

echo "message is: $message"

sh mail.sh "kirandevopskumar@gmail.com, kirankumar.nagaraja@gmail.com" "HIGH MEMORY_USAGE" "\n$message" "DEVOPS TEAM"

