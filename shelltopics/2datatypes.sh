#!/bin/bash
#adding two numbers by giving values inisde shell script
#suppose if we give string like text in number shell will consider them as zero
#num1=100
#num2=900

#result=$((num1+num2))

#echo "the result of adding 2 number is : ${result}"



# now we wil pass the number in argument line
#

#num1=$1
#num2=$2

#result=$((num1+num2))

#echo "result of adding 2 number given by arg: ${result}"
#

#now we will try to add the values given by users

echo "please eneter the first number"
read num1
echo "please eneter second number"
read num2
result=$((num1+num2))
echo "the result of adding 2 numbers is: ${result}"
