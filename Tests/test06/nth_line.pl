#!/usr/bin/perl -w

use strict;

my $lineNum = $ARGV[0];
my $file = $ARGV[1];
my $lineCount = 1;

open FILE, $file;
while (my $line = <FILE>) {
	chomp $line;
	if ($lineCount == $lineNum) {
		print "$line\n";
	}
	$lineCount += 1;
}
close FILE;