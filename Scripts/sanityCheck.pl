#!/perl

use strict;
use Getopt::Long;
use Data::Dumper;
use JSON;

my $usage = "sanityCheck.pl
-file	File to check
-config	Json with config file detailing what the file should look like";

my $file;
my $config;

&GetOptions(
	    'config:s'  	=> \$config,
	    'file:s'		=> \$file  
	    	   );
die ($usage) unless $file && $config;

# load the config from JSON

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $config)
      or die("Can't open \$annotation\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $format = $json->decode($json_text);	   
my $set;

# fetch config for this file
foreach my $conf ( keys %$format){
	if ($file =~ /$conf/){
		print "Using config $conf with file $file\n";
		$set = $format->{$conf};
	}
}

die("No config found to match file $file") unless $set;
my $summarys;

open (FILE,$file) or die("Cannot open file $file for reading\n");
my $line = 0 ;
while (<FILE>){
	chomp;
	$line++;
	next if $line == 1;
	my @array = split("\t");
	for ( my $i = 0 ; $i < scalar(@$set) ; $i++ ){
		my $cell = $array[$i];
		my $f = $set->[$i];
		die("Do not have a format for column $i with value $cell\n") unless $f;
		my @keys = keys %$f;
		if ($f->{$keys[0]}->{"summarise"}){
			$summarys->{$keys[0]}->{$cell}++;
		}
		# test format
		my $test = $f->{$keys[0]}->{"format"};


		unless ( $cell =~ /$test/){
			quarantine($file);
			die("cell $i on row $line (".$keys[0]."), failed formatting test:\n$cell =~ $test \n");
		}
	}
}
if ($line <= 1){
	quarantine($file);
	warn("File $file contained no data\n");
	exit;
}
print STDERR "Summary\n";
print STDERR "Checked $line lines each with " . scalar(@$set) . " columns. All cells pass formating tests.\n";
foreach my $key (keys %$summarys){
	print STDERR "$key:\n";
	foreach my $value ( keys %{$summarys->{$key}}){
		print STDERR "\t$value:\t" .$summarys->{$key}->{$value} ."\n";
	}
}

sub quarantine {
	my ($file) = @_;
	# label the file as failed 
	my $cmd = "mv $file $file.quarantined";
	my $result = system($cmd);
	die("Quantine of file $file failed\n") unless $result == 0;
}
