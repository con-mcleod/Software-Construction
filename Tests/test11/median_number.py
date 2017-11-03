#!/usr/bin/python
import sys

argList = []
count = 1

for i in sys.argv[1:]:
	argList.append(i)

argList.sort(key=int)
listSize = len(argList)

for i in argList:
	if (count == (listSize/2)+1):
		print (i)
	count += 1

