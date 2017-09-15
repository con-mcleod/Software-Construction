#!/usr/bin/python

import sys

whale = sys.argv[1]

pods = 0
individuals = 0

for line in sys.stdin:

	words = line.split(" ",1)

	if (words[1] == (whale + '\n')):
		pods += 1
		individuals += int(words[0])

print (whale + " observations: %d pods, %d individuals"%(pods, individuals))