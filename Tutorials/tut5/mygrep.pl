#!/usr/bin/perl -w

if ($#ARGV >= 1) {
	$expr = $ARGV[0];
	shift @ARGV;

	foreach $file (@ARGV) {
		open FILE, '<', $file or die "Failed to open: $file\n";
		@buffer = <FILE>;
		foreach $line (@buffer) {
			$line =~ /$expr/;
			print $line;
		}
		close FILE;
	}
} elsif ($#ARGV == 0) {
	$expr = $ARGV[0];
	shift @ARGV;
	while ($line = <>) {
		if ($line =~ /$expr/) {
			print $line;
		}
	}
}
else {
	die "./mygrep.pl [expression] [ARGS]\n";
}