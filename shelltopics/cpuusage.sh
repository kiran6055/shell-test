#!/bin/bash

CPUUSAGE=$(top -bn1 | awk '/Cpu/ { print int ($2) }')
MAX_CPU_USAGE=50
message=""


	if [ "$CPUUSAGE" -ge "$MAX_CPU_USAGE" ] ;
	then
		message+="HIGH CPU usage has reached the thresholdlimt $MAX_CPU_USAGE: $CPUUSAGE\n"
	else
		message+="cpu usage is under threshold limit $MAX_CPU_USAGE:  $CPUUSAGE"
	fi


echo "message is: $message"
