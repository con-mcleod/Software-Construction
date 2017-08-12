#!/bin/sh

arg1=`echo $1 | egrep "^[0-9]*$"`

if [ $# -ne 2 ]
then
	echo "Usage: ./echon.sh <number of lines> <string>"
elif [ -z $arg1 ]
then
	echo "./echon.sh: argument 1 must be a non-negative integer"
else
	nvalue=`echo "$1"`
	while [ $nvalue -gt 0 ]
	do
		echo "$2"
		nvalue=$(( nvalue - 1 ))
	done
fi