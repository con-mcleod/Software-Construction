#!/usr/bin/python

import sys, re, urllib

f_flag = 0;
counter = {}

for arg in sys.argv[1:]:
	if (arg == "-f"):
		f_flag = 1;
		continue;

	webpage = urllib.urlopen(arg).read()
	webpage = re.sub("<!--.*?-->", "", webpage)
	webpage = webpage.lower()

	tags = re.findall("<\s*(\w+)", webpage)

	for tag in tags:
		if not (tag in counter.keys()):
			counter[tag] = 1
		else:
			counter[tag] += 1;

if not (f_flag):
	tags = sorted(counter.keys())
	for tag in tags:
		print ("%s %d"%(tag, counter[tag]))
else:
	tags = sorted(counter.items(), key=lambda x: (x[1],x[0]))
	for tag in tags:
		print str(tag[0]) + " " + str(tag[1])