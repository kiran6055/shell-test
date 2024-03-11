#!/bin/bash

directory=/home/ec2-user/shell-test
DATE=$(date +%F)
LOG_FILE="$DATE.log"

INPUT=$(find "${directory}"/*.log -type f -mtime +15)


for FILE in $INPUT 
do

		echo "deleting log files which are older than 15 days: $FILE" &>> "$LOG_FILE"
		rm -f $FILE
	
done

