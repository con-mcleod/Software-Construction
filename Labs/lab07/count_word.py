#!/usr/bin/python

import sys, re

wordCount = 0
pattern = sys.argv[1]

for lines in sys.stdin:
	lines = re.sub("[^a-zA-Z]+", " ", lines)
	lines = lines.lower()
	lines = re.sub("\'", " ", lines)
	words = lines.split(" ")
	
	for word in words:
		if (word == pattern):
			print (word)
			wordCount += 1

print ("%s occurred %d times"%(pattern,wordCount))