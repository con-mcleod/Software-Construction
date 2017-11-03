#!/usr/bin/perl -w

use strict;

my $file = $ARGV[0];

open FILE, '+<', $file or die "Cannot open $file\n";

foreach my $line (<FILE>) {
	$line =~ s/[aeiouAEIOU]//g;
	print FILE "$line";
}



close FILE