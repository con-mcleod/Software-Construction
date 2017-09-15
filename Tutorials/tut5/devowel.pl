#!/usr/bin/perl -w

#create an array called buffer
@buffer = ();

while ($line = <STDIN>) {
	#transform each line by removing vowel
	$line =~ s/[aeiou]//gi;

	#print $line;

	#push each line into the buffer
	push @buffer, $line
}

#print the buffer
print @buffer