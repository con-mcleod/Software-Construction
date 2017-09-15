#!/usr/bin/perl -w

use strict;

my %tag_count = ();
my $print_ascending_freq = 0;
my @links = ();
my @sorted_tags = ();

# loop to check if -f flag set
# if it is, then we set a boolean to trigger ascending sort

foreach my $arg (@ARGV) {
	if ($arg =~ /-f/) {
		$print_ascending_freq = 1;
	} else {
		push @links, $arg;
	}
}

foreach my $arg (@links) {
	my $webpage = `wget -q -O- '$arg'`;
	$webpage = lc($webpage);
	$webpage =~ s/<!--.*?-->//g;

	my @tags = $webpage =~ /<\s*(\w+)/g;

	foreach my $tag (@tags) {
		$tag_count{$tag}++;
	}
}

if ($print_ascending_freq == 1) {
	@sorted_tags = sort {$tag_count{$a} <=> $tag_count{$b}} keys %tag_count;
} else {
	@sorted_tags = sort keys %tag_count;
}

print "$_ $tag_count{$_}\n" foreach @sorted_tags;

#foreach my $tag (sort keys %tag_count) {
#	print "$tag $tag_count{$tag}\n"
#}