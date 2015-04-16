#!perl

=pod

=head1 spliceCheck

  Examines the effect of indels on splice sites

args:
	samtools  Path to samtools
	ref       Faidx indexed reference
	annot     Annovar gene annotation file (tabix'd)
	variant   The indel to examine (Give it the line from the .vcf as it is

usage:
	SpliceCheck->new(samtools,ref,annot);
	if (SpliceCheck->check(variant)){
		# variant is likely deleterious
	}

=cut

package SpliceCheck;
use vars qw(%Config);
use strict;
use Getopt::Long;

sub new {
	my ( $class, $ref, $samtools, $annot, $tabix ) = @_;
	my $self = bless {}, $class;

	# store args
	$self->ref($ref);
	$self->samtools($samtools);
	$self->annot($annot);
	$self->tabix($tabix);
	die(   "Cannot annotate variant without a path to a reference and samtools, tabix and annotation files"
	  )
	  unless $ref && $samtools && $annot && $tabix;
	return $self;
}

sub check {
	my ( $self, $varString ) = @_;
	my $tabix = $self->tabix;
	my $annot = $self->annot;
	my $decision;

	# parse the variant line - something like:
	# 1	200943793	.	CAGGA	C
	if ( $varString =~ /^(\S+)\t(\d+)\t\S+\t(\S+)\t(\S+)*/ ) {
		my $chr = $1;
		my $pos = $2;
		my $ref = $3;
		my $var = $4;
		my @estarts;
		my @eends;
		my $strand;
		my $type;
		my $spliceType;
		my $splice;
	    # print STDERR "VARIANT : $chr $pos $ref $var\n";
		if ( length($ref) > 1 ) {
			$type = "deletion";
		}
		if ( length($var) > 1 ) {
			$type = "insertion";
		}
		die(      "Cannot interpret variant $ref $var is it an insertion or deletion?"
		  )
		  unless $type;

		# fetch the gene annotation for that region
		my $cmd = "$tabix $annot chr$chr:$pos-$pos";

		#print STDERR "Fetching annotation for region: $cmd \n ";
		open( my $fh, "$cmd 2>&1 |" ) or die("Cannot open stream for $cmd");
		while (<$fh>) {
			chomp;
			die("$_\nKILL TABIX: Tabix is giving warnings, best to die now....\n") if $_ eq "[tabix] the index file either does not exist or is older than the vcf file. Please reindex.";
			#print STDERR "PARSING: $_\n";
			my @array   = split("\t");
			my $strand  = $array[2];
			my @eStarts = split( ",", $array[8] );
			my @eEnds   = split( ",", $array[9] );
			die(         "Cannot parse annotation file - different mumber of exon starts and ends\n"
			  )
			  unless ( scalar(@eStarts) == scalar(@eEnds) );

			# so where is the exon in relation to this variant?
			for ( my $i = 0 ; $i < scalar(@eStarts) ; $i++ ) {
				if (    $pos >= $eStarts[$i] - 5
					 && $pos <= $eStarts[$i] + 5 )
				{

					# throw out introns < 7bp
					if ( $i > 0 && $i < scalar(@eStarts) ) {

						# what is the intron length?
						my $len = $eStarts[$i] - $eEnds[ $i - 1 ];
						if ( $len <= 7 ) {

			  # intron is too small - just throw it out
			  # print STDERR "Intron is very small $len bp - discarding indel\n";
							last;
						}
					}

					# when fetching seuence fetch enough to cover the length
					# of the deletion + 5bp
					my $pad = 5;
					$pad += length($ref) if $type eq 'deletion';
					my $seq = $self->fetchSeq( $chr,
											   $eStarts[$i] - 5,
											   $eStarts[$i] + $pad );

					#print STDERR "This is the sequence $seq\n";
					# what type of splice is it?
					if ( $strand eq "-" ) {
						$spliceType = "donor";
						$splice     = "AC";
					} else {
						$spliceType = "acceptor";
						$splice     = "AG";
					}

					# what does it become?
					my $newSeq =
					  $self->adjustSequence( $ref, $var, $pos, $seq,
											 $eStarts[$i] - 5,
											 $type, 5 );

					#print STDERR "Now we have          $newSeq\n";
					# is our splice cannonical?
					if ( uc( substr( $seq, 4, 2 ) ) eq $splice ) {

						#print STDERR "Splice is canonical\n";
						$decision = 'maybe';
					} else {

						#print STDERR "Splice is non-canonical\n";
						$decision = 'throw';
					}

					# is it STILL cannonical?
					if ( uc( substr( $newSeq, 4, 2 ) ) eq $splice ) {

					  #print STDERR "Splice is still canonical after indel :\n";
						$decision = 'throw';
					} else {
						if ( $decision eq 'maybe' ) {

							# the splice was cannonical - now it is disrupted
							# it may be deleterious
							print STDERR "VARIANT $chr $pos $ref $var - splice site is disrupted :\n";
							print STDERR lc( substr( $seq, 0, 4 ) )
							  . uc( substr( $seq, 4, 2 ) )
							  . lc( substr( $seq, 6 ) ) . "\n";
							print STDERR lc( substr( $newSeq, 0, 4 ) )
							  . uc( substr( $newSeq, 4, 2 ) )
							  . lc( substr( $newSeq, 6 ) ) . "\n";

							return 1 if $decision eq 'maybe';
						}
					}
				}
				if (    $pos >= $eEnds[$i] - 5
					 && $pos <= $eEnds[$i] + 5 )
				{

					# throw out introns < 7bp
					if ( $i > 0 && $i < scalar(@eStarts) ) {

						# what is the intron length?
						my $len = $eStarts[ $i + 1 ] - $eEnds[$i];
						if ( $len <= 7 ) {

			  # intron is too small - just throw it out
			  #print STDERR "Intron is very small $len bp - discarding indel\n";
							last;
						}
					}

					# when fetching seuence fetch enough to cover the length
					# of the deletion + 5bp
					my $pad = 5;
					$pad += length($ref) if $type eq 'deletion';
					my $seq =
					  $self->fetchSeq( $chr, $eEnds[$i] - 5,
									   $eEnds[$i] + $pad );

					#print STDERR "This is the sequence $seq\n";
					# what type of splice is it?
					if ( $strand eq "+" ) {
						$spliceType = "donor";
						$splice     = "GT";
					} else {
						$spliceType = "acceptor";
						$splice     = "CT";
					}

					# what does it become?
					my $newSeq =
					  $self->adjustSequence( $ref, $var, $pos, $seq,
											 $eEnds[$i] - 5,
											 $type, 7 );

					#print STDERR "Now we have          $newSeq\n";
					# is our splice cannonical?
					if ( uc( substr( $seq, 6, 2 ) ) eq $splice ) {

						#print STDERR "Splice is canonical\n";
						$decision = 'maybe';
					} else {

						#print STDERR "Splice is non-canonical\n";
						$decision = 'throw';
					}

					# is our splice still cannonical?
					if ( uc( substr( $newSeq, 6, 2 ) ) eq $splice ) {

					   #print STDERR "Splice is still canonical after indels\n";
					} else {
						if ( $decision eq 'maybe' ) {
							print STDERR "VARIANT $chr $pos $ref $var - splice site is disrupted :\n";
							print STDERR lc( substr( $seq, 0, 6 ) )
							  . uc( substr( $seq, 6, 2 ) )
							  . lc( substr( $seq, 8 ) ) . "\n";
							print STDERR lc( substr( $newSeq, 0, 6 ) )
							  . uc( substr( $newSeq, 6, 2 ) )
							  . lc( substr( $newSeq, 8 ) ) . "\n";

							# the splice was cannonical - now it is disrupted
							# it may be deleterious
							return 1;
						}
					}
				}
			}
		}
	} else {
		die("Cannot interpret variant string $varString");
	}
	return 0;
}

sub fetchSeq {
	my ( $self, $chr, $start, $end ) = @_;
	my $string;
	my $cmd = $self->samtools . " faidx " . $self->ref . " $chr:$start-$end";

	#print STDERR "Executing: $cmd\n";
	open( my $fh, "$cmd |" ) or die("Cannot open stream for $cmd");
	while (<$fh>) {
		chomp;
		next if $_ =~ /^>/;
		$string = $_;
	}
	return $string;
}

sub adjustSequence {

	# what will the sequence become once the indel is indit
	my ( $self, $ref, $var, $pos, $seq, $seqPos, $type, $ssp ) = @_;
	my $string;

	# where do we insert
	# the position of the indel is one
	# after the base in the vcf
	# and we need to add another 1 to get
	# the base position correct
	my $ip = ( $pos - $seqPos ) + 2;
	#print STDERR "IP $ip - SSP $ssp pos $pos seqpos $seqPos\n";
	if ( $type eq 'insertion' ) {

		# if the insertion is before the splice site position we need
		# to shorten the string to maintain the position of the site in the
		# string for when we do the cannonical check
		$string = substr( $seq, 0, $ip - 2 );
		$string .= $var;
		$string .= substr( $seq, $ip - 1 );
		# only shift left if we are inserting into intron
		if ( $ip <= $ssp && $ssp == 5) {
			# trim
			$string = substr( $string, length($var) - 1 );
		}
	}
	if ( $type eq 'deletion' ) {

		# if the deletion is before the splice site position we need
		# to pad the string to maintain the position of the site in the
		# string for when we do the cannonical check
		if ( $ip <= $ssp && $ssp == 5 ) {
			for ( my $i = 0 ; $i < length($ref) - 1 ; $i++ ) {
				$string .= "X";
			}
		}
		$string .= substr( $seq, 0, $ip - 1 );
		$string .= substr( $seq, ( $ip + length($ref) ) - 2 );
	}
	return $string;
}

# getters / setters
sub ref {
	my ( $self, $ref ) = @_;
	if ($ref) {

		# test
		die("Cannot find file $ref\n")
		  unless -e $ref;
		$self->{'_ref'} = $ref;
	}
	return $self->{'_ref'};
}

sub annot {
	my ( $self, $annot ) = @_;
	if ($annot) {

		# test
		die("Cannot find file $annot\n")
		  unless -e $annot;
		$self->{'_annot'} = $annot;
	}
	return $self->{'_annot'};
}

sub samtools {
	my ( $self, $samtools ) = @_;
	if ($samtools) {

		# test
		die("Cannot find file $samtools\n")
		  unless -e $samtools;
		$self->{'_samtools'} = $samtools;
	}
	return $self->{'_samtools'};
}

sub tabix {
	my ( $self, $tabix ) = @_;
	if ($tabix) {

		# test
		die("Cannot find file $tabix\n")
		  unless -e $tabix;
		$self->{'_tabix'} = $tabix;
	}
	return $self->{'_tabix'};
}
return 1;
