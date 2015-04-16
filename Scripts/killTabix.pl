#!/usr/bin/perl
#
#Author:Simon White simonw@bcm.edu
# very simple wrapper to check STDERR from Tabix
# and throw exceptions is anything is screwy
#
use strict;
use warnings;
use Carp;

my $fh = *STDIN;

while (<$fh>){
	print STDOUT "$_";
	die("KILL TABIX: Tabix is giving warnings, best to die now....\n") if $_ eq "[tabix] the index file either does not exist or is older than the vcf file. Please reindex.";
}