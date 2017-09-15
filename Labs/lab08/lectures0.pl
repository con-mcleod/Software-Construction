#!/usr/bin/perl -w

use strict;


foreach my $courseCode (@ARGV) {

	my $hyperlink = "http://timetable.unsw.edu.au/2017/${courseCode}.html";

	my $webpage = `wget -q -O- $hyperlink`;

	$webpage =~ /<td class="data">Lecture<\/td>/;

	print "$webpage";


}




# https://github.com/SamanthaChhoeu/COMP2041-16s2/blob/master/lab08/lectures0.pl
# https://github.com/naak19/COMP2041/blob/master/2041-labs/lab08/lectures0.pl