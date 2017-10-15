#!/usr/bin/perl -w

use strict;

foreach my $file (@ARGV) {

	my $totalCount = 0;
	open FILE, '<', $file or die "Can not open $file\n";
	foreach my $line (<FILE>) {
		$totalCount++;
	} 
	close FILE;

	my $count = 0;
	open FILE, '<', $file or die "Can not open $file\n";
	foreach my $line (<FILE>) {
		$count++;
		if ($count == ($totalCount/2)+.5) {
			print "$line";
		} elsif ($count == $totalCount/2) {
			print "$line";
		} elsif ($count == ($totalCount/2)+1) {
			print "$line";
		}
	}
	close FILE;
}