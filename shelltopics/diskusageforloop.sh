#!/bin/bash

DISK_USAGE=$(df -h | grep -vE 'tmpfs|Filesystem' | awk '{print $5, $1}')
DISK_THRESHOLD=20
Message=""

for line in "$DISK_USAGE"
do
	usage=$(echo $line | cut -d "%" -f1)
	partition=$(echo $line | cut -d " " -f2)
	echo "usage is: $usage"
        echo "partition is: $partition"
	if [ $usage -ge $DISK_THRESHOLD ]
	then
		message+="High disk usage on $partition: $usage%/n"
	fi


done

echo "message is $message"
