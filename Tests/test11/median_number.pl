#!/usr/bin/perl -w

use strict;

my @sortedList = sort { $a <=> $b } @ARGV;
my $sizeOfList = @sortedList;
my $count = 1;

foreach my $arg (@sortedList) {
	if ($count == ($sizeOfList/2)+.5) {
		print "$arg\n";
	}
	$count++;
}