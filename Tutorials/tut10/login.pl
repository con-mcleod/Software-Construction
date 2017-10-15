#!/usr/bin/perl -w

#use strict;

print "Username: ";
$username = <STDIN>;

print "Password: ";
$password = <STDIN>;

chomp $username;
chomp $password;

open PWORD_FILE, '<', "users/$username.password" or (print "Unknown username!\n" and exit 1);

$correct_password = <PWORD_FILE>;

chomp $correct_password;

if ($correct_password eq $password) {
	print "You are authenticated\n";
} else {
	print "Incorrect password\n";
}