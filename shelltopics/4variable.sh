#!/bin/bash

# this is another way of giving variables like asking user define the value to variable at run time

echo "please enter DBusername"

read DBusername

echo "user is: ${DBusername}"

echo "please eneter DBpassword"

#read -s will mask the input given by user
read -s DBpassword

echo "password is : ${DBpassword}"



