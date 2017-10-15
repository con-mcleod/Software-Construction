#!/usr/bin/perl -w

use strict;

my @times = ();

foreach my $courseCode (@ARGV) {

	my $url = "http://timetable.unsw.edu.au/2017/${courseCode}.html";
	
	open WEBPAGE, '-|', "wget -q -O- $url" or die "Can not open webpage for $courseCode\n";

	while (my $line = <WEBPAGE>) {

		if ($line =~ /.*"(#(S[12])-[0-9]{4})">Lecture<\/a><\/td>/) {

			my $semester = $line;
			my $classNum = $line;
			$semester =~ s/^.*#//g;
			$semester =~ s/-.*//g;
			$semester =~ s/\n//g;

			$classNum =~ s/^.*-//g;
			$classNum =~ s/\">.*//g;
			$classNum =~ s/\n//g;

			my $count = 0;
			my $newLine;
			while ($count <= 5) {
				$newLine = <WEBPAGE>;
				$count++;
			}

			if (!($newLine =~ /<td class="data"><\/td>/)) {
				$newLine =~ s/^\s+//g;
				$newLine =~ s/.*data">//g;
				$newLine =~ s/<\/td>//g;

				if (!(grep $_ eq $newLine, @times)) {
					push @times, $newLine;
					print "$courseCode: $semester $newLine";
				}
			}
		}
	}
	close WEBPAGE; 
}