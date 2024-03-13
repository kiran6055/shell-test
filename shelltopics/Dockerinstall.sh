#!/bin/bash
#
#this set-e is used to exit the shell script if any error occurs we can use it like validate function to check here trap will list where the error occured and why it is occured like wrong command bcz of what error caused
set -eE -o functrace
failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR


#untill here we need to use if we dont want to used lika validate function by giving exit status

USERID=$(id -u)
LOGFILE="docker-install.log"

R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"


if [ $USERID -ne 0 ]
then
    echo -e "$R Please run this script with root access $N"
    exit 1
fi


CHECK_INSTALLED(){
	yum -q list installed 

}

echo -e "$G ..... installing Docker $N"
sudo yum install docker -y

echo -e "$G ..... starting Docker $N"
systemctl start docker

echo -e "$Y....... enabling Docker $N"
systemctl enable docker

echo -e "$Y ...... adding users in docker group $N"
usermod -aG docker ec2-user


echo -e "$B ... Docker installation is completed logout and login again type Docker --version to see the version $N"
