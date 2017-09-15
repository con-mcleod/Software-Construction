#!/usr/bin/perl -w

use strict;

my $courseCode = $ARGV[0];
my $hyperlink = "http://www.timetable.unsw.edu.au/current/${courseCode}KENS.html";
my $webpage = `wget -q -O- $hyperlink`;
my @courses = $webpage =~ />${courseCode}[0-9]{4}</g;

foreach my $course (@courses) {
	$course =~ s/\>//g;
	$course =~ s/\<//g;
	print "$course\n";
}
