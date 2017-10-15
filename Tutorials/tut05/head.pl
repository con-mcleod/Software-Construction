#!/usr/bin/perl -w

$n = 10;

#can use \d+ instead of [0-9]+ to match the input for the n flag
if (@ARGV && $ARGV[0] =~ /-[0-9]+/) {
	$n = $ARGV[0];
	$n =~ s/-//;
	shift @ARGV;
}

$curr_line = 0;
while ($line = <STDIN>) {
	$curr_line++;
	if ($curr_line > $n) {
		last;		
	}
	print $line;
}