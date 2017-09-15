#!/usr/bin/perl -w

use strict;

foreach my $line (<STDIN>) {

	$line =~ s/\s+/ /g;

	my @words = split / /, $line;
	
	foreach my $word (sort @words) {
		print "$word ";
	}
	print "\n";
}