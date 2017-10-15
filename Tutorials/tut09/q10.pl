#!/bin/perl -w

my $important_file = "/home/cs2041/public_html/index.html";

while (!system = ls $important_file >/dev/null 2>&1") {
	system "echo \"all OK\"";
	system "sleep 1";
}

system "echo \"Panic $important_file gone\"";


###############################################################
###############################################################
###############################################################


#!/bin/perl -w

my $important_file = "/home/cs2041/public_html/index.html";

while (-e $important_file) {
	print "all OK";
	sleep 1;
}

print "Panic $important_file gone"