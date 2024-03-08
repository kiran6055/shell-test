#!/bin/bash
# im trying to install httpd

USERID=$(id -u)

if [ ${USERID} -eq 0 ] 
then
	echo "user has root privelages"
else
	echo "user dont hat root Privelages"
	exit 1
fi

echo "install httpd"
yum install httpd -y

if [ $? -eq 0 ] 
then
	echo "installed http sucessfully"
        httpd -version
else
	echo "httpd not installed"
	exit 12
fi
