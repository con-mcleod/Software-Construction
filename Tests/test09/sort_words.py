#!/usr/bin/python

import re, sys

words = []

for line in sys.stdin:
	line = re.sub("\n","",line) 
	line = re.sub("\s+"," ", line)
	words = line.split(' ')
	words = sorted(words)

	print (' '.join(map(str,words)))
	