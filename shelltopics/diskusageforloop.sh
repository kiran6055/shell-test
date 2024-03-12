#!/bin/bash

DISK_USAGE=$(df -h | grep -vE 'tmpfs|Filesystem' | awk '{print $5, $1}')
DISK_THRESHOLD=5
message=""

# Save the current IFS value
original_ifs=$IFS

# Set IFS to newline
IFS=$'\n'


for line in $DISK_USAGE
do
	usage=$(echo $line | cut -d "%" -f1)
	partition=$(echo $line | cut -d " " -f2)
	echo "usage is: $usage"
        echo "partition is: $partition"
	if [ "$usage" -ge "$DISK_THRESHOLD" ] 
	then
		message+="High disk usage on $partition: $usage%\n"
	fi


done

echo -e "message is : $message"

echo -e "$message" | mail -s "HIGH DISK USAGE" kirandevopskumar@gmail.com, kirankumar.nagaraja@gmail.com
