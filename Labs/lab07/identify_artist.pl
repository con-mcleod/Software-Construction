#!/usr/bin/perl -w

use strict;

my @song_words = ();
my %probability = ();
my $result = 0;
my @result = ();
our $artist = 0;

foreach my $arg (@ARGV) {

	open SONG, '<', $arg;

	while (my $lyrics = <SONG>) {
		$lyrics =~ s/[^a-zA-Z]/ /g;
		$lyrics =~ s/\s+/ /g;
		$lyrics =~ s/\.//g;
		$lyrics = lc $lyrics;
		@song_words = split / /, $lyrics;

		foreach my $song_word (@song_words) {
			
			foreach my $file (glob "lyrics/*.txt") {

				$artist = $file;
				$artist =~ s/[a-z]*\///g;
				$artist =~ s/\.txt//g;
				$artist =~ s/\_/ /g;

				my $wordCount = 0;
				my $totalCount = 0;
				my $fraction = 0;
				my $logValue = 0;

				open FILE, '<', $file or die "Cannot open $file";
				while (my $line = <FILE>) {
					chomp $line;
					$line =~ s/[^a-zA-Z]/ /g;
					$line = lc $line;
					my @words = split / /, $line;
					foreach my $word (@words) {
						if ($word eq "$song_word") {
							$wordCount += 1;
						}
						if ($word ne "") {
							$totalCount += 1;
						}
					}
				}
				close FILE;

				$fraction = (($wordCount+1) / $totalCount);
				$logValue = log($fraction);

				$probability{$artist} += $logValue;
			}
		}
	}

	$result = (sort {$probability{$b} <=> $probability{$a}} keys %probability)[0];
	printf("%s most resembles the work of %s (log-probability=%.1f)\n", $arg, $result, $probability{$result});
	
	close SONG;


	foreach $artist (keys %probability) {
		$probability{$artist} = 0;
	}
	
}