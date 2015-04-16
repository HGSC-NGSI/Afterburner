#!/usr/bin/perl
#
#Author:Simon White simonw@bcm.edu
#
use strict;
use warnings;
use Carp;
use Vcf;
use Getopt::Long;
my $tags;
my $blank;
my $snp;
my $indel;
my $nh;

# Vcf-tools filter for selecting lines from a file based on the filter feild
# will also replace or remove 'Dummy' tags used in the custom filters.
my $usage = "zcat file.vcf.gz | vcf2tsv.pl
-tags    	comma separated list of INFO tags to output.
         	if a file is provided it will take that instead
         	just write a list of tags separated by commas or newlines
-blank   	leave entries with no data blank rather than writing n/a
-snp		just output SNPs
-indel		just output InDels
-noheader	skip the header line	
";
&GetOptions(
			 'tags:s'    => \$tags,
			 'blank!'    => \$blank,
			 'snps!'     => \$snp,
			 'indels!'   => \$indel,
			 'noheader!' => \$nh
);
my @tags;

# parse the tags
#is it a file
if ( -e $tags ) {

	#open the file
	open( TAGS, $tags ) or die("Cannot open file $tags\n");
	while (<TAGS>) {
		chomp;
		my @line = split( /,/, $_ );
		push @tags, \@line;
	}
} else {
	foreach my $t ( split( /,/, $tags ) ) {
		push @tags, [$t];
	}
}
die($usage) unless ($tags);

# Open VCF file and add all required header lines
my $opts;
my %args = ( print_header => 1 );
if ( $$opts{region} )         { $args{region} = $$opts{region}; }
if ( exists( $$opts{file} ) ) { $args{file}   = $$opts{file}; }
else { $args{fh} = \*STDIN; }
my $vcf = Vcf->new(%args);
$$opts{vcf} = $vcf;
$vcf->parse_header();

unless ($nh) {

	#1st print the header lines
	foreach my $tag (@tags) {

		# if we have multiple comma separated tags on in the file
		# show all tags and all descriptions
		if ( scalar(@$tag) > 0 ) {
			my $comma = "";
			foreach my $t (@$tag) {
				print "$comma";
				$comma = ",";
			}
			foreach my $t (@$tag) {
				my @header =
				  @{ $vcf->get_header_line( key => 'INFO', ID => $t ) };
				my $h = $header[0];
				if ($h) {
					my $d = $h->{Description};
					$d =~ s/\s+/_/g;
					print $d;
				} else {
					print "$t";
				}
			}
			print "\t";
		} else {
			my @header =
			  @{ $vcf->get_header_line( key => 'INFO', ID => $tag ) };
			my $h = $header[0];
			if ( $h ne "" ) {
				print $h->{Description} . "\t";
			} else {
				print "$tag\t";
			}
		}
	}
	print "\n";
}
while ( my $line = $vcf->next_line() ) {
	my $x = $vcf->next_data_array($line);
	# only SNPs
	if ( $snp ){
		next unless length($x->[3]) == 1 && length($x->[4]) == 1;
	}
	if ($indel){
		next if length($x->[3]) == 1 && length($x->[4]) == 1;
	}
	foreach my $tag (@tags) {
		my $result;
		if ( scalar(@$tag) > 0 ) {
			my %hash;
			foreach my $t (@$tag) {
				my $e = $vcf->get_info_field( $x->[7], $t );
				$hash{$e} = 1 if defined $e;
			}
			foreach my $r ( keys %hash ) {
				$result .= "," if defined $result;
				$result .= "$r";
			}
		} else {
			$result = $vcf->get_info_field( $x->[7], $tag );
		}
		unless ($result) {

			# try in the other feilds
			foreach my $d (@$x) {
				$result = $x->[0] if $tag->[0] eq "CHROM";
				$result = $x->[1] if $tag->[0] eq "POS";
				$result = $x->[3] if $tag->[0] eq "REF";
				$result = $x->[4] if $tag->[0] eq "ALT";
				$result = $x->[5] if $tag->[0] eq "QUAL";
				$result = $x->[6] if $tag->[0] eq "FILTER";
				$result = $x->[7] if $tag->[0] eq "INFO";

	
				if ( $tag->[0] eq "FORMAT" ) {
					if ( $x->[-1] eq "." ) {
						$result = $x->[-2];
					} else {
						$result = $x->[-1];
					}
				}
			}
		}
		$result = "." unless defined $result;
		$result = "."
		  if $result eq "."
		  or $result eq "''"
		  or $result eq '""';
		$result = "" if $blank && $result eq "n/a";
		print "$result\t";
	}
	print "\n";
}
