#!/usr/bin/perl -w

use strict;

my $count = 0;
my $currMax = -30;
my $maxNum = -30;
my @maxLines = ();

foreach my $line (<STDIN>) {

	if ($line =~ /[0-9]*/) {
		my $nums = $line;
		$nums =~ s/[^0-9.\-]/ /g;
		$nums =~ s/\s+/ /g;
		$nums =~ s/^\s//g;
		$nums =~ s/ \.//g;
		$nums =~ s/--\s//g;
		$nums =~ s/--/-/g;
		$nums =~ s/-\s//g;
		$nums =~ s/-$//g;
		$nums =~ s/\.$//g;


		#print "$nums\n";

		my @numbers = split / /, $nums;

		$currMax = -30;
		
		foreach my $number (@numbers) {

			if ($number > $currMax) {
				$currMax = $number;
			}
		}

		if ($currMax > $maxNum) {
			@maxLines = ();
			$maxNum = $currMax;
			push @maxLines, $line;
		} elsif ($currMax == $maxNum) {
			push @maxLines, $line;
		}
			#	@maxLines = ();
			#	$maxNum = $number;
			#	push @maxLines, $line;
			#} elsif ( $number = $maxNum) {
			#	push @maxLines, $line;
			#}
		#}
	}
}

foreach my $item (@maxLines) {
	print "$item";
}
