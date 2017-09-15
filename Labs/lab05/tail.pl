#!/usr/bin/perl -w

#$i = 0;
$n = 10;
@result = ();

foreach $arg (@ARGV) {
	if ($arg eq "--version") {
		print "$0: version 0.1\n";
		exit 0;
	}
	elsif ($arg =~ /^-[0-9]+$/) {
		$n = $arg;
		$n =~ s/-//g;
	}
	else {
		push @files, $arg;
	}
}
if (@ARGV == 0) {
	@buffer = reverse <>;
	for $i (0..$n-1) {
		push @result, $buffer[$i];
		if ($i == $#buffer) {
			last;
		}
	}
	while ($n > 0) {
		print(pop @result);
		$n = $n - 1;
	}
} else {
	foreach $f (@files) {
		open F, '<', $f or die "$0: Can't open $f: $!\n";

		@file = <F>;
		@buffer = reverse(@file);

		if ($#files > 0) {
			print ("==> $f <==\n");
		}
		for $i (0..$n-1) {
			push @result, $buffer[$i];
			if ($i == $#buffer) {
				last;
			}
		}
		while (@result != 0) {
			print(pop @result);
		}
		close F;
	}
}
