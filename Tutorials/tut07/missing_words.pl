#!/usr/bin/perl -w

use strict;


die "Usage: $0 <file1> <file2>\n" if @ARGV != 2;

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

my %file_one_words = ();
my %file_two_words = ();

open FILE_ONE, '<', $file1 or die "Cannot open $file1";

while (my $line = <FILE_ONE>) {
	chomp $line;
	my @split_line = split / /, $line;
	foreach my $word (@split_line) {
		#if (!exists $file_one_words{$word}) {
		$file_one_words{$word} = "added";
		#}
	}
}
close FILE_ONE;


open FILE_TWO, '<', $file2 or die "Cannot open $file2";

while (my $line = <FILE_TWO>) {
	chomp $line;
	my @split_line = split / /, $line;
	foreach my $word (@split_line) {
		$file_two_words{$word} = "deleted";
	}
}
close FILE_TWO;

foreach my $word (keys %file_one_words) {
	print "$word\n" if !exists $file_two_words{$word};
}