#!/usr/bin/perl -w

use strict;

foreach my $url (@ARGV) {
	open FILE, '-|', "wget -q -O- $url" or die "Can't access $url";
	while (my $line = <FILE>) {
		my @numbers = split /[^\d\- ]/, $line;
		foreach my $result (@numbers) {
			$result =~ s/\D//g;
			print "$result\n" if length $result >= 8 && length $result <= 15;
		}
	}
	close FILE;
}