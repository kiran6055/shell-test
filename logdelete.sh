#!/bin/bash

directory=/home/ec2-user/shell-test
DATE=$(date +%F)
LOG_FILE="${DATE}.log"
INPUT=$(find "${directory}"/*.log -type f -mtime +1)


while IFS= read file;
do
	echo "delete the file: $file" &>> $LOG_FILE
	rm -rf "$file"
done <<< "$INPUT"
