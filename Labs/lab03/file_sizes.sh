#!/bin/sh

for file in *
do
	count=`wc -l < "$file"`
	if [[ $count -lt 10 ]]
	then
		smallFiles="$smallFiles $file"
	elif [[ $count -lt 100 ]]
	then
		mediumFiles="$mediumFiles $file"
	else
		largeFiles="$largeFiles $file"
	fi
done

echo "Small files:$smallFiles"
echo "Medium-sized files:$mediumFiles"
echo "Large files:$largeFiles"