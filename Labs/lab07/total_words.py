#!/usr/bin/python

import sys, re

wordCount = 0

for lines in sys.stdin:
	lines = re.sub("[^a-zA-Z]+", " ", lines)
	lines = re.sub("\'", " ", lines)
	words = lines.split(" ")
	
	for word in words:
		if word:
			#print (word)
			wordCount += 1

print ("%d words"%wordCount)