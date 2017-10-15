#!/usr/bin/perl -w

use strict;

foreach my $line (<STDIN>) {
	$line =~ s/[0-9]//g;
	print "$line";
}
