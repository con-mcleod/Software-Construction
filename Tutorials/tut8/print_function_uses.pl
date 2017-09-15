#!/usr/bin/perl -w

use strict;

my $function_name = "";
if ($ARGV[0]) { 
	$function_name = $ARGV[0];
} else {
	die "Usage: $0 <function-name>";
}

foreach my $c_file (glob("*.c")) {
	open C_FILE, '<', $c_file or die "$0: cannot open $c_file\n";
	while (my $line = <C_FILE>) {
		$line =~ s/\/\/.*//;
		$line =~ s/".*?";//g;
		$line =~ /\b$function_name\s*\(/ or next;
		print "$c_file:$. function $function_name ";

		if ($line =~ /^\s/) {
			print "used\n";
		} elsif ($line =~ /;/) {
			print "declared\n";
		} else {
			print "defined\n";
		}
	}
	close C_FILE;
}