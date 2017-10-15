#!/usr/bin/perl -w

use strict;

my %letterCount = ();
my @equiWord = ();
my $answer = "";

foreach my $line (<STDIN>) {

	# remove extra spaces
	$line =~ s/\s+/ /g;
	# split line into words, space delimited
	my @words = split / /, $line;

	foreach my $word (@words) {

		# remove the trailing newline
		$word =~ s/\n//g;

		# split word into letters
		my @letters = split //, $word;

		foreach my $letter (@letters) {
			# increase count of lc(letter) in hash
			$letterCount{lc($letter)} += 1;
		}

		# variable to store count of individual letter
		my $currCount = 0;
		# flag to determine if a word is an equi-word
		my $equiWord = 1;
		# foreach each letter's count
		foreach my $count (keys %letterCount) {
			# if the current count is zero or not changed
			if ($currCount == 0 || $currCount == $letterCount{$count}) {
				# set current count to this letter's count
				$currCount = $letterCount{$count};
			} else {
				# word is not an equi-word
				$equiWord = 0;
				# break the loop
				last;
			}
		}
		# if word is an equi-word, print it
		if ($equiWord == 1) {
			print "$word ";
		}

		# clear all keys in the hash
		foreach my $count (keys %letterCount) {
			delete $letterCount{$count};
		}
	}

	print "\n";

}