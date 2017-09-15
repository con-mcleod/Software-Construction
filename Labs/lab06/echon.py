#!/usr/bin/python

import sys

if (len(sys.argv) != 3):
	print ("Usage: ./echon.py <number of lines> <string>")

else:
	try:
		number = int(sys.argv[1])
		string = str(sys.argv[2])
		count = 0
		while (count < number):
			print (string)
			count += 1
	except ValueError:
		print ("./echon.py: argument 1 must be a non-negative integer")
