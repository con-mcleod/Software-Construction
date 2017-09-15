#!/bin/sh

for file in *.jpg
do
	filename=`echo $file | cut -d'.' -f1`

	if [ -e "$filename".png ]
	then
		echo "$filename".png already exists
	else
		convert "$filename".jpg "$filename".png
		rm "$filename".jpg
	fi
done