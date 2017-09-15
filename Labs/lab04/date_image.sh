#!/bin/sh


for image in "$@"
do
	imageDate=`ls -l "$image" | sed 's/  / /g' | cut -d' ' -f6-8`
	filename=`echo "$image" | cut -d'.' -f1`
	convert -gravity south -pointsize 36 -draw "text 0,10 '$imageDate'" "$image" "$filename"_dated.png
	convert "$filename"_dated.png "$filename"
done