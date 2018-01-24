Afterburner.pl
=======

Jan 2015

Afterburner is a highly configurable VCF filter, it uses a logical path defined in a .json file to apply a series of 
filters. It uses separate filter sets for SNPs and INDELs and can also use different filters on a per-site
basis as defined in a bed file.

It requires the /Modules folders to be in your perl path - otherwise you can supply it on the command line:


Usage:
perl -I /path/to/Afterburner/Modules/ /path/to/Afterburner/Afterburner.pl 
Afterburner.pl 
-config			json file defining filters 
-vcf 			Annotated vcf
-sites			Override defaults on a regional basis using 
				tabix'd file containing chr start end snpFilter IndelFilter 
-defaultSNP 	default SNP filter set 
-defaultIndel	default Indel filter set
-extraTag		extra tag to record which filter was used (default FL)
-verbose		Write out to STDERR each decision point


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



