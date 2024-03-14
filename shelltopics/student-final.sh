#!/bin/bash

#colors
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USERID=$(id -u)
DATE=$(date +%F)
LOG_FILE="$DATE.log"
TOMCAT_VERSION=$1 #10.1.19
USAGE(){

        echo "usage: $0 <please provide tomcat_version>"

}


if [ -z $TOMCAT_VERSION ]
then
        USAGE
        exit 1
fi

#extracting tomcat major version from tomcat version first number before . will be consider as major version
TOMCAT_MAJOR_VERSION=$(echo $TOMCAT_VERSION | cut -d "." -f1)


#downloading url from tomcat
TOMCAT_URL=https://dlcdn.apache.org/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

#untaring file
TOMCAT_TAR_FILE=$(echo $TOMCAT_URL | awk -F "/" '{print $NF}' )
#forming tomcat dir like after untaring removing .tar.gs using sed
TOMCAT_DIR=$(echo $TOMCAT_TAR_FILE | sed -e 's/.tar.gz//g')

#student application file
STUDENT_WAR_FILE=https://raw.githubusercontent.com/techworldwithsiva/shell-scripting-01/master/application/student.war
#MySQl Connector
MYSQL_DRIVER=https://raw.githubusercontent.com/techworldwithsiva/shell-scripting-01/master/application/mysql-connector-5.1.18.jar


if [ $USERID -ne 0 ]
then
        echo -e "$R please run the script with root previlages $N"
        exit 1
fi

VALIDATE(){
        if [ $1 -ne 0 ]
        then
                echo -e "$R .........failed $2 $N"
                exit 1
        else
                echo -e "$G .........sucess $2 $N"
        fi


}

# SELINUX to enable traffic from Nginx to tomcat
#yum install policycoreutils-python-utils -y &>>$LOG_FILE
#VALIDATE $? "SELINUX related pacakges"
#setsebool -P httpd_can_network_connect 1 &>>$LOG_FILE
#VALIDATE $? "Allow Nginx to Tomcat"

#installing java11 java is prerequsite to run tomcat
#yum install java-11-amazon-corretto-devel -y
#VALIDATE $? "JAVA insalled or not"

#installing mariaDB
yum install mariadb105-server -y &>> $LOG_FILE
VALIDATE $? "INSTALLING MARIADB"

#STARTING MARIADB
systemctl start mariadb &>> $LOG_FILE
VALIDATE $? "start mariaDB"

#enabling mariaDB
systemctl enable mariadb &>> $LOG_FILE
VALIDATE $? "enable marianDB"

#creating database schema table
echo "create database if not exists studentapp;
use studentapp;
CREATE TABLE if not exists Students(student_id INT NOT NULL AUTO_INCREMENT, student_name VARCHAR(100) NOT NULL, student_addr VARCHAR(100) NOT NULL, student_age VARCHAR(3) NOT NULL, student_qual VARCHAR(20) NOT NULL, student_percent VARCHAR(10) NOT NULL, student_year_passed VARCHAR(10) NOT NULL, PRIMARY KEY (student_id));
grant all privileges on studentapp.* to 'student'@'localhost' identified by 'student@1';" > /tmp/student.sql

#the above command will be save into /tmp/student.sql file here below by typing mysql it will take input from tmp/student.sql file which we save the commands of above creating schema and tables
mysql < /tmp/student.sql
VALIDATE $? "Creating DB SCHEMA table grating previalges"

#creating a directory for tomcat where we download it using tar file
mkdir -p /opt/tomcat
cd /opt/tomcat

if [ -d $TOMCAT_DIR ]
then
        echo -e "$B .....tomcat already exists"
else
        wget $TOMCAT_URL &>> $LOG_FILE
        VALIDATE $? "DOWNLOAD TOMCAT"
        tar -xvzf $TOMCAT_TAR_FILE &>> $LOG_FILE
        VALIDATE $? "UNTARING TOMCAT FILE"
fi

cd $TOMCAT_DIR/webapps

wget $STUDENT_WAR_FILE &>> $LOG_FILE
VALIDATE $? "STUDENT_WAR file placed or not"

cd ../lib
wget $MYSQL_DRIVER &>> $LOG_FILE
VALIDATE $? "mysqldriver is installed or not in lib"

cd ../conf
sed -i '/TestDB/ d' context.xml
VALIDATE $? "Removed existing DB config"
sed -i '$ i <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="100" maxIdle="30" maxWaitMillis="10000" username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/studentapp"/>' context.xml
VALIDATE $? "Added DB resource in context.xml"

cd ../bin
sh shutdown.sh &>>$LOG_FILE
sh startup.sh &>>$LOG_FILE
VALIDATE $? "Tomcat Started"

#installing nginx
yum install nginx -y &>> $LOG_FILE
VALIDATE $? "nginx installed or not"

#starting nginx
systemctl start nginx &>>$LOG_FILE
VALIDATE $? "nginx started"

#addling nginx condifuring file
echo 'location / {
     proxy_pass          http://127.0.0.1:8080/;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
}' > /etc/nginx/default.d/student.conf
VALIDATE $? "Added student.conf"


systemctl restart nginx
VALIDATE $? "NgInx restarted"


