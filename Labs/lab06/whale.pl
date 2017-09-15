#!/usr/bin/perl -w

use strict;

my $whale = $ARGV[0];
my $podCount = 0;
my $whaleCount = 0;

foreach my $line (<STDIN>) {
	chomp $line;
	if ($line =~ /$whale/) {
		$podCount += 1;

		my @count = split / /, $line;

		foreach my $counter (@count) {
			if ($counter =~ /[0-9]/) {
				$whaleCount += "$counter";
			}
		}
	}
}
print "$whale observations: $podCount pods, $whaleCount individuals\n";