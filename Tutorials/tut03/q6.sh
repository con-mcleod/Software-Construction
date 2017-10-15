#!/bin/sh

# files: Marks, Students
students=`cat Students`
Marks=`cat Marks`

while read line
do
	student_no=`echo $line | egrep -o "^[0-9]{7}"`
	mark=`cat Marks | egrep "$student_no" | cut -d' ' -f2`
	if echo $mark | egrep -v "^(100|[0-9]{1,2})" > /dev/null
	then
		mark=`echo -n \?\? \($mark\)`
	fi
	name=`cat Students | egrep "$student_no" | sed -E "s/^[0-9]+//"`
	echo $mark, $name
done < Students