#!/usr/bin/perl -w

use strict;


my $chosenWord = $ARGV[0];
my %file_words = ();

foreach my $file (glob "lyrics/*.txt") {

	our $artist = $file;
	$artist =~ s/[a-z]*\///g;
	$artist =~ s/\.txt//g;
	$artist =~ s/\_/ /g;

	our $wordCount = 0;
	our $totalCount = 0;

	open FILE, '<', $file or die "Cannot open $file";
	while (my $line = <FILE>) {
		chomp $line;
		$line =~ s/[^a-zA-Z]/ /g;
		$line = lc $line;
		my @words = split / /, $line;
		foreach my $word (@words) {
			if ($word eq "$chosenWord") {
				$wordCount += 1;
			}
			if ($word ne "") {
				$totalCount += 1;
			}
		}
	}
	close FILE;

	my $fraction = (($wordCount+1) / $totalCount);
	my $logValue = log($fraction);

	printf "log((%d+1)/%6d) = %8.4f %s\n", $wordCount, $totalCount, $logValue, $artist;
}