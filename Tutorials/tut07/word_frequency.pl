#!/usr/bin/perl -w

use strict;

my %word_count = ();

while (my $line = <>) {
	$line = lc $line;
	$line =~ s/[^a-z]/ /g;
	my @split_line = split / /, $line;
	foreach my $element (@split_line) {
		$word_count{$element} += 1;
	}
}

my @words = keys %word_count;
our @sorted_words = sort{$word_count{$a} >= $word_count{$b}} @words;

foreach my $word (@sorted_words) {
	print "$word_count{$word} : $word\n";
}