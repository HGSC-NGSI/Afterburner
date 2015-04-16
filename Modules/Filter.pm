package Filter;

=head1 CONTACT

 simonw@bcm.edu

=cut

=head1 NAME

Modules::Filter 

=head1 SYNOPSIS
	
	my $filter = Modules::Filter->new( -json => $jsonf, -header => $string, verbose => $verbose);
	my $result = $filter->applyFilters($indel,$line);

=head1 description

	module for filtering a vcf line using a generic filter
	logic defined in a json file ie something like:
	{"sets":[
		{"SNP1":[
				{
					"name": "PassFilter",
					"logic": "FILTER eq 'PASS'",
					"true": "HGMD",
					"false": "FAIL"
				},
				{
					"name": "HGMD",
					"logic": "HC ne '.' || ( CD ne '.' && CD < 3 && CD > 8 ) ",
					"true": "FilterAFHGMD",
					"false": "Consequences"
				},

				{
					"name": "Consequences",
					"logic": "RFG =~ m/nonsynonymous/ || RFG =~ m/stop/ || RFG =~ m/splic/ || UCG =~ m/nonsynonymous/ || UCG =~ m/stop/ || UCG =~ m/splic/",
					"true": "PASS",
					"false": "FAIL"
				}
			]}
	]}
	logic is perl code that gets evaluated the tags such as RFG get pulled out the vcf
	You need to keep whitespace between the tags or the code will get confused.

=cut

use strict;
use Data::Dumper;
use Exception;
use Argument qw(rearrange);
use Data::Dumper;
use Scalar::Util qw(looks_like_number);
use lib qw(..);
use JSON qw( );

my $verbose;

=head2 new

  Arg [1]   : None
  Function  : Instantiate object and load and check json
  Returntype: Module::Filter
  Exceptions: Cannot open jsob
  Example   : $filter->new($json);

=cut

sub new {
	my ( $class, @args ) = @_;
	my $self = bless {}, $class;
	my ($jsonf,$header,$info) = rearrange( ['JSON','HEADER','VERBOSE'], @args );
	my $data;
	$verbose = $info;
	my $json_text = do {
		open( my $json_fh, "<:encoding(UTF-8)", $jsonf )
		  or $self->throw("Can't open \$jsonf\": $!\n");
		local $/;
		<$json_fh>;
	};
	my $json = JSON->new;
	my $data = $json->decode($json_text);
	$self->json($data);
	my $extraTags = $self->checkConfig;
	$self->header($header);
	return ($self,$extraTags);
}

=head2 applyFilters

  Arg [1]   : Name (String)
  Arg [2]   : Data (vcf array from Vcf.pm) 
  Function  : Applies Logic to the vcf line, if true it follows
  			  the logic through the data structure untill it comes
  			  to either a PASS or a FAIL
  Returntype: Result (String)
  Exceptions: Throws if Json is not consistent
  Example   : $result = $filter->applyFilters($snp,$x);

=cut

sub applyFilters {
	my ( $self, $name, $data ) = @_;
	
	# put the vcf into data structure
	my $hash = $self->parseVCF($data);
	#print Dumper($hash);
	# 1st get all with the name
	my $set = $self->set($name);
	$self->throw("No set found with name $name\n")
		unless ( $set);
	# start at the beginning
	my $filter = $set->[0];
	my $info = $hash->{INFO};
	$info =~ s/;$//;

	print STDERR $hash->{"CHR"} ." : " . $hash->{POS} ." : ".
		$hash->{REF} ." : " . $hash->{ALT} ."\n" if $verbose;
	# follow the path based on the logic
	while ( $filter ne 'PASS' && $filter ne 'FAIL' ) {
		# need to turn the pseudocode logic into real logic
		# check the logic - make sure we have all the tags
		my $query ="";
		my @logic = split(/\s+/,$filter->{logic});
		foreach my $bit (@logic){
			# is the element a defined tag?
			if ( $self->hasTag($bit)){
			# do we have a value for given tag in the vcf line?
				if ( defined $hash->{$bit} ){
					$query .= $hash->{$bit} ." " ;				
				} else {
					# tag is defined but we dont have a value for it
					$query .= "'.' " ;
				}
			} else {
				$query .= $bit." " ;
			}
		}
		
	
		print STDERR $filter->{logic} ."\n" if $verbose;
		print STDERR "$query\n" if $verbose;

	 	my  $result = eval $query;              # Evaluate that line

	 	if ($@) {   
    		print STDERR join("\t", @$data);                    # Check for compile or run-time errors.
        	$self->throw("Cannot evaluate query :\n $query\n$@");
    	}
    	
		# annotation
		if ( $filter->{tag}  ){
			# write it to the vcf line
			$hash->{INFO} = "$info;" . $filter->{tag} ."=$result;";
			# add it to the hash in case we want to test it later
			if ($result =~ /\d+/ ){
			$hash->{$filter->{tag}} = $result;
			} else {

			$hash->{$filter->{tag}} = '"'.$result.'"';				
			}
			# move onto next filter
			$filter = $self->filter( $name, $filter->{true} );
		} elsif  ($result ){
			print STDERR "TRUE\n" if $verbose;
			$filter = $self->filter( $name, $filter->{true} );
		} else {
			print STDERR "FALSE\n" if $verbose;
			$filter = $self->filter( $name, $filter->{false} );	
		}
	}
	return ($filter,$hash->{INFO});
}

=head2 checkConfig

  Function  : Checks json for allowed structures:
     		  name	-	filter name (Cannot be PASS or FAIL)
			  logic	-	perl logic to execute
	          true	-	filter to use if true
	          false -	filter to use if false
  Returntype: none
  Exceptions: Throws if Json is not consistent
  Example   : $self->checkConfig;

=cut

sub checkConfig {
	my ($self) = @_;

	# json should be sets filters and tag/value/ops
	my $json = $self->json;
	my @extraTags;
	print STDERR "Checking config ";
	$self->throw("no sets defined") unless ( $json->{sets} );

	# sets
	foreach my $FilterSets ( @{ $json->{sets} } ) {
		foreach my $set ( keys %$FilterSets ) {
			print STDERR "SET $set\n" if $verbose;
			foreach my $filter ( @{ $FilterSets->{$set} } ) {

				# tests
				unless (    $filter->{name}
						 && $filter->{logic}
						 && $filter->{true}
						 && $filter->{false} )
				{
					print STDERR  Dumper($filter);
					$self->throw(      "Filters must contain all of the following:\nname\nlogic\ntrue\nfalse\n"
					);
				}
				if (    lc( $filter->{name} ) eq 'pass'
					 or lc( $filter->{name} ) eq 'fail' )
				{
					print STDERR  Dumper($filter);
					$self->throw(      "Filters can not be called PASS or FAIL - these are reserved words\n"
					);
				}
				if ($filter->{tag} && 
					$filter->{description} &&  
					$filter->{number} &&  
					$filter->{type} ){
					# extra tags to add
					push (@extraTags,"##INFO=<ID=".$filter->{tag}.",Number=".$filter->{number}.
					",Type=".$filter->{type}.
					",Description=\"".$filter->{description}."\">");
					# store the extra tag
					$self->{_tags}->{$filter->{tag}} = 1;
				} elsif (
					$filter->{tag} or 
					$filter->{description} or  
					$filter->{number} or 
					$filter->{type}
				) {	print STDERR  Dumper($filter);
					$self->throw("In order to add annotations you must define:\ntag\ndescription\nnumber\ntype\nAs you would in vcf header\n");
				}
				# store them internally
				$self->filter( $set, $filter->{name}, $filter );
			}

			# store the speicial filters
			$self->filter( $set, 'PASS', 'PASS' );
			$self->filter( $set, 'FAIL', 'FAIL' );

			# check that the path through the filters works
			my $count = 0;
			foreach my $filter ( @{ $FilterSets->{$set} } ) {
				$count++;
				if ($count > scalar(@{ $FilterSets->{$set}})){
					$self->throw("Too many paths through filters - do you have a circular reference?\n");
				}
				$self->throw(   "Filter "
							  . $filter->{name}
							  . " in set $set has no true path:\n"
							  . $filter->{true}
							  . " does not exist\n" )
				  unless $self->filter( $set, $filter->{true} );
				$self->throw(   "Filter "
							  . $filter->{name}
							  . " in set $set has no false path:\n"
							  . $filter->{false}
							  . " does not exist\n" )
				  unless $self->filter( $set, $filter->{false} );
			}
			$self->set( $set, $FilterSets->{$set} );
		}
	}
	print STDERR "...ok\n";
	return \@extraTags;
}

=head2 parseVCF

  Function  : Converts elements of VCF line into key - values
  Returntype: hash ref
  Exceptions: Throws unless given an Arrayref
  Example   : $self->parseVCF($arrayRef);

=cut

sub parseVCF {
	my ( $self, $array ) = @_;
	my $hash;
	unless ($array) {
		$self->throw("What the what? \n");
	}
	$hash->{CHR}    = $array->[0];
	$hash->{POS}    = $array->[1];
	$hash->{ID}     = $array->[2];
	$hash->{REF}    = "\"" . $array->[3] . "\"";
	$hash->{ALT}    = "\"" . $array->[4] . "\"";
	$hash->{QUAL}   = $array->[5];
	$hash->{FILTER} = "\"" . $array->[6] . "\"";
	$hash->{INFO}   = $array->[7];
	$hash->{FORMAT} = "\"" . $array->[8] . "\"";
	$hash->{SAMPLE} = "\"" . $array->[9] . "\"";
	my @format = split( ":", $array->[8] );
	my @info   = split( ";", $array->[7] );

	for ( my $i = 0 ; $i < scalar(@info) ; $i++ ) {
		if ( $info[$i] =~ /^(\S+)=(\S+)/ ) {
			if (looks_like_number($2)){
			$hash->{$1} = $2;
			} else {
			$hash->{$1} = '"'.$2.'"';	
			}
		}
	}
	# deal with multisample vcf - refer to 
	# format at TAG.NUM where num = sample number
	# ie DP.1 > DP.2
	for (my $s = 9 ; $s < scalar(@$array) ; $s++) {
		my @sample = split( ":", $array->[$s] );	
		for ( my $i = 0 ; $i < scalar(@format) ; $i++ ) {
			$hash->{  $format[$i]."." . ($s - 8) } = "'" . $sample[$i] . "'" ;
		}
	}
	return $hash;
}

## containers

=head2 filter

  Function  : Container for filter objects
  ARGS[1]   : Filter set name 	(String)
  ARGS[2]   : Filter name  		(String)
  ARGS[3]   : Filters 			(HashRef) 
  Returntype: hash ref
  Exceptions: Throws unless filter name and set name are supplied
  Example   : $self->filter("snp","hgmd",$filters)

=cut

sub filter() {
	my ( $self, $set, $filter, $value ) = @_;
	unless ( defined $set && $filter ) {
		$self->throw("No set and filter name supplied\n");
	}
	if ( defined $value && $filter && $set ) {
		$self->{'_filter'}->{$set}->{ lc($filter) } = $value;
	} else {
		return $self->{'_filter'}->{$set}->{ lc($filter) };
	}
}

=head2 set

  Function  : Container for set objects returns an ordered array of filters
  ARGS[1]   : Filter set name 	(String)
  ARGS[3]   : Filters 			(ArrayRef) 
  Returntype: hash ref
  Exceptions: Throws unless set name  supplied
  Example   : $self->filter("snp",$filters)

=cut

sub set() {
	my ( $self, $set, $filter ) = @_;
	unless ( defined $set ) {
		$self->throw("No set supplied\n");
	}
	if ( defined $filter && $set ) {
		$self->{'_set'}->{$set} = $filter;
	} else {
		return $self->{'_set'}->{$set};
	}
}

=head2 hasTag

  Function  : Checks to see if the tag is defined in the header
  ARGS[1]   : Tag name 	(String)
  Returntype: Boolean
  Exceptions: Throws unless tag name  supplied
  Example   : if ($self->hasTag("GN")){ then print "tag "};

=cut

sub hasTag() {
	my ( $self, $tag ) = @_;
	unless ( defined $tag ) {
		$self->throw("No tag defined\n");
	}
	# be aware of multi sample tags
	# ie DP.2 is in header as just DP

	if ( $tag =~ /(\S+)\.(\d+)/){
		$tag = $1;
	}

	if ( defined $self->{'_tags'}->{$tag}){
		return 1;
	} else {
		return 0;
	}
}

## CONTAINERS ##

=head2 json

  Function  : Container for json objects
  ARGS[1]   : Json
  Returntype: Json
  Exceptions: none
  Example   : 	my $json = JSON->new;
				my $data = $json->decode($json_text);
				$self->json($data);
	
=cut

sub json ( ) {
	my ( $self, $value ) = @_;
	if ( defined $value ) {
		$self->{'_json'} = $value;
	}
	return $self->{'_json'};
}

=head2 header

  Function  : Store for vcf header
  ARGS[1]   : String
  Returntype: None
  Exceptions: none
  Example   : $self->header($header)
	
=cut

sub header ( ) {
	my ( $self, $value ) = @_;
	if ( defined $value ) {
		$self->{'_header'} = $value;
	} else {
		$self->throw("Must pass a header string\n");
	}
	my @lines = split("\n",$value);
	# store tags so we can look up if they are defined in the vcf
	foreach my $line ( @lines){
		if ($line =~ /^##INFO=<ID=(\w+),.*/){
			$self->{'_tags'}->{$1} = 1;
		}
	}
	# store FORMAT tags so we can look up if they are defined in the vcf
	foreach my $line ( @lines){
		if ($line =~ /^##FORMAT=<ID=(\w+),.*/){
			$self->{'_tags'}->{$1} = 1;
		}
	}
	# also need to include column headers 
	my $columns = pop(@lines);
	foreach my $col ( split("\t",$columns)){
		$self->{'_tags'}->{$col} = 1;
	}
}


1;
