#!/hgsc_software/perl/latest/bin/perl 

=head1 Afterburner

 simonw@bcm.edu

=cut

=head1 NAME

Afterburner.pl

=head1 SYNOPSIS
	
Afterburner.pl 

	-config		json file defining filters 
	-vcf 		Annotated vcf (- if streaming from STDIN)
	-sites		Override defaults on a regional basis using 
			file containing chr start end snpFilter IndelFilter 
	-defaultSNP 	default SNP filter set 
	-defaultIndel	default Indel filter set
	-extraTag		extra tag to record which filter was used (default FL)

=head1 description

Configurable VCF filter. Logic is written in json file applying filters on vcf tags.
The filters applied depend on true false outcomes - defined in json using true / false tags.
An optional bed file can be used to apply different sets of filters on a regional basis.

=cut

use strict;
use Filter;
use SpliceCheck;
use Vcf;
use Getopt::Long;
use Data::Dumper;

my $usage = "Afterburner.pl 
-config		json file defining filters 
-vcf 		Annotated vcf (- if streaming from STDIN)
-sites		Override defaults on a regional basis using
		tabix'd file containing chr start end snpFilter IndelFilter 
-defaultSNP 	default SNP filter set 
-defaultIndel	default Indel filter set
-extraTag		extra tag to record which filter was used (default FL)
-verbose		Write out to STDERR each decision point\n";

my $xmlf;
my $sitesf;
my $vcff;
my $defSNP;
my $defIndel;
my $etag = "FL";
my $verbose;
my $type = "";
my $sites;

&GetOptions(
	    'config:s'  	=> \$xmlf,
	    'sites:s'		=> \$sitesf,
	    'vcf:s'			=> \$vcff,
	    'defaultSNP:s' 	=> \$defSNP,
	    'defaultIndel:s' => \$defIndel,	
		'extraTag:s'    =>	\$etag,    
	    'verbose!'		=> \$verbose,   
	    );
die ($usage) unless $xmlf && $vcff && $defSNP && $defIndel ;

# Load the sites file into a hash to begin with 
if ( $sites ){
	open ( SITES,$sitesf) or die("Cannot open sites file $sitesf\n");
	print STDERR "Loading sites file\ ";
	while (<SITES>){
		chomp;
		my ($c,$s,$e,$ss,$id) = split("\t");
		die("Sites file should contain chr start stop snp and indel - not:$_\n")
			unless ( $id);
		for ( my $i = $s ; $i <= $e; $i++ ){
			$sites->{$c}->{$i} = "$ss,$id";
		}
	}			
	print STDERR "..done.\n";
}
my $opts;
my %args;
my $vcf;

# now load the vcf file to be output
if ( $vcff eq "-" ){
	$args{fh} = \*STDIN;
	$vcf = Vcf->new(%args);
} else {
	open ( my $vcfh,$vcff) or die("Cannot open vcf file $vcff\n");
	# Open VCF file and add all required header lines
	%args = ( print_header => 1 );
	if   ( $$opts{region} )         { $args{region} = $$opts{region}; }
	if   ( exists( $$opts{file} ) ) { $args{file}   = $$opts{file}; }
	else                            { $args{fh}     = $vcfh; }
	$vcf = Vcf->new(%args);
}
$$opts{vcf} = $vcf;
$vcf->parse_header();
# want to add in the info feild any extra info
my $str =  $vcf->format_header();
# instantiate the filter module
my ($filter,$extraTags) = Filter->new( -json => $xmlf, -header => $str, verbose => $verbose);


my @header = split("\n",$str);
my $ll =  pop(@header);
push (@header,"##INFO=<ID=$etag,Number=.,Type=String,Description=\"Name of filter used on this site.\">");
foreach my $extra (@$extraTags){
	push (@header,$extra);
}
push (@header,"$ll\n");
$str =  join("\n",@header);
print "$str";

while ( my $line = $vcf->next_line() )
{
	my $x = $vcf->next_data_array($line);
	# is it a SNP or an Indel?
	my $result;
	# default filters
	my $snp = $defSNP;
	my $indel = $defIndel;
	my $info = $x->[7];
	# check for regional override
	if ( my $region = $sites->{$x->[0]}->{$x->[1]}){
		($snp,$indel) = split(",",$region) if $region;
	}

	if ( length($x->[3])  == 1 && length($x->[4]) == 1 ) {
		if ( $verbose ){
			print STDERR "Applying $snp at pos " . $x->[0] .":". $x->[1]  ."\n" unless $type eq $snp;
		} 
		$type = $snp;
		($result,$info) = $filter->applyFilters($snp,$x);
		# add the extra tag to record which filter was used
		$info =~ s/;$//;
		$x->[7] = $info.";$etag=$snp";
	} else {
		if ( $verbose ){
			print STDERR "Applying $indel at pos " . $x->[0] .":". $x->[1] ."\n"unless $type eq $indel ;
		}
		$type = $indel;
		($result,$info) = $filter->applyFilters($indel,$x);
		$info =~ s/;$//;
		# add the extra tag to record which filter was used
		$x->[7] = $info.";$etag=$indel";
	}
	# add the extra tag into the line
	 
	print join("\t",@$x) ."\n" if $result eq 'PASS';
}