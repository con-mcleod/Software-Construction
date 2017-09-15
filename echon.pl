#!/usr/bin/perl -w

if ($#ARGV != 1 || @ARGV[0] =~ /^[^0-9]+/ || @ARGV[1] =~ /^[^a-z]+$/) {
	die "Usage: ./echon.pl <number of lines> <string>\n";
}

if (@ARGV && $ARGV[0] =~ /[0-9]+/) {
	$n = $ARGV[0];
	shift @ARGV;

	if (@ARGV) {
		$string = $ARGV[0];
		while ($n > 0) {
			$n--;
			print "$string\n";
		}
	}
}
