#!/usr/bin/perl -w

use strict;

my $snapNum = $ARGV[0];
my %word_Counter = ();


while (1) {
	my $line = <STDIN>;
	$word_Counter{$line} += 1;
	if ($word_Counter{$line} == $snapNum) {
		print "Snap: $line";
		last;
	}
}