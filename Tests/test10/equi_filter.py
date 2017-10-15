#!/usr/bin/python

import sys, re

letterCount = {}
equiWord = []

for line in sys.stdin:
	line = re.sub("\s+"," ",line)

	words = line.split(' ')

	for word in words:
		#word = re.sub("\n","",word)

		letters = list(word)

		for letter in letters:
			#print ("letter %s"%(letter))
			if letter in letterCount:
				letterCount[letter.lower()] += 1
			else:
				letterCount[letter.lower()] = 1

		currCount = 0
		equiWord = 1
		for letter in letterCount:
			if (currCount == 0 or currCount == letterCount[letter]):
				currCount = letterCount[letter]
			else:
				equiWord = 0
				break

		if (equiWord == 1):
			if (word == "Not-equi:"):
				print "\n", word,
			else:
				print word,

		letterCount.clear()


	
