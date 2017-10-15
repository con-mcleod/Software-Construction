#!/usr/bin/python

import sys, re

numDistinct = int(sys.argv[1])
lineCount = 0
uniqueCount = 0
#done = 0

uniqueLine = []


while True:
	line = sys.stdin.readline()
	if (line == ""):
		break
	lineCount += 1
	line = re.sub("\s+"," ",line)
	line = re.sub("^\s","",line)
	line = re.sub("\s$","",line)
	line = line.lower()
	if line not in uniqueLine:
		uniqueLine.append(line)
		uniqueCount += 1
	if (uniqueCount == numDistinct):
		print ("%d distinct lines seen after %d lines read"%(numDistinct,lineCount))
		break

if (uniqueCount < numDistinct):
	print ("End of input reached after %d lines read -  %d different lines not seen."%(lineCount, numDistinct))
