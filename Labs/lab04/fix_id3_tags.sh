#!/bin/sh

directory=`echo "$1" | cut -d '/' -f1`
cd "$directory"

for f in "$@"
do

	album=`echo "$f" | cut -d'/' -f2`
	year=`echo "$album" | cut -d',' -f2 | sed 's/ //'`

	cd "$album"

	for i in *
	do
		trackInfo=`echo "$i"`
		track=`echo "$trackInfo" | cut -d'-' -f1 | sed 's/ //'`
		title=`echo "$trackInfo" | cut -d'-' -f2 | sed 's/ //'`
		artist=`echo "$trackInfo" | cut -d'-' -f3 | cut -d'.' -f1 | sed 's/ //'`
		id3 -t "$title" -T "$track" -a "$artist" -A "$album" -y "$year" "$i" > /dev/null
	done

	cd ..
done
exit