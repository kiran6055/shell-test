#!/bin/bash

DISK_USAGE=$(df -h | grep -vE 'tmpfs|Filesystem' | awk '{print $5 " " $1}')
DISK_THRESHOLD=25
message=""

while IFS= read line;
do
	usage=$(echo $line | cut -d "%" -f1)
	partion=$(echo $line | cut -d " " -f2)
	echo "usage is: $usage"
	echo "partion is: $partion"
	if [ $usage  -ge $DISK_THRESHOLD ]
	then
		message+="HIGH diskusage on $partion: $usage%/n"
	fi



done <<< "$DISK_USAGE"

echo "message is: $message"
