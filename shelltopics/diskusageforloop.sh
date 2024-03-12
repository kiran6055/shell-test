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
	echo "usage is: $usage" &>> file.log
        echo "partition is: $partition" &>> file.log
	if [ $usage -ge $DISK_THRESHOLD ] 
	then
		message+="High disk usage on $partition: $usage%\n"
	fi


done

echo -e "message is : \n$message"

#echo -e "$message" | mail -s "high_disk_usage" kirandevopskumar@gmail.com, kirankumar.nagaraja@gmail.com 
#here we are using andother shfile mail.sh to run here
#
sh mail.sh "kirandevopskumar@gmail.com, kirankumar.nagaraja@gmail.com" "HIGH DISK_USAGE" "\n$message" "DEVOPS TEAM"
