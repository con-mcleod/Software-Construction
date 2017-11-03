#!/bin/sh

file=$@

text=`cat $file | sed 's/[aeiouAEIOU]//g'`

echo "$text" > $file