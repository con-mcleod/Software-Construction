#!/usr/bin/perl -w

use strict;

my @variableList = ();

while (my $line = <>) {

	# print #! line
	if ($line =~ /^#!/ && $. == 1) {
		print "#!/usr/bin/perl -w";
	} # print comments as they are
	elsif ($line =~ /^\s*(#|$)/) {
		print "$line";
	} # append "$" to variable name initiation
	elsif ($line =~ /^[a-z]+=/) {
		$line =~ s/$/;/;
		print "\$$line";
	}

	# replace "do" with {
	if ($line =~ /(^do$|\t+do$|\s+do$)/) {
		$line =~ s/do/{/;
		print "$line";
	} # replace "done" with }
	elsif ($line =~ /(^done$|\t+done$|\s+done$)/) {
		$line =~ s/done/}/;
		print "$line";
	} # replace "then" with {
	elsif ($line =~ /(^then$|\t+then$|\s+then$)/) {
		$line =~ s/then/{/;
	} # replace "fi" with }
	elsif ($line =~ /(^fi$|\t+fi$|\s+fi$)/) {
		$line =~ s/fi/}/;
	}

	# convert echo to print
	if ($line =~ /(echo|\s+echo|\t+echo)/) {
		$line =~ s/echo /print "/;
		$line =~ s/$/";/;
		print "$line";
	}

	# deal with while loops
	if ($line =~ /(while[ (]|\s+while[ (]|\t+while[ (])/) {

		my $operator = $line;
		$operator =~ s/[^+-\/*!=<>]//g;

		$line =~ s/\(\(//g;
		$line =~ s/\)\)//g;

		my $var1 = $line;
		$var1 =~ s/\t*while //;
		$var1 =~ s/\s$operator.*//;
		$var1 =~ s/\n$//;
		my $var2 = $line;
		$var2 =~ s/while //;
		$var2 =~ s/.*$operator\s*//;
		$var2 =~ s/\n$//;

		if ($var1 =~ /[a-zA-Z]+/) {
			substr($var1,0,0,'$');
		} 
		if ($var2 =~ /[a-zA-Z]+/) {
			substr($var2,0,0,'$');
		}

		print "while ($var1 $operator $var2)\n";
	}

=pod




	# deal with tabulation
	if ($line =~ /^(\s|\t)\W+/) {

		if ($line =~ /echo/) {
			$line =~ s/echo //g;
			$line =~ s/\n$//g;
			$line =~ s/\s+/ /g;
			$line =~ s/^ //g;
			print "\tprint \"$line\n\"";
		} else {
			$line =~ s/(\$\(|\)|\()//g;
			my $result = $line;
			my $var1 = $line;
			my $operator = $line;
			my $var2 = $line;

			$result =~ s/(\s|\t)//g;
			$result =~ s/[+-\/*=<>].*//g;

			$var1 =~ s/.*=//g;
			$var1 =~ s/[+-\/*]+.*//g;
			$var1 =~ s/\n//g;
			$var1 =~ s/\s+$//g;

			if ($var1 =~ /[a-zA-Z]+/) {
				substr($var1,0,0,'$');
			}

			$operator =~ s/[^+-\/*]//g;

			$var2 =~ s/.* //g;
			$var2 =~ s/\n//g;

			if ($var2 =~ /[a-zA-Z]+/) {
				substr($var2,0,0,'$');
			}

			print "\t\$$result = $var1 $operator $var2;\n";
		}
	}
=cut
}