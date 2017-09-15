#!/usr/bin/perl -w

use strict;

foreach my $subject (@ARGV) {

	my $UGurl = "http://www.handbook.unsw.edu.au/undergraduate/courses/current/$subject.html";
	my $PGurl = "http://www.handbook.unsw.edu.au/postgraduate/courses/current/$subject.html";

	open FILE, '-|', "wget -q -O- $UGurl" or die "Can't access $UGurl";
	while (my $line = <FILE>) {
		my @array = split /<p>/, $line;

		foreach my $result (@array) {
			if ($result =~ /Prerequisite:/ | $result =~ /Prerequisites:/ | $result =~ /Prereq/) {
				my @subjects = split / /, $result;
				foreach my $answer (@subjects) {
					if ($answer =~ /[A-Z]{4}[0-9]{4}/) {
						$answer =~ s/<\/p>//g;
						$answer =~ s/\.//g;
						print "$answer\n";
					}
				}
			}
		}
	}
	close FILE;


	open FILE, '-|', "wget -q -O- $PGurl" or die "Can't access $PGurl";
	while (my $line = <FILE>) {
		my @array = split /<p>/, $line;

		foreach my $result (@array) {
			if ($result =~ /Prerequisite:/ | $result =~ /Prerequisites:/ | $result =~ /Prereq/) {
				my @subjects = split / /, $result;
				foreach my $answer (@subjects) {
					if ($answer =~ /[A-Z]{4}[0-9]{4}/) {
						$answer =~ s/<\/p>//g;
						$answer =~ s/\.//g;
						print "$answer\n";
					}
				}
			}
		}
	}
	close FILE;
}