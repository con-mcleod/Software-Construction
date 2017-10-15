#!/usr/bin/python

import sys

uniqueWords = []

for word in sys.argv[1:]:
	if word not in uniqueWords:
		uniqueWords.append(word)

print (' '.join(map(str,uniqueWords)))