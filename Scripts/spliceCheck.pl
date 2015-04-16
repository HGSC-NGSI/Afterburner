#!/hgsc_software/perl/latest/bin/perl 

=head1 spliceCheck.pl

 simonw@bcm.edu

=cut

=head1 NAME

MABX.pl

=head1 SYNOPSIS
	
spliceCheck.pl 

-vcf 		Annotated vcf
-tabix	  		Path to tabix,
-ref			Path to refernence,
-samtools		Path to samtools,
-knowngene		Path to knowngene gene set (annovar),
-refgene		Path to refgene   gene set (annovar)

=head1 description

Checks if InDels actually disrupt cannonical splice junctions or meerly add / remove
some bases without changing the donor / acceptor 

=cut

use strict;
use Filter;
use SpliceCheck;
use Vcf;
use Getopt::Long;
use Data::Dumper;

my $usage = "cat vcf | spliceCheck.pl 

-tabix	  		Path to tabix,
-ref			Path to refernence,
-samtools		Path to samtools,
-knowngene		Path to knowngene gene set (annovar),
-refgene		Path to refgene   gene set (annovar)\n";


my $tabix;
my $ref;
my $samtools;
my $knowngene ;
my $refgene;

&GetOptions(
	    'tabix:s'	   	=> \$tabix,
	    'ref:s'			=> \$ref,
	    'samtools:s'	=> \$samtools,
	    'knowngene:s'	=>	\$knowngene,
	    'refgene:s'		=>	\$refgene 	   
	    );
die ($usage) unless  $tabix && $ref && $samtools && $knowngene && $refgene;

# instantiate the splice test and put it into the vcf
my $UCSCCheck   = SpliceCheck->new( $ref, $samtools,$knowngene,$tabix );
my $RefSeqCheck = SpliceCheck->new( $ref, $samtools,$refgene,$tabix  );

# now load the vcf file to be output

# Open VCF file and add all required header lines
my $opts;
my %args;
$args{fh} = \*STDIN;
my $vcf = Vcf->new(%args);
$$opts{vcf} = $vcf;
$vcf->parse_header();
# want to add in the info feild the extra info
my $str =  $vcf->format_header();

my @header = split("\n",$str);
my $ll =  pop(@header);
push (@header,"##INFO=<ID=SPLICING,Number=.,Type=String,Description=\"Result of SpliceCheck test if variant disrupts cannonical splice site.\">");
push (@header,"$ll\n");
$str =  join("\n",@header);
print "$str";

while ( my $line = $vcf->next_line() )
{
	my $x = $vcf->next_data_array($line);
	# is it a SNP or an Indel?

	if ( length($x->[3])  == 1 && length($x->[4]) == 1 ) {
		# do nothing
	} else {
		# special case of splicing filter
      	my $refseqeffect = $vcf->get_info_field($x->[7],"IRF");
      	my $ucsceffect   = $vcf->get_info_field($x->[7],"IUC");
      	$refseqeffect = $vcf->get_info_field($x->[7],"RFG") unless $refseqeffect ; # if we are using annotate task
      	$ucsceffect   = $vcf->get_info_field($x->[7],"UCG") unless $ucsceffect ; # if we are using annotate task;
      	# Add into vcf if the line affects splicing
		if ( $refseqeffect =~ m/splic/  ) {
      		my $rc = $RefSeqCheck->check($line);
      		if ( $rc > 1 ){
      			die("SpliceCheck.pm is throwing exceptions\n");
      		}			
			$x->[7].= ";SPLICING=1" if $rc;
		} elsif ( $ucsceffect =~ m/splic/  ) {
      		my $uc = $UCSCCheck->check($line);
      		if (  $uc > 1){
      			die("SpliceCheck.pm is throwing exceptions\n");
      		}
			$x->[7].= ";SPLICING=1" if $uc;
		}
	}
	# add the extra tag into the line
	 
	print join("\t",@$x) ."\n" ;
}