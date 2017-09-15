#!/usr/bin/perl -w

use strict;

my %distinct_line = ();
my $n = $ARGV[0];
my $lineCount = 0;

while (my $line = <STDIN>) {
	$lineCount++;
	$line = lc($line);
	$line =~ s/^\s+//g;
	$line =~ s/\s+/ /g;
	$distinct_line{$line} += 1;

	my $distinct_counter = keys %distinct_line;

	if ($distinct_counter == $n) {
		print "$n distinct lines seen after $lineCount lines read.\n";
		exit;
	}
}
print "End of input reached after $lineCount lines read - $n different lines not seen.\n";