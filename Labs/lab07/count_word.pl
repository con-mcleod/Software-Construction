#!/usr/bin/perl -w

use strict;

my $wordCount = 0;
my $chosenWord = $ARGV[0];
my %file_words = ();


while (my $line = <STDIN>) {
	$line =~ s/[^a-zA-Z]/ /g;
	$line = lc $line;
	my @words = split / /, $line;
	foreach my $word (@words) {
		if ($word eq "$chosenWord") {
			$wordCount += 1;
		}
	}
}

print "$chosenWord occurred $wordCount times\n";