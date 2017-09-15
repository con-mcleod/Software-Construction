#!/usr/bin/python

import sys

for line in sys.stdin:

	line = line.replace("0","<")
	line = line.replace("1","<")
	line = line.replace("2","<")
	line = line.replace("3","<")
	line = line.replace("4","<")
	line = line.replace("6",">")
	line = line.replace("7",">")
	line = line.replace("8",">")
	line = line.replace("9",">")
	
	sys.stdout.write(line)