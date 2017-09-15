#!/usr/bin/perl -w

if ($#ARGV != 1) {
	die "Usage: ./echon.pl <number of lines> <string>\n";
}
if ($ARGV[0] =~ /^[^0-9]+/) {
	die "./echon.pl: argument 1 must be a non-negative integer\n"
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