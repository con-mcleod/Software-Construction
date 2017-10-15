#!/usr/bin/perl -w

use strict;

our $total = 0;

foreach my $file (glob("*.[ch]")) {
	open FILE, '<', $file or die "Cannot open $file";
	my @lines = <FILE>;
	my $n_lines = @lines;

	printf "%7d %s\n", $n_lines, $file;
	$total += $n_lines;
	close FILE;
}

printf "%7d total\n", $total;