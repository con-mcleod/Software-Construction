#!/usr/bin/perl -w

use strict;

our @tidiedInput = ();
our @uniqueNames = ();

foreach my $line (<STDIN>) {
	chomp $line;

	$line =~ s/([A-Z])/lc($1)/ge;
	$line =~ s/s$//g;
	$line =~ s/ +/ /g;
	$line =~ s/ $//g;

	push @tidiedInput, $line;

	my $whaleNames = $line;
	my @whaleNames = split / /, $whaleNames, 2;

	if (!grep { $_ eq $whaleNames[1] } @uniqueNames) {
		push @uniqueNames, $whaleNames[1];
	}
	@uniqueNames = sort @uniqueNames;
}

foreach my $uniqueName (@uniqueNames) {
	my $pods = 0;
	my $individuals = 0;

	foreach my $entry (@tidiedInput) {
		my @array = split / /, $entry, 2;

		if ($array[1] eq $uniqueName) {
			$pods += 1;
			$individuals += $array[0];
		}
	}
	print "$uniqueName observations: $pods pods, $individuals individuals\n";
}