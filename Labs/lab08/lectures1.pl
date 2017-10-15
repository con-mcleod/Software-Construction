#!/usr/bin/perl -w

use strict;

my @times = ();
my @lecTimes = ();
my @uniqueTimes = ();
my $dFlag = 0;

if ($ARGV[0] eq "-d") {
	$dFlag = 1;
}

foreach my $courseCode (@ARGV) {

	my $url = "http://timetable.unsw.edu.au/2017/$courseCode.html";
	
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

				my @lecTimes = ($newLine =~ /[a-zA-Z]{3} [0-9]{2}:00 - [0-9]{2}/g);

				if ($dFlag == 1) {
					foreach my $time (@lecTimes) {
						my $day = $time;
						my $startTime = $time;
						my $endTime = $time;
						$day =~ s/ .*//g;
						$startTime =~ s/[a-zA-Z]{3} //g;
						$startTime =~ s/:.*//g;
						if ($startTime =~ /0[1-9]/) {
							$startTime =~ s/0//g;
						}
						$endTime =~ s/.*- //s;

						my $twoHrFlag = 0;
						my $threeHrFlag = 0;
						if ($endTime - $startTime == 2) {
							$twoHrFlag = 1;
						} elsif ($endTime - $startTime == 3) {
							$threeHrFlag = 1;
						}

						if ($twoHrFlag == 1) {
							if (!(grep $_ eq $startTime, @times)) {
								push @times, $newLine;
								print "$semester $courseCode $day $startTime\n";
							}
							$startTime = $startTime + 1;
							if (!(grep $_ eq $startTime, @times)) {
								push @times, $newLine;
								print "$semester $courseCode $day $startTime\n";
							}
						} elsif ($threeHrFlag == 1) {
							my $midTime = 0;
							my $finalTime = 0;
							if (!(grep $_ eq $startTime, @times)) {
								push @times, $newLine;
								print "$semester $courseCode $day $startTime\n";
							}
							$midTime = $startTime + 1;
							if (!(grep $_ eq $startTime, @times)) {
								push @times, $newLine;
								print "$semester $courseCode $day $midTime\n";
							}
							$finalTime = $midTime + 1;
							if (!(grep $_ eq $startTime, @times)) {
								push @times, $newLine;
								print "$semester $courseCode $day $finalTime\n";
							}
						} else {
							print "$semester $courseCode $day $startTime\n";
						}
					}
				} else {
					if (!(grep $_ eq $newLine, @times)) {
						push @times, $newLine;
						print "$courseCode: $semester $newLine";
					}
				}
			}
		}
	}
	close WEBPAGE; 
}