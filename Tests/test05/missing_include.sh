#!/bin/sh

ch_files=`ls | egrep "\.[ch]"`

for file in $@
do

	includeLine=`egrep "#include \"" $file | egrep -o "[a-z]*\.[ch]"`

	for item in $includeLine
	do
		if [[ -f "$item" ]]
		then
			continue
		else
			echo "$item included into $file does not exist"
		fi
	done
done