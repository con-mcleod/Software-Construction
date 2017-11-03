#!/bin/sh

if test -d "$1"
then
	for file in .* *
	do
		case $file in 
		.|..)
			;;
		*)
			if test -f "$file"
			then
				rm "$file"
			fi
			;;
		esac
	done

	for directory in .* *
	do
		case $directory in
			.|..)
				;;
			*)
				if test -d "$directory"
				echo -n "Delete $directory?"
				read answer

				if test "$answer" == "yes"
				then
					../"$0" "$directory"
				fi
		esac
	done
else
	echo "Usage: ./rmall.sh <directory>"
fi