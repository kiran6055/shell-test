#!/bin/bash

USERID=$(id -u)
DATE=$(date +"%F-%H-%M-%S")
LOG_FILE="$DATE.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
B="\e[34m"


if [ $USERID -ne 0 ]
then
	echo -e "$R please run with root previlages $N"
        exit 1
fi

VALIDATE(){
	if [ $1 -ne 0 ]
	then
		echo -e "$2 ..... $R FAILED $N"
	        exit 1
	else
		echo -e "$2 ..... $G sucess $N"
	fi

}

for PACKAGE in $@
do
	yum -q list installed $PACKAGE &>/dev/null
	if [ $? -ne 0 ]
	then
		echo -e "$B $PACKAGE not instlled will initate the install $N"
		yum install $PACKAGE -y &>>$LOG_FILE
		VALIDATE $? "$PACKAGE installation"
	else
		echo -e "$Y $PACKAGE already installed $N"
	fi
done
