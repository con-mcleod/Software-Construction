#!/usr/bin/perl -w

use strict;
my %whales = ();

while (my $line = <>) {
	chomp $line;
	my @split_line = split / /, $line;
	my $count = $split_line[0];
	shift @split_line;
	my $name = join " ", @split_line;
	#print "n=$count, name=$name";
	$whales{$name} += $count;
}

foreach my $key (keys %whales) {
	print "k=$key, str=$whales{$key}\n";
}