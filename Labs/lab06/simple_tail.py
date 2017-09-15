#!/usr/bin/python

import sys

for arg in sys.argv[1:]:

	file = open(arg)
	lines = file.readlines()

	i = -10

	while (i < 0):
		try:
			print lines[i],
		except IndexError:
			pass
		i += 1