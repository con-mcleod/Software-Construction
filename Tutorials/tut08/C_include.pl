#!/usr/bin/perl -w

use strict;

sub getIncludedContents () {
	my $included_file = $_[0];
	open INC_FILE, '<', $included_file;
	while (my $line = <INC_FILE>) {
		if $line =~ /#include\s*"(.*)"/) {
			print "$line\n";
		}
		else {
			next;
		} 
	}
	close INC_FILE;
}

foreach my $arg (@ARGV) {

	

	
	open FILE, '<', $arg or die "Cannot open $arg\n";
	while (my $line = <FILE>) {
		if $line =~ /#include\s*"(.*)"/) {

		}
		else {
			next;
		}
	}
	close FILE;
}