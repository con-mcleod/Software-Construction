#!/usr/bin/python
import sys, re

file = sys.argv[1]

for line in open(file):
	line = re.sub("[aeiouAEIOU]","",line)
	line = re.sub("\n","",line)

	print (line)