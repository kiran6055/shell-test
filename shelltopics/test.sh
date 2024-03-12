#!/bin/bash

DISK_USAGE=$(df -h | grep -vE 'tmpfs|Filesystem' | awk '{print int($5), $1}')
DISK_THRESHOLD=5
message=""
# Save the current IFS value
original_ifs=$IFS

# Set IFS to newline
IFS=$'\n'

for line in $DISK_USAGE
do
        usage=$(echo $line | awk '{print int($1)}')
        partition=$(echo $line | awk '{print $2}')
        echo "usage is: $usage"
        echo "partition is: $partition"
        if [ "$usage" -ge "$DISK_THRESHOLD" ]
        then
                message+="High disk usage on $partition: $usage%\n"
        fi
done

# Restore the original IFS value
IFS=$original_ifs

echo -e "message is : $message"

