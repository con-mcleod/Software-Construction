#!/bin/sh

while read line
do
	transformed=`echo $line | sed "s/[01234]/</g" | sed "s/[6789]/>/g"`
	echo $transformed
done