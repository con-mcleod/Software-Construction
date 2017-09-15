#!/usr/bin/perl -w

use strict;

die "$0 <loc1> <loc2>\n" if @ARGV != 2;

my %distance = ();
my $start = $ARGV[0];
my $end = $ARGV[1];

while (my $line = <>) {
	$line =~ /(\w+)\s+(\w+)\s+(\d+)/ || next;
	$distance{$1}{$2} = $3;
	$distance{$2}{$1} = $3;
}

my %shortest_journey = ();
my %route = ();

$shortest_journey{$start} = 0;
$route{$start} = "";
my $toVisit = keys %distance;
my $current_town = $start;

while ($current_town && $current_town ne $end) {
	foreach my $loc (keys %distance{$current_town}) {
		print "$loc\n";
	}
}