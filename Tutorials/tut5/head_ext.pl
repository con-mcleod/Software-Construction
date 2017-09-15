#!/usr/bin/perl -w

$n = 10;

#can use \d+ instead of [0-9]+ to match the input for the n flag
if (@ARGV && $ARGV[0] =~ /-[0-9]+/) {
	$n = $ARGV[0];
	$n =~ s/-//;
	shift @ARGV;
}

if (@ARGV) {
	# file reading mode
	foreach $file (@ARGV) {
		open FILE, '<', $file or die "File does not exist";
		print "\n===> $file <===\n";
		@buffer = <FILE>;
		print @buffer[0..$n-1];
		close FILE;
	}
} else {
	$curr_line = 0;
	while ($line = <STDIN>) {
		$curr_line++;
		if ($curr_line > $n) {
			last;
		}
		print $line;
	}
}