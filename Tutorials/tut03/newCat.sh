#!/bin/sh

for arg in $@
do
	while read < $arg
	do
		echo $contents
	done 
done

#
#while read line
#do
#	echo "$line"
#done