MABX.pl
=======

Jan 2015

MABX is a highly configurable VCF filter, it uses a logical path defined in a .json file to apply a series of 
filters. It uses separate filter sets for SNPs and INDELs and can also use different filters on a per-site
basis as defined in a bed file.

It requires the /Modules folders to be in your perl path - otherwise you can supply it on the command line:


Usage:
perl -I /path/to/MABX/Modules/ /path/to/MABX/MABX.pl 
MABX.pl 
-config			json file defining filters 
-vcf 			Annotated vcf
-sites			Override defaults on a regional basis using 
				tabix'd file containing chr start end snpFilter IndelFilter 
-defaultSNP 	default SNP filter set 
-defaultIndel	default Indel filter set
-extraTag		extra tag to record which filter was used (default FL)
-verbose		Write out to STDERR each decision point

* = specific to Mendelian Afterburner implemetation ( might take this out for a more general release)
For sample specific data use the equivalent FORMAT tag and the number of the sample ie: DP.1 = Depth of 1st (leftmost) sample 

Example json config:

{
	"sets": [{
			"SNP1": [{									-name of the filer set
					"name": "PassFilter",				-name of the filter
					"logic": "FILTER eq 'PASS'",		-perl logic that is evaluated, VCF column names and tags
														-are parsed out and replaced with appropriate values
					"true": "HGMD",						-step to go to if the logic evaluates to true
					"false": "FAIL"						-step to go to if the logic evaluates to false
														-FAIL indicates stop here and do not output this variant
				},{
					"name": "HGMD",						-next filter
					"logic": "HC ne '.' ",				-HC = HGMD variant category tag from vcf
					"true": "FAIL",						-FAIL
					"false": "Consequences"				-move onto next step if false
				},{
					"name": "Consequences",
					"logic": "RFG =~ m/nonsynonymous/",	-variant is annotated as nonsynonymous
					"true": "PASS",						-PASS - end of logic variant gets written to output
					"false": "FAIL"						-FAIL
				}]
			}]
}

The code expects at least one set for SNPs and one for Indels - you could set them both to the same set if needed.

Example sites file:
17	7404209	7404209	SNP2	INDEL2
17	7411855	7411855	SNP2	INDEL2
17	7416599	7416599	SNP2	INDEL2
17	7416683	7416683	SNP2	INDEL2
17	7417086	7417086	SNP2	INDEL2
17	7462555	7462555	SNP2	INDEL2

This defines a 1-based set of regions for which to apply a different set of filters.

VALENCE
=======
Run the mendelian workflow using Valence as follows:
Valence.py -w (working directory)  -a SAMPLE=(sample name),OUTDIR=(output directory),\
SNPVCF=(Annotated SNP VCF),INDELVCF=(Annotated INDEl VCF) -o (filled in xml) \
 /path/to/MABX/Valence/MendelianAB.xml 
 


Other useful tools are vcf2tsv in the Scripts directory which will reformat the vcf into a tsv file with the columns
ordered by a config file of vcf headers or tags ie:
perl -I /path/to/MABX/Modules/ /path/to/MABX/Scripts/vcf2tsv.pl 
zcat file.vcf.gz | vcf2tsv.pl
-tags    	comma separated list of INFO tags to output.
         	if a file is provided it will take that instead
         	just write a list of tags separated by commas or newlines
-blank   	leave entries with no data blank rather than writing n/a
-snp		just output SNPs
-indel		just output InDels
-noheader	skip the header line

example tags file:
CHROM
POS
REF
ALT
QUAL
FILTER
SAMPLE
PU		-pileup (vcf tag)
RFG		-refseq gene name (vcf tag)
UCG		-ucsc gene name (vcf tag)

Finally sanityCheck.pl in the Scripts directory is used for comparing a tsv with a json file defining what type 
of data you would expect the tsv to have in each column - numbers, strings etc. Useful for catching formatting
errors before they get propagated. The code will throw an exception and rename the output file to file.quarantined
pending investigation.
perl -I /path/to/MABX/Modules/ /path/to/MABX/Scripts/sanityCheck.pl 
sanityCheck.pl
-file	File to check
-config	Json with config file detailing what the file should look like 

Example config file:
{
	".*.aricfilt.xls": [											-apply to filenames matching this regex
	{"CHROM": 					{"format": "\\S+"}},				-format should be a string
	{"POS": 					{"format": "\\d+"}},				-format should be a number
	{"Pileup_data": 			{"format": "\\.|\\S+"}},			-format should be either a string or "."
	{"Mutation_type_(Refseq)": 	{"format": "\\S+","summarise": 1}}	-string, summarize the output of this field on completion
	]
}

