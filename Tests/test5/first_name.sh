#!/bin/sh

fileName=$1

stuNames=`egrep "COMP[29]041" $1 | cut -d'|' -f3 | cut -d',' -f2 | sed 's/^ *//g' | sed 's/ .*$//g' > names`
sortedNames=`sort names | uniq -c | sort | tail -1 | tr -d '[0-9]*' | sed "s/^[ \t]*//" > solution`
cat solution
rm names solution