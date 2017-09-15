#!/usr/bin/python

import sys


pods = 0
individuals = 0

for line in sys.stdin:

	line = line.lower()

	print (line[2])

	words = line.split(" ",1)

	#if (words[1] == (whale + '\n')):
	#	pods += 1
	#	individuals += int(words[0])

	#print (whale + " observations: %d pods, %d individuals"%(pods, individuals))