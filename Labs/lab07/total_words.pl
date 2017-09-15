#!/usr/bin/perl -w

use strict;

my $wordCount = 0;

while (my $line = <>) {
	$line =~ s/[^a-zA-Z]/ /g;
	my @words = split / /, $line;

	foreach my $word (@words) {
		if ($word ne "") {
			$wordCount += 1;
		}
	}
}

print "$wordCount words\n";