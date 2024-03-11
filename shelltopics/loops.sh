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

#IS_INSTALLED is a global variable 
#CHECK_INSTALLED is another function by default we gave no it will check if it is not installed it will move the return value to validate function

IS_INSTALLED=no

CHECK_INSTALLED(){
        yum -q list installed $1 &>/dev/null
	if [ $? -eq 0 ]
	then
		IS_INSTALLED=yes
	fi

}



#PACKAGE is a variable we are giving vallues at the cli level

for PACKAGE in $@
do
        CHECK_INSTALLED $PACKAGE
        

        if [ ${IS_INSTALLED} == "no" ]
        then
                echo -e "$B $PACKAGE not instlled will initate the install $N"
                yum install $PACKAGE -y &>>$LOG_FILE
                VALIDATE $? "$PACKAGE installation"
        else
                echo -e "$Y $PACKAGE already installed $N"
        fi
done





#CHECK_INSTALLED is another function by default we gave no it will check if it is not installed it will move the return value to validate function

#IS_INSTALLED=no
#THIS IS ANOTHER WAY IF ISNTALEED IS 10 IT IS NOT INSTALLED IF INSTALLED IS 20 THEN IT IS INSTALLED
#CHECK_INSTALLED(){
#       yum -q list installed $1 &>/dev/null
#       IS_INSTALLED=10
#       if [ $? -eq 0 ]
#       then
#               IS_INSTALLED=20
#       fi
#       return $IS_INSTALLED
#
#}




#PACKAGE is a variable we are giving vallues at the cli level

#for PACKAGE in $@
#do
#	CHECK_INSTALLED $PACKAGE
#	return_value=$?
#	echo "return value from function: $return_value"
#
#	if [ $return_value -ne 20 ]
#	then
#		echo -e "$B $PACKAGE not instlled will initate the install $N"
#		yum install $PACKAGE -y &>>$LOG_FILE
#		VALIDATE $? "$PACKAGE installation"
#	else
#		echo -e "$Y $PACKAGE already installed $N"
#	fi
#done
