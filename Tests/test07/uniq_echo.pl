#!/usr/bin/perl -w

use strict;

my %uniq_word = ();
my $n = 0;

foreach my $arg (@ARGV) {

	if (!exists $uniq_word{$arg}) {
		$uniq_word{$arg} = $arg;
		print "$uniq_word{$arg} ";
	}
}
print "\n";