#!/bin/sh

cat $1 | cut -d'|' -f1,3 | egrep "COMP2041" | cut -d',' -f2 | cut -d' ' -f2 | sort | uniq -c | sort -n | tail -1 | sed 's/[^a-zA-Z]//g'