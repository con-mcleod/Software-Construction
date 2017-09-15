#!/bin/sh

for file in *.htm
do
	fileName=`echo $file | cut -d'.' -f1`

	if [ -e "$fileName".html ]
	then
		echo "$fileName".html exists
		exit 1
	else
		touch "$fileName".html
		rm "$fileName".htm
	fi
done