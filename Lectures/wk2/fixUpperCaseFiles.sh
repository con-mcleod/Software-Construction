#!/bin/sh

for upper_case in *
do
	lower_case=`echo $upper_case|tr A-Z a-z`
	mv $upper_case $lower_case
	trash $upper_case
done