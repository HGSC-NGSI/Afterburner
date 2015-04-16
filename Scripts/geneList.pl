# add omim, genetest and hgmd info

{
  header   => [
    qq[key=INFO,ID=GT,Number=1,Type=String,Description="GENE_CATEGORY"],
    qq[key=INFO,ID=GTD,Number=1,Type=String,Description="DiseaseOriginal"],
      ],
  tag      => 'Dummy',
  test     => sub {
    # Data in embedded in the script

    unless (  %genetest ) {
      my $data = getData();
      my @lines = split(/\n/,$data);
      foreach my $line (@lines){
        chomp;
        my @array = split(/\t/,$line);
        $genetest{$array[0]}{'disease'} = $array[1];
        $genetest{$array[0]}{'omim'} = 1 if $array[2] eq 'OMIM';
        $genetest{$array[0]}{'hgmd'} = 1 if $array[3] eq 'HGMD';
        $genetest{$array[0]}{'genetest'} = 1 if $array[4] eq 'GENETEST';     
      }
    }
    # now to add the info into the vcf
    my $SNPGeneName    = $VCF->get_info_field($$RECORD[7],'GN');
    my $INDELGeneName  = $VCF->get_info_field($$RECORD[7],'IGN');
    my $name;
    # pick a gene name
    if ($INDELGeneName && $SNPGeneName eq ""){
    	$name = $INDELGeneName;
    } else {
    	$name = $SNPGeneName;
    }

    my $string = 'OTHER';
    if( $name ) {
      $string = 'OMIM' if $genetest{$name}{'omim'};
      $string = 'HGMD' if $genetest{$name}{'hgmd'};
      $string = 'GENETEST' if $genetest{$name}{'genetest'};
    }
	my $disease =  $genetest{$name}{'disease'};
	$disease =~ s/ /_/g;
	$disease =~ s/;/,/g;
		
    # add to the vcf
    $$RECORD[7] = $VCF->add_info_field($$RECORD[7],'GT'=>$string); 
    $$RECORD[7] = $VCF->add_info_field($$RECORD[7],'GTD'=>"'" . $disease . "'"); 
  
  return $PASS;

  sub getData {
    return "A2M	Alpha-2-macroglobulin deficiency [MIM:614036]	OMIM	HGMD
AAAS	Achalasia-addisonianism-alacrimia syndrome [MIM:231550]	OMIM	HGMD	GENETEST
AAGAB	Keratoderma, palmoplantar, punctate type IA [MIM:148600]	OMIM	
AARS	Charcot-Marie-Tooth disease, axonal, type 2N [MIM:613287]	OMIM	HGMD	GENETEST
AARS2	Combined oxidative phosphorylation deficiency 8 [MIM:614096]	OMIM	HGMD	GENETEST
AASS	Hyperlysinemia [MIM:238700]; Saccharopinuria [MIM:268700]	OMIM	HGMD	GENETEST
ABAT	GABA-transaminase deficiency [MIM:613163]	OMIM	HGMD	GENETEST
ABCA1	HDL deficiency, type 2 [MIM:604091]; Tangier disease [MIM:205400]	OMIM	HGMD	GENETEST
ABCA12	Ichthyosis, autosomal recessive 4B (harlequin) [MIM:242500]; Ichthyosis, congenital, autosomal recessive 4A [MIM:601277]	OMIM	HGMD	GENETEST
ABCA3	Surfactant metabolism dysfunction, pulmonary, 3 [MIM:610921]	OMIM	HGMD	GENETEST
ABCA4	Cone-rod dystrophy 3 [MIM:604116]; Macular degeneration, age-related, 2 [MIM:153800]; Retinitis pigmentosa 19 [MIM:601718]; Stargardt disease 1 [MIM:248200]	OMIM	HGMD	GENETEST
ABCB11	Cholestasis, benign recurrent intrahepatic, 2 [MIM:605479]; Cholestasis, progressive familial intrahepatic 2 [MIM:601847]	OMIM	HGMD	GENETEST
ABCB4	Cholestasis, intrahepatic, of pregnancy, 3 [MIM:614972]; Cholestasis, progressive familial intrahepatic 3 [MIM:602347]; Gallbladder disease 1 [MIM:600803]	OMIM	HGMD	GENETEST
ABCB6	Microphthalmia, isolated, with coloboma 7 [MIM:614497]	OMIM	HGMD
ABCB7	Anemia, sideroblastic, with ataxia [MIM:301310]	OMIM	HGMD	GENETEST
ABCC2	Dubin-Johnson syndrome [MIM:237500]	OMIM	HGMD	GENETEST
ABCC6	Arterial calcification, generalized, of infancy, 2 [MIM:614473]; Pseudoxanthoma elasticum [MIM:264800]; Pseudoxanthoma elasticum, forme fruste [MIM:177850]	OMIM	HGMD	GENETEST
ABCC8	Diabetes mellitus, noninsulin-dependent [MIM:125853]; Diabetes mellitus, permanent neonatal [MIM:606176]; Diabetes mellitus, transient neonatal 2 [MIM:610374]; Hyperinsulinemic hypoglycemia, familial, 1 [MIM:256450]; Hypoglycemia of infancy, leucine-sensitive [MIM:240800]	OMIM	HGMD	GENETEST
ABCC9	Atrial fibrillation, familial, 12 [MIM:614050]; Cardiomyopathy, dilated, 1O [MIM:608569]; Hypertrichotic osteochondrodysplasia [MIM:239850]	OMIM	HGMD	GENETEST
ABCD1	Adrenoleukodystrophy [MIM:300100]	OMIM	HGMD	GENETEST
ABCD4	Methylmalonic aciduria and homocystinuria, cblJ type [MIM:614857]	OMIM		GENETEST
ABCG5	Sitosterolemia [MIM:210250]	OMIM	HGMD	GENETEST
ABCG8	Gallbladder disease 4 [MIM:611465]; Sitosterolemia [MIM:210250]	OMIM	HGMD	GENETEST
ABHD12	Polyneuropathy, hearing loss, ataxia, retinitis pigmentosa, and cataract [MIM:612674]	OMIM	HGMD	GENETEST
ABHD5	Chanarin-Dorfman syndrome [MIM:275630]	OMIM	HGMD	GENETEST
ABL1	Leukemia, Philadelphia chromosome-positive, resistant to imatinib	OMIM	
ABL2	Leukemia, acute myeloid, with eosinophilia	OMIM	
ACACA	Acetyl-CoA carboxylase deficiency [MIM:613933]	OMIM	HGMD
ACAD8	Isobutyryl-CoA dehydrogenase deficiency [MIM:611283]	OMIM	HGMD	GENETEST
ACAD9	ACAD9 deficiency [MIM:611126]	OMIM	HGMD	GENETEST
ACADM	Acyl-CoA dehydrogenase, medium chain, deficiency of [MIM:201450]	OMIM	HGMD	GENETEST
ACADS	Acyl-CoA dehydrogenase, short-chain, deficiency of [MIM:201470]	OMIM	HGMD	GENETEST
ACADSB	2-methylbutyrylglycinuria [MIM:610006]	OMIM	HGMD	GENETEST
ACADVL	VLCAD deficiency [MIM:201475]	OMIM	HGMD	GENETEST
ACAN	Osteochondritis dissecans, short stature, and early-onset osteoarthritis [MIM:165800]; Spondyloepimetaphyseal dysplasia, aggrecan type [MIM:612813]; Spondyloepiphyseal dysplasia, Kimberley type [MIM:608361]	OMIM	HGMD
ACAT1	Alpha-methylacetoacetic aciduria [MIM:203750]	OMIM	HGMD	GENETEST
ACE	Renal tubular dysgenesis [MIM:267430]	OMIM	HGMD	GENETEST
ACO2	Infantile cerebellar-retinal degeneration [MIM:614559]	OMIM	
ACOX1	Peroxisomal acyl-CoA oxidase deficiency [MIM:264470]	OMIM	HGMD	GENETEST
ACP5	Spondyloenchondrodysplasia with immune dysregulation [MIM:607944]	OMIM	HGMD
ACSF3	Combined malonic and methylmalonic aciduria [MIM:614265]	OMIM	HGMD	GENETEST
ACSL4	Mental retardation, X-linked 63 [MIM:300387]	OMIM	HGMD	GENETEST
ACSL6	Myelodysplastic syndrome; Myelogenous leukemia, acute	OMIM	
ACTA1	Myopathy, actin, congenital, with cores; Myopathy, congenital, with fiber-type disproportion 1 [MIM:255310]; Myopathy, nemaline, 3 [MIM:161800]	OMIM	HGMD	GENETEST
ACTA2	Aortic aneurysm, familial thoracic 6 [MIM:611788]; Moyamoya disease 5 [MIM:614042]; Multisystemic smooth muscle dysfunction syndrome [MIM:613834]	OMIM	HGMD	GENETEST
ACTB	Baraitser-Winter syndrome 2 [MIM:243310]; Dystonia, juvenile-onset [MIM:607371]	OMIM	HGMD	GENETEST
ACTC1	Atrial septal defect 5 [MIM:612794]; Cardiomyopathy, dilated, 1R [MIM:613424]; Cardiomyopathy, familial hypertrophic, 11 [MIM:612098]	OMIM	HGMD	GENETEST
ACTG1	Baraitser-Winter syndrome 2 [MIM:614583]; Deafness, autosomal dominant 20/26 [MIM:604717]	OMIM	HGMD	GENETEST
ACTN2	Cardiomyopathy, dilated, 1AA [MIM:612158]	OMIM	HGMD	GENETEST
ACTN4	Glomerulosclerosis, focal segmental, 1 [MIM:603278]	OMIM	HGMD	GENETEST
ACVR1	Fibrodysplasia ossificans progressiva [MIM:135100]	OMIM	HGMD	GENETEST
ACVR2B	Heterotaxy, visceral, 4, autosomal [MIM:613751]	OMIM	HGMD	GENETEST
ACVRL1	Telangiectasia, hereditary hemorrhagic, type 2 [MIM:600376]	OMIM	HGMD	GENETEST
ACY1	Aminoacylase 1 deficiency [MIM:609924]	OMIM	HGMD
ADA	Adenosine deaminase deficiency, partial [MIM:102700]	OMIM	HGMD	GENETEST
ADAM17	Inflammatory skin and bowel disease, neonatal [MIM:614328]	OMIM	HGMD
ADAM9	Cone-rod dystrophy 9 [MIM:612775]	OMIM	HGMD	GENETEST
ADAMTS10	Weill-Marchesani syndrome 1, recessive [MIM:277600]	OMIM	HGMD	GENETEST
ADAMTS13	Thrombotic thrombocytopenic purpura, familial [MIM:274150]	OMIM	HGMD	GENETEST
ADAMTS17	Weill-Marchesani-like syndrome [MIM:613195]	OMIM	HGMD	GENETEST
ADAMTS18	Knobloch syndrome 2 [MIM:608454]	OMIM	HGMD
ADAMTS2	Ehlers-Danlos syndrome, type VIIC [MIM:225410]	OMIM	HGMD
ADAMTSL2	Geleophysic dysplasia 1 [MIM:231050]	OMIM	HGMD	GENETEST
ADAMTSL4	Ectopia lentis, isolated, autosomal recessive [MIM:225100]	OMIM	HGMD	GENETEST
ADAR	Aicardi-Goutieres syndrome 6 [MIM:615010]; Dyschromatosis symmetrica hereditaria [MIM:127400]	OMIM	HGMD	GENETEST
ADCK3	Coenzyme Q10 deficiency, primary, 4 [MIM:612016]	OMIM	HGMD	GENETEST
ADCY5	Dyskinesia, familial, with facial myokymia [MIM:606703]	OMIM	
ADIPOQ	Adiponectin deficiency [MIM:612556]	OMIM	HGMD
ADK	Hypermethioninemia due to adenosine kinase deficiency [MIM:614300]	OMIM	HGMD	GENETEST
ADRB2	Beta-2-adrenoreceptor agonist, reduced response to	OMIM	HGMD	GENETEST
ADSL	Adenylosuccinase deficiency [MIM:103050]	OMIM	HGMD	GENETEST
AFF2	Mental retardation, X-linked, FRAXE type [MIM:309548]	OMIM		GENETEST
AFG3L2	Ataxia, spastic, 5, autosomal recessive [MIM:614487]; Spinocerebellar ataxia 28 [MIM:610246]	OMIM	HGMD	GENETEST
AGA	Aspartylglucosaminuria [MIM:208400]	OMIM	HGMD	GENETEST
AGK	Cataract, autosomal recessive congenital 5 [MIM:614691]; Sengers syndrome [MIM:212350]	OMIM	HGMD	GENETEST
AGL	Glycogen storage disease IIIa [MIM:232400]	OMIM	HGMD	GENETEST
AGPAT2	Lipodystrophy, congenital generalized, type 1 [MIM:608594]	OMIM	HGMD	GENETEST
AGPS	Rhizomelic chondrodysplasia punctata, type 3 [MIM:600121]	OMIM	HGMD	GENETEST
AGRN	Myasthenia, limb-girdle, familial [MIM:254300]	OMIM	HGMD	GENETEST
AGT	Renal tubular dysgenesis [MIM:267430]	OMIM	HGMD	GENETEST
AGTR1	Hypertension, essential [MIM:145500]; Renal tubular dysgenesis [MIM:267430]	OMIM	HGMD	GENETEST
AGTR2	Mental retardation, X-linked 88 [MIM:300852]	OMIM	HGMD	GENETEST
AGXT	Hyperoxaluria, primary, type 1 [MIM:259900]	OMIM	HGMD	GENETEST
AHCY	Hypermethioninemia with deficiency of S-adenosylhomocysteine hydrolase [MIM:613752]	OMIM	HGMD	GENETEST
AHI1	Joubert syndrome-3 [MIM:608629]	OMIM	HGMD	GENETEST
AICDA	Immunodeficiency with hyper-IgM, type 2 [MIM:605258]	OMIM	HGMD	GENETEST
AIFM1	Combined oxidative phosphorylation deficiency 6 [MIM:300816]; Cowchock syndrome [MIM:310490]	OMIM	HGMD	GENETEST
AIMP1	Leukodystrophy, hypomyelinating, 3 [MIM:260600]	OMIM	HGMD	GENETEST
AIP	Pituitary adenoma, ACTH-secreting [MIM:219090]; Pituitary adenoma, growth hormone-secreting [MIM:102200]; Pituitary adenoma, prolactin-secreting [MIM:600634]	OMIM	HGMD	GENETEST
AIPL1	Cone-rod dystrophy [MIM:604393]	OMIM	HGMD	GENETEST
AIRE	Autoimmune polyendocrinopathy syndrome , type I, with or without reversible metaphyseal dysplasia [MIM:240300]	OMIM	HGMD	GENETEST
AK1	Hemolytic anemia due to adenylate kinase deficiency [MIM:612631]	OMIM	HGMD
AK2	Reticular dysgenesis [MIM:267500]	OMIM	HGMD
AKAP9	Long QT syndrome-11 [MIM:611820]	OMIM	HGMD	GENETEST
AKR1C2	46XY sex reversal 8 [MIM:614279]; Obesity, hyperphagia, and developmental delay	OMIM	HGMD
AKR1D1	Bile acid synthesis defect, congenital, 2 [MIM:235555]	OMIM	HGMD	GENETEST
AKT2	Diabetes mellitus, type II [MIM:125853]; Hypoinsulinemic hypoglycemia with hemihypertrophy [MIM:240900]	OMIM	HGMD
AKT3	Megalencephaly-polymicrogyria-polydactyly-hydrocephalus syndrome [MIM:603387]	OMIM		GENETEST
ALAD	Porphyria, acute hepatic [MIM:612740]	OMIM	HGMD	GENETEST
ALAS2	Anemia, sideroblastic, X-linked [MIM:300751]; Protoporphyria, erythropoietic, X-linked [MIM:300752]	OMIM	HGMD	GENETEST
ALB	Analbuminemia	OMIM	HGMD	GENETEST
ALDH18A1	Cutis laxa, autosomal recessive, type IIIA [MIM:219150]	OMIM	HGMD	GENETEST
ALDH2	Alcohol sensitivity, acute [MIM:610251]	OMIM	HGMD
ALDH3A2	Sjogren-Larsson syndrome [MIM:270200]	OMIM	HGMD	GENETEST
ALDH4A1	Hyperprolinemia, type II [MIM:239510]	OMIM	HGMD	GENETEST
ALDH5A1	Succinic semialdehyde dehydrogenase deficiency [MIM:271980]	OMIM	HGMD	GENETEST
ALDH6A1	Methylmalonate semialdehyde dehydrogenase deficiency [MIM:614105]	OMIM	HGMD	GENETEST
ALDH7A1	Epilepsy, pyridoxine-dependent [MIM:266100]	OMIM	HGMD	GENETEST
ALDOA	Glycogen storage disease XII [MIM:611881]	OMIM	HGMD	GENETEST
ALDOB	Fructose intolerance [MIM:229600]	OMIM	HGMD	GENETEST
ALG1	Congenital disorder of glycosylation, type Ik [MIM:608540]	OMIM	HGMD	GENETEST
ALG11	Congenital disorder of glycosylation, type Ip [MIM:613661]	OMIM	HGMD	GENETEST
ALG12	Congenital disorder of glycosylation, type Ig [MIM:607143]	OMIM	HGMD	GENETEST
ALG13	Congenital disorder of glycosylation, type Is [MIM:300884]	OMIM		GENETEST
ALG2	Congenital disorder of glycosylation, type Ii [MIM:607906]	OMIM	HGMD	GENETEST
ALG3	Congenital disorder of glycosylation, type Id [MIM:601110]	OMIM	HGMD	GENETEST
ALG6	Congenital disorder of glycosylation, type Ic [MIM:603147]	OMIM	HGMD	GENETEST
ALG8	Congenital disorder of glycosylation, type Ih [MIM:608104]	OMIM	HGMD	GENETEST
ALG9	Congenital disorder of glycosylation, type Il [MIM:608776]	OMIM	HGMD	GENETEST
ALMS1	Alstrom syndrome [MIM:203800]	OMIM	HGMD	GENETEST
ALOX12B	Ichthyosis, congenital, autosomal recessive 2 [MIM:242100]	OMIM	HGMD	GENETEST
ALOXE3	Ichthyosis, congenital, autosomal recessive 3 [MIM:606545]	OMIM	HGMD	GENETEST
ALPL	Hypophosphatasia, childhood [MIM:241510]; Hypophosphatasia, infantile [MIM:241500]; Odontohypophosphatasia [MIM:146300]	OMIM	HGMD	GENETEST
ALS2	Amyotrophic lateral sclerosis 2, juvenile [MIM:205100]; Primary lateral sclerosis, juvenile [MIM:606353]; Spastic paralysis, infantile onset ascending [MIM:607225]	OMIM	HGMD	GENETEST
ALX1	Frontonasal dysplasia 3 [MIM:613456]	OMIM	HGMD
ALX3	Frontonasal dysplasia 1 [MIM:136760]	OMIM	HGMD	GENETEST
ALX4	Frontonasal dysplasia 2 [MIM:613451]; Parietal foramina 2 [MIM:609597]	OMIM	HGMD	GENETEST
AMACR	Alpha-methylacyl-CoA racemase deficiency [MIM:614307]; Bile acid synthesis defect, congenital, 4 [MIM:214950]	OMIM	HGMD	GENETEST
AMELX	Amelogenesis imperfecta, hypoplastic/hypomaturation type 1E [MIM:301200]	OMIM	HGMD	GENETEST
AMER1	Osteopathia striata with cranial sclerosis [MIM:300373]	OMIM		GENETEST
AMH	Persistent Mullerian duct syndrome, type I [MIM:261550]	OMIM	HGMD
AMHR2	Persistent Mullerian duct syndrome, type II [MIM:261550]	OMIM	HGMD
AMN	Megaloblastic anemia-1, Norwegian type [MIM:261100]	OMIM	HGMD	GENETEST
AMPD1	Myoadenylate deaminase deficiency	OMIM	HGMD	GENETEST
AMT	Glycine encephalopathy [MIM:605899]	OMIM	HGMD	GENETEST
ANG	Amyotrophic lateral sclerosis 9 [MIM:611895]	OMIM	HGMD	GENETEST
ANGPTL3	Hypobetalipoproteinemia, familial, 2 [MIM:605019]	OMIM	HGMD
ANK1	Spherocytosis, type 1 [MIM:182900]	OMIM	HGMD	GENETEST
ANK2	Long QT syndrome-4 [MIM:600919]	OMIM	HGMD	GENETEST
ANKH	Chondrocalcinosis 2 [MIM:118600]; Craniometaphyseal dysplasia [MIM:123000]	OMIM	HGMD	GENETEST
ANKK1	Dopamine receptor D2, reduced brain density of	OMIM	HGMD
ANKRD11	KBG syndrome [MIM:148050]	OMIM	HGMD	GENETEST
ANKRD26	Thrombocytopenia 2 [MIM:188000]	OMIM	HGMD	GENETEST
ANO10	Spinocerebellar ataxia, autosomal recessive 10 [MIM:613728]	OMIM	HGMD	GENETEST
ANO3	Dystonia 24 [MIM:615034]	OMIM	
ANO5	Gnathodiaphyseal dysplasia [MIM:166260]; Miyoshi muscular dystrophy 3 [MIM:613319]; Muscular dystrophy, limb-girdle, type 2L [MIM:611307]	OMIM	HGMD	GENETEST
ANO6	Scott syndrome [MIM:262890]	OMIM	HGMD
ANTXR2	Hyaline fibromatosis syndrome [MIM:228600]	OMIM	HGMD	GENETEST
AP1S1	MEDNIK syndrome [MIM:609313]	OMIM	HGMD
AP1S2	Mental retardation, X-linked syndromic, Fried type [MIM:300630]	OMIM	HGMD	GENETEST
AP3B1	Hermansky-Pudlak syndrome 2 [MIM:608233]	OMIM	HGMD	GENETEST
AP4B1	Spastic paraplegia 47, autosomal recessive [MIM:614066]	OMIM	HGMD
AP4E1	Spastic paraplegia 51, autosomal recessive [MIM:613744]	OMIM	HGMD
AP4M1	Spastic paraplegia 50, autosomal recessive [MIM:612936]	OMIM	HGMD
AP4S1	Spastic paraplegia 52, autosomal recessive [MIM:614067]	OMIM	HGMD
AP5Z1	Spastic paraplegia 48, autosomal recessive [MIM:613647]	OMIM		GENETEST
APC	Adenomatous polyposis coli [MIM:175100]; Brain tumor-polyposis syndrome 2; Desmoid disease, hereditary [MIM:135290]; Gardner syndrome	OMIM	HGMD	GENETEST
APCDD1	Hypotrichosis simplex [MIM:605389]	OMIM	HGMD
APOA1	Amyloidosis, 3 or more types [MIM:105200]; ApoA-I and apoC-III deficiency, combined; Corneal clouding, autosomal recessive; Hypoalphalipoproteinemia [MIM:604091]	OMIM	HGMD	GENETEST
APOA2	Apolipoprotein A-II deficiency	OMIM	HGMD
APOA5	Hyperchylomicronemia, late-onset [MIM:144650]	OMIM	HGMD
APOB	Hypercholesterolemia, due to ligand-defective apo B [MIM:144010]; Hypobetalipoproteinemia; Hypobetalipoproteinemia, normotriglyceridemic	OMIM	HGMD	GENETEST
APOC2	Hyperlipoproteinemia, type Ib [MIM:207750]	OMIM	HGMD	GENETEST
APOC3	Hyperalphalipoproteinemia 2 [MIM:614028]	OMIM	HGMD
APOE	Alzheimer disease-2 [MIM:104310]; Hyperlipoproteinemia, type III; Lipoprotein glomerulopathy [MIM:611771]; Sea-blue histiocyte disease [MIM:269600]	OMIM	HGMD	GENETEST
APP	Alzheimer disease 1, familial [MIM:104300]; Cerebral amyloid angiopathy, Dutch, Italian, Iowa, Flemish, Arctic variants [MIM:605714]	OMIM	HGMD	GENETEST
APRT	Adenine phosphoribosyltransferase deficiency [MIM:614723]	OMIM	HGMD	GENETEST
APTX	Ataxia, early-onset, with oculomotor apraxia and hypoalbuminemia [MIM:208920]	OMIM	HGMD	GENETEST
AQP2	Diabetes insipidus, nephrogenic [MIM:125800]	OMIM	HGMD	GENETEST
AR	Androgen insensitivity [MIM:300068]; Androgen insensitivity, partial, with or without breast cancer [MIM:312300]; Hypospadias 1, X-linked [MIM:300633]; Spinal and bulbar muscular atrophy of Kennedy [MIM:313200]	OMIM	HGMD	GENETEST
ARFGEF2	Periventricular heterotopia with microcephaly [MIM:608097]	OMIM	HGMD	GENETEST
ARG1	Argininemia [MIM:207800]	OMIM	HGMD	GENETEST
ARHGAP26	Leukemia, juvenile myelomonocytic [MIM:607785]	OMIM	
ARHGAP31	Adams-Oliver syndrome 1 [MIM:100300]	OMIM	HGMD	GENETEST
ARHGEF10	Slowed nerve conduction velocity, AD [MIM:608236]	OMIM	HGMD
ARHGEF12	Leukemia, acute myeloid [MIM:601626]	OMIM	HGMD
ARHGEF6	Mental retardation, X-linked 46 [MIM:300436]	OMIM	HGMD	GENETEST
ARHGEF9	Epileptic encephalopathy, early infantile, 8 [MIM:300607]	OMIM	HGMD	GENETEST
ARID1A	Mental retardation, autosomal dominant 14 [MIM:614607]	OMIM		GENETEST
ARID1B	Mental retardation, autosomal dominant 12 [MIM:614562]	OMIM		GENETEST
ARL13B	Joubert syndrome 8 [MIM:612291]	OMIM	HGMD	GENETEST
ARL6	Bardet-Biedl syndrome 3 [MIM:209900]; Retinitis pigmentosa 55 [MIM:613575]	OMIM	HGMD	GENETEST
ARNT	Leukemia, acute myeloblastic	OMIM	
ARSA	Metachromatic leukodystrophy [MIM:250100]	OMIM	HGMD	GENETEST
ARSB	Mucopolysaccharidosis type VI (Maroteaux-Lamy) [MIM:253200]	OMIM	HGMD	GENETEST
ARSE	Chondrodysplasia punctata, X-linked recessive [MIM:302950]	OMIM	HGMD	GENETEST
ARX	Epileptic encephalopathy, early infantile, 1 [MIM:308350]; Lissencephaly, X-linked 2 [MIM:300215]; Mental retardation, X-linked 29; Mental retardation, X-linked 29 and others [MIM:300419]; Partington syndrome [MIM:309510]; Proud syndrome [MIM:300004]	OMIM	HGMD	GENETEST
ASAH1	Farber lipogranulomatosis [MIM:228000]; Spinal muscular atrophy with progressive myoclonic epilepsy [MIM:159950]	OMIM	HGMD	GENETEST
ASCC1	Barrett esophagus/esophageal adenocarcinoma [MIM:614266]	OMIM	HGMD
ASCL1	Haddad syndrome [MIM:209880]	OMIM	HGMD
ASL	Argininosuccinic aciduria [MIM:207900]	OMIM	HGMD	GENETEST
ASPA	Canavan disease [MIM:271900]	OMIM	HGMD	GENETEST
ASPM	Microcephaly 5, primary, autosomal recessive [MIM:608716]	OMIM	HGMD	GENETEST
ASPSCR1	Alveolar soft-part sarcoma [MIM:606243]	OMIM	
ASS1	Citrullinemia [MIM:215700]	OMIM	HGMD	GENETEST
ASXL1	Bohring-Opitz syndrome [MIM:605039]	OMIM	HGMD	GENETEST
ATCAY	Ataxia, cerebellar, Cayman type [MIM:601238]	OMIM	HGMD	GENETEST
ATIC	AICA-ribosiduria due to ATIC deficiency [MIM:608688]	OMIM	HGMD
ATL1	Neuropathy, hereditary sensory, type ID [MIM:613708]; Spastic paraplegia 3A, autosomal dominant [MIM:182600]	OMIM	HGMD	GENETEST
ATM	Ataxia-telangiectasia [MIM:208900]; Lymphoma, mantle cell; T-cell prolymphocytic leukemia, sporadic	OMIM	HGMD	GENETEST
ATN1	Dentatorubro-pallidoluysian atrophy [MIM:125370]	OMIM		GENETEST
ATP13A2	Parkinson disease 9 [MIM:606693]	OMIM	HGMD	GENETEST
ATP1A2	Alternating hemiplegia of childhood [MIM:104290]; Migraine, familial basilar [MIM:602481]	OMIM	HGMD	GENETEST
ATP1A3	Alternating hemiplegia of childhood 2 [MIM:614820]; Dystonia-12 [MIM:128235]	OMIM	HGMD	GENETEST
ATP2A1	Brody myopathy [MIM:601003]	OMIM	HGMD	GENETEST
ATP2A2	Acrokeratosis verruciformis [MIM:101900]; Darier disease [MIM:124200]	OMIM	HGMD	GENETEST
ATP2B3	Spinocerebellar ataxia, X-linked 1 [MIM:302500]	OMIM	
ATP2C1	Hailey-Hailey disease [MIM:169600]	OMIM	HGMD	GENETEST
ATP5E	Mitochondrial complex V (ATP synthase) deficiency, nuclear type 3 [MIM:614053]	OMIM	HGMD	GENETEST
ATP6AP2	Mental retardation, X-linked, with epilepsy [MIM:300423]	OMIM	HGMD	GENETEST
ATP6V0A2	Cutis laxa, autosomal recessive, type IIA [MIM:219200]; Wrinkly skin syndrome [MIM:278250]	OMIM	HGMD	GENETEST
ATP6V0A4	Renal tubular acidosis, distal, autosomal recessive [MIM:602722]	OMIM	HGMD	GENETEST
ATP6V1B1	Renal tubular acidosis with deafness [MIM:267300]	OMIM	HGMD	GENETEST
ATP7A	Menkes disease [MIM:309400]; Occipital horn syndrome [MIM:304150]; Spinal muscular atrophy, distal, X-linked 3 [MIM:300489]	OMIM	HGMD	GENETEST
ATP7B	Wilson disease [MIM:277900]	OMIM	HGMD	GENETEST
ATP8B1	Cholestasis, benign recurrent intrahepatic [MIM:243300]; Cholestasis, intrahepatic, of pregnancy, 1 [MIM:147480]; Cholestasis, progressive familial intrahepatic 1 [MIM:211600]	OMIM	HGMD	GENETEST
ATPAF2	Mitochondrial complex V (ATP synthase) deficiency, nuclear type 1 [MIM:604273]	OMIM	HGMD	GENETEST
ATR	Cutaneous telangiectasia and cancer syndrome, familial [MIM:614564]; Seckel syndrome 1 [MIM:210600]	OMIM	HGMD	GENETEST
ATRX	Alpha-thalassemia/mental retardation syndrome [MIM:301040]; Mental retardation-hypotonic facies syndrome, X-linked [MIM:309580]	OMIM	HGMD	GENETEST
ATXN1	Spinocerebellar ataxia 1 [MIM:164400]	OMIM		GENETEST
ATXN10	Spinocerebellar ataxia 10 [MIM:603516]	OMIM	HGMD	GENETEST
ATXN2	Spinocerebellar ataxia 2 [MIM:183090]	OMIM		GENETEST
ATXN3	Machado-Joseph disease [MIM:109150]	OMIM		GENETEST
ATXN7	Spinocerebellar ataxia 7 [MIM:164500]	OMIM		GENETEST
ATXN8	Spinocerebellar ataxia 8 [MIM:608768]	OMIM	HGMD	GENETEST
ATXN8OS	Spinocerebellar ataxia 8 [MIM:608768]	OMIM		GENETEST
AUH	3-methylglutaconic aciduria, type I [MIM:250950]	OMIM	HGMD	GENETEST
AURKC	Spermatogenic failure 5 [MIM:243060]	OMIM	HGMD	GENETEST
AVP	Diabetes insipidus, neurohypophyseal [MIM:125700]	OMIM	HGMD	GENETEST
AVPR2	Diabetes insipidus, nephrogenic [MIM:304800]; Nephrogenic syndrome of inappropriate antidiuresis [MIM:300539]	OMIM	HGMD	GENETEST
AXIN1	Caudal duplication anomaly [MIM:607864]	OMIM	HGMD
AXIN2	Colorectal cancer [MIM:114500]; Oligodontia-colorectal cancer syndrome [MIM:608615]	OMIM	HGMD	GENETEST
B2M	Hypoproteinemia, hypercatabolic [MIM:241600]	OMIM	HGMD
B3GALTL	Peters-plus syndrome [MIM:261540]	OMIM	HGMD	GENETEST
B3GAT3	Multiple joint dislocations, short stature, craniofacial dysmorphism, and congenital heart defects [MIM:245600]	OMIM	HGMD
B4GALT1	Congenital disorder of glycosylation, type IId [MIM:607091]	OMIM	HGMD	GENETEST
B4GALT7	Ehlers-Danlos syndrome, progeroid form [MIM:130070]	OMIM	HGMD
B9D1	Meckel syndrome 9 [MIM:614209]	OMIM	HGMD	GENETEST
B9D2	Meckel syndrome 10 [MIM:614175]	OMIM	HGMD	GENETEST
BAAT	Hypercholanemia, familial [MIM:607748]	OMIM	HGMD	GENETEST
BAG3	Cardiomyopathy, dilated, 1HH [MIM:613881]; Myopathy, myofibrillar, BAG3-related [MIM:612954]	OMIM	HGMD	GENETEST
BANF1	Nestor-Guillermo progeria syndrome [MIM:614008]	OMIM	HGMD	GENETEST
BAP1	Tumor predisposition syndrome [MIM:614327]	OMIM	HGMD	GENETEST
BAX	Colorectal cancer; T-cell acute lymphoblastic leukemia	OMIM	HGMD
BBS1	Bardet-Biedl syndrome 1 [MIM:209900]	OMIM	HGMD	GENETEST
BBS10	Bardet-Biedl syndrome 10 [MIM:209900]	OMIM	HGMD	GENETEST
BBS12	Bardet-Biedl syndrome 12 [MIM:209900]	OMIM	HGMD	GENETEST
BBS2	Bardet-Biedl syndrome 2 [MIM:209900]	OMIM	HGMD	GENETEST
BBS4	Bardet-Biedl syndrome 4 [MIM:209900]	OMIM	HGMD	GENETEST
BBS5	Bardet-Biedl syndrome 5 [MIM:209900]	OMIM	HGMD	GENETEST
BBS7	Bardet-Biedl syndrome 7 [MIM:209900]	OMIM	HGMD	GENETEST
BBS9	Bardet-Biedl syndrome 9 [MIM:209900]	OMIM	HGMD	GENETEST
BCHE	Apnea, postanesthetic	OMIM	HGMD	GENETEST
BCKDHA	Maple syrup urine disease, type Ia [MIM:248600]	OMIM	HGMD	GENETEST
BCKDHB	Maple syrup urine disease, type Ib [MIM:248600]	OMIM	HGMD	GENETEST
BCKDK	Branched-chain ketoacid dehydrogenase kinase deficiency [MIM:614923]	OMIM	
BCL2	Leukemia/lymphoma, B-cell, 2	OMIM	HGMD
BCL3	Leukemia/lymphoma, B-cell, 3	OMIM	
BCL6	Lymphoma, B-cell	OMIM	
BCL7A	B-cell non-Hodgkin lymphoma, high-grade	OMIM	
BCMO1	Hypercarotenemia and vitamin A deficiency, autosomal dominant [MIM:115300]	OMIM	HGMD
BCOR	Microphthalmia, syndromic 2 [MIM:300166]	OMIM	HGMD	GENETEST
BCR	Leukemia, acute lymphocytic [MIM:613065]; Leukemia, chronic myeloid [MIM:608232]	OMIM	HGMD
BCS1L	Bjornstad syndrome [MIM:262000]; GRACILE syndrome [MIM:603358]; Leigh syndrome [MIM:256000]; Mitochondrial complex III deficiency [MIM:124000]	OMIM	HGMD	GENETEST
BDNF	Central hypoventilation syndrome, congenital [MIM:209880]	OMIM	HGMD
BEST1	Best macular dystrophy [MIM:153700]; Bestrophinopathy [MIM:611809]; Maculopathy, bull's-eye; Retinitis pigmentosa-50 [MIM:613194]; Vitelliform macular dystrophy, adult-onset [MIM:608161]; Vitreoretinochoroidopathy [MIM:193220]	OMIM	HGMD	GENETEST
BFSP1	Cataract, cortical, juvenile-onset [MIM:611391]	OMIM	
BFSP2	Cataract, autosomal dominant, multiple types 1 [MIM:611597]	OMIM	HGMD	GENETEST
BIN1	Myopathy, centronuclear, autosomal recessive [MIM:255200]	OMIM	HGMD	GENETEST
BLK	Maturity-onset diabetes of the young, type 11 [MIM:613375]	OMIM	HGMD	GENETEST
BLM	Bloom syndrome [MIM:210900]	OMIM	HGMD	GENETEST
BLNK	Agammaglobulinemia 4 [MIM:613502]	OMIM	HGMD
BLOC1S3	Hermansky-Pudlak syndrome 8 [MIM:614077]	OMIM	HGMD	GENETEST
BLOC1S6	Hermansky-pudlak syndrome 9 [MIM:614171]	OMIM		GENETEST
BLVRA	Hyperbiliverdinemia [MIM:614156]	OMIM	HGMD
BMP1	Osteogenesis imperfecta, type XIII [MIM:614856]	OMIM	HGMD
BMP15	Ovarian dysgenesis 2 [MIM:300510]	OMIM	HGMD	GENETEST
BMP2	Brachydactyly, type A2 [MIM:112600]	OMIM	HGMD
BMP4	Microphthalmia, syndromic 6 [MIM:607932]; Orofacial cleft 11 [MIM:600625]	OMIM	HGMD	GENETEST
BMPER	Diaphanospondylodysostosis [MIM:608022]	OMIM	HGMD	GENETEST
BMPR1A	Polyposis syndrome, hereditary mixed, 2 [MIM:610069]; Polyposis, juvenile intestinal [MIM:174900]	OMIM	HGMD	GENETEST
BMPR1B	Brachydactyly, type A2 [MIM:112600]; Chrondrodysplasia, acromesomelic, with genital anomalies [MIM:609441]	OMIM	HGMD	GENETEST
BMPR2	Pulmonary hypertension, familial primary [MIM:178600]; Pulmonary venoocclusive disease [MIM:265450]	OMIM	HGMD	GENETEST
BOLA3	Multiple mitochondrial dysfunctions syndrome 2 [MIM:614299]	OMIM	HGMD	GENETEST
BPGM	Erythrocytosis due to bisphosphoglycerate mutase deficiency [MIM:222800]	OMIM	HGMD
BRAF	Cardiofaciocutaneous syndrome [MIM:115150]; LEOPARD syndrome 3 [MIM:613707]; Noonan syndrome 7 [MIM:613706]	OMIM	HGMD	GENETEST
BRAT1	Rigidity and multifocal seizure syndrome, lethal neonatal [MIM:614498]	OMIM	HGMD
BRCA2	Fanconi anemia, complementation group D1 [MIM:605724]; Pancreatic cancer [MIM:613347]; Prostate cancer [MIM:176807]; Wilms tumor [MIM:194070]	OMIM	HGMD	GENETEST
BRIP1	Breast cancer, early-onset [MIM:114480]; Fanconi anemia, complementation group J [MIM:609054]	OMIM	HGMD	GENETEST
BRWD3	Mental retardation, X-linked 93 [MIM:300659]	OMIM	HGMD	GENETEST
BSCL2	Lipodystrophy, congenital generalized, type 2 [MIM:269700]; Neuropathy, distal hereditary motor, type V [MIM:600794]; Silver spastic paraplegia syndrome [MIM:270685]	OMIM	HGMD	GENETEST
BSND	Bartter syndrome, type 4a [MIM:602522]	OMIM	HGMD	GENETEST
BTD	Biotinidase deficiency [MIM:253260]	OMIM	HGMD	GENETEST
BTK	Agammaglobulinemia and isolated hormone deficiency [MIM:307200]; Agammaglobulinemia, X-linked 1 [MIM:300755]	OMIM	HGMD	GENETEST
BUB1	Colorectal cancer with chromosomal instability	OMIM	
BUB1B	Colorectal cancer [MIM:114500]; Mosaic variegated aneuploidy syndrome [MIM:257300]	OMIM	HGMD
C10orf2	Mitochondrial DNA depletion syndrome 7 (hepatocerebral type) [MIM:271245]; Progressive external ophthalmoplegia, autosomal dominant, 3 [MIM:609286]	OMIM	HGMD	GENETEST
C12orf65	Combined oxidative phosphorylation deficiency 7 [MIM:613559]; Spastic paraplegia 55, autosomal recessive [MIM:615035]	OMIM	HGMD	GENETEST
C19orf12	Neurodegeneration with brain iron accumulation 4 [MIM:614298]	OMIM	HGMD	GENETEST
C1QA	C1q deficiency [MIM:613652]	OMIM	HGMD
C1QB	C1q deficiency [MIM:613652]	OMIM	HGMD
C1QC	C1q deficiency [MIM:613652]	OMIM	HGMD
C1QTNF5	Retinal degeneration, late-onset, autosomal dominant [MIM:605670]	OMIM	HGMD	GENETEST
C1R	C1r/C1s deficiency, combined [MIM:216950]	OMIM	HGMD
C1S	C1s deficiency [MIM:613783]	OMIM	HGMD
C2	C2 deficiency [MIM:217000]	OMIM	HGMD	GENETEST
C2orf71	Retinitis pigmentosa 54 [MIM:613428]	OMIM	HGMD	GENETEST
C3	C3 deficiency [MIM:613779]	OMIM	HGMD	GENETEST
C4A	C4a deficiency [MIM:614380]	OMIM	HGMD
C4B	C4B deficiency [MIM:614379]	OMIM	HGMD
C4orf26	Amelogenesis imperfecta, hypomaturation type, IIA4 [MIM:614832]	OMIM	
C5	C5 deficiency [MIM:609536]	OMIM	HGMD
C5orf42	Joubert syndrome 17 [MIM:614615]	OMIM		GENETEST
C6	C6 deficiency [MIM:612446]; Combined C6/C7 deficiency	OMIM	HGMD
C7	C7 deficiency [MIM:610102]	OMIM	HGMD
C8A	C8 deficiency, type I [MIM:613790]	OMIM	HGMD
C8B	C8 deficiency, type II [MIM:613789]	OMIM	HGMD
C8orf37	Cone-rod dystrophy 16 [MIM:614500]	OMIM	HGMD	GENETEST
C9	C9 deficiency [MIM:613825]	OMIM	HGMD
C9orf72	Amyotrophic lateral sclerosis and/or frontotemporal dementia [MIM:105550]	OMIM		GENETEST
CA12	Hyperchlorhidrosis, isolated [MIM:143860]	OMIM	HGMD
CA2	Osteopetrosis, autosomal recessive 3, with renal tubular acidosis [MIM:259730]	OMIM	HGMD	GENETEST
CA4	Retinitis pigmentosa 17 [MIM:600852]	OMIM	HGMD	GENETEST
CA8	Cerebellar ataxia and mental retardation with or without quadrupedal locomotion 3 [MIM:613227]	OMIM	HGMD
CABP2	Deafness, autosomal recessive 93 [MIM:614899]	OMIM	
CABP4	Night blindness, congenital stationary (incomplete), 2B, autosomal recessive [MIM:610427]	OMIM	HGMD	GENETEST
CACNA1A	Episodic ataxia, type 2 [MIM:108500]; Migraine, familial hemiplegic, 1 [MIM:141500]; Spinocerebellar ataxia 6 [MIM:183086]	OMIM	HGMD	GENETEST
CACNA1C	Brugada syndrome 3 [MIM:611875]; Timothy syndrome [MIM:601005]	OMIM	HGMD	GENETEST
CACNA1D	Sinoatrial node dysfunction and deafness [MIM:614896]	OMIM	HGMD
CACNA1F	Aland Island eye disease [MIM:300600]; Cone-rod dystropy, X-linked, 3 [MIM:300476]; Night blindness, congenital stationary (incomplete), 2A, X-linked [MIM:300071]	OMIM	HGMD	GENETEST
CACNA1S	Hypokalemic periodic paralysis, type 1 [MIM:170400]	OMIM	HGMD	GENETEST
CACNA2D4	Retinal cone dystrophy 4 [MIM:610478]	OMIM	HGMD	GENETEST
CACNB2	Brugada syndrome 4 [MIM:611876]	OMIM	HGMD	GENETEST
CACNB4	Episodic ataxia, type 5 [MIM:613855]	OMIM	HGMD	GENETEST
CACNG2	Mental retardation, autosomal dominant 10 [MIM:614256]	OMIM	HGMD
CALM1	Ventricular tachycardia, catecholaminergic polymorphic, 4 [MIM:614916]	OMIM	HGMD
CALR3	Cardiomyopathy, familial hypertrophic, 19 [MIM:613875]	OMIM	HGMD
CAMTA1	Cerebellar ataxia, nonprogressive, with mental retardation [MIM:614756]	OMIM	HGMD
CANT1	Desbuquois dysplasia [MIM:251450]	OMIM	HGMD	GENETEST
CAPN3	Muscular dystrophy, limb-girdle, type 2A [MIM:253600]	OMIM	HGMD	GENETEST
CARD14	Pityriasis rubra pilaris [MIM:173200]	OMIM	
CARD9	Candidiasis, familial, 2, autosomal recessive [MIM:212050]	OMIM	HGMD	GENETEST
CASC5	Microcephaly 4, primary, autosomal recessive [MIM:604321]	OMIM		GENETEST
CASK	FG syndrome 4 [MIM:300422]; Mental retardation and microcephaly with pontine and cerebellar hypoplasia [MIM:300749]	OMIM	HGMD	GENETEST
CASP10	Autoimmune lymphoproliferative syndrome, type II [MIM:603909]	OMIM	HGMD	GENETEST
CASP8	Immunodeficiency due to CASP8 deficiency [MIM:607271]	OMIM	HGMD	GENETEST
CASQ2	Ventricular tachycardia, catecholaminergic polymorphic, 2 [MIM:611938]	OMIM	HGMD	GENETEST
CASR	Hyperparathyroidism, neonatal [MIM:239200]; Hypocalcemia, autosomal dominant [MIM:146200]; Hypocalcemia, autosomal dominant, with Bartter syndrome; Hypocalciuric hypercalcemia, type I [MIM:145980]	OMIM	HGMD	GENETEST
CAT	Acatalasemia [MIM:614097]	OMIM	HGMD
CATSPER1	Spermatogenic failure 7 [MIM:612997]	OMIM	HGMD	GENETEST
CAV1	Lipodystrophy, congenital generalized, type 3 [MIM:612526]	OMIM	HGMD
CAV3	Cardiomyopathy, familial hypertrophic [MIM:192600]; Creatine phosphokinase, elevated serum [MIM:123320]; Long QT syndrome-9 [MIM:611818]; Muscular dystrophy, limb-girdle, type IC [MIM:607801]; Myopathy, distal, Tateyama type [MIM:614321]; Rippling muscle disease [MIM:606072]	OMIM	HGMD	GENETEST
CBL	Noonan syndrome-like disorder with or without juvenile meylomonocytic leukemia [MIM:613563]	OMIM	HGMD	GENETEST
CBS	Thrombosis, hyperhomocysteinemic [MIM:236200]	OMIM	HGMD	GENETEST
CBX2	46XY sex reversal 5 [MIM:613080]	OMIM	HGMD
CC2D1A	Mental retardation, autosomal recessive 3 [MIM:608443]	OMIM	
CC2D2A	COACH syndrome [MIM:216360]; Joubert syndrome 9 [MIM:612285]; Meckel syndrome 6 [MIM:612284]	OMIM	HGMD	GENETEST
CCBE1	Hennekam lymphangiectasia-lymphedema syndrome [MIM:235510]	OMIM	HGMD	GENETEST
CCDC103	Ciliary dyskinesia, primary, 17 [MIM:614679]	OMIM		GENETEST
CCDC11	Heterotaxy, visceral, 6, autosomal recessive [MIM:614779]	OMIM	
CCDC39	Ciliary dyskinesia, primary, 14 [MIM:613807]	OMIM	HGMD	GENETEST
CCDC40	Ciliary dyskinesia, primary, 15 [MIM:613808]	OMIM	HGMD	GENETEST
CCDC50	Deafness, autosomal dominant 44 [MIM:607453]	OMIM	HGMD	GENETEST
CCDC6	Thyroid papillary carcinoma [MIM:188550]	OMIM	
CCDC78	Myopathy, centronuclear, 4 [MIM:614807]	OMIM	
CCDC8	Three M syndrome 3 [MIM:614205]	OMIM	HGMD	GENETEST
CCDC88C	Hydrocephalus, nonsyndromic, autosomal recessive [MIM:236600]	OMIM	HGMD
CCM2	Cerebral cavernous malformations-2 [MIM:603284]	OMIM	HGMD	GENETEST
CCT5	Neuropathy, hereditary sensory, with spastic paraplegia [MIM:256840]	OMIM	HGMD	GENETEST
CD151	Nephropathy with pretibial epidermolysis bullosa and deafness [MIM:609057]	OMIM	HGMD
CD19	Immunodeficiency, common variable, 3 [MIM:613493]	OMIM	HGMD	GENETEST
CD247	Immunodeficiency due to defect in CD3-zeta [MIM:610163]	OMIM	HGMD
CD2AP	Glomerulosclerosis, focal segmental, 3 [MIM:607832]	OMIM	HGMD	GENETEST
CD320	Methylmalonic aciduria due to transcobalamin receptor defect [MIM:613646]	OMIM	HGMD
CD36	Platelet glycoprotein IV deficiency [MIM:608404]	OMIM	HGMD	GENETEST
CD3D	Severe combined immunodeficiency, T cell-negative, B-cell/natural killer-cell positive [MIM:608971]	OMIM	HGMD	GENETEST
CD3E	Immunodeficiency due to defect in CD3-epsilon; Severe combined immunodeficiency, T cell-negative, B-cell/natural killer-cell positive [MIM:608971]	OMIM	HGMD	GENETEST
CD3G	Immunodeficiency due to defect in CD3-gamma	OMIM	HGMD	GENETEST
CD4	OKT4 epitope deficiency [MIM:613949]	OMIM	HGMD
CD40	Immunodeficiency with hyper-IgM, type 3 [MIM:606843]	OMIM	HGMD	GENETEST
CD40LG	Immunodeficiency, X-linked, with hyper-IgM [MIM:308230]	OMIM	HGMD	GENETEST
CD59	CD59 deficiency [MIM:612300]	OMIM	HGMD
CD79A	Agammaglobulinemia 3 [MIM:613501]	OMIM	HGMD
CD79B	Agammaglobulinemia 6 [MIM:612692]	OMIM	HGMD
CD81	Immunodeficiency, common variable, 6 [MIM:613496]	OMIM	HGMD
CD8A	CD8 deficiency, familial [MIM:608957]	OMIM	HGMD
CD96	C syndrome [MIM:211750]	OMIM	HGMD	GENETEST
CDAN1	Anemia, congenital dyserythropoietic, type I [MIM:224120]	OMIM	HGMD	GENETEST
CDC6	Meier-Gorlin syndrome 5 [MIM:613805]	OMIM	HGMD	GENETEST
CDC73	Hyperparathyroidism, familial primary [MIM:145000]; Hyperparathyroidism-jaw tumor syndrome [MIM:145001]; Parathyroid carcinoma [MIM:608266]	OMIM	HGMD	GENETEST
CDH1	Gastric cancer, familial diffuse, with or without cleft lip and/or palate [MIM:137215]	OMIM	HGMD	GENETEST
CDH15	Mental retardation, autosomal dominant 3 [MIM:612580]	OMIM	HGMD
CDH23	Deafness, autosomal recessive 12 [MIM:601386]; Usher syndrome, type 1D [MIM:601067]	OMIM	HGMD	GENETEST
CDH3	Ectodermal dysplasia, ectrodactyly, and macular dystrophy [MIM:225280]; Hypotrichosis, congenital, with juvenile macular dystrophy [MIM:601553]	OMIM	HGMD	GENETEST
CDHR1	Cone-rod dystrophy 15 [MIM:613660]	OMIM	HGMD	GENETEST
CDK5RAP2	Microcephaly 3, primary, autosomal recessive [MIM:604804]	OMIM	HGMD	GENETEST
CDKL5	Angelman syndrome-like [MIM:105830]; Epileptic encephalopathy, early infantile, 2 [MIM:300672]	OMIM	HGMD	GENETEST
CDKN1B	Multiple endocrine neoplasia, type IV [MIM:610755]	OMIM	HGMD	GENETEST
CDKN1C	Beckwith-Wiedemann syndrome [MIM:130650]; IMAGE syndrome [MIM:614732]	OMIM	HGMD	GENETEST
CDKN2A	Melanoma and neural system tumor syndrome [MIM:155755]; Orolaryngeal cancer, multiple,; Pancreatic cancer/melanoma syndrome [MIM:606719]	OMIM	HGMD	GENETEST
CDON	Holoprosencephaly 11 [MIM:614226]	OMIM	HGMD	GENETEST
CDSN	Hypotrichosis simplex of scalp 1 [MIM:146520]; Peeling skin syndrome [MIM:270300]	OMIM	HGMD
CDT1	Meier-Gorlin syndrome 4 [MIM:613804]	OMIM	HGMD	GENETEST
CEACAM16	Deafness, autosomal dominant 4B [MIM:614614]	OMIM	HGMD
CEBPA	Leukemia, acute myeloid [MIM:601626]	OMIM	HGMD	GENETEST
CEBPE	Specific granule deficiency [MIM:245480]	OMIM	HGMD
CEL	Maturity-onset diabetes of the young, type VIII [MIM:609812]	OMIM	HGMD	GENETEST
CENPJ	Microcephaly 6, primary, autosomal recessive [MIM:608393]; Seckel syndrome 4 [MIM:613676]	OMIM	HGMD	GENETEST
CEP135	Microcephaly 8, primary, autosomal recessive [MIM:614673]	OMIM		GENETEST
CEP152	Microcephaly 9, primary, autosomal recessive [MIM:614852]; Seckel syndrome 5 [MIM:613823]	OMIM	HGMD	GENETEST
CEP164	Nephronophthisis 15 [MIM:614845]	OMIM	
CEP290	Bardet-Biedl syndrome 14 [MIM:209900]; Joubert syndrome 5 [MIM:610188]; Leber congenital amaurosis 10 [MIM:611755]; Meckel syndrome 4 [MIM:611134]; Senior-Loken syndrome 6 [MIM:610189]	OMIM	HGMD	GENETEST
CEP41	Joubert syndrome 15 [MIM:614464]	OMIM	HGMD	GENETEST
CEP57	Mosaic variegated aneuploidy syndrome 2 [MIM:614114]	OMIM	HGMD
CEP63	Seckel syndrome 6 [MIM:614728]	OMIM	HGMD
CERKL	Retinitis pigmentosa 26 [MIM:608380]	OMIM	HGMD	GENETEST
CES1	Carboxylesterase 1 deficiency	OMIM	HGMD
CETP	Hyperalphalipoproteinemia [MIM:143470]	OMIM	HGMD	GENETEST
CFC1	Double-outlet right ventricle [MIM:217095]; Heterotaxy, visceral, 2, autosomal [MIM:605376]; Transposition of the great arteries, dextro-looped 2 [MIM:613853]	OMIM	HGMD	GENETEST
CFD	Complement factor D deficiency [MIM:613912]	OMIM	HGMD
CFH	Basal laminar drusen [MIM:126700]; Complement factor H deficiency [MIM:609814]	OMIM	HGMD	GENETEST
CFHR5	Nephropathy due to CFHR5 deficiency [MIM:614809]	OMIM	HGMD	GENETEST
CFI	Complement factor I deficiency [MIM:610984]	OMIM	HGMD	GENETEST
CFL2	Nemaline myopathy 7 [MIM:610687]	OMIM	HGMD	GENETEST
CFP	Properdin deficiency, X-linked [MIM:312060]	OMIM	HGMD	GENETEST
CFTR	Congenital bilateral absence of vas deferens [MIM:277180]; Cystic fibrosis [MIM:219700]; Sweat chloride elevation without CF	OMIM	HGMD	GENETEST
CHAT	Myasthenic syndrome, congenital, associated with episodic apnea [MIM:254210]	OMIM	HGMD	GENETEST
CHD7	CHARGE syndrome [MIM:214800]; Hypogonadotropic hypogonadism 5 with or without anosmia [MIM:612370]	OMIM	HGMD	GENETEST
CHEK2	Li-Fraumeni syndrome [MIM:609265]	OMIM	HGMD	GENETEST
CHKB	Muscular dystrophy, congenital, megaconial type [MIM:602541]	OMIM	HGMD	GENETEST
CHM	Choroideremia [MIM:303100]	OMIM	HGMD	GENETEST
CHMP1A	Pontocerebellar hypoplasia, type 8 [MIM:614961]	OMIM	
CHMP2B	Amyotrophic lateral sclerosis 17 [MIM:614696]; Dementia, familial, nonspecific [MIM:600795]	OMIM	HGMD	GENETEST
CHMP4B	Cataract, posterior polar, 3 [MIM:605387]	OMIM	HGMD
CHN1	Duane retraction syndrome 2 [MIM:604356]	OMIM	HGMD	GENETEST
CHRDL1	Megalocornea 1, X-linked 309300	OMIM	HGMD
CHRM3	Eagle-Barrett syndrome [MIM:100100]	OMIM	HGMD
CHRNA1	Multiple pterygium syndrome, lethal type [MIM:253290]; Myasthenic syndrome, fast-channel congenital [MIM:608930]; Myasthenic syndrome, slow-channel congenital [MIM:601462]	OMIM	HGMD	GENETEST
CHRNA2	Epilepsy, nocturnal frontal lobe, type 4 [MIM:610353]	OMIM	HGMD	GENETEST
CHRNA4	Epilepsy, nocturnal frontal lobe, 1 [MIM:600513]	OMIM	HGMD	GENETEST
CHRNA7	Schizophrenia, neurophysiologic defect in	OMIM	HGMD
CHRNB1	Myasthenic syndrome, congenital, associated with acetylcholine receptor deficiency [MIM:608931]; Myasthenic syndrome, slow-channel congenital [MIM:601462]	OMIM	HGMD	GENETEST
CHRNB2	Epilepsy, nocturnal frontal lobe, 3 [MIM:605375]	OMIM	HGMD	GENETEST
CHRND	Multiple pterygium syndrome, lethal type [MIM:253290]; Myasthenic syndrome, fast-channel congenital [MIM:608930]; Myasthenic syndrome, slow-channel congenital [MIM:601462]	OMIM	HGMD	GENETEST
CHRNE	Myasthenic syndrome, congenital, associated with acetylcholine receptor deficiency [MIM:608931]; Myasthenic syndrome, fast-channel congenital [MIM:608930]; Myasthenic syndrome, slow-channel congenital [MIM:601462]	OMIM	HGMD	GENETEST
CHRNG	Escobar syndrome [MIM:265000]; Multiple pterygium syndrome, lethal type [MIM:253290]; Myasthenia gravis, neonatal transient	OMIM	HGMD	GENETEST
CHST14	Ehlers-Danlos syndrome, musculocontractural type  [MIM:601776]	OMIM	HGMD	GENETEST
CHST3	Spondyloepiphyseal dysplasia with congenital joint dislocations [MIM:143095]	OMIM	HGMD	GENETEST
CHST6	Macular corneal dystrophy [MIM:217800]	OMIM	HGMD	GENETEST
CHSY1	Temtamy preaxial brachydactyly syndrome [MIM:605282]	OMIM	HGMD
CHUK	Cocoon syndrome [MIM:613630]	OMIM	HGMD
CIB2	Deafness, autosomal recessive 48 [MIM:609439]; Usher syndrome, type IJ [MIM:614869]	OMIM		GENETEST
CIITA	Bare lymphocyte syndrome, type II, complementation group A [MIM:209920]	OMIM	HGMD	GENETEST
CIRH1A	Cirrhosis, North American Indian childhood type [MIM:604901]	OMIM	HGMD	GENETEST
CISD2	Wolfram syndrome 2 [MIM:604928]	OMIM	HGMD	GENETEST
CITED2	Atrial septal defect 8 [MIM:614433]; Ventricular septal defect 2 [MIM:614431]	OMIM	HGMD
CLCF1	Cold-induced sweating syndrome 1 [MIM:610313]	OMIM	HGMD	GENETEST
CLCN1	Myotonia congenita, dominant [MIM:160800]; Myotonia congenita, recessive [MIM:255700]; Myotonia levior, recessive	OMIM	HGMD	GENETEST
CLCN5	Dent disease [MIM:300009]; Hypophosphatemic rickets [MIM:300554]; Nephrolithiasis, type I [MIM:310468]; Proteinuria, low molecular weight, with hypercalciuric nephrocalcinosis [MIM:308990]	OMIM	HGMD	GENETEST
CLCN7	Osteopetrosis, autosomal dominant 2 [MIM:166600]; Osteopetrosis, autosomal recessive 4 [MIM:611490]	OMIM	HGMD	GENETEST
CLCNKA	Bartter syndrome, type 4b, digenic [MIM:613090]	OMIM	HGMD	GENETEST
CLCNKB	Bartter syndrome, type 3 [MIM:607364]; Bartter syndrome, type 4b, digenic [MIM:613090]	OMIM	HGMD	GENETEST
CLDN1	Ichthyosis, leukocyte vacuoles, alopecia, and sclerosing cholangitis [MIM:607626]	OMIM	HGMD	GENETEST
CLDN14	Deafness, autosomal recessive 29 [MIM:614035]	OMIM	HGMD	GENETEST
CLDN16	Hypomagnesemia 3, renal [MIM:248250]	OMIM	HGMD	GENETEST
CLDN19	Hypomagnesemia 5, renal, with ocular involvement [MIM:248190]	OMIM	HGMD	GENETEST
CLEC7A	Candidiasis, familial, 4, autosomal dominant [MIM:613108]	OMIM	HGMD
CLIC2	Mental retardation, X-linked, syndromic 32 [MIM:300886]	OMIM	HGMD
CLN3	Ceroid lipofuscinosis, neuronal, 3 [MIM:204200]	OMIM	HGMD	GENETEST
CLN5	Ceroid lipofuscinosis, neuronal, 5 [MIM:256731]	OMIM	HGMD	GENETEST
CLN6	Ceroid lipofuscinosis, neuronal, 6 [MIM:601780]; Ceroid lipofuscinosis, neuronal, Kufs type, adult onset [MIM:204300]	OMIM	HGMD	GENETEST
CLN8	Ceroid lipofuscinosis, neuronal, 8 [MIM:600143]; Ceroid lipofuscinosis, neuronal, 8, Northern epilepsy variant [MIM:610003]	OMIM	HGMD	GENETEST
CLRN1	Retinitis pigmentosa 61 [MIM:614180]; Usher syndrome, type 3A [MIM:276902]	OMIM	HGMD	GENETEST
CNBP	Myotonic dystrophy 2 [MIM:602668]	OMIM		GENETEST
CNGA1	Retinitis pigmentosa 49 [MIM:613756]	OMIM	HGMD	GENETEST
CNGA3	Achromatopsia-2 [MIM:216900]	OMIM	HGMD	GENETEST
CNGB1	Retinitis pigmentosa 45 [MIM:613767]	OMIM	HGMD	GENETEST
CNGB3	Achromatopsia-3 [MIM:262300]; Macular degeneration, juvenile [MIM:248200]	OMIM	HGMD	GENETEST
CNNM2	Hypomagnesemia 6, renal [MIM:613882]	OMIM	HGMD	GENETEST
CNNM4	Jalili syndrome [MIM:217080]	OMIM	HGMD	GENETEST
CNTN1	Myopathy, congenital, Compton-North [MIM:612540]	OMIM	HGMD	GENETEST
CNTNAP2	Pitt-Hopkins like syndrome 1 [MIM:610042]	OMIM	HGMD	GENETEST
COA5	Mitochondrial complex IV deficiency [MIM:220110]	OMIM	
COCH	Deafness, autosomal dominant 9 [MIM:601369]	OMIM	HGMD	GENETEST
COG1	Congenital disorder of glycosylation, type IIg [MIM:611209]	OMIM	HGMD	GENETEST
COG4	Congenital disorder of glycosylation, type IIj [MIM:613489]	OMIM	HGMD	GENETEST
COG5	Congenital disorder of glycosylation, type IIi [MIM:613612]	OMIM	HGMD	GENETEST
COG6	Congenital disorder of glycosylation, type IIl [MIM:614576]	OMIM	HGMD	GENETEST
COG7	Congenital disorder of glycosylation, type IIe [MIM:608779]	OMIM	HGMD	GENETEST
COG8	Congenital disorder of glycosylation, type IIh [MIM:611182]	OMIM	HGMD	GENETEST
COL10A1	Metaphyseal chondrodysplasia, Schmid type [MIM:156500]	OMIM	HGMD	GENETEST
COL11A1	Fibrochondrogenesis [MIM:228520]; Marshall syndrome [MIM:154780]; Stickler syndrome, type II [MIM:604841]	OMIM	HGMD	GENETEST
COL11A2	Deafness, autosomal dominant 13 [MIM:601868]; Deafness, autosomal recessive 53 [MIM:609706]; Fibrochondrogenesis 2 [MIM:614524]; Otospondylomegaepiphyseal dysplasia [MIM:215150]; Stickler syndrome, type III [MIM:184840]; Weissenbacher-Zweymuller syndrome [MIM:277610]	OMIM	HGMD	GENETEST
COL17A1	Epidermolysis bullosa, junctional, non-Herlitz type [MIM:226650]	OMIM	HGMD	GENETEST
COL18A1	Knobloch syndrome, type 1 [MIM:267750]	OMIM	HGMD	GENETEST
COL1A1	Caffey disease [MIM:114000]; Ehlers-Danlos syndrome, type I [MIM:130000]; Ehlers-Danlos syndrome, type VIIA [MIM:130060]; OI type II [MIM:166210]; OI type III [MIM:259420]; OI type IV [MIM:166220]; Osteogenesis imperfecta, type I [MIM:166200]	OMIM	HGMD	GENETEST
COL1A2	Ehlers-Danlos syndrome, cardiac valvular form [MIM:225320]; Ehlers-Danlos syndrome, type VIIB [MIM:130060]; Osteogenesis imperfecta, type II [MIM:166210]; Osteogenesis imperfecta, type III [MIM:259420]; Osteogenesis imperfecta, type IV [MIM:166220]	OMIM	HGMD	GENETEST
COL2A1	Achondrogenesis, type II or hypochondrogenesis [MIM:200610]; Avascular necrosis of the femoral head [MIM:608805]; Czech dysplasia [MIM:609162]; Epiphyseal dysplasia, multiple, with myopia and deafness [MIM:132450]; Kniest dysplasia [MIM:156550]; Legg-Calve-Perthes disease [MIM:150600]; Osteoarthritis with mild chondrodysplasia [MIM:604864]; Otospondylomegaepiphyseal dysplasia [MIM:215150]; Platyspondylic skeletal dysplasia, Torrance type [MIM:151210]; SED congenita [MIM:183900]; SED, Namaqualand type; SMED Strudwick type [MIM:184250]; Spondyloperipheral dysplasia [MIM:271700]; Stickler sydrome, type I, nonsyndromic ocular [MIM:609508]; Stickler syndrome, type I [MIM:108300]; Vitreoretinopathy with phalangeal epiphyseal dysplasia	OMIM	HGMD	GENETEST
COL3A1	Ehlers-Danlos syndrome, type III [MIM:130020]; Ehlers-Danlos syndrome, type IV [MIM:130050]	OMIM	HGMD	GENETEST
COL4A1	Angiopathy, hereditary, with nephropathy, aneurysms, and muscle [MIM:611773]; Brain small vessel disease with hemorrhage [MIM:607595]; Porencephaly 1 [MIM:175780]	OMIM	HGMD	GENETEST
COL4A2	Porencephaly 2 [MIM:614483]	OMIM	HGMD	GENETEST
COL4A3	Alport syndrome, autosomal dominant [MIM:104200]; Alport syndrome, autosomal recessive [MIM:203780]; Hematuria, benign familial [MIM:141200]	OMIM	HGMD	GENETEST
COL4A4	Alport syndrome, autosomal recessive [MIM:203780]; Hematuria, familial benign	OMIM	HGMD	GENETEST
COL4A5	Alport syndrome [MIM:301050]	OMIM	HGMD	GENETEST
COL4A6	Leiomyomatosis, diffuse, with Alport syndrome [MIM:308940]	OMIM	
COL5A1	Ehlers-Danlos syndrome, type I [MIM:130000]; Ehlers-Danlos syndrome, type II [MIM:130010]	OMIM	HGMD	GENETEST
COL5A2	Ehlers-Danlos syndrome, type I [MIM:130000]	OMIM	HGMD	GENETEST
COL6A1	Bethlem myopathy [MIM:158810]; Ullrich congenital muscular dystrophy [MIM:254090]	OMIM	HGMD	GENETEST
COL6A2	Bethlem myopathy [MIM:158810]; Myosclerosis, congenital [MIM:255600]; Ullrich congenital muscular dystrophy [MIM:254090]	OMIM	HGMD	GENETEST
COL6A3	Bethlem myopathy [MIM:158810]; Ullrich congenital muscular dystrophy [MIM:254090]	OMIM	HGMD	GENETEST
COL7A1	EBD inversa [MIM:226600]; EBD, Bart type [MIM:132000]; EBD, localisata variant; Epidermolysis bullosa dystrophica, AD [MIM:131750]; Epidermolysis bullosa pruriginosa [MIM:604129]; Epidermolysis bullosa, pretibial [MIM:131850]; Toenail dystrophy, isolated [MIM:607523]; Transient bullous of the newborn [MIM:131705]	OMIM	HGMD	GENETEST
COL8A2	Corneal dystrophy polymorphous posterior, 2 [MIM:609140]; Corneal dystrophy, Fuchs endothelial, 1 [MIM:136800]	OMIM	HGMD
COL9A1	Epiphyseal dysplasia, multiple, 6 [MIM:614135]; Stickler syndrome, type IV [MIM:614134]	OMIM	HGMD	GENETEST
COL9A2	Epiphyseal dysplasia, multiple, 2 [MIM:600204]; Stickler syndrome, type V [MIM:614284]	OMIM	HGMD	GENETEST
COL9A3	Epiphyseal dysplasia, multiple, 3 [MIM:600969]; Epiphyseal dysplasia, multiple, with myopathy	OMIM	HGMD	GENETEST
COLEC11	3MC syndrome 2 [MIM:265050]	OMIM	HGMD
COLQ	Endplate acetylcholinesterase deficiency [MIM:603034]	OMIM	HGMD	GENETEST
COMP	Epiphyseal dysplasia, multiple 1 [MIM:132400]; Pseudoachondroplasia [MIM:177170]	OMIM	HGMD	GENETEST
COQ2	Coenzyme Q10 deficiency, primary, 1 [MIM:607426]	OMIM	HGMD	GENETEST
COQ6	Coenzyme Q10 deficiency, primary, 6 [MIM:614650]	OMIM	HGMD
COQ9	Coenzyme Q10 deficiency, primary, 5 [MIM:614654]	OMIM	HGMD	GENETEST
CORIN	Preeclampsia/eclampsia 5 [MIM:614595]	OMIM	HGMD
COX10	Encephalopathy, progressive mitochondrial, with proximal renal tubulopathy due to cytochrome c oxidase deficiency	OMIM	HGMD	GENETEST
COX14	Mitochondrial complex IV deficiency [MIM:220110]	OMIM	
COX15	Cardiomyopathy, hypertrophic, early-onset fatal; Leigh syndrome due to cytochrome c oxidase deficiency [MIM:256000]	OMIM	HGMD	GENETEST
COX4I2	Exocrine pancreatic insufficiency, dyserythropoietic anemia, and calvarial hyperostosis [MIM:612714]	OMIM	HGMD	GENETEST
COX6B1	Cytochrome c oxidase deficiency [MIM:220110]	OMIM	HGMD	GENETEST
COX7B	Aplasia cutis congenita, reticulolinear, with mmicrocephaly, facial dysmorphism and other congenital anomalies [MIM:300887]	OMIM	
CP	Cerebellar ataxia [MIM:604290]	OMIM	HGMD	GENETEST
CPA6	Epilepsy, familial temporal lobe, 5 [MIM:614417]; Febrile seizures, familial, 11 [MIM:614418]	OMIM	HGMD	GENETEST
CPN1	Carboxypeptidase N deficiency [MIM:212070]	OMIM	HGMD
CPOX	Coproporphyria [MIM:121300]	OMIM	HGMD	GENETEST
CPS1	Carbamoylphosphate synthetase I deficiency [MIM:237300]	OMIM	HGMD	GENETEST
CPT1A	CPT deficiency, hepatic, type IA [MIM:255120]	OMIM	HGMD	GENETEST
CPT2	CPT II deficiency, lethal neonatal [MIM:608836]; CPT deficiency, hepatic, type II [MIM:600649]; Myopathy due to CPT II deficiency [MIM:255110]	OMIM	HGMD	GENETEST
CR1	CR1 deficiency	OMIM	HGMD
CR2	Immunodeficiency, common variable, 7 [MIM:614699]	OMIM	HGMD	GENETEST
CRADD	Mental retardation, autosomal recessive 34 [MIM:614499]	OMIM	HGMD
CRB1	Leber congenital amaurosis 8 [MIM:613835]; Pigmented paravenous chorioretinal atrophy [MIM:172870]; Retinitis pigmentosa-12, autosomal recessive [MIM:600105]	OMIM	HGMD	GENETEST
CRBN	Mental retardation, autosomal recessive 2 [MIM:607417]	OMIM	HGMD
CREBBP	Rubinstein-Taybi syndrome [MIM:180849]	OMIM	HGMD	GENETEST
CRLF1	Cold-induced sweating syndrome [MIM:272430]	OMIM	HGMD	GENETEST
CRTAP	Osteogenesis imperfecta, type VII [MIM:610682]	OMIM	HGMD	GENETEST
CRTC1	Mucoepidermoid salivary gland carcinoma	OMIM	
CRX	Cone-rod retinal dystrophy-2 [MIM:120970]; Leber congenital amaurosis 7 [MIM:613829]	OMIM	HGMD	GENETEST
CRYAA	Cataract, autosomal dominant nuclear; Cataract, congenital, autosomal recessive; Cataract, zonular central nuclear, autosomal dominant	OMIM	HGMD	GENETEST
CRYAB	Cataract, posterior polar 2 [MIM:613763]; Myopathy, myofibrillar, alpha-B crystallin-related [MIM:608810]; Myopathy, myofibrillar, fatal infantile hypertrophy, alpha-B crystallin-related [MIM:613869]	OMIM	HGMD	GENETEST
CRYBA1	Cataract, congenital zonular, with sutural opacities [MIM:600881]	OMIM	HGMD
CRYBA4	Cataract, lamellar 2 [MIM:610425]; Microphthalmia with cataract 4 [MIM:610426]	OMIM	HGMD
CRYBB1	Cataract, congenital nuclear, autosomal recessive 3 [MIM:611544]; Cataract, pulverulent	OMIM	HGMD	GENETEST
CRYBB2	Cataract, Coppock-like [MIM:604307]; Cataract, cerulean, type 2 [MIM:601547]; Cataract, sutural, with punctate and cerulean opacities [MIM:607133]	OMIM	HGMD
CRYBB3	Cataract, congenital nuclear, 2 [MIM:609741]	OMIM	HGMD	GENETEST
CRYGC	Cataract, Coppock-like [MIM:604307]; Cataract, variable zonular pulverulent	OMIM	HGMD
CRYGD	Cataract, congenital, cerulean type, 3 [MIM:608983]; Cataract, crystalline aculeiform [MIM:115700]; Cataract, nonnuclear polymorphic congenital [MIM:601286]; Cataracts, punctate, progressive juvenile-onset	OMIM	HGMD	GENETEST
CRYGS	Cataract, progressive polymorphic cortical	OMIM	HGMD
CRYM	Deafness, autosomal dominant 40	OMIM	HGMD
CSF1R	Leukoencephalopathy, diffuse hereditary, with spheroids [MIM:221820]	OMIM	HGMD	GENETEST
CSF2RA	Surfactant metabolism dysfunction, pulmonary, 4 [MIM:300770]	OMIM	HGMD	GENETEST
CSF2RB	Surfactant metabolism dysfunction, pulmonary, 5 [MIM:614370]	OMIM	HGMD
CSF3R	Neutrophilia, hereditary [MIM:162830]	OMIM	HGMD
CSRP3	Cardiomyopathy, dilated, 1M [MIM:607482]; Cardiomyopathy, familial hypertrophic, 12 [MIM:612124]	OMIM	HGMD	GENETEST
CST3	Cerebral amyloid angiopathy [MIM:105150]; Macular degeneration, age-related, 11 [MIM:611953]	OMIM	HGMD
CSTA	Exfoliative ichthyosis, autosomal recessive, ichthyosis bullosa of Siemens-like [MIM:607936]	OMIM	HGMD
CSTB	Epilepsy, progressive myoclonic 1A (Unverricht and Lundborg) [MIM:254800]	OMIM	HGMD	GENETEST
CTC1	Cerebroretinal microangiopathy with calcifications and cysts [MIM:612199]	OMIM		GENETEST
CTDP1	Congenital cataracts, facial dysmorphism, and neuropathy [MIM:604168]	OMIM	HGMD	GENETEST
CTH	Cystathioninuria [MIM:219500]; Homocysteine, total plasma, elevated	OMIM	HGMD	GENETEST
CTHRC1	Barrett esophagus/esophageal adenocarcinoma [MIM:614266]	OMIM	HGMD
CTNNB1	Colorectal cancer; Hepatoblastoma; Hepatocellular carcinoma [MIM:114550]; Ovarian cancer [MIM:167000]; Pilomatricoma [MIM:132600]	OMIM	HGMD
CTNND2	Mental retardation in cri-du-chat syndrome [MIM:123450]	OMIM	
CTNS	Cystinosis, atypical nephropathic; Cystinosis, late-onset juvenile or adolescent nephropathic [MIM:219900]; Cystinosis, nephropathic [MIM:219800]; Cystinosis, ocular nonnephropathic [MIM:219750]	OMIM	HGMD	GENETEST
CTSA	Galactosialidosis [MIM:256540]	OMIM	HGMD	GENETEST
CTSC	Haim-Munk syndrome [MIM:245010]; Papillon-Lefevre syndrome [MIM:245000]; Periodontitis 1, juvenile [MIM:170650]	OMIM	HGMD	GENETEST
CTSD	Ceroid lipofuscinosis, neuronal, 10 [MIM:610127]	OMIM	HGMD	GENETEST
CTSK	Pycnodysostosis [MIM:265800]	OMIM	HGMD	GENETEST
CUBN	Megaloblastic anemia-1, Finnish type [MIM:261100]	OMIM	HGMD	GENETEST
CUL3	Pseudohypoaldosteronism, type IIE [MIM:614496]	OMIM	HGMD	GENETEST
CUL4B	Mental retardation, X-linked, syndromic 15 (Cabezas type) [MIM:300354]	OMIM	HGMD	GENETEST
CUL7	3-M syndrome 1 [MIM:273750]	OMIM	HGMD	GENETEST
CXCR4	Myelokathexis, isolated; WHIM syndrome [MIM:193670]	OMIM	HGMD
CYB5A	Methemoglobinemia, type IV [MIM:250790]	OMIM	HGMD
CYB5R3	Methemoglobinemia, type I [MIM:250800]	OMIM	HGMD	GENETEST
CYBA	Chronic granulomatous disease, autosomal, due to deficiency of CYBA [MIM:233690]	OMIM	HGMD	GENETEST
CYBB	Atypical mycobacteriosis, familial, X-linked 2 [MIM:300645]; Chronic granulomatous disease, X-linked [MIM:306400]	OMIM	HGMD	GENETEST
CYCS	Thrombocytopenia 4 [MIM:612004]	OMIM	HGMD	GENETEST
CYLD	Brooke-Spiegler syndrome [MIM:605041]; Cylindromatosis, familial [MIM:132700]; Trichoepithelioma, multiple familial, 1 [MIM:601606]	OMIM	HGMD	GENETEST
CYP11A1	Adrenal insufficiency, congenital, with 46XY sex reversal, partial or complete [MIM:613743]	OMIM	HGMD	GENETEST
CYP11B1	Adrenal hyperplasia, congenital, due to 11-beta-hydroxylase deficiency [MIM:202010]; Aldosteronism, glucocorticoid-remediable [MIM:103900]	OMIM	HGMD	GENETEST
CYP11B2	Aldosterone to renin ratio raised; Hypoaldosteronism, congenital, due to CMO I deficiency [MIM:203400]; Hypoaldosteronism, congenital, due to CMO II deficiency [MIM:610600]	OMIM	HGMD	GENETEST
CYP17A1	17,20-lyase deficiency, isolated [MIM:202110]	OMIM	HGMD	GENETEST
CYP19A1	Aromatase deficiency [MIM:613546]; Aromatase excess syndrome [MIM:139300]	OMIM	HGMD	GENETEST
CYP1B1	Glaucoma 3A, primary open angle, congenital, juvenile, or adult onset [MIM:231300]; Peters anomaly [MIM:604229]	OMIM	HGMD	GENETEST
CYP21A2	Adrenal hyperplasia, congenital, due to 21-hydroxylase deficiency [MIM:201910]	OMIM	HGMD	GENETEST
CYP24A1	Hypercalcemia, infantile [MIM:143880]	OMIM	HGMD	GENETEST
CYP26B1	Craniosynostosis with radiohumeral fusions and other skeletal and craniofacial anomalies [MIM:614416]	OMIM	HGMD
CYP26C1	Focal facial dermal dysplasia 4 [MIM:614974]	OMIM	
CYP27A1	Cerebrotendinous xanthomatosis [MIM:213700]	OMIM	HGMD	GENETEST
CYP27B1	Vitamin D-dependent rickets, type I [MIM:264700]	OMIM	HGMD	GENETEST
CYP2A6	Coumarin resistance [MIM:122700]	OMIM	HGMD
CYP2B6	Efavirenz, poor metabolism of [MIM:614546]	OMIM	HGMD
CYP2C19	Proguanil poor metabolizer [MIM:609535]	OMIM	HGMD
CYP2C8	Rhabdomyolysis, cerivastatin-induced	OMIM	HGMD
CYP2C9	Tolbutamide poor metabolizer; Warfarin sensitivity [MIM:122700]	OMIM	HGMD
CYP2R1	Rickets due to defect in vitamin D 25-hydroxylation [MIM:600081]	OMIM	HGMD
CYP2U1	Spastic paraplegia 56, autosomal recessive [MIM:615030]	OMIM	
CYP4F22	Ichthyosis, congenital, autosomal recessive 5 [MIM:604777]	OMIM	HGMD	GENETEST
CYP4V2	Bietti crystalline corneoretinal dystrophy [MIM:210370]	OMIM	HGMD	GENETEST
CYP7B1	Bile acid synthesis defect, congenital, 3 [MIM:613812]; Spastic paraplegia 5A, autosomal recessive [MIM:270800]	OMIM	HGMD	GENETEST
D2HGDH	D-2-hydroxyglutaric aciduria [MIM:600721]	OMIM	HGMD	GENETEST
DAG1	Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 9 [MIM:613818]	OMIM	HGMD
DARS2	Leukoencephalopathy with brain stem and spinal cord involvement and lactate elevation [MIM:611105]	OMIM	HGMD	GENETEST
DBH	Dopamine beta-hydroxylase deficiency [MIM:223360]	OMIM	HGMD	GENETEST
DBT	Maple syrup urine disease, type II [MIM:248600]	OMIM	HGMD	GENETEST
DCAF17	Woodhouse-Sakati syndrome [MIM:241080]	OMIM	HGMD	GENETEST
DCC	Colorectal cancer; Mirror movements, congenital [MIM:157600]	OMIM	HGMD
DCLRE1C	Omenn syndrome [MIM:603554]; Severe combined immunodeficiency, Athabascan type [MIM:602450]	OMIM	HGMD	GENETEST
DCN	Corneal dystrophy, congenital stromal [MIM:610048]	OMIM	HGMD	GENETEST
DCTN1	Neuropathy, distal hereditary motor, type VIIB [MIM:607641]; Perry syndrome [MIM:168605]	OMIM	HGMD	GENETEST
DCX	Lissencephaly, X-linked [MIM:300067]	OMIM	HGMD	GENETEST
DCXR	Pentosuria [MIM:260800]	OMIM	HGMD
DDB1	Xeroderma pigmentosum, group E, subtype 2	OMIM	
DDB2	Xeroderma pigmentosum, group E, DDB-negative subtype [MIM:278740]	OMIM	HGMD	GENETEST
DDC	Aromatic L-amino acid decarboxylase deficiency [MIM:608643]	OMIM	HGMD	GENETEST
DDHD1	Spastic paraplegia 28, autosomal recessive [MIM:609340]	OMIM	
DDHD2	Spastic paraplegia 54, autosomal recessive [MIM:615033]	OMIM	
DDIT3	Myxoid liposarcoma [MIM:613488]	OMIM	
DDOST	Congenital disorder of glycosylation, type Ir [MIM:614507]	OMIM	HGMD	GENETEST
DDR2	Spondylometaepiphyseal dysplasia, short limb-hand type [MIM:271665]	OMIM	HGMD	GENETEST
DDX11	Warsaw breakage syndrome [MIM:613398]	OMIM	HGMD
DEC1	Esophageal squamous cell carcinoma [MIM:133239]	OMIM	HGMD
DEK	Leukemia, acute nonlymphocytic	OMIM	
DES	Cardiomyopathy, dilated, 1I [MIM:604765]; Myopathy, myofibrillar, 1 [MIM:601419]; Scapuloperoneal syndrome, neurogenic, Kaeser type [MIM:181400]	OMIM	HGMD	GENETEST
DFNA5	Deafness, autosomal dominant 5 [MIM:600994]	OMIM	HGMD	GENETEST
DFNB31	Deafness, autosomal recessive 31 [MIM:607084]; Usher syndrome, type 2D [MIM:611383]	OMIM	HGMD	GENETEST
DFNB59	Deafness, autosomal recessive 59 [MIM:610220]	OMIM	HGMD	GENETEST
DGKE	Nephrotic syndrome, type 7 [MIM:615008]	OMIM	
DGUOK	Mitochondrial DNA depletion syndrome 3 (hepatocerebral type) [MIM:251880]	OMIM	HGMD	GENETEST
DHCR24	Desmosterolosis [MIM:602398]	OMIM	HGMD	GENETEST
DHCR7	Smith-Lemli-Opitz syndrome [MIM:270400]	OMIM	HGMD	GENETEST
DHDDS	Retinitis pigmentosa 59 [MIM:613861]	OMIM	HGMD	GENETEST
DHFR	Megaloblastic anemia due to dihydrofolate reductase deficiency [MIM:613839]	OMIM	HGMD	GENETEST
DHH	46XY partial gonadal dysgenesis, with minifascicular neuropathy [MIM:607080]; 46XY sex reversal 7 [MIM:233420]	OMIM	HGMD	GENETEST
DHODH	Miller syndrome [MIM:263750]	OMIM	HGMD	GENETEST
DHTKD1	2-aminoadipic 2-oxoadipic aciduria [MIM:204750]; Charcot-Marie-Tooth disease, axonal, type 2Q [MIM:614025]	OMIM	
DIABLO	Deafness, autosomal dominant 64 [MIM:614152]	OMIM	HGMD
DIAPH1	Deafness, autosomal dominant 1 [MIM:124900]	OMIM	HGMD	GENETEST
DIAPH2	Premature ovarian failure [MIM:300511]	OMIM		GENETEST
DIAPH3	Auditory neuropathy, autosomal dominant, 1 [MIM:609129]	OMIM	HGMD
DICER1	Goiter, multinodular 1, with or without Sertoli-Leydig cell tumors [MIM:138800]; Pleuropulmonary blastoma [MIM:601200]	OMIM	HGMD	GENETEST
DIP2B	Mental retardation, FRA12A type [MIM:136630]	OMIM	
DIRC2	Renal cell carcinoma [MIM:144700]	OMIM	
DIS3L2	Perlman syndrome [MIM:267000]	OMIM		GENETEST
DISC2	Schizophrenia [MIM:181500]	OMIM	
DKC1	Dyskeratosis congenita, X-linked [MIM:305000]; Hoyeraal-Hreidarsson syndrome [MIM:300240]	OMIM	HGMD	GENETEST
DLAT	Pyruvate dehydrogenase E2 deficiency [MIM:245348]	OMIM	HGMD	GENETEST
DLD	Leigh syndrome [MIM:256000]; Maple syrup urine disease, type III [MIM:248600]	OMIM	HGMD	GENETEST
DLEC1	Esophageal cancer [MIM:133239]; Lung cancer [MIM:211980]	OMIM	
DLG3	Mental retardation, X-linked 90 [MIM:300850]	OMIM	HGMD	GENETEST
DLL3	Spondylocostal dysostosis, autosomal recessive, 1 [MIM:277300]	OMIM	HGMD	GENETEST
DLX3	Amelogenesis imperfecta, hypomaturation-hypoplastic type, with taurodontism [MIM:104510]; Trichodontoosseous syndrome [MIM:190320]	OMIM	HGMD	GENETEST
DLX5	Split-hand/foot malformation 1 with sensorineural hearing loss [MIM:220600]	OMIM	HGMD
DMD	Becker muscular dystrophy [MIM:300376]; Cardiomyopathy, dilated, 3B [MIM:302045]; Duchenne muscular dystrophy [MIM:310200]	OMIM	HGMD	GENETEST
DMGDH	Dimethylglycine dehydrogenase deficiency [MIM:605850]	OMIM	HGMD
DMP1	Hypophosphatemic rickets, AR [MIM:241520]	OMIM	HGMD	GENETEST
DMPK	Myotonic dystrophy 1 [MIM:160900]	OMIM		GENETEST
DNAAF1	Ciliary dyskinesia, primary, 13 [MIM:613193]	OMIM	HGMD	GENETEST
DNAAF2	Ciliary dyskinesia, primary, 10 [MIM:612518]	OMIM	HGMD	GENETEST
DNAAF3	Ciliary dyskinesia, primary, 2 [MIM:606763]	OMIM		GENETEST
DNAH11	Ciliary dyskinesia, primary, 7, with or without situs inversus [MIM:611884]	OMIM	HGMD	GENETEST
DNAH5	Ciliary dyskinesia, primary, 3, with or without situs inversus [MIM:608644]	OMIM	HGMD	GENETEST
DNAI1	Ciliary dyskinesia, primary, 1, with or without situs inversus [MIM:244400]	OMIM	HGMD	GENETEST
DNAI2	Ciliary dyskinesia, primary, 9, with or without situs inversus [MIM:612444]	OMIM	HGMD	GENETEST
DNAJB2	Spinal muscular atrophy, distal, autosomal recessive, 5 [MIM:614881]	OMIM	
DNAJB6	Muscular dystrophy, limb-girdle, type 1E [MIM:603511]	OMIM		GENETEST
DNAJC19	3-methylglutaconic aciduria, type V [MIM:610198]	OMIM	HGMD	GENETEST
DNAJC5	Ceroid lipofuscinosis, neuronal, 4, Parry type [MIM:162350]	OMIM	HGMD	GENETEST
DNAL1	Ciliary dyskinesia, primary, 16 [MIM:614017]	OMIM	HGMD	GENETEST
DNASE1L3	Systemic lupus erythematosus 16 [MIM:614420]	OMIM	HGMD
DNM1L	Encephalopahty, lethal, due to defective mitochondrial peroxisomal fission [MIM:614388]	OMIM	HGMD	GENETEST
DNM2	Charcot-Marie-Tooth disease, axonal, type 2M [MIM:606482]; Myopathy, centronuclear [MIM:160150]	OMIM	HGMD	GENETEST
DNMT1	Neuropathy, hereditary sensory, type IE [MIM:614116]	OMIM	HGMD	GENETEST
DNMT3B	Immunodeficiency-centromeric instability-facial anomalies syndrome 1 [MIM:242860]	OMIM	HGMD	GENETEST
DOCK6	Adams-Oliver syndrome 2 [MIM:614219]	OMIM	HGMD	GENETEST
DOCK8	Hyper-IgE recurrent infection syndrome, autosomal recessive [MIM:243700]; Mental retardation, autosomal dominant 2 [MIM:614113]	OMIM	HGMD	GENETEST
DOK7	Fetal akinesia deformation sequence [MIM:208150]; Myasthenia, limb-girdle, familial [MIM:254300]	OMIM	HGMD	GENETEST
DOLK	Congenital disorder of glycosylation, type Im [MIM:610768]	OMIM	HGMD	GENETEST
DPAGT1	Congenital disorder of glycosylation, type Ij [MIM:608093]; Myasthenic syndrome, congenital, with tubular aggregates 2 [MIM:614750]	OMIM	HGMD	GENETEST
DPCR1	Panbronchiolitis, diffuse	OMIM	
DPM1	Congenital disorder of glycosylation, type Ie [MIM:608799]	OMIM	HGMD	GENETEST
DPM2	Congenital disorder of glycosylation, type Iu [MIM:615042]	OMIM	
DPM3	Congenital disorder of glycosylation, type Io [MIM:612937]	OMIM	HGMD	GENETEST
DPP6	Ventricular fibrillation, paroxysmal familial, 2 [MIM:612956]	OMIM	HGMD
DPY19L2	Spermatogenic failure 9 [MIM:613958]	OMIM		GENETEST
DPYD	5-fluorouracil toxicity [MIM:274270]	OMIM	HGMD	GENETEST
DPYS	Dihydropyrimidinuria [MIM:222748]	OMIM	HGMD	GENETEST
DRD2	Dystonia, myoclonic [MIM:159900]	OMIM	HGMD
DRD4	Autonomic nervous system dysfunction	OMIM	HGMD
DRD5	Dystonia, primary cervical	OMIM	HGMD
DSC2	Arrhythmogenic right ventricular dysplasia 11 [MIM:610476]	OMIM	HGMD	GENETEST
DSC3	Hypotrichosis and recurrent skin vesicles [MIM:613102]	OMIM	HGMD
DSG1	Keratosis palmoplantaris striata I [MIM:148700]	OMIM	HGMD
DSG2	Arrhythmogenic right ventricular dysplasia 10 [MIM:610193]; Cardiomyopathy, dilated, 1BB [MIM:612877]	OMIM	HGMD	GENETEST
DSG4	Hypotrichosis, localized, autosomal recessive [MIM:607903]	OMIM	HGMD	GENETEST
DSP	Arrhythmogenic right ventricular dysplasia 8 [MIM:607450]; Dilated cardiomyopathy with woolly hair and keratoderma [MIM:605676]; Epidermolysis bullosa, lethal acantholytic [MIM:609638]; Keratosis palmoplantaris striata II [MIM:612908]; Skin fragility-woolly hair syndrome [MIM:607655]	OMIM	HGMD	GENETEST
DSPP	Deafness, autosomal dominant 36, with dentinogenesis [MIM:605594]; Dentin dysplasia, type II [MIM:125420]; Dentinogenesis imperfecta, Shields type II [MIM:125490]; Dentinogenesis imperfecta, Shields type III [MIM:125500]	OMIM	HGMD	GENETEST
DST	Neuropathy, hereditary sensory and autonomic, type VI [MIM:614653]	OMIM	HGMD	GENETEST
DTNA	Left ventricular noncompaction 1, with or without congenital heart defects [MIM:604169]	OMIM	HGMD	GENETEST
DTNBP1	Hermansky-Pudlak syndrome 7 [MIM:614076]	OMIM	HGMD	GENETEST
DUOX2	Thryoid dyshormonogenesis 6 [MIM:607200]	OMIM	HGMD	GENETEST
DUOXA2	Thyroid dyshormonogenesis 5 [MIM:274900]	OMIM	HGMD
DYM	Dyggve-Melchior-Clausen disease [MIM:223800]; Smith-McCort dysplasia [MIM:607326]	OMIM	HGMD	GENETEST
DYNC1H1	Charcot-Marie-Tooth disease, axonal, type 20 [MIM:614228]; Mental retardation, autosomal dominant 13 [MIM:614563]; Spinal muscular atrophy, lower extremity, autosomal dominant [MIM:158600]	OMIM	HGMD	GENETEST
DYNC2H1	Asphyxiating thoracic dystrophy 3 [MIM:613091]; Short rib-polydactyly syndrome, type II, digenic [MIM:263520]; Short rib-polydactyly syndrome, type III [MIM:263510]	OMIM	HGMD	GENETEST
DYRK1A	Mental retardation, autosomal dominant 7 [MIM:614104]	OMIM	
DYSF	Miyoshi muscular dystrophy 1 [MIM:254130]; Muscular dystrophy, limb-girdle, type 2B [MIM:253601]; Myopathy, distal, with anterior tibial onset [MIM:606768]	OMIM	HGMD	GENETEST
EARS2	Combined oxidative phosphorylation deficiency 12 [MIM:614924]	OMIM		GENETEST
EBP	Chondrodysplasia punctata, X-linked dominant [MIM:302960]	OMIM	HGMD	GENETEST
ECE1	Hirschsprung disease, cardiac defects, and autonomic dysfunction [MIM:613870]	OMIM	HGMD	GENETEST
ECM1	Lipoid proteinosis [MIM:247100]	OMIM	HGMD
EDA	Ectodermal dysplasia 1, hypohidrotic, X-linked [MIM:305100]; Tooth agenesis, selective, X-linked 1 [MIM:313500]	OMIM	HGMD	GENETEST
EDAR	Ectodermal dysplasia 10A, hypohidrotic/hair/nail type, autosomal dominant [MIM:129490]; Ectodermal dysplasia 10B, hypohidrotic/hair/tooth type, autosomal recessive [MIM:224900]	OMIM	HGMD	GENETEST
EDARADD	Ectodermal dysplasia 11A, hypohidrotic/hair/tooth type [MIM:614940]; Ectodermal dysplasia 11B, hypohidrotic/hair/tooth type, autosomal recessive [MIM:614941]	OMIM	HGMD	GENETEST
EDN3	Central hypoventilation syndrome, congenital [MIM:209880]; Waardenburg syndrome, type 4B [MIM:613265]	OMIM	HGMD	GENETEST
EDNRA	Migraine, resistance to [MIM:157300]	OMIM	HGMD
EDNRB	ABCD syndrome [MIM:600501]; Waardenburg syndrome, type 4A [MIM:277580]	OMIM	HGMD	GENETEST
EFEMP1	Doyne honeycomb degeneration of retina [MIM:126600]	OMIM	HGMD	GENETEST
EFEMP2	Cutis laxa, autosomal recessive, type IB [MIM:614437]	OMIM	HGMD	GENETEST
EFNB1	Craniofrontonasal dysplasia [MIM:304110]	OMIM	HGMD	GENETEST
EFTUD2	Mandibulofacial dysostosis with microcephaly [MIM:610536]	OMIM	HGMD
EGF	Hypomagnesemia 4, renal [MIM:611718]	OMIM	HGMD	GENETEST
EGLN1	Erythrocytosis, familial, 3 [MIM:609820]	OMIM	HGMD	GENETEST
EGR2	Charcot-Marie-Tooth disease, type 1D [MIM:607678]; Dejerine-Sottas disease [MIM:145900]; Neuropathy, congenital hypomyelinating, 1 [MIM:605253]	OMIM	HGMD	GENETEST
EHMT1	Kleefstra syndrome [MIM:610253]	OMIM	HGMD	GENETEST
EIF2AK3	Wolcott-Rallison syndrome [MIM:226980]	OMIM	HGMD	GENETEST
EIF2B1	Leukoencephalopathy with vanishing white matter [MIM:603896]	OMIM	HGMD	GENETEST
EIF2B2	Ovarioleukodystrophy [MIM:603896]	OMIM	HGMD	GENETEST
EIF2B3	Leukoencephalopathy with vanishing white matter [MIM:603896]	OMIM	HGMD	GENETEST
EIF2B4	Ovarioleukodystrophy [MIM:603896]	OMIM	HGMD	GENETEST
EIF2B5	Ovarioleukodystrophy [MIM:603896]	OMIM	HGMD	GENETEST
EIF4G1	Parkinson disease 18 [MIM:614251]	OMIM	HGMD
ELANE	Neutropenia, cyclic [MIM:162800]; Neutropenia, severe congenital 1, autosomal dominant [MIM:202700]	OMIM	HGMD	GENETEST
ELAVL4	Neuropathy, paraneoplastic sensory	OMIM	
ELN	Cutis laxa, AD [MIM:123700]; Supravalvar aortic stenosis [MIM:185500]; Williams-Beuren syndrome	OMIM	HGMD	GENETEST
ELOVL4	Ichthyosis, spastic quadriplegia, and mental retardation [MIM:614457]; Stargardt disease 3 [MIM:600110]	OMIM	HGMD	GENETEST
EMD	Emery-Dreifuss muscular dystrophy 1, X-linked [MIM:310300]	OMIM	HGMD	GENETEST
EMG1	Bowen-Conradi syndrome [MIM:211180]	OMIM	HGMD
EMX2	Schizencephaly [MIM:269160]	OMIM	HGMD	GENETEST
ENAM	Amelogenesis imperfecta, type IB [MIM:104500]; Amelogenesis imperfecta, type IC [MIM:204650]	OMIM	HGMD	GENETEST
ENG	Telangiectasia, hereditary hemorrhagic, type 1 [MIM:187300]	OMIM	HGMD	GENETEST
ENO1	Enolase deficiency	OMIM	HGMD
ENO3	Glycogen storage disease XIII [MIM:612932]	OMIM	HGMD	GENETEST
ENPP1	Arterial calcification, generalized, of infancy, 1 [MIM:208000]; Hypophosphatemic rickets, autosomal recessive, 2 [MIM:613312]; Ossification of posterior longitudinal ligament of spine [MIM:602475]	OMIM	HGMD	GENETEST
EP300	Colorectal cancer [MIM:114500]; Rubinstein-Taybi syndrome 2 [MIM:613684]	OMIM	HGMD	GENETEST
EPAS1	Erythrocytosis, familial, 4 [MIM:611783]	OMIM	HGMD	GENETEST
EPB41	Elliptocytosis-1 [MIM:611804]	OMIM	HGMD
EPB41L1	Mental retardation, autosomal dominant 11 [MIM:614257]	OMIM	HGMD
EPB42	Spherocytosis, hereditary, type 5 [MIM:612690]	OMIM	HGMD	GENETEST
EPCAM	Colorectal cancer, hereditary nonpolyposis, type 8 [MIM:613244]; Diarrhea 5, with tufting enteropathy, congenital [MIM:613217]	OMIM	HGMD	GENETEST
EPHA2	Cataract, age-related cortical, 2 [MIM:613020]; Cataract, posterior polar, 1 [MIM:116600]	OMIM	HGMD	GENETEST
EPHB2	Prostate cancer, progression and metastasis of [MIM:603688]	OMIM	HGMD
EPHX1	Diphenylhydantoin toxicity; Hypercholanemia, familial [MIM:607748]	OMIM	HGMD
EPM2A	Epilepsy, progressive myoclonic 2A (Lafora) [MIM:254780]	OMIM	HGMD	GENETEST
EPX	Eosinophil peroxidase deficiency [MIM:261500]	OMIM	HGMD
ERBB3	Lethal congenital contractural syndrome 2 [MIM:607598]	OMIM	HGMD
ERCC1	Cerebrooculofacioskeletal syndrome 4 [MIM:610758]	OMIM	HGMD	GENETEST
ERCC2	Cerebrooculofacioskeletal syndrome 2 [MIM:610756]; Trichothiodystrophy [MIM:601675]; Xeroderma pigmentosum, group D [MIM:278730]	OMIM	HGMD	GENETEST
ERCC3	Trichothiodystrophy [MIM:601675]; Xeroderma pigmentosum, group B [MIM:610651]	OMIM	HGMD	GENETEST
ERCC4	XFE progeroid syndrome [MIM:610965]; Xeroderma pigmentosum, group F [MIM:278760]	OMIM	HGMD	GENETEST
ERCC5	Cerebrooculofacioskeletal syndrome 3; Xeroderma pigmentosum, group G [MIM:278780]	OMIM	HGMD	GENETEST
ERCC6	Cerebrooculofacioskeletal syndrome 1 [MIM:214150]; Cockayne syndrome, type B [MIM:133540]; De Sanctis-Cacchione syndrome [MIM:278800]; UV-sensitive syndrome 1 [MIM:600630]	OMIM	HGMD	GENETEST
ERCC8	Cockayne syndrome, type A [MIM:216400]; UV-sensitive syndrome 2 [MIM:614621]	OMIM	HGMD	GENETEST
ERLIN2	Spastic paraplegia 18, autosomal recessive [MIM:611225]	OMIM	HGMD
ESCO2	Roberts syndrome [MIM:268300]; SC phocomelia syndrome [MIM:269000]	OMIM	HGMD	GENETEST
ESPN	Deafness, autosomal recessive 36 [MIM:609006]; Deafness, neurosensory, without vestibular involvement, autosomal dominant	OMIM	HGMD	GENETEST
ESR1	Breast cancer; Estrogen resistance	OMIM	HGMD
ESRRB	Deafness, autosomal recessive 35 [MIM:608565]	OMIM	HGMD	GENETEST
ETFA	Glutaric acidemia IIA [MIM:231680]	OMIM	HGMD	GENETEST
ETFB	Glutaric acidemia IIB [MIM:231680]	OMIM	HGMD	GENETEST
ETFDH	Glutaric acidemia IIC [MIM:231680]	OMIM	HGMD	GENETEST
ETHE1	Ethylmalonic encephalopathy [MIM:602473]	OMIM	HGMD	GENETEST
EVC	Ellis-van Creveld syndrome [MIM:225500]; Weyers acrodental dysostosis [MIM:193530]	OMIM	HGMD	GENETEST
EVC2	Ellis-van Creveld syndrome [MIM:225500]	OMIM	HGMD	GENETEST
EWSR1	Ewing sarcoma [MIM:612219]	OMIM	
EXOSC3	Pontocerebellar hypoplasia, type 1B [MIM:614678]	OMIM		GENETEST
EXPH5	Epidermolysis bullosa, nonspecific, autosomal recessive [MIM:615028]	OMIM	
EXT1	Chondrosarcoma [MIM:215300]; Exostoses, multiple, type 1 [MIM:133700]; Trichorhinophalangeal syndrome, type II	OMIM	HGMD	GENETEST
EXT2	Exostoses, multiple, type 2 [MIM:133701]	OMIM	HGMD	GENETEST
EYA1	Anterior segment anomalies with or without cataract [MIM:113650]; Branchiootic syndrome 1 [MIM:602588]; Otofaciocervical syndrome [MIM:166780]	OMIM	HGMD	GENETEST
EYA4	Cardiomyopathy, dilated, 1J [MIM:605362]; Deafness, autosomal dominant 10 [MIM:601316]	OMIM	HGMD	GENETEST
EYS	Retinitis pigmentosa 25 [MIM:602772]	OMIM	HGMD	GENETEST
EZH2	Weaver syndrome 2 [MIM:614421]	OMIM	HGMD	GENETEST
F10	Factor X deficiency [MIM:227600]	OMIM	HGMD	GENETEST
F11	Factor XI deficiency, autosomal dominant [MIM:612416]	OMIM	HGMD	GENETEST
F12	Angioedema, hereditary, type III [MIM:610618]; Factor XII deficiency [MIM:234000]	OMIM	HGMD	GENETEST
F13A1	Factor XIIIA deficiency [MIM:613225]	OMIM	HGMD	GENETEST
F13B	Factor XIIIB deficiency [MIM:613235]	OMIM	HGMD	GENETEST
F2	Dysprothrombinemia [MIM:613679]; Thrombophilia due to thrombin defect [MIM:188050]	OMIM	HGMD	GENETEST
F5	Factor V deficiency [MIM:227400]; Thrombophilia due to activated protein C resistance [MIM:188055]	OMIM	HGMD	GENETEST
F7	Factor VII deficiency [MIM:227500]	OMIM	HGMD	GENETEST
F8	Hemophilia A [MIM:306700]	OMIM	HGMD	GENETEST
F9	Hemophilia B [MIM:306900]	OMIM	HGMD	GENETEST
FA2H	Spastic paraplegia 35, autosomal recessive [MIM:612319]	OMIM	HGMD	GENETEST
FADD	Infections, recurrent, with encephalopathy, hepatic dysfunction, and cardiovasuclar malformations [MIM:613759]	OMIM	HGMD
FAH	Tyrosinemia, type I [MIM:276700]	OMIM	HGMD	GENETEST
FAM126A	Leukodystrophy, hypomyelinating, 5 [MIM:610532]	OMIM	HGMD	GENETEST
FAM134B	Neuropathy, hereditary sensory and autonomic, type IIB [MIM:613115]	OMIM	HGMD	GENETEST
FAM161A	Retinitis pigmentosa 28 [MIM:606068]	OMIM	HGMD	GENETEST
FAM20A	Amelogenesis imperfecta and gingival fibromatosis syndrome [MIM:614253]	OMIM	HGMD
FAM20C	Raine syndrome [MIM:259775]	OMIM	HGMD
FAM58A	STAR syndrome [MIM:300707]	OMIM	HGMD	GENETEST
FAM83H	Amelogenesis imperfecta, type 3 [MIM:130900]	OMIM	HGMD	GENETEST
FAN1	Interstitial nephritis, karyomegalic [MIM:614817]	OMIM	
FANCA	Fanconi anemia, complementation group A [MIM:227650]	OMIM	HGMD	GENETEST
FANCB	Fanconi anemia, complementation group B [MIM:300514]	OMIM	HGMD	GENETEST
FANCC	Fanconi anemia, complementation group C [MIM:227645]	OMIM	HGMD	GENETEST
FANCD2	Fanconi anemia, complementation group D2 [MIM:227646]	OMIM	HGMD	GENETEST
FANCE	Fanconi anemia, complementation group E [MIM:600901]	OMIM	HGMD	GENETEST
FANCF	Fanconi anemia, complementation group F [MIM:603467]	OMIM	HGMD	GENETEST
FANCG	Fanconi anemia, complementation group G [MIM:614082]	OMIM	HGMD	GENETEST
FANCI	Fanconi anemia, complementation group I [MIM:609053]	OMIM	HGMD	GENETEST
FANCL	Fanconi anemia, complementation group L [MIM:614083]	OMIM	HGMD	GENETEST
FANCM	Fanconi anemia, complementation group M [MIM:614087]	OMIM	HGMD	GENETEST
FARS2	Combined oxidative phosphorylation deficiency 14 [MIM:614946]	OMIM	
FASLG	Autoimmune lymphoproliferative syndrome, type IB [MIM:601859]	OMIM	HGMD	GENETEST
FASTKD2	Mitochondrial complex IV deficiency [MIM:220110]	OMIM	HGMD	GENETEST
FBLN1	Synpolydactyly, 3/3'4, associated with metacarpal and metatarsal synostoses [MIM:608180]	OMIM	HGMD
FBLN5	Cutis laxa, autosomal dominant 2 [MIM:614434]; Cutis laxa, autosomal recessive, type IA [MIM:219100]; Macular degeneration, age-related, 3 [MIM:608895]	OMIM	HGMD	GENETEST
FBN1	Acromicric dysplasia [MIM:102370]; Aortic aneurysm, ascending, and dissection; Ectopia lentis, familial [MIM:129600]; Geleophysic dysplasia 2 [MIM:614185]; MASS syndrome [MIM:604308]; Marfan syndrome [MIM:154700]; Stiff skin syndrome [MIM:184900]; Weill-Marchesani syndrome 2, dominant [MIM:608328]	OMIM	HGMD	GENETEST
FBN2	Contractural arachnodactyly, congenital [MIM:121050]	OMIM	HGMD	GENETEST
FBP1	Fructose-1,6-bidphosphatase deficiency [MIM:229700]	OMIM	HGMD	GENETEST
FBXO7	Parkinson disease 15, autosomal recessive [MIM:260300]	OMIM	HGMD	GENETEST
FBXW4	Split-hand/foot malformation 3, gene duplication syndrome	OMIM		GENETEST
FCGR2C	Thrombocytopenic purpura, autoimmune [MIM:188030]	OMIM	
FCGR3B	Neutropenia, alloimmune neonatal	OMIM	
FCN3	Immunodeficiency due to ficolin 3 deficiency [MIM:613860]	OMIM	HGMD
FECH	Protoporphyria, erythropoietic, autosomal recessive [MIM:177000]	OMIM	HGMD	GENETEST
FERMT1	Kindler syndrome [MIM:173650]	OMIM	HGMD	GENETEST
FERMT3	Leukocyte adhesion deficiency, type III [MIM:612840]	OMIM	HGMD
FGA	Afibrinogenemia, congenital [MIM:202400]; Amyloidosis, hereditary renal [MIM:105200]; Dysfibrinogenemia, alpha type, causing bleeding diathesis; Dysfibrinogenemia, alpha type, causing recurrent thrombosis	OMIM	HGMD	GENETEST
FGB	Afibrinogenemia, congenital [MIM:202400]; Dysfibrinogenemia, beta type; Thrombophilia, dysfibrinogenemic	OMIM	HGMD	GENETEST
FGD1	Aarskog-Scott syndrome [MIM:305400]	OMIM	HGMD	GENETEST
FGD4	Charcot-Marie-Tooth disease, type 4H [MIM:609311]	OMIM	HGMD	GENETEST
FGF10	Aplasia of lacrimal and salivary glands [MIM:180920]; LADD syndrome [MIM:149730]	OMIM	HGMD	GENETEST
FGF14	Spinocerebellar ataxia 27 [MIM:609307]	OMIM	HGMD	GENETEST
FGF23	Hypophosphatemic rickets, autosomal dominant [MIM:193100]; Osteomalacia, tumor-induced; Tumoral calcinosis, hyperphosphatemic, familial [MIM:211900]	OMIM	HGMD	GENETEST
FGF3	Deafness, congenital with inner ear agenesis, microtia, and microdontia [MIM:610706]	OMIM	HGMD	GENETEST
FGF8	Hypogonadotropic hypogonadism 6 with or without anosmia [MIM:612702]	OMIM	HGMD	GENETEST
FGF9	Multiple synostoses syndrome 3 [MIM:612961]	OMIM	HGMD	GENETEST
FGFR1	Hypogonadotropic hypogonadism 2 with or without anosmia [MIM:147950]; Jackson-Weiss syndrome [MIM:123150]; Osteoglophonic dysplasia [MIM:166250]; Pfeiffer syndrome [MIM:101600]; Trigonocephaly 1 [MIM:190440]	OMIM	HGMD	GENETEST
FGFR1OP	Myeloproliferative disorder	OMIM	
FGFR2	Antley-Bixler syndrome without genital anomalies or disordered steroidogenesis [MIM:207410]; Apert syndrome [MIM:101200]; Beare-Stevenson cutis gyrata syndrome [MIM:123790]; Bent bone dysplasia syndrome [MIM:614592]; Craniofacial-skeletal-dermatologic dysplasia; Craniosynostosis, nonspecific; Crouzon syndrome [MIM:123500]; Jackson-Weiss syndrome [MIM:123150]; LADD syndrome [MIM:149730]; Pfeiffer syndrome [MIM:101600]; Saethre-Chotzen syndrome [MIM:101400]; Scaphocephaly and Axenfeld-Rieger anomaly; Scaphocephaly, maxillary retrusion, and mental retardation [MIM:609579]	OMIM	HGMD	GENETEST
FGFR3	Achondroplasia [MIM:100800]; CATSHL syndrome [MIM:610474]; Crouzon syndrome with acanthosis nigricans [MIM:612247]; Hypochondroplasia [MIM:146000]; LADD syndrome [MIM:149730]; Muenke syndrome [MIM:602849]; Thanatophoric dysplasia, type I [MIM:187600]; Thanatophoric dysplasia, type II [MIM:187601]	OMIM	HGMD	GENETEST
FGG	Dysfibrinogenemia, gamma type; Hypofibrinogenemia, gamma type; Thrombophilia, dysfibrinogenemic	OMIM	HGMD	GENETEST
FH	Fumarase deficiency [MIM:606812]; Leiomyomatosis and renal cell cancer [MIM:150800]	OMIM	HGMD	GENETEST
FHL1	Emery-Dreifuss muscular dystrophy 6, X-linked [MIM:300696]; Myopathy, reducing body, X-linked, childhood-onset [MIM:300718]; Myopathy, reducing body, X-linked, severe early-onset [MIM:300717]; Scapuloperoneal myopathy, X-linked dominant [MIM:300695]	OMIM	HGMD	GENETEST
FIG4	Amyotrophic lateral sclerosis 11 [MIM:612577]; Charcot-Marie-Tooth disease, type 4J [MIM:611228]	OMIM	HGMD	GENETEST
FIGLA	Premature ovarian failure 6 [MIM:612310]	OMIM	HGMD	GENETEST
FKBP10	Osteogenesis imperfecta, type XI [MIM:610968]	OMIM	HGMD	GENETEST
FKBP14	Ehlers-Danlos syndrome with progressive kyphoscoliosis, myopathy, and hearing loss [MIM:614557]	OMIM	HGMD
FKRP	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 5 [MIM:613153]; Muscular dystrophy-dystroglycanopathy (congenital with or without mental retardation), type B, 5 [MIM:606612]; Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 5 [MIM:607155]	OMIM	HGMD	GENETEST
FKTN	Cardiomyopathy, dilated, 1X [MIM:611615]; Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 4 [MIM:253800]; Muscular dystrophy-dystroglycanopathy (congenital without mental retardation), type B, 4 [MIM:613152]; Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 4 [MIM:611588]	OMIM	HGMD	GENETEST
FLCN	Birt-Hogg-Dube syndrome [MIM:135150]; Pneumothorax, primary spontaneous [MIM:173600]	OMIM	HGMD	GENETEST
FLG	Ichthyosis vulgaris [MIM:146700]	OMIM	HGMD	GENETEST
FLNA	Cardiac valvular dysplasia, X-linked [MIM:314400]; FG syndrome 2 [MIM:300321]; Frontometaphyseal dysplasia [MIM:305620]; Heterotopia, periventricular [MIM:300049]; Heterotopia, periventricular, ED variant [MIM:300537]; Intestinal pseudoobstruction, neuronal [MIM:300048]; Melnick-Needles syndrome [MIM:309350]; Otopalatodigital syndrome, type I [MIM:311300]; Otopalatodigital syndrome, type II [MIM:304120]; Terminal osseous dysplasia [MIM:300244]	OMIM	HGMD	GENETEST
FLNB	Atelosteogenesis, type I [MIM:108720]; Atelosteogenesis, type III [MIM:108721]; Boomerang dysplasia [MIM:112310]; Larsen syndrome [MIM:150250]; Spondylocarpotarsal synostosis syndrome [MIM:272460]	OMIM	HGMD	GENETEST
FLNC	Myopathy, distal, 4 [MIM:614065]; Myopathy, myofibrillar, 5 [MIM:609524]	OMIM	HGMD	GENETEST
FLT3	Leukemia, acute lymphoblastic; Leukemia, acute myeloid [MIM:601626]; Leukemia, acute myeloid, reduced survival in	OMIM	HGMD
FLT4	Lymphedema, hereditary I [MIM:153100]	OMIM	HGMD	GENETEST
FLVCR1	Ataxia, posterior column, with retinitis pigmentosa [MIM:609033]	OMIM	HGMD	GENETEST
FLVCR2	Proliferative vasculopathy and hydraencephaly-hydrocephaly syndrome [MIM:225790]	OMIM	HGMD	GENETEST
FMO3	Trimethylaminuria [MIM:602079]	OMIM	HGMD	GENETEST
FMR1	Fragile X syndrome [MIM:300624]; Fragile X tremor/ataxia syndrome [MIM:300623]; Premature ovarian failure 1 [MIM:311360]	OMIM	HGMD	GENETEST
FN1	Glomerulopathy with fibronectin deposits 2 [MIM:601894]; Plasma fibronectin deficiency [MIM:614101]	OMIM	HGMD
FOLR1	Neurodegeneration due to cerebral folate transport deficiency [MIM:613068]	OMIM	HGMD	GENETEST
FOXC1	Iridogoniodysgenesis, type 1 [MIM:601631]; Rieger or Axenfeld anomalies [MIM:602482]	OMIM	HGMD	GENETEST
FOXC2	Lymphedema-distichiasis syndrome [MIM:153400]	OMIM	HGMD	GENETEST
FOXE1	Bamforth-Lazarus syndrome [MIM:241850]	OMIM	HGMD	GENETEST
FOXE3	Anterior segment mesenchymal dysgenesis [MIM:107250]; Aphakia, congenital primary [MIM:610256]	OMIM	HGMD	GENETEST
FOXF1	Alveolar capillary dysplasia with misalignment of pulmonary veins [MIM:265380]	OMIM	HGMD	GENETEST
FOXG1	Rett syndrome, congenital variant [MIM:613454]	OMIM	HGMD	GENETEST
FOXI1	Enlarged vestibular aqueduct [MIM:600791]	OMIM	HGMD	GENETEST
FOXL2	Blepharophimosis, epicanthus inversus, and ptosis, type 1 [MIM:110100]; Premature ovarian failure 3 [MIM:608996]	OMIM	HGMD	GENETEST
FOXN1	T-cell immunodeficiency, congenital alopecia, and nail dystrophy [MIM:601705]	OMIM	HGMD	GENETEST
FOXO1	Rhabdomyosarcoma, alveolar [MIM:268220]	OMIM	
FOXP1	Mental retardation with language impairment and autistic features [MIM:613670]	OMIM	HGMD	GENETEST
FOXP2	Speech-language disorder-1 [MIM:602081]	OMIM	HGMD	GENETEST
FOXP3	Immunodysregulation, polyendocrinopathy, and enteropathy, X-linked [MIM:304790]	OMIM	HGMD	GENETEST
FOXRED1	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]; Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
FRAS1	Fraser syndrome [MIM:219000]	OMIM	HGMD	GENETEST
FREM1	Bifid nose with or without anorectal and renal anomalies [MIM:608980]; Manitoba oculotrichoanal syndrome [MIM:248450]; Trigonocephaly 2 [MIM:614485]	OMIM	HGMD	GENETEST
FREM2	Fraser syndrome [MIM:219000]	OMIM	HGMD	GENETEST
FRMD7	Nystagmus 1, congenital, X-linked [MIM:310700]	OMIM	HGMD	GENETEST
FSCN2	Retinitis pigmentosa 30 [MIM:607921]	OMIM	HGMD	GENETEST
FSHB	Follicle-stimulating hormone deficiency, isolated [MIM:229070]	OMIM	HGMD	GENETEST
FSHR	Ovarian dysgenesis 1 [MIM:233300]; Ovarian hyperstimulation syndrome [MIM:608115]; Ovarian response to FSH stimulation [MIM:276400]	OMIM	HGMD	GENETEST
FTCD	Glutamate formiminotransferase deficiency [MIM:229100]	OMIM	HGMD	GENETEST
FTH1	Iron overload, autosomal dominant	OMIM	HGMD	GENETEST
FTL	Hyperferritinemia-cataract syndrome [MIM:600886]; Neurodegeneration with brain iron accumulation 3 [MIM:606159]	OMIM	HGMD	GENETEST
FTO	Growth retardation, developmental delay, coarse facies, and early death [MIM:612938]	OMIM	HGMD	GENETEST
FTSJ1	Mental retardation, X-linked 9 [MIM:309549]	OMIM	HGMD	GENETEST
FUCA1	Fucosidosis [MIM:230000]	OMIM	HGMD	GENETEST
FUS	Amyotrophic lateral sclerosis 6, autosomal recessive, with or without frontotemporal dementia [MIM:608030]; Tremor, hereditary essential, 4 [MIM:614782]	OMIM	HGMD	GENETEST
FUT6	Fucosyltransferase 6 deficiency [MIM:613852]	OMIM	HGMD
FUZ	Neural tube defects [MIM:182940]	OMIM	HGMD
FXN	Friedreich ataxia [MIM:229300]	OMIM	HGMD	GENETEST
FXYD2	Hypomagnesemia-2, renal [MIM:154020]	OMIM	HGMD	GENETEST
FYCO1	Cataract, autosomal recessive congenital 2 [MIM:610019]	OMIM	HGMD	GENETEST
FZD4	Retinopathy of prematurity [MIM:133780]	OMIM	HGMD	GENETEST
FZD6	Nail disorder, nonsyndromic congenital, 10, (claw-shaped nails) [MIM:614157]	OMIM	HGMD
G6PC	Glycogen storage disease Ia [MIM:232200]	OMIM	HGMD	GENETEST
G6PC3	Dursun syndrome [MIM:612541]	OMIM	HGMD	GENETEST
G6PD	Favism; G6PD deficiency; Hemolytic anemia due to G6PD deficiency	OMIM	HGMD	GENETEST
GAA	Glycogen storage disease II [MIM:232300]	OMIM	HGMD	GENETEST
GABRB3	Insomnia	OMIM	HGMD	GENETEST
GABRG2	Febrile seizures, familial, 8 [MIM:611277]	OMIM	HGMD	GENETEST
GAD1	Cerebral palsy, spastic quadriplegic, 1 [MIM:603513]	OMIM	HGMD	GENETEST
GALC	Krabbe disease [MIM:245200]	OMIM	HGMD	GENETEST
GALE	Galactose epimerase deficiency [MIM:230350]	OMIM	HGMD	GENETEST
GALK1	Galactokinase deficiency with cataracts [MIM:230200]	OMIM	HGMD	GENETEST
GALNS	Mucopolysaccharidosis IVA [MIM:253000]	OMIM	HGMD	GENETEST
GALNT3	Tumoral calcinosis, hyperphosphatemic, familial [MIM:211900]	OMIM	HGMD	GENETEST
GALT	Galactosemia [MIM:230400]	OMIM	HGMD	GENETEST
GAMT	GAMT deficiency [MIM:612736]	OMIM	HGMD	GENETEST
GAN	Giant axonal neuropathy-1 [MIM:256850]	OMIM	HGMD	GENETEST
GARS	Charcot-Marie-Tooth disease, type 2D [MIM:601472]; Neuropathy, distal hereditary motor, type V [MIM:600794]	OMIM	HGMD	GENETEST
GATA1	Anemia, X-linked, with/without neutropenia and/or platelet abnormalities [MIM:300835]; Thrombocytopenia with beta-thalassemia, X-linked [MIM:314050]; Thrombocytopenia, X-linked, with or without dyserythropoietic anemia [MIM:300367]	OMIM	HGMD	GENETEST
GATA2	Dendritic cell, monocyte, B lymphocyte, and natural killer lymphocyte deficiency [MIM:614172]; Emberger syndrome [MIM:614038]	OMIM	HGMD	GENETEST
GATA3	Hypoparathyroidism, sensorineural deafness, and renal dysplasia [MIM:146255]	OMIM	HGMD	GENETEST
GATA4	Atrial septal defect 2 [MIM:607941]; Atrioventricular septal defect 4 [MIM:614430]; Ventricular septal defect 1 [MIM:614429]	OMIM	HGMD	GENETEST
GATA6	Atrial septal defect 9 [MIM:614475]; Atrioventricular septal defect 5 [MIM:614474]; Pancreatic agenesis and congenital heart defects [MIM:600001]; Persistent truncus arteriosus [MIM:217095]; Tetralogy of Fallot [MIM:187500]	OMIM	HGMD	GENETEST
GATAD1	Cardiomyopathy, dilated, 2B [MIM:614672]	OMIM	HGMD
GATM	AGAT deficiency [MIM:612718]	OMIM	HGMD	GENETEST
GBA	Gaucher disease, perinatal lethal [MIM:608013]; Gaucher disease, type I [MIM:230800]; Gaucher disease, type II [MIM:230900]; Gaucher disease, type III [MIM:231000]; Gaucher disease, type IIIC [MIM:231005]	OMIM	HGMD	GENETEST
GBE1	Glycogen storage disease IV [MIM:232500]; Polyglucosan body disease, adult form [MIM:263570]	OMIM	HGMD	GENETEST
GCDH	Glutaricaciduria, type I [MIM:231670]	OMIM	HGMD	GENETEST
GCH1	Dystonia, DOPA-responsive, with or without hyperphenylalaninemia [MIM:128230]; Hyperphenylalaninemia, BH4-deficient, B [MIM:233910]	OMIM	HGMD	GENETEST
GCK	Diabetes mellitus, noninsulin-dependent, late onset [MIM:125853]; Diabetes mellitus, permanent neonatal [MIM:606176]; Hyperinsulinemic hypoglycemia, familial, 3 [MIM:602485]; MODY, type II [MIM:125851]	OMIM	HGMD	GENETEST
GCLC	Hemolytic anemia due to gamma-glutamylcysteine synthetase deficiency [MIM:230450]	OMIM	HGMD
GCM2	Hypoparathyroidism, familial isolated [MIM:146200]	OMIM	HGMD	GENETEST
GCSH	Glycine encephalopathy [MIM:605899]	OMIM	HGMD	GENETEST
GDAP1	Charcot-Marie-Tooth disease, axonal, type 2K [MIM:607831]; Charcot-Marie-Tooth disease, axonal, with vocal cord paresis [MIM:607706]; Charcot-Marie-Tooth disease, recessive intermediate, A [MIM:608340]; Charcot-Marie-Tooth disease, type 4A [MIM:214400]	OMIM	HGMD	GENETEST
GDF1	Double-outlet right ventricle [MIM:217095]; Tetralogy of Fallot [MIM:187500]; Transposition of great arteries, dextro-looped 3 [MIM:613854]	OMIM	HGMD	GENETEST
GDF3	Klippel-Feil syndrome 3, autosomal dominant [MIM:613702]; Microphthalmia with coloboma 6 [MIM:613703]; Microphthalmia, isolated 7 [MIM:613704]	OMIM	HGMD
GDF5	Acromesomelic dysplasia, Hunter-Thompson type [MIM:201250]; Brachydactyly, type A2 [MIM:112600]; Brachydactyly, type C [MIM:113100]; Chondrodysplasia, Grebe type [MIM:200700]; Fibular hypoplasia and complex brachydactyly [MIM:228900]; Multiple synostoses syndrome 2 [MIM:610017]; Symphalangism, proximal [MIM:185800]	OMIM	HGMD	GENETEST
GDF6	Klippel-Feil syndrome 1, autosomal dominant [MIM:118100]; Microphthalmia with coloboma 6, digenic [MIM:613703]; Microphthalmia, isolated 4 [MIM:613094]	OMIM	HGMD	GENETEST
GDI1	Mental retardation, X-linked 41 [MIM:300849]	OMIM	HGMD	GENETEST
GDNF	Central hypoventilation syndrome [MIM:209880]	OMIM	HGMD	GENETEST
GFAP	Alexander disease [MIM:203450]	OMIM	HGMD	GENETEST
GFER	Myopathy, mitochondrial progressive, with congenital cataract, hearing loss, and developmental delay [MIM:613076]	OMIM	HGMD	GENETEST
GFI1	Neutropenia, nonimmune chronic idiopathic, of adults [MIM:607847]; Neutropenia, severe congenital 2, autosomal dominant [MIM:613107]	OMIM	HGMD	GENETEST
GFM1	Combined oxidative phosphorylation deficiency 1 [MIM:609060]	OMIM	HGMD	GENETEST
GFPT1	Myasthenia, congenital, with tubular aggregates 1 [MIM:610542]	OMIM	HGMD	GENETEST
GGCX	Pseudoxanthoma elasticum-like disorder with multiple coagulation factor deficiency [MIM:610842]; Vitamin K-dependent coagulation defect [MIM:277450]	OMIM	HGMD	GENETEST
GGT1	Glutathioninuria	OMIM	
GH1	Growth hormone deficiency, isolated, type IA [MIM:262400]; Growth hormone deficiency, isolated, type IB [MIM:612781]; Growth hormone deficiency, isolated, type II [MIM:173100]; Kowarski syndrome [MIM:262650]	OMIM	HGMD	GENETEST
GHR	Increased responsiveness to growth hormone; Laron dwarfism [MIM:262500]; Short stature [MIM:604271]	OMIM	HGMD	GENETEST
GHRH	Gigantism due to GHRF hypersecretion	OMIM	HGMD
GHRHR	Growth hormone deficiency, isolated, type IB [MIM:612781]	OMIM	HGMD	GENETEST
GHSR	Short stature [MIM:604271]	OMIM	HGMD	GENETEST
GIF	Intrinsic factor deficiency [MIM:261000]	OMIM	HGMD	GENETEST
GIGYF2	Parkinson disease 11 [MIM:607688]	OMIM	HGMD
GIPC3	Deafness, autosomal recessive 15 [MIM:601869]	OMIM	HGMD
GJA1	Atrioventricular septal defect 3 [MIM:600309]; Hallermann-Streiff syndrome [MIM:234100]; Hypoplastic left heart syndrome 1 [MIM:241550]; Oculodentodigital dysplasia [MIM:164200]; Oculodentodigital dysplasia, autosomal recessive [MIM:257850]; Syndactyly, type III [MIM:186100]	OMIM	HGMD	GENETEST
GJA3	Cataract, zonular pulverulent-3 [MIM:601885]	OMIM	HGMD	GENETEST
GJA5	Atrial fibrillation, familial, 11 [MIM:614049]	OMIM	HGMD	GENETEST
GJA8	Cataract, nuclear progressive; Cataract, nuclear pulverulent; Cataract, zonular pulverulent-1 [MIM:116200]; Cataract-microcornea syndrome [MIM:116150]	OMIM	HGMD	GENETEST
GJB1	Charcot-Marie-Tooth neuropathy, X-linked dominant, 1 [MIM:302800]	OMIM	HGMD	GENETEST
GJB2	Bart-Pumphrey syndrome [MIM:149200]; Deafness, autosomal dominant 3A [MIM:601544]; Deafness, autosomal recessive 1A [MIM:220290]; Hystrix-like ichthyosis with deafness [MIM:602540]; Keratitis-ichthyosis-deafness syndrome [MIM:148210]; Keratoderma, palmoplantar, with deafness [MIM:148350]; Vohwinkel syndrome [MIM:124500]	OMIM	HGMD	GENETEST
GJB3	Deafness, autosomal dominant 2B [MIM:612644]; Deafness, autosomal dominant, with peripheral neuropathy; Deafness, autosomal recessive; Deafness, digenic, GJB2/GJB3 [MIM:220290]; Erythrokeratodermia variabilis et progressiva [MIM:133200]	OMIM	HGMD	GENETEST
GJB4	Erythrokeratodermia variabilis with erythema gyratum repens [MIM:133200]	OMIM	HGMD	GENETEST
GJB6	Deafness, autosomal dominant 3B [MIM:612643]; Deafness, autosomal recessive 1B [MIM:612645]; Deafness, digenic GJB2/GJB6 [MIM:220290]; Ectodermal dysplasia 2, Clouston type [MIM:129500]	OMIM	HGMD	GENETEST
GJC2	Leukodystrophy, hypomyelinating, 2 [MIM:608804]; Lymphedema, hereditary, IC [MIM:613480]; Spastic paraplegia 44, autosomal recessive [MIM:613206]	OMIM	HGMD	GENETEST
GK	Glycerol kinase deficiency [MIM:307030]	OMIM	HGMD	GENETEST
GLA	Fabry disease [MIM:301500]	OMIM	HGMD	GENETEST
GLB1	GM1-gangliosidosis, type I [MIM:230500]; GM1-gangliosidosis, type II [MIM:230600]; GM1-gangliosidosis, type III [MIM:230650]; Mucopolysaccharidosis type IVB (Morquio) [MIM:253010]	OMIM	HGMD	GENETEST
GLDC	Glycine encephalopathy [MIM:605899]	OMIM	HGMD	GENETEST
GLE1	Arthrogryposis, lethal, with anterior horn cell disease [MIM:611890]; Lethal congenital contracture syndrome 1 [MIM:253310]	OMIM	HGMD	GENETEST
GLI2	Holoprosencephaly-9 [MIM:610829]	OMIM	HGMD	GENETEST
GLI3	Greig cephalopolysyndactyly syndrome [MIM:175700]; Pallister-Hall syndrome [MIM:146510]; Polydactyly, postaxial, types A1 and B [MIM:174200]; Polydactyly, preaxial, type IV [MIM:174700]	OMIM	HGMD	GENETEST
GLIS2	Nephronophthisis 7 [MIM:611498]	OMIM	HGMD	GENETEST
GLIS3	Diabetes mellitus, neonatal, with congenital hypothyroidism [MIM:610199]	OMIM	HGMD	GENETEST
GLMN	Glomuvenous malformations [MIM:138000]	OMIM	HGMD	GENETEST
GLRA1	Hyperekplexia, hereditary 1, autosomal dominant or recessive [MIM:149400]	OMIM	HGMD	GENETEST
GLRB	Hyperekplexia 2, autosomal recessive [MIM:614619]	OMIM	HGMD	GENETEST
GLRX5	Anemia, sideroblastic, pyridoxine-refractory, autosomal recessive [MIM:205950]	OMIM	HGMD	GENETEST
GLUD1	Hyperinsulinism-hyperammonemia syndrome [MIM:606762]	OMIM	HGMD	GENETEST
GLUL	Glutamine deficiency, congenital [MIM:610015]	OMIM	HGMD	GENETEST
GLYCTK	D-glyceric aciduria [MIM:220120]	OMIM	HGMD
GM2A	GM2-gangliosidosis, AB variant [MIM:272750]	OMIM	HGMD	GENETEST
GMPS	Leukemia, acute myelogenous [MIM:601626]	OMIM	
GNAI2	Pituitary ACTH-secreting adenoma; Ventricular tachycardia, idiopathic [MIM:192605]	OMIM	HGMD
GNAI3	Auriculocondylar syndrome 1 [MIM:602483]	OMIM	
GNAQ	Bleeding diathesis due to GNAQ deficiency	OMIM	HGMD
GNAS	ACTH-independent macronodular adrenal hyperplasia [MIM:219080]; Acromegaly [MIM:102200]; McCune-Albright syndrome [MIM:174800]; Osseous heteroplasia, progressive [MIM:166350]; Prolonged bleeding time, brachydactyly and mental retardation; Prolonged bleeding time, brachydactyly, and mental retardation; Pseudohypoparathyroidism Ia [MIM:103580]; Pseudohypoparathyroidism Ib [MIM:603233]; Pseudohypoparathyroidism Ic [MIM:612462]; Pseudopseudohypoparathyroidism [MIM:612463]	OMIM	HGMD	GENETEST
GNAS-AS1	Pseudohypoparathyroidism, type IB [MIM:603233]	OMIM	
GNAT1	Night blindness, congenital stationary, autosomal dominant 3 [MIM:610444]	OMIM	HGMD	GENETEST
GNAT2	Achromatopsia-4 [MIM:613856]	OMIM	HGMD	GENETEST
GNE	Inclusion body myopathy, autosomal recessive [MIM:600737]; Nonaka myopathy [MIM:605820]; Sialuria [MIM:269921]	OMIM	HGMD	GENETEST
GNMT	Glycine N-methyltransferase deficiency [MIM:606664]	OMIM	HGMD
GNPAT	Chondrodysplasia punctata, rhizomelic, type 2 [MIM:222765]	OMIM	HGMD	GENETEST
GNPTAB	Mucolipidosis II alpha/beta [MIM:252500]; Mucolipidosis III alpha/beta [MIM:252600]	OMIM	HGMD	GENETEST
GNPTG	Mucolipidosis III gamma [MIM:252605]	OMIM	HGMD	GENETEST
GNRH1	Hypogonadotropic hypogonadism 12 with or without anosmia [MIM:614841]	OMIM	HGMD	GENETEST
GNRHR	Fertile eunuch syndrome [MIM:228300]; Hypogonadotropic hypogonadism 7 with or without anosmia [MIM:146110]	OMIM	HGMD	GENETEST
GNS	Mucopolysaccharidosis type IIID [MIM:252940]	OMIM	HGMD	GENETEST
GOLGA5	Thyroid carcinoma, papillary [MIM:188550]	OMIM	HGMD
GORAB	Geroderma osteodysplasticum [MIM:231070]	OMIM	HGMD	GENETEST
GOSR2	Epilepsy, progressive myoclonic 6 [MIM:614018]	OMIM	HGMD	GENETEST
GOT1	Aspartate aminotransferase, serum level of, QTL1 [MIM:614419]	OMIM	HGMD
GP1BA	Bernard-Soulier syndrome, type A1 (recessive) [MIM:231200]; Bernard-Soulier syndrome, type A2 (dominant) [MIM:153670]; von Willebrand disease, platelet-type [MIM:177820]	OMIM	HGMD	GENETEST
GP1BB	Bernard-Soulier syndrome, type B [MIM:231200]	OMIM	HGMD	GENETEST
GP6	Bleeding disorder, platelet-type, 11 [MIM:614201]	OMIM	HGMD
GP9	Bernard-Soulier syndrome, type C [MIM:231200]	OMIM	HGMD	GENETEST
GPC3	Simpson-Golabi-Behmel syndrome, type 1 [MIM:312870]	OMIM	HGMD	GENETEST
GPC6	Omodysplasia 1 [MIM:258315]	OMIM	HGMD	GENETEST
GPD1	Hypertriglyceridemia, transient infantile [MIM:614480]	OMIM	HGMD
GPD1L	Brugada syndrome 2 [MIM:611777]	OMIM	HGMD	GENETEST
GPHN	Molybdenum cofactor deficiency, type C [MIM:252150]	OMIM	HGMD	GENETEST
GPI	Hemolytic anemia, nonspherocytic, due to glucose phosphate isomerase deficiency [MIM:613470]	OMIM	HGMD
GPR143	Nystagmus 6, congenital, X-linked [MIM:300814]; Ocular albinism, type I, Nettleship-Falls type [MIM:300500]	OMIM	HGMD	GENETEST
GPR179	Night blindness, congenital stationary (complete), 1E, autosomal recessive [MIM:614565]	OMIM	HGMD	GENETEST
GPR56	Polymicrogyria, bilateral frontoparietal [MIM:606854]	OMIM	HGMD	GENETEST
GPR98	Febrile seizures, familial, 4 [MIM:604352]; Usher syndrome, type 2C [MIM:605472]	OMIM	HGMD	GENETEST
GPSM2	Chudley-McCullough syndrome [MIM:604213]	OMIM	HGMD
GPX1	Hemolytic anemia due to glutathione peroxidase deficiency [MIM:614164]	OMIM	HGMD
GRHL2	Deafness, autosomal dominant 28 [MIM:608641]	OMIM	HGMD	GENETEST
GRHPR	Hyperoxaluria, primary, type II [MIM:260000]	OMIM	HGMD	GENETEST
GRIA3	Mental retardation, X-linked 94 [MIM:300699]	OMIM	HGMD	GENETEST
GRIK2	Mental retardation, autosomal recessive, 6 [MIM:611092]	OMIM	
GRIN1	Mental retardation, autosomal dominant 8 [MIM:614254]	OMIM	HGMD
GRIN2A	Epilepsy with neurodevelopmental defects [MIM:613971]	OMIM	HGMD	GENETEST
GRIN2B	Mental retardation, autosomal dominant 6 [MIM:613970]	OMIM	HGMD	GENETEST
GRK1	Oguchi disease-2 [MIM:613411]	OMIM	HGMD	GENETEST
GRM1	Spinocerebellar ataxia, autosomal recessive 13 [MIM:614831]	OMIM	HGMD
GRM6	Night blindness, congenital stationary (complete), 1B, autosomal recessive [MIM:257270]	OMIM	HGMD	GENETEST
GRN	Aphasia, primary progressive [MIM:607485]; Ceroid lipofuscinosis, neuronal, 11 [MIM:614706]	OMIM	HGMD	GENETEST
GRXCR1	Deafness, autosomal recessive 25 [MIM:613285]	OMIM	HGMD
GSN	Amyloidosis, Finnish type [MIM:105120]	OMIM	HGMD	GENETEST
GSR	Hemolytic anemia due to glutathione reductase deficiency	OMIM	HGMD
GSS	Glutathione synthetase deficiency [MIM:266130]; Hemolytic anemia due to glutathione synthetase deficiency [MIM:231900]	OMIM	HGMD	GENETEST
GSTZ1	Tyrosinemia, type Ib	OMIM	HGMD
GTDC2	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies, type A, 8 [MIM:614830]	OMIM		GENETEST
GTF2H5	Trichothiodystrophy, complementation group A [MIM:601675]	OMIM	HGMD
GUCA1A	Cone dystrophy-3 [MIM:602093]	OMIM	HGMD	GENETEST
GUCA1B	Retinitis pigmentosa 48 [MIM:613827]	OMIM	HGMD	GENETEST
GUCY2C	Diarrhea 6 [MIM:614616]; Meconium ileus [MIM:614665]	OMIM	
GUCY2D	Cone-rod dystrophy 6 [MIM:601777]; Leber congenital amaurosis 1 [MIM:204000]	OMIM	HGMD	GENETEST
GULOP	Scurvy	OMIM	
GUSB	Mucopolysaccharidosis VII [MIM:253220]	OMIM	HGMD	GENETEST
GYG1	Glycogen storage disease XV [MIM:613507]	OMIM	HGMD
GYS1	Glycogen storage disease 0, muscle [MIM:611556]	OMIM	HGMD	GENETEST
GYS2	Glycogen storage disease, type 0 [MIM:240600]	OMIM	HGMD	GENETEST
H19	Beckwith-Wiedemann syndrome [MIM:130650]; Silver-Russell syndrome [MIM:180860]; Wilms tumor 2 [MIM:194071]	OMIM	HGMD	GENETEST
H6PD	Cortisone reductase deficiency 1 [MIM:604931]	OMIM	HGMD
HADH	3-hydroxyacyl-CoA dehydrogenase deficiency [MIM:231530]; Hyperinsulinemic hypoglycemia, familial, 4 [MIM:609975]	OMIM	HGMD	GENETEST
HADHA	LCHAD deficiency [MIM:609016]; Trifunctional protein deficiency [MIM:609015]	OMIM	HGMD	GENETEST
HADHB	Trifunctional protein deficiency [MIM:609015]	OMIM	HGMD	GENETEST
HAMP	Hemochromatosis, type 2B [MIM:613313]	OMIM	HGMD	GENETEST
HARS	Usher syndrome type 3B [MIM:614504]	OMIM	HGMD	GENETEST
HARS2	Perrault syndrome 2 [MIM:614926]	OMIM	HGMD
HAX1	Neutropenia, severe congenital 3, autosomal recessive [MIM:610738]	OMIM	HGMD	GENETEST
HBA1	Erythremias, alpha-; Heinz body anemias, alpha- [MIM:140700]; Hemoglobin H disease, nondeletional [MIM:613978]; Methemoglobinemias, alpha-; Thalassemias, alpha- [MIM:604131]	OMIM	HGMD	GENETEST
HBA2	Erythrocytosis; Heinz body anemia [MIM:140700]; Hemoglobin H disease, nondeletional [MIM:613978]; Hypochromic microcytic anemia; Thalassemia, alpha- [MIM:604131]	OMIM	HGMD	GENETEST
HBB	Delta-beta thalassemia [MIM:141749]; Erythremias, beta-; Heinz body anemias, beta- [MIM:140700]; Methemoglobinemias, beta-; Sickle cell anemia [MIM:603903]; Thalassemia-beta, dominant inclusion-body [MIM:603902]; Thalassemias, beta- [MIM:613985]	OMIM	HGMD	GENETEST
HBD	Thalassemia due to Hb Lepore; Thalassemia, delta-	OMIM	HGMD	GENETEST
HBG1	Fetal hemoglobin quantitative trait locus 1 [MIM:141749]	OMIM	HGMD
HBG2	Cyanosis, transient neonatal [MIM:613977]; Fetal hemoglobin quantitative trait locus 1 [MIM:141749]	OMIM	HGMD
HCCS	Microphthalmia, syndromic 7 [MIM:309801]	OMIM	HGMD	GENETEST
HCFC1	Mental retardation, X-linked 3 [MIM:309541]	OMIM	
HCN4	Brugada syndrome 8 [MIM:613123]; Sick sinus syndrome 2 [MIM:163800]	OMIM	HGMD	GENETEST
HCRT	Narcolepsy 1 [MIM:161400]	OMIM	HGMD
HDAC4	Brachydacytly-mental retardation syndrome [MIM:600430]	OMIM	HGMD	GENETEST
HDAC8	Cornelia de Lange syndrome 5 [MIM:300882]; Wilson-Turner syndrome [MIM:309585]	OMIM		GENETEST
HEATR2	Ciliary dyskinesia, primary, 18 [MIM:614874]	OMIM		GENETEST
HEPACAM	Megalencephalic leukoencephalopathy with subcortical cysts 2A [MIM:613925]; Megalencephalic leukoencephalopathy with subcortical cysts 2B, remitting, with or without mental retardation [MIM:613926]	OMIM	HGMD	GENETEST
HES7	Spondylocostal dysostosis 4, autosomal recessive [MIM:613686]	OMIM	HGMD	GENETEST
HESX1	Septooptic dysplasia [MIM:182230]	OMIM	HGMD	GENETEST
HEXA	Tay-Sachs disease [MIM:272800]	OMIM	HGMD	GENETEST
HEXB	Sandhoff disease, infantile, juvenile, and adult forms [MIM:268800]	OMIM	HGMD	GENETEST
HFE	Hemochromatosis [MIM:235200]	OMIM	HGMD	GENETEST
HFE2	Hemochromatosis, type 2A [MIM:602390]	OMIM	HGMD	GENETEST
HGD	Alkaptonuria [MIM:203500]	OMIM	HGMD	GENETEST
HGF	Deafness, autosomal recessive 39 [MIM:608265]	OMIM	HGMD	GENETEST
HGSNAT	Mucopolysaccharidosis type IIIC (Sanfilippo C) [MIM:252930]	OMIM	HGMD	GENETEST
HIBCH	3-hydroxyisobutryl-CoA hydrolase deficiency [MIM:250620]	OMIM	HGMD
HINT1	Neuromyotonia and axonal neuropathy, autosomal recessive [MIM:137200]	OMIM	
HK1	Hemolytic anemia due to hexokinase deficiency [MIM:235700]	OMIM	HGMD
HLCS	Holocarboxylase synthetase deficiency [MIM:253270]	OMIM	HGMD	GENETEST
HMBS	Porphyria, acute intermittent [MIM:176000]	OMIM	HGMD	GENETEST
HMGCL	HMG-CoA lyase deficiency [MIM:246450]	OMIM	HGMD	GENETEST
HMGCS2	HMG-CoA synthase-2 deficiency [MIM:605911]	OMIM	HGMD	GENETEST
HMOX1	Heme oxygenase-1 deficiency [MIM:614034]	OMIM	HGMD
HMX1	Oculoauricular syndrome [MIM:612109]	OMIM	
HNF1A	Diabetes mellitus, insulin-dependent, 20 [MIM:612520]; MODY, type III [MIM:600496]; Renal cell carcinoma [MIM:144700]	OMIM	HGMD	GENETEST
HNF1B	Diabetes mellitus, noninsulin-dependent [MIM:125853]; Renal cysts and diabetes syndrome [MIM:137920]	OMIM	HGMD	GENETEST
HNF4A	MODY, type I [MIM:125850]	OMIM	HGMD	GENETEST
HOGA1	Hyperoxaluria, primary, type III [MIM:613616]	OMIM	HGMD	GENETEST
HOXA1	Bosley-Salih-Alorainy syndrome [MIM:601536]	OMIM	HGMD	GENETEST
HOXA11	Radioulnar synostosis with amegakaryocytic thrombocytopenia [MIM:605432]	OMIM	HGMD
HOXA13	Guttmacher syndrome [MIM:176305]; Hand-foot-uterus syndrome [MIM:140000]	OMIM	HGMD	GENETEST
HOXA2	Microtia, hearing impairment, and cleft palate [MIM:612290]	OMIM	HGMD	GENETEST
HOXB1	Facial paresis, hereditary congenital, 3 [MIM:614744]	OMIM	
HOXC13	Ectodermal dysplasia 9, hair/nail type [MIM:614931]	OMIM	
HOXD10	Vertical talus, congenital [MIM:192950]	OMIM	HGMD	GENETEST
HOXD13	Brachydactyly, type D [MIM:113200]; Brachydactyly, type E [MIM:113300]; Brachydactyly-syndactyly syndrome [MIM:610713]; Syndactyly, type V [MIM:186300]; Synpolydactyly, type II [MIM:186000]; VACTERL association [MIM:192350]	OMIM	HGMD	GENETEST
HPD	Hawkinsinuria [MIM:140350]; Tyrosinemia, type III [MIM:276710]	OMIM	HGMD	GENETEST
HPGD	Cranioosteoarthropathy [MIM:259100]; Digital clubbing, isolated congenital [MIM:119900]	OMIM	HGMD	GENETEST
HPRT1	HPRT-related gout [MIM:300323]; Lesch-Nyhan syndrome [MIM:300322]	OMIM	HGMD	GENETEST
HPS1	Hermansky-Pudlak syndrome 1 [MIM:203300]	OMIM	HGMD	GENETEST
HPS3	Hermansky-Pudlak syndrome 3 [MIM:614072]	OMIM	HGMD	GENETEST
HPS4	Hermansky-Pudlak syndrome 4 [MIM:614073]	OMIM	HGMD	GENETEST
HPS5	Hermansky-Pudlak syndrome 5 [MIM:614074]	OMIM	HGMD	GENETEST
HPS6	Hermansky-Pudlak syndrome 6 [MIM:614075]	OMIM	HGMD	GENETEST
HPSE2	Urofacial syndrome [MIM:236730]	OMIM	HGMD
HR	Alopecia universalis [MIM:203655]; Atrichia with papular lesions [MIM:209500]; Hypotrichosis, hereditary, Marie Unna type, 1 [MIM:146550]	OMIM	HGMD	GENETEST
HRAS	Costello syndrome [MIM:218040]	OMIM	HGMD	GENETEST
HRG	Thrombophilia due to elevated HRG [MIM:613116]	OMIM	HGMD
HSD11B1	Cortisone reductase deficiency 2 [MIM:614662]	OMIM	HGMD
HSD11B2	Apparent mineralocorticoid excess [MIM:218030]	OMIM	HGMD	GENETEST
HSD17B10	17-beta-hydroxysteroid dehydrogenase X deficiency [MIM:300438]; Mental retardation, X-linked 17/31, microduplication [MIM:300705]; Mental retardation, X-linked syndromic 10 [MIM:300220]	OMIM	HGMD	GENETEST
HSD17B3	Pseudohermaphroditism, male, with gynecomastia [MIM:264300]	OMIM	HGMD	GENETEST
HSD17B4	D-bifunctional protein deficiency [MIM:261515]; Perrault syndrome [MIM:233400]	OMIM	HGMD	GENETEST
HSD3B2	3-beta-hydroxysteroid dehydrogenase, type II, deficiency [MIM:201810]	OMIM	HGMD	GENETEST
HSD3B7	Bile acid synthesis defect, congenital, 1 [MIM:607765]	OMIM	HGMD
HSF4	Cataract, lamellar [MIM:116800]	OMIM	HGMD	GENETEST
HSPB1	Charcot-Marie-Tooth disease, axonal, type 2F [MIM:606595]; Neuropathy, distal hereditary motor, type IIB [MIM:608634]	OMIM	HGMD	GENETEST
HSPB3	Neuronopathy, distal hereditary motor, type IIC [MIM:613376]	OMIM	HGMD	GENETEST
HSPB8	Charcot-Marie-Tooth disease, axonal, type 2L [MIM:608673]; Neuropathy, distal hereditary motor, type IIA [MIM:158590]	OMIM	HGMD	GENETEST
HSPD1	Leukodystrophy, hypomyelinating, 4 [MIM:612233]; Spastic paraplegia 13, autosomal dominant [MIM:605280]	OMIM	HGMD	GENETEST
HSPG2	Dyssegmental dysplasia, Silverman-Handmaker type [MIM:224410]; Schwartz-Jampel syndrome, type 1 [MIM:255800]	OMIM	HGMD	GENETEST
HTR1A	Periodic fever, menstrual cycle dependent [MIM:614674]	OMIM	HGMD
HTRA1	CARASIL syndrome [MIM:600142]	OMIM	HGMD	GENETEST
HTRA2	Parkinson disease 13 [MIM:610297]	OMIM	HGMD	GENETEST
HTT	Huntington disease [MIM:143100]	OMIM		GENETEST
HUWE1	Mental retardation, X-linked syndromic, Turner type [MIM:300706]	OMIM	HGMD	GENETEST
HYAL1	Mucopolysaccharidosis type IX [MIM:601492]	OMIM	HGMD	GENETEST
HYDIN	Ciliary dyskinesia, primary, 5 [MIM:608647]	OMIM		GENETEST
HYLS1	Hydrolethalus syndrome [MIM:236680]	OMIM	HGMD	GENETEST
ICK	Endocrine-cerebroosteodysplasia [MIM:612651]	OMIM	HGMD
ICOS	Immunodeficiency, common variable, 1 [MIM:607594]	OMIM	HGMD	GENETEST
IDH2	D-2-hydrosyglutaric aciduria 2 [MIM:613657]	OMIM	HGMD	GENETEST
IDH3B	Retinitis pigmentosa 46 [MIM:612572]	OMIM	HGMD	GENETEST
IDS	Mucopolysaccharidosis II [MIM:309900]	OMIM	HGMD	GENETEST
IDUA	Mucopolysaccharidosis Ih [MIM:607014]; Mucopolysaccharidosis Ih/s [MIM:607015]; Mucopolysaccharidosis Is [MIM:607016]	OMIM	HGMD	GENETEST
IER3IP1	Microcephaly, epilepsy, and diabetes syndrome [MIM:614231]	OMIM	HGMD
IFITM5	Osteogenesis imperfecta, type V [MIM:610967]	OMIM		GENETEST
IFNA1	Interferon, alpha, deficiency	OMIM	
IFNGR1	BCG infection, generalized familial [MIM:209950]	OMIM	HGMD	GENETEST
IFT122	Cranioectodermal dysplasia 1 [MIM:218330]	OMIM	HGMD	GENETEST
IFT140	Mainzer-Saldino syndrome [MIM:266920]	OMIM		GENETEST
IFT43	Cranioectodermal dysplasia 3 [MIM:614099]	OMIM	HGMD	GENETEST
IFT80	Asphyxiating thoracic dystrophy 2 [MIM:611263]	OMIM	HGMD	GENETEST
IGBP1	Corpus callosum, agenesis of, with mental retardation, ocular coloboma and micrognathia [MIM:300472]	OMIM	HGMD	GENETEST
IGF1	Growth retardation with deafness and mental retardation due to IGF1 deficiency [MIM:608747]	OMIM	HGMD	GENETEST
IGF1R	Insulin-like growth factor I, resistance to [MIM:270450]	OMIM	HGMD	GENETEST
IGF2R	Hepatocellular carcinoma	OMIM	HGMD
IGFALS	Acid-labile subunit, deficiency of	OMIM	HGMD	GENETEST
IGFBP7	Retinal arterial macroaneurysm with supravalvular pulmonic stenosis [MIM:614224]	OMIM	HGMD
IGHG2	IgG2 deficiency, selective	OMIM	HGMD
IGHM	Agammaglobulinemia 1 [MIM:601495]	OMIM	HGMD	GENETEST
IGHMBP2	Neuronopathy, distal hereditary motor, type VI [MIM:604320]	OMIM	HGMD	GENETEST
IGLL1	Agammaglobulinemia 2 [MIM:613500]	OMIM	HGMD
IGSF1	Hypothyroidism, central, and testicular enlargement [MIM:300888]	OMIM	
IHH	Acrocapitofemoral dysplasia [MIM:607778]; Brachydactyly, type A1 [MIM:112500]	OMIM	HGMD	GENETEST
IKBKAP	Dysautonomia, familial [MIM:223900]	OMIM	HGMD	GENETEST
IKBKG	Ectodermal dysplasia, hypohidrotic, with immune deficiency [MIM:300291]; Ectodermal, dysplasia, anhidrotic, lymphedema and immunodeficiency [MIM:300301]; Immunodeficiency, isolated [MIM:300584]; Incontinentia pigmenti, type II [MIM:308300]; Invasive pneumococcal disease, recurrent isolated, 2 [MIM:300640]	OMIM	HGMD	GENETEST
IKZF1	Leukemia, acute lymphoblastic	OMIM	
IL10RA	Inflammatory bowel disease 28, early onset, autosomal recessive [MIM:613148]	OMIM	HGMD	GENETEST
IL10RB	Inflammatory bowel disease 25, early onset, autosomal recessive [MIM:612567]	OMIM	HGMD	GENETEST
IL11RA	Craniosynostosis and dental anomalies [MIM:614188]	OMIM	HGMD
IL12B	BCG and salmonella infection, disseminated [MIM:209950]	OMIM	HGMD	GENETEST
IL17F	Candidiasis, familial, 6, autosomal dominant [MIM:613956]	OMIM	HGMD	GENETEST
IL17RA	Candidiasis, familial, 5, autosomal recessive [MIM:613953]	OMIM	HGMD	GENETEST
IL1RAPL1	Mental retardation, X-linked 21/34 [MIM:300143]	OMIM	HGMD	GENETEST
IL1RN	Interleukin 1 receptor antagonist deficiency [MIM:612852]	OMIM	HGMD	GENETEST
IL2	Severe combined immunodeficiency due to IL2 deficiency	OMIM	HGMD
IL21R	Lymphoma, diffuse large B-cell	OMIM	HGMD
IL2RA	Interleukin-2 receptor, alpha chain, deficiency of [MIM:606367]	OMIM	HGMD	GENETEST
IL2RG	Combined immunodeficiency, X-linked, moderate [MIM:312863]; Severe combined immunodeficiency, X-linked [MIM:300400]	OMIM	HGMD	GENETEST
IL31RA	Amyloidosis, primary localized cutaneous, 2 [MIM:613955]	OMIM	HGMD
IL36RN	Psoriasis, generalized pustular [MIM:614204]	OMIM	HGMD	GENETEST
IL7R	Severe combined immunodeficiency, T-cell negative, B-cell/natural killer cell-positive type [MIM:608971]	OMIM	HGMD	GENETEST
ILDR1	Deafness, autosomal recessive 42 [MIM:609646]	OMIM	HGMD
IMPAD1	Chondrodysplasia with joint dislocations, GRAPP type [MIM:614078]	OMIM	HGMD	GENETEST
IMPDH1	Leber congenital amaurosis 11 [MIM:613837]; Retinitis pigmentosa 10 [MIM:180105]	OMIM	HGMD	GENETEST
IMPG2	Retinitis pigmentosa 56 [MIM:613581]	OMIM	HGMD	GENETEST
INF2	Charcot-Marie-Tooth disease, dominant intermediate E [MIM:614455]; Glomerulosclerosis, focal segmental, 5 [MIM:613237]	OMIM	HGMD	GENETEST
INPP5E	Joubert syndrome 1 [MIM:213300]; Mental retardation, truncal obesity, retinal dystrophy, and micropenis [MIM:610156]	OMIM	HGMD	GENETEST
INS	Diabetes mellitus, permanent neonatal [MIM:606176]; Diabetes mellitus, type 1 [MIM:125852]; Hyperproinsulinemia, familial, with or without diabetes; Maturity-onset diabetes of the young, type 10 [MIM:613370]	OMIM	HGMD	GENETEST
INSL3	Cryptorchidism [MIM:219050]	OMIM	HGMD
INSR	Diabetes mellitus, insulin-resistant, with acanthosis nigricans [MIM:610549]; Hyperinsulinemic hypoglycemia, familial, 5 [MIM:609968]; Leprechaunism [MIM:246200]; Rabson-Mendenhall syndrome [MIM:262190]	OMIM	HGMD	GENETEST
INVS	Nephronophthisis 2, infantile [MIM:602088]	OMIM	HGMD	GENETEST
IQCB1	Senior-Loken syndrome 5 [MIM:609254]	OMIM	HGMD	GENETEST
IQSEC2	Mental retardation, X-linked 1 [MIM:309530]	OMIM	HGMD
IRAK4	IRAK4 deficiency [MIM:607676]; Invasive pneumococcal disease, recurrent isolated, 1 [MIM:610799]	OMIM	HGMD	GENETEST
IRF1	Myelodysplastic syndrome, preleukemic; Myelogenous leukemia, acute	OMIM	HGMD
IRF4	Multiple myeloma [MIM:254500]	OMIM	HGMD
IRF6	Orofacial cleft 6 [MIM:608864]; Popliteal pterygium syndrome 1 [MIM:119500]; van der Woude syndrome [MIM:119300]	OMIM	HGMD	GENETEST
IRGM	Inflammatory bowel disease 19 [MIM:612278]	OMIM	HGMD
IRX5	Hamamy syndrome [MIM:611174]	OMIM		GENETEST
ISCU	Myopathy with lactic acidosis, hereditary [MIM:255125]	OMIM	HGMD	GENETEST
ISPD	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 7 [MIM:614643]	OMIM		GENETEST
ITCH	Autoimmune disease, syndromic multisystem [MIM:613385]	OMIM	HGMD
ITGA2B	Glanzmann thrombasthenia [MIM:273800]; Thrombocytopenia, neonatal alloimmune, BAK antigen related	OMIM	HGMD	GENETEST
ITGA3	Interstitial lung disease, nephrotic syndrome, and epidermolysis bullosa, congenital [MIM:614748]	OMIM	
ITGA6	Epidermolysis bullosa, junctional, with pyloric stenosis [MIM:226730]	OMIM	HGMD	GENETEST
ITGA7	Muscular dystrophy, congenital, due to ITGA7 deficiency [MIM:613204]	OMIM	HGMD	GENETEST
ITGB2	Leukocyte adhesion deficiency [MIM:116920]	OMIM	HGMD	GENETEST
ITGB3	Glanzmann thrombasthenia [MIM:273800]; Purpura, posttransfusion; Thrombocytopenia, neonatal alloimmune	OMIM	HGMD	GENETEST
ITGB4	Epidermolysis bullosa of hands and feet [MIM:131800]; Epidermolysis bullosa, junctional, non-Herlitz type [MIM:226650]; Epidermolysis bullosa, junctional, with pyloric atresia [MIM:226730]	OMIM	HGMD	GENETEST
ITK	Lymphoproliferative syndrome, EBV-associated, autosomal, 1 [MIM:613011]	OMIM	HGMD	GENETEST
ITM2B	Dementia, familial British [MIM:176500]; Dementia, familial Danish [MIM:117300]	OMIM	HGMD
ITPR1	Spinocerebellar ataxia 15 [MIM:606658]	OMIM	HGMD	GENETEST
IVD	Isovaleric acidemia [MIM:243500]	OMIM	HGMD	GENETEST
IYD	Thyroid dyshormonogenesis 4 [MIM:274800]	OMIM	HGMD	GENETEST
JAG1	Alagille syndrome [MIM:118450]; Deafness, congenital heart defects, and posterior embryotoxon; Tetralogy of Fallot [MIM:187500]	OMIM	HGMD	GENETEST
JAK2	Leukemia, acute myelogenous [MIM:601626]; Polycythemia vera [MIM:263300]; Thrombocythemia 3 [MIM:614521]	OMIM		GENETEST
JAK3	SCID, autosomal recessive, T-negative/B-positive type [MIM:600802]	OMIM	HGMD	GENETEST
JAM3	Hemorrhagic destruction of the brain, subependymal calcification, and cataracts [MIM:613730]	OMIM	HGMD
JAZF1	Endometrial stromal tumors	OMIM	
JPH2	Cardiomyopathy, familial hypertrophic 17 [MIM:613873]	OMIM	HGMD
JPH3	Huntington disease-like 2 [MIM:606438]	OMIM		GENETEST
JUP	Arrhythmogenic right ventricular dysplasia 12 [MIM:611528]; Naxos disease [MIM:601214]	OMIM	HGMD	GENETEST
KAL1	Hypogonadotropic hypogonadism 1 with or without anosmia (Kallmann syndrome 1) [MIM:308700]	OMIM	HGMD	GENETEST
KANK1	Cerebral palsy, spastic quadriplegic, 2 [MIM:612900]	OMIM	
KANSL1	Koolen-De Vries syndrome [MIM:610443]	OMIM		GENETEST
KARS	Charcot-Marie-Tooth disease, recessive intermediate, B [MIM:613641]	OMIM	HGMD	GENETEST
KAT6B	Genitopatellar syndrome [MIM:606170]; SBBYSS syndrome [MIM:603736]	OMIM	HGMD	GENETEST
KBTBD13	Nemaline myopathy 6 [MIM:609273]	OMIM	HGMD	GENETEST
KCNA1	Episodic ataxia/myokymia syndrome [MIM:160120]	OMIM	HGMD	GENETEST
KCNA5	Atrial fibrillation, familial, 7 [MIM:612240]	OMIM	HGMD	GENETEST
KCNC3	Spinocerebellar ataxia 13 [MIM:605259]	OMIM	HGMD	GENETEST
KCNE1	Jervell and Lange-Nielsen syndrome 2 [MIM:612347]; Long QT syndrome-5 [MIM:613695]	OMIM	HGMD	GENETEST
KCNE2	Atrial fibrillation, familial, 4 [MIM:611493]; Long QT syndrome-6 [MIM:613693]	OMIM	HGMD	GENETEST
KCNE3	Brugada syndrome 6 [MIM:613119]	OMIM	HGMD	GENETEST
KCNH2	Long QT syndrome-2 [MIM:613688]; Short QT syndrome-1 [MIM:609620]	OMIM	HGMD	GENETEST
KCNJ1	Bartter syndrome, type 2 [MIM:241200]	OMIM	HGMD	GENETEST
KCNJ10	Enlarged vestibular aqueduct, digenic [MIM:600791]; SESAME syndrome [MIM:612780]	OMIM	HGMD	GENETEST
KCNJ11	Diabetes mellitus, transient neonatal, 3 [MIM:610582]; Diabetes, permanent neonatal [MIM:606176]; Hyperinsulinemic hypoglycemia, familial, 2 [MIM:601820]	OMIM	HGMD	GENETEST
KCNJ13	Leber congenital amaurosis 16 [MIM:614186]; Snowflake vitreoretinal degeneration [MIM:193230]	OMIM	HGMD	GENETEST
KCNJ2	Andersen syndrome [MIM:170390]; Atrial fibrillation, familial, 9 [MIM:613980]; Short QT syndrome-3 [MIM:609622]	OMIM	HGMD	GENETEST
KCNJ5	Hyperaldosteronism, familial, type III [MIM:613677]; Long QT syndrome 13 [MIM:613485]	OMIM	HGMD	GENETEST
KCNK9	Birk-Barel mental retardation dysmorphism syndrome [MIM:612292]	OMIM	HGMD	GENETEST
KCNMA1	Generalized epilepsy and paroxysmal dyskinesia [MIM:609446]	OMIM	HGMD	GENETEST
KCNQ1	Atrial fibrillation, familial, 3 [MIM:607554]; Jervell and Lange-Nielsen syndrome [MIM:220400]; Long QT syndrome-1 [MIM:192500]; Short QT syndrome-2 [MIM:609621]	OMIM	HGMD	GENETEST
KCNQ1OT1	Beckwith-Wiedemann syndrome [MIM:130650]	OMIM		GENETEST
KCNQ2	Epileptic encephalopathy, early infantile, 7 [MIM:613720]; Myokymia [MIM:121200]	OMIM	HGMD	GENETEST
KCNQ3	Seizures, benign neonatal, type 2 [MIM:121201]	OMIM	HGMD	GENETEST
KCNQ4	Deafness, autosomal dominant 2A [MIM:600101]	OMIM	HGMD	GENETEST
KCNT1	Epilepsy, nocturnal frontal lobe, 5 [MIM:615005]; Epileptic encephalopathy, early infantile, 14 [MIM:614959]	OMIM	
KCNV2	Retinal cone dystrophy 3B [MIM:610356]	OMIM	HGMD	GENETEST
KCTD7	Epilepsy, progressive myoclonic 3, with or without intracellular inclusions [MIM:611726]	OMIM	HGMD	GENETEST
KDM5C	Mental retardation, X-linked, syndromic, Claes-Jensen type [MIM:300534]	OMIM	HGMD	GENETEST
KDM6A	Kabuki syndrome 2 [MIM:300867]	OMIM	HGMD	GENETEST
KDSR	Lymphoma/leukemia, B-cell, variant	OMIM	
KERA	Cornea plana congenita, recessive [MIM:217300]	OMIM	HGMD
KHDC3L	Hydatidiform mole, recurrent, 2 [MIM:614293]	OMIM	
KIAA0196	Spastic paraplegia 8, autosomal dominant [MIM:603563]	OMIM	HGMD	GENETEST
KIAA1279	Goldberg-Shprintzen megacolon syndrome [MIM:609460]	OMIM	HGMD	GENETEST
KIF11	Microcephaly with or without chorioretinopathy, lymphedema, or mental retardation [MIM:152950]	OMIM	HGMD
KIF1A	Mental retardation, autosomal dominant 9 [MIM:614255]; Neuropathy, hereditary sensory, type IIC [MIM:614213]; Spastic paraplegia 30, autosomal recessive [MIM:610357]	OMIM	HGMD	GENETEST
KIF1B	Charcot-Marie-Tooth disease, type 2A1 [MIM:118210]; Pheochromocytoma [MIM:171300]	OMIM	HGMD	GENETEST
KIF21A	Fibrosis of extraocular muscles, congenital, 1 [MIM:135700]	OMIM	HGMD	GENETEST
KIF22	Spondyloepimetaphyseal dysplasia with joint laxity, type 2 [MIM:603546]	OMIM	HGMD
KIF5A	Spastic paraplegia 10, autosomal dominant [MIM:604187]	OMIM	HGMD	GENETEST
KIF7	Hydrolethalus syndrome 2 [MIM:614120]; Joubert syndrome 12 [MIM:200990]	OMIM	HGMD	GENETEST
KIRREL3	Mental retardation, autosomal dominant 4 [MIM:612581]	OMIM	HGMD
KISS1	Hypogonadotropic hypogonadism 13 with or without anosmia [MIM:614842]	OMIM	HGMD	GENETEST
KISS1R	Hypogonadotropic hypogonadism 8 with or without anosmia [MIM:614837]; Precocious puberty, central [MIM:176400]	OMIM	HGMD	GENETEST
KIT	Gastrointestinal stromal tumor, familial [MIM:606764]; Germ cell tumors [MIM:273300]; Leukemia, acute myeloid [MIM:601626]; Mast cell disease [MIM:154800]; Piebaldism [MIM:172800]	OMIM	HGMD	GENETEST
KITLG	Hyperpigmentation, familial progressive, 2 [MIM:145250]	OMIM	HGMD
KL	Tumoral calcinosis, hyperphosphatemic [MIM:211900]	OMIM	HGMD	GENETEST
KLF1	Anemia, dyserythropoietic congenital, type IV [MIM:613673]; Blood group--Lutheran inhibitor [MIM:111150]	OMIM	HGMD	GENETEST
KLF11	Maturity-onset diabetes of the young, type VII [MIM:610508]	OMIM	HGMD	GENETEST
KLF6	Prostate adenocarcinoma	OMIM	HGMD
KLHDC8B	Hodgkin lymphoma [MIM:236000]	OMIM	HGMD
KLHL3	Pseudohypoaldosteronism, type IID [MIM:614495]	OMIM	HGMD	GENETEST
KLHL7	Retinitis pigmentosa 42 [MIM:612943]	OMIM	HGMD	GENETEST
KLK4	Amelogenesis imperfecta, type IIA1 [MIM:204700]	OMIM	HGMD	GENETEST
KLKB1	Fletcher factor deficiency [MIM:612423]	OMIM	HGMD
KRAS	Cardiofaciocutaneous syndrome [MIM:115150]; Leukemia, acute myelogenous; Noonan syndrome 3 [MIM:609942]	OMIM	HGMD	GENETEST
KRIT1	Cerebral cavernous malformations-1 [MIM:116860]	OMIM	HGMD	GENETEST
KRT1	Epidermolytic hyperkeratosis [MIM:113800]; Ichthyosis histrix, Curth-Macklin type [MIM:146590]; Ichthyosis, cyclic, with epidermolytic hyperkeratosis [MIM:607602]; Keratosis palmoplantaris striata III [MIM:607654]; Palmoplantar keratoderma, epidermolytic [MIM:144200]; Palmoplantar keratoderma, nonepidermolytic [MIM:600962]	OMIM	HGMD	GENETEST
KRT10	Epidermolytic hyperkeratosis [MIM:113800]; Ichthyosis with confetti [MIM:609165]; Ichthyosis, cyclic, with epidermolytic hyperkeratosis [MIM:607602]	OMIM	HGMD	GENETEST
KRT12	Meesmann corneal dystrophy [MIM:122100]	OMIM	HGMD
KRT13	White sponge nevus [MIM:193900]	OMIM	HGMD	GENETEST
KRT14	Dermatopathia pigmentosa reticularis [MIM:125595]; Epidermolysis bullosa simplex, Dowling-Meara type [MIM:131760]; Epidermolysis bullosa simplex, Koebner type [MIM:131900]; Epidermolysis bullosa simplex, Weber-Cockayne type [MIM:131800]; Epidermolysis bullosa simplex, recessive [MIM:601001]; Naegeli-Franceschetti-Jadassohn syndrome [MIM:161000]	OMIM	HGMD	GENETEST
KRT16	Pachyonychia congenita, Jadassohn-Lewandowsky type [MIM:167200]; Palmoplantar keratoderma, nonepidermolytic [MIM:600962]; Palmoplantar keratoderma, nonepidermolytic, focal [MIM:613000]; Palmoplantar verrucous nevus, unilateral [MIM:144200]	OMIM	HGMD	GENETEST
KRT17	Pachyonychia congenita, Jackson-Lawler type [MIM:167210]; Steatocystoma multiplex [MIM:184500]	OMIM	HGMD	GENETEST
KRT18	Cirrhosis, cryptogenic	OMIM	HGMD
KRT2	Ichthyosis bullosa of Siemens [MIM:146800]	OMIM	HGMD	GENETEST
KRT3	Meesmann corneal dystrophy [MIM:122100]	OMIM	HGMD
KRT4	White sponge nevus [MIM:193900]	OMIM	HGMD	GENETEST
KRT5	Dowling-Degos disease [MIM:179850]; Epidermolysis bullosa simplex with migratory circinate erythema [MIM:609352]; Epidermolysis bullosa simplex with mottled pigmentation [MIM:131960]; Epidermolysis bullosa simplex, Dowling-Meara type [MIM:131760]; Epidermolysis bullosa simplex, Koebner type [MIM:131900]; Epidermolysis bullosa simplex, Weber-Cockayne type [MIM:131800]	OMIM	HGMD	GENETEST
KRT6A	Pachyonychia congenita, Jadassohn-Lewandowsky type [MIM:167200]	OMIM	HGMD	GENETEST
KRT6B	Pachyonychia congenita, Jackson-Lawler type [MIM:167210]	OMIM	HGMD	GENETEST
KRT74	Hypotrichosis simplex of the scalp 2 [MIM:613981]; Woolly hair, autosomal dominant [MIM:194300]	OMIM	HGMD
KRT8	Cirrhosis, cryptogenic	OMIM	HGMD
KRT81	Monilethrix [MIM:158000]	OMIM	HGMD	GENETEST
KRT83	Monilethrix [MIM:158000]	OMIM	HGMD	GENETEST
KRT85	Ectodermal dysplasia 4, hair/nail type [MIM:602032]	OMIM	HGMD
KRT86	Monilethrix [MIM:158000]	OMIM	HGMD	GENETEST
KRT9	Epidermolytic palmoplantar keratoderma [MIM:144200]	OMIM	HGMD	GENETEST
L1CAM	Corpus callosum, partial agenesis of [MIM:304100]; Hydrocephalus with Hirschsprung disease [MIM:307000]; MASA syndrome [MIM:303350]	OMIM	HGMD	GENETEST
L2HGDH	L-2-hydroxyglutaric aciduria [MIM:236792]	OMIM	HGMD	GENETEST
LAMA2	Muscular dystrophy, congenital merosin-deficient [MIM:607855]	OMIM	HGMD	GENETEST
LAMA3	Epidermolysis bullosa, generalized atrophic benign [MIM:226650]; Epidermolysis bullosa, junctional, Herlitz type [MIM:226700]; Laryngoonychocutaneous syndrome [MIM:245660]	OMIM	HGMD	GENETEST
LAMB2	Nephrotic syndrome, type 5, with or without ocular abnormalities [MIM:614199]; Pierson syndrome [MIM:609049]	OMIM	HGMD	GENETEST
LAMB3	Epidermolysis bullosa, junctional, Herlitz type [MIM:226700]; Epidermolysis bullosa, junctional, non-Herlitz type [MIM:226650]	OMIM	HGMD	GENETEST
LAMC2	Epidermolysis bullosa, junctional, Herlitz type [MIM:226700]; Epidermolysis bullosa, junctional, non-Herlitz type [MIM:226650]	OMIM	HGMD	GENETEST
LAMC3	Cortical malformations, occipital [MIM:614115]	OMIM	HGMD
LAMP2	Danon disease [MIM:300257]	OMIM	HGMD	GENETEST
LAMTOR2	Immunodeficiency due to defect in MAPBP-interacting protein [MIM:610798]	OMIM	HGMD
LARGE	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 6 [MIM:613154]; Muscular dystrophy-dystroglycanopathy (congenital with mental retardation), type B, 6 [MIM:608840]	OMIM	HGMD	GENETEST
LBR	HEM skeletal dysplasia [MIM:215140]; Pelger-Huet anomaly [MIM:169400]; Reynolds syndrome [MIM:613471]	OMIM	HGMD	GENETEST
LCA5	Leber congenital amaurosis 5 [MIM:604537]	OMIM	HGMD	GENETEST
LCAT	Fish-eye disease [MIM:136120]; Norum disease [MIM:245900]	OMIM	HGMD	GENETEST
LCK	SCID due to LCK deficiency	OMIM	
LCT	Lactase deficiency, congenital [MIM:223000]	OMIM	HGMD	GENETEST
LDB3	Cardiomyopathy, dilated 1C [MIM:601493]; Myopathy, myofibrillar, ZASP-related [MIM:609452]	OMIM	HGMD	GENETEST
LDHA	Glycogen storage disease XI [MIM:612933]	OMIM	HGMD	GENETEST
LDHB	Lactate dehydrogenase-B deficiency [MIM:614128]	OMIM	HGMD	GENETEST
LDLR	LDL cholesterol level QTL2 [MIM:143890]	OMIM	HGMD	GENETEST
LDLRAP1	Hypercholesterolemia, familial, autosomal recessive [MIM:603813]	OMIM	HGMD	GENETEST
LEFTY2	Left-right axis malformations	OMIM	HGMD	GENETEST
LEMD3	Melorheostosis with osteopoikilosis [MIM:155950]; Osteopoikilosis [MIM:166700]	OMIM	HGMD	GENETEST
LEP	Obesity, morbid, due to leptin deficiency [MIM:614962]	OMIM	HGMD	GENETEST
LEPR	Obesity, morbid, due to leptin receptor deficiency [MIM:614963]	OMIM	HGMD	GENETEST
LEPRE1	Osteogenesis imperfecta, type VIII [MIM:610915]	OMIM	HGMD	GENETEST
LEPREL1	Myopia, high, with cataract and vitreoretinal degeneration [MIM:614292]	OMIM	HGMD
LFNG	Spondylocostal dysostosis, autosomal recessive 3 [MIM:609813]	OMIM	HGMD	GENETEST
LGI1	Epilepsy, familial temporal lobe, 1 [MIM:600512]	OMIM	HGMD	GENETEST
LHB	Hypogonadism, hypergonadotropic	OMIM	HGMD
LHCGR	Luteinizing hormone resistance, female [MIM:238320]; Precocious puberty, male [MIM:176410]	OMIM	HGMD	GENETEST
LHFPL5	Deafness, autosomal recessive 67 [MIM:610265]	OMIM	HGMD	GENETEST
LHX3	Pituitary hormone deficiency, combined, 3 [MIM:221750]	OMIM	HGMD	GENETEST
LHX4	Pituitary hormone deficiency, combined, 4 [MIM:262700]	OMIM	HGMD	GENETEST
LIAS	Pyruvate dehydrogenase lipoic acid synthetase deficiency [MIM:614462]	OMIM	HGMD
LIFR	Stuve-Wiedemann syndrome/Schwartz-Jampel type 2 syndrome [MIM:601559]	OMIM	HGMD	GENETEST
LIG1	DNA ligase I deficiency	OMIM	HGMD
LIG4	LIG4 syndrome [MIM:606593]; Severe combined immunodeficiency with sensitivity to ionizing radiation [MIM:602450]	OMIM	HGMD	GENETEST
LIM2	Cataract, cortical pulverulent, late-onset	OMIM	HGMD	GENETEST
LIPA	Wolman disease [MIM:278000]	OMIM	HGMD	GENETEST
LIPC	Hepatic lipase deficiency [MIM:614025]	OMIM	HGMD	GENETEST
LIPH	Hypotrichosis, localized, autosomal recessive 2 [MIM:604379]	OMIM	HGMD
LIPN	Ichthyosis, congenital, autosomal recessive 8 [MIM:613943]	OMIM	HGMD
LITAF	Charcot-Marie-Tooth disease, type 1C [MIM:601098]	OMIM	HGMD	GENETEST
LMAN1	Combined factor V and VIII deficiency [MIM:227300]	OMIM	HGMD	GENETEST
LMBR1	Acheiropody [MIM:200500]; Syndactyly, type IV [MIM:186200]; Triphalangeal thumb, type I [MIM:174500]	OMIM		GENETEST
LMBRD1	Methylmalonic aciduria and homocystinuria, cblF type [MIM:277380]	OMIM	HGMD	GENETEST
LMF1	Lipase deficiency, combined [MIM:246650]	OMIM	HGMD
LMNA	Cardiomyopathy, dilated, 1A [MIM:115200]; Charcot-Marie-Tooth disease, type 2B1 [MIM:605588]; Emery-Dreifuss muscular dystrophy 2, AD [MIM:181350]; Heart-hand syndrome, Slovenian type [MIM:610140]; Hutchinson-Gilford progeria [MIM:176670]; Lipodystrophy, familial partial, 2 [MIM:151660]; Malouf syndrome [MIM:212112]; Mandibuloacral dysplasia [MIM:248370]; Muscular dystrophy, congenital [MIM:613205]; Muscular dystrophy, limb-girdle, type 1B [MIM:159001]; Restrictive dermopathy, lethal [MIM:275210]	OMIM	HGMD	GENETEST
LMNB1	Leukodystrophy, adult-onset, autosomal dominant [MIM:169500]	OMIM		GENETEST
LMO1	Leukemia, T-cell acute lymphoblastic	OMIM	
LMO2	Leukemia, acute T-cell	OMIM	
LMX1B	Nail-patella syndrome [MIM:161200]	OMIM	HGMD	GENETEST
LOR	Vohwinkel syndrome with ichthyosis [MIM:604117]	OMIM	HGMD
LOXHD1	Deafness, autosomal recessive 77 [MIM:613079]	OMIM	HGMD	GENETEST
LPAR6	Hypotrichosis 8 [MIM:278150]	OMIM	HGMD
LPIN1	Myoglobinuria, acute recurrent, autosomal recessive [MIM:268200]	OMIM	HGMD	GENETEST
LPIN2	Majeed syndrome [MIM:609628]	OMIM	HGMD	GENETEST
LPL	Combined hyperlipidemia, familial [MIM:144250]; Lipoprotein lipase deficiency [MIM:238600]	OMIM	HGMD	GENETEST
LPP	Leukemia, acute myeloid [MIM:601626]; Lipoma	OMIM	
LRAT	Leber congenital amaurosis 14 [MIM:613341]	OMIM	HGMD	GENETEST
LRBA	Immunodeficiency, common variable, 8, with autoimmunity [MIM:614700]	OMIM	
LRIT3	Night blindness, congenital stationary (complete), 1F, autosomal recessive [MIM:615058]	OMIM	
LRP2	Donnai-Barrow syndrome [MIM:222448]	OMIM	HGMD	GENETEST
LRP4	Cenani-Lenz syndactyly syndrome [MIM:212780]; Sclerosteosis 2 [MIM:614305]	OMIM	HGMD	GENETEST
LRP5	Exudative vitreoretinopathy 4 [MIM:601813]; Osteopetrosis, autosomal dominant 1 [MIM:607634]; Osteoporosis-pseudoglioma syndrome [MIM:259770]; Osteosclerosis [MIM:144750]; van Buchem disease, type 2 [MIM:607636]	OMIM	HGMD	GENETEST
LRPPRC	Leigh syndrome, French-Canadian type [MIM:220111]	OMIM	HGMD	GENETEST
LRRC6	Ciliary dyskinesia, primary, 19 [MIM:614935]	OMIM		GENETEST
LRRC8A	Agammaglobulinemia 5 [MIM:613506]	OMIM	
LRRK2	Parkinson disease 8 [MIM:607060]	OMIM	HGMD	GENETEST
LRSAM1	Charcot-Marie-Toothe disease, axonal, type 2P [MIM:614436]	OMIM	HGMD	GENETEST
LRTOMT	Deafness, autosomal recessive 63 [MIM:611451]	OMIM	HGMD	GENETEST
LTBP2	Glaucoma 3, primary congenital, D [MIM:613086]; Microspherophakia and/or megalocornea, with ectopia lentis and with or without secondary glaucoma [MIM:251750]; Weill-Marchesani syndrome 3 [MIM:614819]	OMIM	HGMD	GENETEST
LTBP3	Tooth agenesis, selective, 6 [MIM:613097]	OMIM	HGMD
LTBP4	Cutis laxa, autosomal recessive, type IC [MIM:613177]	OMIM	HGMD	GENETEST
LTC4S	Leukotriene C4 synthase deficiency [MIM:614037]	OMIM	HGMD
LYL1	Leukemia, T-cell acute lymphoblastoid	OMIM	
LYST	Chediak-Higashi syndrome [MIM:214500]	OMIM	HGMD	GENETEST
LYZ	Amyloidosis, renal [MIM:105200]	OMIM	HGMD	GENETEST
LZTS1	Esophageal squamous cell carcinoma [MIM:133239]	OMIM	HGMD
MAF	Cataract, pulverulent or cerulean, with or without microcornea [MIM:610202]	OMIM	HGMD
MAFB	Multicentric carpotarsal osteolysis syndrome [MIM:166300]	OMIM		GENETEST
MAGT1	Immunodeficiency, X-linked, with magnesium defect, Epstein-Barr virus infection and neoplasia [MIM:300853]; Mental retardation, X-linked 95 [MIM:300716]	OMIM	HGMD	GENETEST
MAK	REtinitis pigmentosa 62 [MIM:614181]	OMIM	HGMD	GENETEST
MALT1	MALT lymphoma	OMIM	
MAML2	Mucoepidermoid salivary gland carcinoma	OMIM	
MAMLD1	Hypospadias 2, X-linked [MIM:300758]	OMIM	HGMD	GENETEST
MAN1B1	Mental retardation, autosomal recessive 15 [MIM:614202]	OMIM	HGMD	GENETEST
MAN2B1	Mannosidosis, alpha-, types I and II [MIM:248500]	OMIM	HGMD	GENETEST
MANBA	Mannosidosis, beta [MIM:248510]	OMIM	HGMD	GENETEST
MAOA	Brunner syndrome [MIM:300615]	OMIM	HGMD	GENETEST
MAP2K1	Cardiofaciocutaneous syndrome [MIM:115150]	OMIM	HGMD	GENETEST
MAP2K2	Cardiofaciocutaneous syndrome [MIM:115150]	OMIM	HGMD	GENETEST
MAP3K1	46XY sex reversal 6 [MIM:613762]	OMIM	HGMD
MAPK10	Epileptic encephalopathy, Lennox-Gastaut type [MIM:606369]	OMIM		GENETEST
MAPT	Dementia, frontotemporal, with or without parkinsonism [MIM:600274]; Pick disease [MIM:172700]; Supranuclear palsy, progressive [MIM:601104]; Supranuclear palsy, progressive atypical [MIM:260540]; Tauopathy and respiratory failure	OMIM	HGMD	GENETEST
MARVELD2	Deafness, autosomal recessive 49 [MIM:610153]	OMIM	HGMD	GENETEST
MASP1	3MC syndrome 1 [MIM:257920]	OMIM	HGMD
MASP2	MASP2 deficiency [MIM:613791]	OMIM	HGMD	GENETEST
MASTL	Thrombocytopenia-2 [MIM:188000]	OMIM	HGMD	GENETEST
MAT1A	Methionine adenosyltransferase deficiency, autosomal recessive [MIM:250850]	OMIM	HGMD	GENETEST
MATN3	Epiphyseal dysplasia, multiple, 5 [MIM:607078]; Spondyloepimetaphyseal dysplasia [MIM:608728]	OMIM	HGMD	GENETEST
MATR3	Myopathy, distal 2 [MIM:606070]	OMIM	HGMD	GENETEST
MBD5	Mental retardation, autosomal dominant 1 [MIM:156200]	OMIM	HGMD	GENETEST
MBTPS2	IFAP syndrome with or without BRESHECK syndrome [MIM:308205]; Keratosis follicularis spinulosa decalvans, X-linked [MIM:308800]	OMIM	HGMD	GENETEST
MC2R	Glucocorticoid deficiency, due to ACTH unresponsiveness [MIM:202200]	OMIM	HGMD	GENETEST
MC4R	Obesity, autosomal dominant [MIM:601665]	OMIM	HGMD	GENETEST
MCC	Colorectal cancer	OMIM	
MCCC1	3-Methylcrotonyl-CoA carboxylase 1 deficiency [MIM:210200]	OMIM	HGMD	GENETEST
MCCC2	3-Methylcrotonyl-CoA carboxylase 2 deficiency [MIM:210210]	OMIM	HGMD	GENETEST
MCEE	Methylmalonyl-CoA epimerase deficiency [MIM:251120]	OMIM	HGMD	GENETEST
MCFD2	Factor V and factor VIII, combined deficiency of [MIM:613625]	OMIM	HGMD	GENETEST
MCM4	Natural killer cell and glucocorticoid deficiency with DNA repair defect [MIM:609981]	OMIM		GENETEST
MCM6	Lactase persistance/nonpersistance [MIM:223100]	OMIM		GENETEST
MCOLN1	Mucolipidosis IV [MIM:252650]	OMIM	HGMD	GENETEST
MCPH1	Microcephaly 1, primary, autosomal recessive [MIM:251200]	OMIM	HGMD	GENETEST
MECOM	3q21q26 syndrome; Myelodysplasia syndrome-1	OMIM	
MECP2	Angelman syndrome [MIM:105830]; Encephalopathy, neonatal severe [MIM:300673]; Mental retardation, X-linked syndromic, Lubs type [MIM:300260]; Mental retardation, X-linked, syndromic 13 [MIM:300055]; Rett syndrome [MIM:312750]	OMIM	HGMD	GENETEST
MED12	Lujan-Fryns syndrome [MIM:309520]; Opitz-Kaveggia syndrome [MIM:305450]	OMIM	HGMD	GENETEST
MED13L	Transposition of the great arteries, dextro-looped 1 [MIM:608808]	OMIM	HGMD
MED17	Microcephaly, postnatal progressive, with seizures and brain atrophy [MIM:613668]	OMIM	HGMD
MED23	Mental retardation, autosomal recessive 18 [MIM:614249]	OMIM	HGMD
MED25	Charcot-Marie-Tooth disease, type 2B2 [MIM:605589]	OMIM	HGMD	GENETEST
MEF2C	Chromosome 5q14.3 deletion syndrome [MIM:613443]	OMIM	HGMD	GENETEST
MEFV	Familial Mediterranean fever, AD [MIM:134610]; Familial Mediterranean fever, AR [MIM:249100]	OMIM	HGMD	GENETEST
MEGF10	Myopathy, areflexia, respiratory distress, and dysphagia, early-onset [MIM:614399]	OMIM	HGMD	GENETEST
MEGF8	Carpenter syndrome 2 [MIM:614976]	OMIM	
MEN1	Carcinoid tumor of lung; Multiple endocrine neoplasia 1 [MIM:131100]	OMIM	HGMD	GENETEST
MERTK	Retinitis pigmentosa 38 [MIM:613862]	OMIM	HGMD	GENETEST
MESP2	Spondylocostal dysostosis, autosomal recessive 2 [MIM:608681]	OMIM	HGMD	GENETEST
MET	Hepatocellular carcinoma, childhood type [MIM:114550]	OMIM	HGMD	GENETEST
MFHAS1	Malignant fibrous histiocytoma	OMIM	
MFN2	Charcot-Marie-Tooth disease, type 2A2 [MIM:609260]; Hereditary motor and sensory neuropathy VI [MIM:601152]	OMIM	HGMD	GENETEST
MFRP	Microphthalmia, isolated 5 [MIM:611040]; Nanophthalmos 2 [MIM:609549]	OMIM	HGMD	GENETEST
MFSD8	Ceroid lipofuscinosis, neuronal, 7 [MIM:610951]	OMIM	HGMD	GENETEST
MGAT2	Congenital disorder of glycosylation, type IIa [MIM:212066]	OMIM	HGMD	GENETEST
MGP	Keutel syndrome [MIM:245150]	OMIM	HGMD	GENETEST
MID1	Opitz GBBB syndrome, type I [MIM:300000]	OMIM	HGMD	GENETEST
MINPP1	Thyroid carcinoma, follicular [MIM:188470]	OMIM	HGMD
MIP	Cataract, polymorphic and lamellar	OMIM	HGMD
MIPOL1	Mirror-image polydactyly [MIM:135750]	OMIM	
MIR17HG	Feingold syndrome 2 [MIM:614326]	OMIM		GENETEST
MIR184	EDICT syndrome [MIM:614303]	OMIM	HGMD
MIR96	Deafness, autosomal dominant 50 [MIM:613074]	OMIM	HGMD	GENETEST
MITF	Tietz albinism-deafness syndrome [MIM:103500]; Waardenburg syndrome, type 2A [MIM:193510]; Waardenburg syndrome/ocular albinism, digenic [MIM:103470]	OMIM	HGMD	GENETEST
MKKS	Bardet-Biedl syndrome 6 [MIM:209900]; McKusick-Kaufman syndrome [MIM:236700]	OMIM	HGMD	GENETEST
MKL1	Megakaryoblastic leukemia, acute	OMIM	HGMD
MKS1	Bardet-Biedl syndrome 13 [MIM:209900]; Meckel syndrome 1 [MIM:249000]	OMIM	HGMD	GENETEST
MLC1	Megalencephalic leukoencephalopathy with subcortical cysts [MIM:604004]	OMIM	HGMD	GENETEST
MLF1	Leukemia, acute myeloid [MIM:601626]	OMIM	
MLH1	Colorectal cancer, hereditary nonpolyposis, type 2 [MIM:609310]; Mismatch repair cancer syndrome [MIM:276300]; Muir-Torre syndrome [MIM:158320]	OMIM	HGMD	GENETEST
MLH3	Colon cancer, hereditary nonpolyposis, type 7 [MIM:614385]; Endometrial cancer [MIM:608089]	OMIM	HGMD	GENETEST
MLL	Leukemia, myeloid/lymphoid or mixed-lineage; Wiedemann-Steiner syndrome [MIM:605130]	OMIM	
MLL2	Kabuki syndrome 1 [MIM:147920]	OMIM	HGMD	GENETEST
MLLT10	Leukemia, acute T-cell lymphoblastic; Leukemia, acute myeloid [MIM:601626]	OMIM	
MLLT11	Leukemia, acute myelomonocytic	OMIM	
MLPH	Griscelli syndrome, type 3 [MIM:609227]	OMIM	HGMD
MLYCD	Malonyl-CoA decarboxylase deficiency [MIM:248360]	OMIM	HGMD	GENETEST
MMAA	Methylmalonic aciduria, vitamin B12-responsive [MIM:251100]	OMIM	HGMD	GENETEST
MMAB	Methylmalonic aciduria, vitamin B12-responsive, due to defect in synthesis of adenosylcobalamin, cblB complementation type [MIM:251110]	OMIM	HGMD	GENETEST
MMACHC	Methylmalonic aciduria and homocystinuria, cblC type [MIM:277400]	OMIM	HGMD	GENETEST
MMADHC	Homocystinuria, cblD type, variant 1 [MIM:277410]	OMIM	HGMD	GENETEST
MME	Membranous glomerulonephritis, antenatal	OMIM	HGMD
MMP1	COPD, rate of decline of lung function in [MIM:606963]	OMIM	HGMD
MMP13	Metaphyseal anadysplasia 1 [MIM:602111]	OMIM	HGMD	GENETEST
MMP2	Torg-Winchester syndrome [MIM:259600]	OMIM	HGMD	GENETEST
MMP20	Amelogenesis imperfecta, type IIA2 [MIM:612529]	OMIM	HGMD	GENETEST
MMP9	Metaphyseal anadysplasia 2 [MIM:613073]	OMIM	HGMD
MN1	Meningioma [MIM:607174]	OMIM	
MNX1	Currarino syndrome [MIM:176450]	OMIM	HGMD	GENETEST
MOCS1	Molybdenum cofactor deficiency, type A [MIM:252150]	OMIM	HGMD	GENETEST
MOCS2	Molybdenum cofactor deficiency, type B [MIM:252150]	OMIM	HGMD	GENETEST
MOG	Narcolepsy 7 [MIM:614250]	OMIM	HGMD
MOGS	Congenital disorder of glycosylation, type IIb [MIM:606056]	OMIM	HGMD	GENETEST
MPC1	Mitochondrial pyruvate carrier deficiency [MIM:614741]	OMIM	
MPDU1	Congenital disorder of glycosylation, type If [MIM:609180]	OMIM	HGMD	GENETEST
MPI	Congenital disorder of glycosylation, type Ib [MIM:602579]	OMIM	HGMD	GENETEST
MPL	Thrombocythemia 2 [MIM:601977]; Thrombocytopenia, congenital amegakaryocytic [MIM:604498]	OMIM	HGMD	GENETEST
MPLKIP	Trichothiodystrophy, nonphotosensitive 1 [MIM:234050]	OMIM		GENETEST
MPO	Myeloperoxidase deficiency [MIM:254600]	OMIM	HGMD
MPV17	Mitochondrial DNA depletion syndrome 6 (hepatocerebral type) [MIM:256810]	OMIM	HGMD	GENETEST
MPZ	Charcot-Marie-Tooth disease, dominant intermediate D [MIM:607791]; Charcot-Marie-Tooth disease, type 1B [MIM:118200]; Charcot-Marie-Tooth disease, type 2I [MIM:607677]; Charcot-Marie-Tooth disease, type 2J [MIM:607736]; Dejerine-Sottas disease [MIM:145900]; Neuropathy, congenital hypomyelinating [MIM:605253]; Roussy-Levy syndrome [MIM:180800]	OMIM	HGMD	GENETEST
MRAP	Glucocorticoid deficiency 2 [MIM:607398]	OMIM	HGMD	GENETEST
MRE11A	Ataxia-telangiectasia-like disorder [MIM:604391]	OMIM	HGMD	GENETEST
MRPL3	Combined oxidative phosphorylation deficiency 9 [MIM:614582]	OMIM	HGMD
MRPS16	Combined oxidative phosphorylation deficiency 2 [MIM:610498]	OMIM	HGMD	GENETEST
MRPS22	Combined oxidative phosphorylation deficiency 5 [MIM:611719]	OMIM	HGMD	GENETEST
MRTO4	Mental retardation, autosomal recessive, 4	OMIM	
MS4A1	Immunodeficiency, common variable, 5 [MIM:613495]	OMIM	HGMD
MSH2	Colorectal cancer, hereditary nonpolyposis, type 1 [MIM:120435]; Mismatch repair cancer syndrome [MIM:276300]; Muir-Torre syndrome [MIM:158320]	OMIM	HGMD	GENETEST
MSH3	Endometrial carcinoma	OMIM	HGMD
MSH6	Colorectal cancer, hereditary nonpolyposis, type 5 [MIM:614350]; Endometrial cancer, familial [MIM:608089]; Mismatch repair cancer syndrome [MIM:276300]	OMIM	HGMD	GENETEST
MSR1	Barrett esophagus/esophageal adenocarcinoma [MIM:614266]; Prostate cancer, hereditary [MIM:176807]	OMIM	HGMD
MSRB3	Deafness, autosomal recessive 74 [MIM:613718]	OMIM	HGMD
MSTN	Muscle hypertrophy [MIM:614160]	OMIM	HGMD	GENETEST
MSX1	Ectodermal dysplasia 3, Witkop type [MIM:189500]; Orofacial cleft 5 [MIM:608874]; Tooth agenesis, selective, 1, with or without orofacial cleft [MIM:106600]	OMIM	HGMD	GENETEST
MSX2	Craniosynostosis, type 2 [MIM:604757]; Parietal foramina 1 [MIM:168500]; Parietal foramina with cleidocranial dysplasia [MIM:168550]	OMIM	HGMD	GENETEST
MTAP	Diaphyseal medullary stenosis with malignant fibrous histiocytoma [MIM:112250]	OMIM		GENETEST
MTFMT	Combined oxidative phosphorylation deficiency 15 [MIM:614947]	OMIM	HGMD
MTHFR	Homocystinuria due to MTHFR deficiency [MIM:236250]	OMIM	HGMD	GENETEST
MTM1	Myotubular myopathy, X-linked [MIM:310400]	OMIM	HGMD	GENETEST
MTMR2	Charcot-Marie-Tooth disease, type 4B1 [MIM:601382]	OMIM	HGMD	GENETEST
MTO1	Combined oxidative phosphorylation deficiency 10 [MIM:614702]	OMIM		GENETEST
MTPAP	Ataxia, spastic, 4 [MIM:613672]	OMIM	HGMD
MTR	Methylcobalamin deficiency, cblG type [MIM:250940]	OMIM	HGMD	GENETEST
MTRR	Homocystinuria-megaloblastic anemia, cbl E type [MIM:236270]	OMIM	HGMD	GENETEST
MTTP	Abetalipoproteinemia [MIM:200100]	OMIM	HGMD	GENETEST
MUSK	Myasthenic syndrome, congenital, associated with acetylcholine receptor deficiency [MIM:608931]	OMIM	HGMD	GENETEST
MUT	Methylmalonic aciduria, mut(0) type [MIM:251000]	OMIM	HGMD	GENETEST
MUTYH	Adenomas, multiple colorectal [MIM:608456]; Colorectal adenomatous polyposis, autosomal recessive, with pilomatricomas [MIM:132600]	OMIM	HGMD	GENETEST
MVK	Hyper-IgD syndrome [MIM:260920]; Mevalonic aciduria [MIM:610377]; Porokeratosis 3, disseminated superficial actinic [MIM:175900]	OMIM	HGMD	GENETEST
MXI1	Neurofibrosarcoma	OMIM	
MYBPC1	Arthrogryposis, distal, type 1B [MIM:614335]; Lethal congenital contracture syndrome 4 [MIM:614915]	OMIM	HGMD	GENETEST
MYBPC3	Cardiomyopathy, familial hypertrophic, 4 [MIM:115197]	OMIM	HGMD	GENETEST
MYC	Burkitt lymphoma [MIM:113970]	OMIM	HGMD
MYCN	Feingold syndrome [MIM:164280]	OMIM	HGMD	GENETEST
MYD88	Pyogenic bacterial infections, recurrent, due to MYD88 deficiency [MIM:612260]	OMIM	HGMD
MYF6	Myopathy, centronuclear, 3 [MIM:614408]	OMIM	HGMD	GENETEST
MYH11	Aortic aneurysm, familial thoracic 4 [MIM:132900]	OMIM	HGMD	GENETEST
MYH14	Deafness, autosomal dominant 4A [MIM:600652]; Peripheral neuropathy, myopathy, hoarseness, and hearing loss [MIM:614369]	OMIM	HGMD	GENETEST
MYH2	Inclusion body myopathy-3 [MIM:605637]	OMIM	HGMD	GENETEST
MYH3	Arthrogryposis, distal, type 2A [MIM:193700]; Arthrogryposis, distal, type 2B [MIM:601680]	OMIM	HGMD	GENETEST
MYH6	Atrial septal defect 3 [MIM:614089]; Cardiomyopathy, dilated, 1EE [MIM:613252]; Cardiomyopathy, familial hypertrophic, 14 [MIM:613251]	OMIM	HGMD	GENETEST
MYH7	Cardiomyopathy, dilated, 1S [MIM:613426]; Cardiomyopathy, familial hypertrophic, 1 [MIM:192600]; Laing distal myopathy [MIM:160500]; Myopathy, myosin storage [MIM:608358]; Scapuloperoneal syndrome, myopathic type [MIM:181430]	OMIM	HGMD	GENETEST
MYH8	Carney complex variant [MIM:608837]; Trismus-pseudocamptodactyly syndrome [MIM:158300]	OMIM	HGMD	GENETEST
MYH9	Deafness, autosomal dominant 17 [MIM:603622]; Epstein syndrome [MIM:153650]; Fechtner syndrome [MIM:153640]; Macrothrombocytopenia and progressive sensorineural deafness [MIM:600208]; May-Hegglin anomaly [MIM:155100]; Sebastian syndrome [MIM:605249]	OMIM	HGMD	GENETEST
MYL2	Cardiomyopathy, familial hypertrophic, 10 [MIM:608758]	OMIM	HGMD	GENETEST
MYL3	Cardiomyopathy, familial hypertrophic, 8 [MIM:608751]	OMIM	HGMD	GENETEST
MYLK	Aortic aneurysm, familial thoracic 7 [MIM:613780]	OMIM	HGMD	GENETEST
MYLK2	Cardiomyopathy, hypertrophic, midventricular, digenic [MIM:192600]	OMIM	HGMD	GENETEST
MYO15A	Deafness, autosomal recessive 3 [MIM:600316]	OMIM	HGMD	GENETEST
MYO1A	Deafness, autosomal dominant 48 [MIM:607841]	OMIM	HGMD	GENETEST
MYO1E	Glomerulosclerosis, focal segmental, 6 [MIM:614131]	OMIM	HGMD
MYO3A	Deafness, autosomal recessive 30 [MIM:607101]	OMIM	HGMD	GENETEST
MYO5A	Griscelli syndrome, type 1 [MIM:214450]	OMIM	HGMD
MYO5B	Microvillus inclusion disease [MIM:251850]	OMIM	HGMD	GENETEST
MYO6	Deafness, autosomal dominant 22 [MIM:606346]; Deafness, autosomal recessive 37 [MIM:607821]	OMIM	HGMD	GENETEST
MYO7A	Deafness, autosomal dominant 11 [MIM:601317]; Deafness, autosomal recessive 2 [MIM:600060]; Usher syndrome, type 1B [MIM:276900]	OMIM	HGMD	GENETEST
MYOC	Glaucoma 1A, primary open angle [MIM:137750]	OMIM	HGMD	GENETEST
MYOT	Muscular dystrophy, limb-girdle, type 1A [MIM:159000]; Myopathy, spheroid body [MIM:182920]; Myotilinopathy [MIM:609200]	OMIM	HGMD	GENETEST
MYOZ2	Cardiomyopathy, familial hypertrophic, 16 [MIM:613838]	OMIM	HGMD	GENETEST
NAA10	N-terminal acetyltransferase deficiency [MIM:300855]	OMIM	HGMD	GENETEST
NAGA	Kanzaki disease [MIM:609242]; Schindler disease, type I [MIM:609241]	OMIM	HGMD	GENETEST
NAGLU	Mucopolysaccharidosis type IIIB (Sanfilippo B) [MIM:252920]	OMIM	HGMD	GENETEST
NAGS	N-acetylglutamate synthase deficiency [MIM:237310]	OMIM	HGMD	GENETEST
NAT8L	N-acetylaspartate deficiency [MIM:614063]	OMIM	HGMD
NBAS	Short stature, optic nerve atrophy, and Pelger-Huet anomaly [MIM:614800]	OMIM	HGMD
NBEAL2	Gray platelet syndrome [MIM:139090]	OMIM	HGMD	GENETEST
NBEAP1	Lymphoma, diffuse large cell	OMIM	
NBN	Leukemia, acute lymphoblastic; Nijmegen breakage syndrome [MIM:251260]	OMIM	HGMD	GENETEST
NCF1	Chronic granulomatous disease due to deficiency of NCF-1 [MIM:233700]	OMIM	HGMD	GENETEST
NCF2	Chronic granulomatous disease due to deficiency of NCF-2 [MIM:233710]	OMIM	HGMD	GENETEST
NCF4	Granulomatous disease, chronic, autosomal recessive, cytochrome b-positive, type III [MIM:613960]	OMIM	HGMD	GENETEST
NCOA4	Thyroid carcinoma, papillary [MIM:188550]	OMIM	
NCSTN	Acne inversa, familial, 1 [MIM:142690]	OMIM	HGMD
NDE1	Lissencephaly 4 (with microcephaly) [MIM:614019]	OMIM	HGMD	GENETEST
NDN	Prader-Willi syndrome [MIM:176270]	OMIM	
NDP	Exudative vitreoretinopathy, X-linked [MIM:305390]; Norrie disease [MIM:310600]	OMIM	HGMD	GENETEST
NDRG1	Charcot-Marie-Tooth disease, type 4D [MIM:601455]	OMIM	HGMD	GENETEST
NDUFA1	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFA10	Leigh syndrome [MIM:256000]	OMIM	HGMD	GENETEST
NDUFA11	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFA12	Leigh syndrome due to mitochondrial complex 1 deficiency [MIM:256000]	OMIM	HGMD
NDUFA2	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]	OMIM	HGMD	GENETEST
NDUFA9	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]	OMIM	HGMD
NDUFAF1	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFAF2	Leigh syndrome [MIM:256000]; Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFAF3	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFAF4	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFAF5	Mitochondrial complex 1 deficiency [MIM:252010]	OMIM		GENETEST
NDUFAF6	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]	OMIM		GENETEST
NDUFB3	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD
NDUFS1	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFS2	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFS3	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]; Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFS4	Leigh syndrome [MIM:256000]; Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFS6	Complex I, mitochondrial respiratory chain, deficiency of [MIM:252010]	OMIM	HGMD	GENETEST
NDUFS7	Leigh syndrome [MIM:256000]	OMIM	HGMD	GENETEST
NDUFS8	Leigh syndrome due to mitochondrial complex I deficiency [MIM:256000]	OMIM	HGMD	GENETEST
NDUFV1	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NDUFV2	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NEB	Nemaline myopathy 2, autosomal recessive [MIM:256030]	OMIM	HGMD	GENETEST
NEFL	Charcot-Marie-Tooth disease, type 1F [MIM:607734]; Charcot-Marie-Tooth disease, type 2E [MIM:607684]	OMIM	HGMD	GENETEST
NEK1	Short rib-polydactyly syndorme, type II [MIM:263520]	OMIM	HGMD	GENETEST
NEK8	Nephronophthisis 9 [MIM:613824]	OMIM	HGMD	GENETEST
NEU1	Sialidosis, type I [MIM:256550]	OMIM	HGMD	GENETEST
NEUROD1	Maturity-onset diabetes of the young 6 [MIM:606394]	OMIM	HGMD	GENETEST
NEUROG3	Diarrhea 4, malabsorptive, congenital [MIM:610370]	OMIM	HGMD
NEXN	Cardiomyopathy, dilated, 1CC [MIM:613122]; Cardiomyopathy, familial hypertrophic, 20 [MIM:613876]	OMIM	HGMD	GENETEST
NF1	Leukemia, juvenile myelomonocytic [MIM:607785]; Melanoma, desmoplastic neurotrophic; Neurofibromatosis, familial spinal [MIM:162210]; Neurofibromatosis, type 1 [MIM:162200]; Neurofibromatosis-Noonan syndrome [MIM:601321]; Watson syndrome [MIM:193520]	OMIM	HGMD	GENETEST
NF2	Neurofibromatosis, type 2 [MIM:101000]; Schwannomatosis [MIM:162091]	OMIM	HGMD	GENETEST
NFIX	Marshall-Smith syndrome [MIM:602535]; Sotos syndrome 2 [MIM:614753]	OMIM	HGMD
NFKBIA	Ectodermal dysplasia, anhidrotic, with T-cell immunodeficiency [MIM:612132]	OMIM	HGMD	GENETEST
NFU1	Multiple mitochondrial dysfunctions syndrome 1 [MIM:605711]	OMIM	HGMD	GENETEST
NGF	Neuropathy, hereditary sensory and autonomic, type V [MIM:608654]	OMIM	HGMD	GENETEST
NHEJ1	Severe combined immunodeficiency with microcephaly, growth retardation, and sensitivity to ionizing radiation [MIM:611291]	OMIM	HGMD
NHLRC1	Epilepsy, progressive myoclonic 2B (Lafora) [MIM:254780]	OMIM	HGMD	GENETEST
NHP2	Dyskeratosis congenita, autosomal recessive 2 [MIM:613987]	OMIM	HGMD	GENETEST
NHS	Cataract, congenital, X-linked [MIM:302200]; Nance-Horan syndrome [MIM:302350]	OMIM	HGMD	GENETEST
NIN	Seckel syndrome 7 [MIM:614851]	OMIM	
NIPA1	Spastic paraplegia 6, autosomal dominant [MIM:600363]	OMIM	HGMD	GENETEST
NIPAL4	Ichthyosis, congenital, autosomal recessive 6 [MIM:612281]	OMIM	HGMD	GENETEST
NIPBL	Cornelia de Lange syndrome 1 [MIM:122470]	OMIM	HGMD	GENETEST
NKX2-1	Chorea, hereditary benign [MIM:118700]; Choreoathetosis, hypothyroidism, and neonatal respiratory distress [MIM:610978]; Goiter, familial, due to TTF-1 defect	OMIM	HGMD	GENETEST
NKX2-5	Atrial septal defect 7, with or without AV conduction defects [MIM:108900]; Atrioventricular block, second-degree; Conotruncal heart malformations, variable [MIM:217095]; Hypoplastic left heart syndrome 2 [MIM:614435]; Hypothyroidism, congenital nongoitrous, 5 [MIM:225250]; Tetrology of Fallot [MIM:187500]; Ventricular septal defect 3 [MIM:614432]	OMIM	HGMD	GENETEST
NKX2-6	Persistent truncus arteriosus [MIM:217095]	OMIM	HGMD
NKX3-2	Spondylo-megaepiphyseal-metaphyseal dysplasia [MIM:613330]	OMIM	HGMD	GENETEST
NLGN4X	Mental retardation, X-linked [MIM:300495]	OMIM	HGMD	GENETEST
NLRP12	Familial cold autoinflammatory syndrome 2 [MIM:611762]	OMIM	HGMD	GENETEST
NLRP3	CINCA syndrome [MIM:607115]; Cold-induced autoinflammatory syndrome, familial [MIM:120100]; Muckle-Wells syndrome [MIM:191900]	OMIM	HGMD	GENETEST
NLRP7	Hydatidiform mole [MIM:231090]	OMIM	HGMD	GENETEST
NME1	Neuroblastoma [MIM:256700]	OMIM	HGMD
NME8	Ciliary dyskinesia, primary, 6 [MIM:610852]	OMIM		GENETEST
NMNAT1	Leber congenital amaurosis 9 [MIM:608553]	OMIM		GENETEST
NNMT	Homocysteine plasma level	OMIM	
NNT	Glucocorticoid deficiency 4 [MIM:614736]	OMIM	
NOBOX	Premature ovarian failure 5 [MIM:611548]	OMIM	HGMD	GENETEST
NOD2	Blau syndrome [MIM:186580]; Sarcoidosis, early-onset [MIM:609464]	OMIM	HGMD	GENETEST
NODAL	Heterotaxy, visceral, 5 [MIM:270100]	OMIM	HGMD	GENETEST
NOG	Brachydactyly, type B2 [MIM:611377]; Multiple synostosis syndrome 1 [MIM:186500]; Stapes ankylosis with broad thumb and toes [MIM:184460]; Symphalangism, proximal [MIM:185800]; Tarsal-carpal coalition syndrome [MIM:186570]	OMIM	HGMD	GENETEST
NOL3	Myoclonus, familial cortical [MIM:614937]	OMIM	
NOP10	Dyskeratosis congenita, autosomal recessive 1 [MIM:224230]	OMIM	HGMD	GENETEST
NOP56	Spinocerebellar ataxia 36 [MIM:614153]	OMIM	
NOTCH1	Aortic valve disease [MIM:109730]; Leukemia, T-cell acute lymphoblastic	OMIM	HGMD	GENETEST
NOTCH2	Alagille syndrome 2 [MIM:610205]; Hajdu-Cheney syndrome [MIM:102500]	OMIM	HGMD	GENETEST
NOTCH3	Cerebral arteriopathy with subcortical infarcts and leukoencephalopathy [MIM:125310]	OMIM	HGMD	GENETEST
NPC1	Niemann-Pick disease, type D [MIM:257220]	OMIM	HGMD	GENETEST
NPC2	Niemann-pick disease, type C2 [MIM:607625]	OMIM	HGMD	GENETEST
NPHP1	Joubert syndrome 4 [MIM:609583]; Nephronophthisis 1, juvenile [MIM:256100]; Senior-Loken syndrome-1 [MIM:266900]	OMIM	HGMD	GENETEST
NPHP3	Meckel syndrome 7 [MIM:267010]; Nephronophthisis 3 [MIM:604387]; Renal-hepatic-pancreatic dysplasia [MIM:208540]	OMIM	HGMD	GENETEST
NPHP4	Nephronophthisis 4 [MIM:606966]; Senior-Loken syndrome 4 [MIM:606996]	OMIM	HGMD	GENETEST
NPHS1	Nephrotic syndrome, type 1 [MIM:256300]	OMIM	HGMD	GENETEST
NPHS2	Nephrotic syndrome, type 2 [MIM:600995]	OMIM	HGMD	GENETEST
NPM1	Leukemia, acute myeloid [MIM:601626]; Leukemia, acute promyelocytic, NPM/RARA type	OMIM		GENETEST
NPPA	Atrial fibrillation, familial, 6 [MIM:612201]	OMIM	HGMD
NPR2	Acromesomelic dysplasia, Maroteaux type [MIM:602875]	OMIM	HGMD	GENETEST
NR0B1	46XY sex reversal 2, dosage-sensitive [MIM:300018]; Adrenal hypoplasia, congenital, with hypogonadotropic hypogonadism [MIM:300200]	OMIM	HGMD	GENETEST
NR0B2	Obesity, mild, early-onset [MIM:601665]	OMIM	HGMD
NR2E3	Enhanced S-cone syndrome [MIM:268100]; Retinitis pigmentosa 37 [MIM:611131]	OMIM	HGMD	GENETEST
NR3C1	Cortisol resistance	OMIM	HGMD	GENETEST
NR3C2	Hypertension, early-onset, autosomal dominant, with exacerbation in pregnancy [MIM:605115]; Pseudohypoaldosteronism type I, autosomal dominant [MIM:177735]	OMIM	HGMD	GENETEST
NR4A3	Chondrosarcoma, extraskeletal myxoid [MIM:612237]	OMIM	
NR5A1	46XY sex reversal 3 [MIM:612965]; Adrenocortical insufficiency; Premature ovarian failure 7 [MIM:612964]; Spermatogenic failure 8 [MIM:613957]	OMIM	HGMD	GENETEST
NRAS	Autoimmune lymphoproliferative syndrome type IV [MIM:614470]; Colorectal cancer [MIM:114500]; Noonan syndrome 6 [MIM:613224]; Thyroid carcinoma, follicular [MIM:188470]	OMIM	HGMD	GENETEST
NRL	Retinal degeneration, autosomal recessive, clumped pigment type; Retinitis pigmentosa 27 [MIM:613750]	OMIM	HGMD	GENETEST
NRXN1	Pitt-Hopkins-like syndrome 2 [MIM:614325]	OMIM	HGMD	GENETEST
NSD1	Beckwith-Wiedemann syndrome [MIM:130650]; Leukemia, acute myeloid [MIM:601626]; Sotos syndrome 1 [MIM:117550]; Weaver syndrome [MIM:277590]	OMIM	HGMD	GENETEST
NSDHL	CHILD syndrome [MIM:308050]; CK syndrome [MIM:300831]	OMIM	HGMD	GENETEST
NSMF	Hypogonadotropic hypogonadism 9 with or without anosmia [MIM:614838]	OMIM		GENETEST
NSUN2	Mental retardation, autosomal recessive 5 [MIM:611091]	OMIM		GENETEST
NT5C3	Anemia, hemolytic, due to UMPH1 deficiency [MIM:266120]	OMIM	HGMD
NT5E	Calcification of joints and arteries [MIM:211800]	OMIM	HGMD
NTF4	Glaucoma 1, open angle, 1O [MIM:613100]	OMIM	HGMD
NTRK1	Insensitivity to pain, congenital, with anhidrosis [MIM:256800]; Medullary thyroid carcinoma, familial [MIM:155240]	OMIM	HGMD	GENETEST
NTRK2	Obesity, hyperphagia, and developmental delay [MIM:613886]	OMIM	HGMD
NUBPL	Mitochondrial complex I deficiency [MIM:252010]	OMIM	HGMD	GENETEST
NUMA1	Leukemia, acute promyelocytic, NUMA/RARA type	OMIM	
NUP214	Leukemia, T-cell acute lymphoblastic; Leukemia, acute myeloid [MIM:601626]	OMIM	
NUP62	Striatonigral degeneration, infantile [MIM:271930]	OMIM	HGMD
NYX	Night blindness, congenital stationary (complete), 1A, X-linked [MIM:310500]	OMIM	HGMD	GENETEST
OAT	Gyrate atrophy of choroid and retina with or without ornithinemia [MIM:258870]	OMIM	HGMD	GENETEST
OBSL1	3-M syndrome 2 [MIM:612921]	OMIM	HGMD	GENETEST
OCA2	Albinism, brown oculocutaneous [MIM:203200]	OMIM	HGMD	GENETEST
OCLN	Band-like calcification with simplified gyration and polymicrogyria [MIM:251290]	OMIM	HGMD	GENETEST
OCRL	Dent disease 2 [MIM:300555]; Lowe syndrome [MIM:309000]	OMIM	HGMD	GENETEST
OFD1	Joubert syndrome 10 [MIM:300804]; Oral-facial-digital syndrome 1 [MIM:311200]; Simpson-Golabi-Behmel syndrome, type 2 [MIM:300209]	OMIM	HGMD	GENETEST
OGDH	Alpha-ketoglutarate dehydrogenase deficiency [MIM:203740]	OMIM	
OPA1	Optic atrophy 1 [MIM:165500]; Optic atrophy with or without deafness, ophthalmoplegia, myopathy, ataxia, and neuropathy [MIM:125250]	OMIM	HGMD	GENETEST
OPA3	3-methylglutaconic aciduria, type III [MIM:258501]; Optic atrophy 3 with cataract [MIM:165300]	OMIM	HGMD	GENETEST
OPHN1	Mental retardation, X-linked, with cerebellar hypoplasia and distinctive facial appearance [MIM:300486]	OMIM	HGMD	GENETEST
OPLAH	5-oxoprolinase deficiency [MIM:260005]	OMIM	
OPN1LW	Blue cone monochromacy [MIM:303700]; Colorblindness, protan [MIM:303900]	OMIM	HGMD	GENETEST
OPN1MW	Blue cone monochromacy [MIM:303700]; Colorblindness, deutan [MIM:303800]	OMIM	HGMD	GENETEST
OPN1SW	Colorblindness, tritan [MIM:190900]	OMIM	HGMD
OPTN	Amyotrophic lateral sclerosis 12 [MIM:613435]; Glaucoma 1, open angle, E [MIM:137760]	OMIM	HGMD	GENETEST
ORAI1	Immune dysfunction with T-cell inactivation due to calcium entry defect 1 [MIM:612782]	OMIM	HGMD
ORC1	Meier-Gorlin syndrome 1 [MIM:224690]	OMIM	HGMD	GENETEST
ORC4	Meier-Gorlin syndrome 2 [MIM:613800]	OMIM	HGMD	GENETEST
ORC6	Meier-Gorlin syndrome 3 [MIM:613803]	OMIM	HGMD	GENETEST
OSMR	Amyloidosis, primary localized cutaneous, 1 [MIM:105250]	OMIM	HGMD
OSTM1	Osteopetrosis, autosomal recessive 5 [MIM:259720]	OMIM	HGMD	GENETEST
OTC	Ornithine transcarbamylase deficiency [MIM:311250]	OMIM	HGMD	GENETEST
OTOA	Deafness, autosomal recessive 22 [MIM:607039]	OMIM	HGMD	GENETEST
OTOF	Deafness, autosomal recessive 9 [MIM:601071]	OMIM	HGMD	GENETEST
OTOG	Deafness, autosomal recessive 18B [MIM:614945]	OMIM	
OTOGL	Deafness, autosomal recessive 84B [MIM:614944]	OMIM	
OTX2	Microphthalmia, syndromic 5 [MIM:610125]; Pituitary hormone deficiency, combined, 6 [MIM:613986]	OMIM	HGMD	GENETEST
OXCT1	Succinyl CoA:3-oxoacid CoA transferase deficiency [MIM:245050]	OMIM	HGMD	GENETEST
P2RX1	Bleeding disorder due to P2RX1 defect	OMIM	HGMD
P2RY12	Bleeding disorder, platelet-type, 8 [MIM:609821]	OMIM	HGMD
PABPN1	Oculopharyngeal muscular dystrophy [MIM:164300]	OMIM	HGMD	GENETEST
PACS1	Mental retardation, autosomal dominant 17 [MIM:615009]	OMIM	
PAFAH1B1	Lissencephaly 1 [MIM:607432]; Miller-Dieker lissencephaly syndrome	OMIM	HGMD	GENETEST
PAH	Phenylketonuria [MIM:261600]	OMIM	HGMD	GENETEST
PAK3	Mental retardation, X-linked 30/47 [MIM:300558]	OMIM	HGMD	GENETEST
PALB2	Fanconi anemia, complementation group N [MIM:610832]	OMIM	HGMD	GENETEST
PANK2	HARP syndrome [MIM:607236]; Neurodegeneration with brain iron accumulation 1 [MIM:234200]	OMIM	HGMD	GENETEST
PAPSS2	Brachyolmia 4 with mild epiphyseal and metaphyseal changes [MIM:612847]	OMIM	HGMD
PARK2	Parkinson disease, juvenile, type 2 [MIM:600116]	OMIM	HGMD	GENETEST
PARK7	Parkinson disease 7, autosomal recessive early-onset [MIM:606324]	OMIM	HGMD	GENETEST
PAX2	Papillorenal syndrome [MIM:120330]; Renal hypoplasia, isolated [MIM:191830]	OMIM	HGMD	GENETEST
PAX3	Craniofacial-deafness-hand syndrome [MIM:122880]; Rhabdomyosarcoma 2, alveolar [MIM:268220]; Waardenburg syndrome, type 1 [MIM:193500]; Waardenburg syndrome, type 3 [MIM:148820]	OMIM	HGMD	GENETEST
PAX4	Diabetes mellitus, ketosis-prone [MIM:612227]; Diabetes mellitus, type 2 [MIM:125853]; Maturity-onset diabetes of the young, type IX [MIM:612225]	OMIM	HGMD	GENETEST
PAX5	Lymphoplasmacytoid lymphoma	OMIM	
PAX6	Aniridia [MIM:106210]; Coloboma of optic nerve [MIM:120430]; Coloboma, ocular [MIM:120200]; Foveal hyperplasia [MIM:136520]; Gillespie syndrome [MIM:206700]; Keratitis [MIM:148190]; Optic nerve hypoplasia [MIM:165550]; Peters anomaly [MIM:604229]; Wilms tumor, aniridia, genitourinary anomalies and mental retardation syndrome	OMIM	HGMD	GENETEST
PAX7	Rhabdomyosarcoma 2, alveolar [MIM:268220]	OMIM	
PAX8	Hypothyroidism, congenital, due to thyroid dysgenesis or hypoplasia [MIM:218700]	OMIM	HGMD	GENETEST
PAX9	Tooth agenesis, selective, 3 [MIM:604625]	OMIM	HGMD	GENETEST
PBX1	Leukemia, acute pre-B-cell	OMIM	
PC	Pyruvate carboxylase deficiency [MIM:266150]	OMIM	HGMD	GENETEST
PCBD1	Hyperphenylalaninemia, BH4-deficient, D [MIM:264070]	OMIM	HGMD	GENETEST
PCCA	Propionicacidemia [MIM:606054]	OMIM	HGMD	GENETEST
PCCB	Propionicacidemia [MIM:606054]	OMIM	HGMD	GENETEST
PCDH15	Deafness, autosomal recessive 23 [MIM:609533]; Usher syndrome, type 1D/F digenic [MIM:601067]; Usher syndrome, type 1F [MIM:602083]	OMIM	HGMD	GENETEST
PCDH19	Epileptic encephalopathy, early infantile, 9 [MIM:300088]	OMIM	HGMD	GENETEST
PCK2	PEPCK deficiency, mitochondrial [MIM:261650]	OMIM		GENETEST
PCM1	Thyroid carcinoma, papillary [MIM:188550]	OMIM	HGMD
PCNT	Microcephalic osteodysplastic primordial dwarfism, type II [MIM:210720]	OMIM	HGMD	GENETEST
PCSK1	Obesity with impaired prohormone processing [MIM:600955]	OMIM	HGMD	GENETEST
PCSK9	Hypercholesterolemia, familial, 3 [MIM:603776]	OMIM	HGMD	GENETEST
PDCD10	Cerebral cavernous malformations 3 [MIM:603285]	OMIM	HGMD	GENETEST
PDE11A	Pigmented nodular adrenocortical disease, primary, 2 [MIM:610475]	OMIM	HGMD
PDE4D	Acrodysostosis 2, with or without hormone resistance [MIM:614613]	OMIM		GENETEST
PDE6A	Retinitis pigmentosa 43 [MIM:613810]	OMIM	HGMD	GENETEST
PDE6B	Night blindness, congenital stationary, autosomal dominant 2 [MIM:163500]; Retinitis pigmentosa-40 [MIM:613801]	OMIM	HGMD	GENETEST
PDE6C	Cone dystrophy 4 [MIM:613093]	OMIM	HGMD	GENETEST
PDE6G	Retinitis pigmentosa 57 [MIM:613582]	OMIM	HGMD	GENETEST
PDE6H	Achromatopsia 6 [MIM:610024]	OMIM	HGMD	GENETEST
PDE8B	Pigmented nodular adrenocortical disease, primary, 3 [MIM:614190]; Striatal degeneration, autosomal dominant [MIM:609161]	OMIM	HGMD
PDGFB	Dermatofibrosarcoma protuberans; Giant-cell fibroblastoma; Meningioma, SIS-related	OMIM	
PDGFRA	Hypereosinophilic syndrome, idiopathic, resistant to imatinib [MIM:607685]	OMIM	HGMD	GENETEST
PDGFRB	Basal ganglia calcification, idiopathic, 4 [MIM:615007]; Myelomonocytic leukemia, chronic; Myeloproliferative disorder with eosinophilia [MIM:131440]	OMIM		GENETEST
PDGFRL	Colorectal cancer [MIM:114500]; Hepatocellular cancer [MIM:114550]	OMIM	
PDHA1	Leigh syndrome, X-linked [MIM:308930]; Pyruvate dehydrogenase E1-alpha deficiency [MIM:312170]	OMIM	HGMD	GENETEST
PDHB	Pyruvate dehydrogenase E1-beta deficiency [MIM:614111]	OMIM	HGMD	GENETEST
PDHX	Lacticacidemia due to PDX1 deficiency [MIM:245349]	OMIM	HGMD	GENETEST
PDP1	Pyruvate dehydrogenase phosphatase deficiency [MIM:608782]	OMIM	HGMD	GENETEST
PDSS1	Coenzyme Q10 deficiency, primary, 2 [MIM:614651]	OMIM	HGMD	GENETEST
PDSS2	Coenzyme Q10 deficiency, primary, 3 [MIM:614652]	OMIM	HGMD	GENETEST
PDX1	MODY, type IV [MIM:606392]; Pancreatic agenesis [MIM:260370]	OMIM	HGMD	GENETEST
PDYN	Spinocerebellar ataxia 23 [MIM:610245]	OMIM	HGMD	GENETEST
PDZD7	Usher syndrome, type IIC, GPR98/PDZD7 digenic [MIM:605472]	OMIM	HGMD
PEPD	Prolidase deficiency [MIM:170100]	OMIM	HGMD	GENETEST
PER2	Advanced sleep phase syndrome, familial [MIM:604348]	OMIM	HGMD
PEX1	Peroxisome biogenesis disorder 1A (Zellweger) [MIM:214100]; Peroxisome biogenesis disorder 1B (NALD/IRD) [MIM:601539]	OMIM	HGMD	GENETEST
PEX10	Peroxisome biogenesis disorder 6A (Zellweger) [MIM:614870]; Peroxisome biogenesis disorder 6B [MIM:614871]	OMIM	HGMD	GENETEST
PEX11B	Peroxisome biogenesis disorder 14B [MIM:614920]	OMIM	
PEX12	Peroxisome biogenesis disorder 3A (Zellweger) [MIM:614859]; Peroxisome biogenesis disorder 3B [MIM:266510]	OMIM	HGMD	GENETEST
PEX13	Peroxisome biogenesis disorder 11A (Zellweger) [MIM:614883]; Peroxisome biogenesis disorder 11B [MIM:614885]	OMIM	HGMD	GENETEST
PEX14	Peroxisome biogenesis disorder 13A (Zellweger) [MIM:614887]	OMIM	HGMD	GENETEST
PEX16	Peroxisome biogenesis disorder 8A, (Zellweger) [MIM:614876]; Peroxisome biogenesis disorder 8B [MIM:614877]	OMIM	HGMD	GENETEST
PEX19	Peroxisome biogenesis disorder 12A (Zellweger) [MIM:614886]	OMIM	HGMD	GENETEST
PEX2	Peroxisome biogenesis disorder 5A (Zellweger) [MIM:614866]; Peroxisome biogenesis disorder 5B [MIM:614867]	OMIM	HGMD	GENETEST
PEX26	Peroxisome biogenesis disorder 7A (Zellweger) [MIM:614872]; Peroxisome biogenesis disorder 7B [MIM:614873]	OMIM	HGMD	GENETEST
PEX3	Peroxisome biogenesis disorder 10A (Zellweger) [MIM:614882]	OMIM	HGMD	GENETEST
PEX5	Peroxisome biogenesis disorder 2A (Zellweger) [MIM:214110]; Peroxisome biogenesis disorder 2B [MIM:202370]	OMIM	HGMD	GENETEST
PEX6	Peroxisome biogenesis disorder 4A (Zellweger) [MIM:614862]; Peroxisome biogenesis disorder 4B [MIM:614863]	OMIM	HGMD	GENETEST
PEX7	Peroxisome biogenesis disorder 9B [MIM:614879]; Rhizomelic chondrodysplasia punctata, type 1 [MIM:215100]	OMIM	HGMD	GENETEST
PFKL	Hemolytic anemia due to phosphofructokinase deficiency	OMIM	
PFKM	Glycogen storage disease VII [MIM:232800]	OMIM	HGMD	GENETEST
PFN1	Amyotrophic lateral sclerosis 18 [MIM:614808]	OMIM		GENETEST
PGAM2	Glycogen storage disease X [MIM:261670]	OMIM	HGMD	GENETEST
PGK1	Phosphoglycerate kinase 1 deficiency [MIM:300653]	OMIM	HGMD	GENETEST
PGM1	Congenital disorder of glycosylation, type It [MIM:614921]; Glycogen storage disease XIV [MIM:612934]	OMIM	HGMD	GENETEST
PHEX	Hypophosphatemic rickets, X-linked dominant [MIM:307800]	OMIM	HGMD	GENETEST
PHF6	Borjeson-Forssman-Lehmann syndrome [MIM:301900]	OMIM	HGMD	GENETEST
PHF8	Mental retardation syndrome, X-linked, Siderius type [MIM:300263]	OMIM	HGMD	GENETEST
PHGDH	Phosphoglycerate dehydrogenase deficiency [MIM:601815]	OMIM	HGMD	GENETEST
PHKA1	Muscle glycogenosis [MIM:300559]	OMIM	HGMD	GENETEST
PHKA2	Glycogen storage disease, type IXa1 [MIM:306000]	OMIM	HGMD	GENETEST
PHKB	Phosphorylase kinase deficiency of liver and muscle, autosomal recessive [MIM:261750]	OMIM	HGMD	GENETEST
PHKG2	Cirrhosis due to liver phosphorylase kinase deficiency; Glycogen storage disease IXc [MIM:613027]	OMIM	HGMD	GENETEST
PHOX2A	Fibrosis of extraocular muscles, congenital, 2 [MIM:602078]	OMIM	HGMD	GENETEST
PHOX2B	Central hypoventilation syndrome, congenital, with or without Hirschsprung disease [MIM:209880]	OMIM	HGMD	GENETEST
PHYH	Refsum disease [MIM:266500]	OMIM	HGMD	GENETEST
PICALM	Leukemia, acute T-cell lymphoblastic; Leukemia, acute myeloid [MIM:601626]	OMIM	HGMD
PIGA	Multiple congenital anomalies-hypotonia-seizures syndrome 2 [MIM:300868]	OMIM	HGMD
PIGL	CHIME syndrome [MIM:280000]	OMIM		GENETEST
PIGM	Glycosylphosphatidylinositol deficiency [MIM:610293]	OMIM	HGMD
PIGN	Multiple congenital anomalies-hypotonia-seizures syndrome 1 [MIM:614080]	OMIM	HGMD
PIGO	Hyperphosphatasia with mental retardation syndrome 2 [MIM:614749]	OMIM		GENETEST
PIGV	Hyperphosphatasia with mental retardation syndrome 1 [MIM:239300]	OMIM	HGMD	GENETEST
PIK3CA	Nevus,	OMIM		GENETEST
PIK3R2	Megalencephaly-polymicrogyria-polydactyly-hydrocephalus syndrome [MIM:603387]	OMIM		GENETEST
PIKFYVE	Corneal fleck dystrophy [MIM:121850]	OMIM	HGMD	GENETEST
PINK1	Parkinson disease 6, early onset [MIM:605909]	OMIM	HGMD	GENETEST
PIP5K1C	Lethal congenital contractural syndrome 3 [MIM:611369]	OMIM	HGMD
PITPNM3	Cone-rod dystrophy 5 [MIM:600977]	OMIM	HGMD	GENETEST
PITX1	Clubfoot, congenital, with or without deficiency of long bones and/or mirror-image polydactyly [MIM:119800]; Liebenberg syndrome [MIM:186550]	OMIM	HGMD	GENETEST
PITX2	Axenfeld-Rieger syndrome, type 1 [MIM:180500]; Iridogoniodysgenesis, type 2 [MIM:137600]; Peters anomaly [MIM:604229]; Ring dermoid of cornea [MIM:180550]	OMIM	HGMD	GENETEST
PITX3	Anterior segment mesenchymal dysgenesis [MIM:107250]; Cataract, congenital; Cataract, posterior polar, 4 [MIM:610623]	OMIM	HGMD	GENETEST
PKD1	Polycystic kidney disease, adult type I [MIM:173900]	OMIM	HGMD	GENETEST
PKD2	Polycystic kidney disease 2 [MIM:613095]	OMIM	HGMD	GENETEST
PKHD1	Polycystic kidney and hepatic disease [MIM:263200]	OMIM	HGMD	GENETEST
PKLR	Adenosine triphosphate, elevated, of erythrocytes [MIM:102900]; Pyruvate kinase deficiency [MIM:266200]	OMIM	HGMD	GENETEST
PKP1	Ectodermal dysplasia/skin fragility syndrome [MIM:604536]	OMIM	HGMD	GENETEST
PKP2	Arrhythmogenic right ventricular dysplasia 9 [MIM:609040]	OMIM	HGMD	GENETEST
PLA2G4A	Phospholipase A2, group IV A, deficiency of	OMIM	HGMD
PLA2G5	Fleck retina, familial benign [MIM:228980]	OMIM	HGMD
PLA2G6	Infantile neuroaxonal dystrophy 1 [MIM:256600]; Karak syndrome [MIM:610217]; Parkinson disease 14 [MIM:612953]	OMIM	HGMD	GENETEST
PLA2G7	Platelet-activating factor acetylhydrolase deficiency [MIM:614278]	OMIM	HGMD
PLAG1	Adenomas, salivary gland pleomorphic [MIM:181030]	OMIM	
PLAT	Thrombophilia, familial, due to decreased release of PLAT [MIM:612348]	OMIM	HGMD
PLAU	Quebec platelet disorder [MIM:601709]	OMIM	HGMD	GENETEST
PLCB1	Epileptic encephalopathy, early infantile, 12 [MIM:613722]	OMIM		GENETEST
PLCB2	Platelet PLC beta-2 deficiency	OMIM	
PLCB4	Auriculocondylar syndrome 2 [MIM:614669]	OMIM		GENETEST
PLCD1	Nail disorder, nonsyndromic congenital, 3, (leukonychia) [MIM:151600]	OMIM	HGMD
PLCE1	Nephrotic syndrome, type 3 [MIM:610725]	OMIM	HGMD	GENETEST
PLCG2	Autoinflammation, antibody deficiency, and immune dysregulation syndrome [MIM:614878]; Familial cold autoinflammatory syndrome 3 [MIM:614468]	OMIM	
PLEC	Epidermolysis bullosa simplex with pyloric atresia [MIM:612138]; Epidermolysis bullosa simplex, Ogna type [MIM:131950]; Muscular dystrophy with epidermolysis bullosa simplex [MIM:226670]; Muscular dystrophy, limb-girdle, type 2Q [MIM:613723]	OMIM	HGMD	GENETEST
PLEKHG4	Spinocerebellar ataxia 4	OMIM	HGMD
PLEKHG5	Spinal muscular atrophy, distal, autosomal recessive, 4 [MIM:611067]	OMIM	HGMD	GENETEST
PLEKHM1	Osteopetrosis, autosomal recessive 6 [MIM:611497]	OMIM	HGMD	GENETEST
PLG	Conjunctivitis, ligneous [MIM:217090]; Plasminogen Tochigi disease; Plasminogen deficiency, types I and II; Thrombophilia, dysplasminogenemic	OMIM	HGMD
PLIN1	Lipodystrophy, familial partial, type 4 [MIM:613877]	OMIM	HGMD
PLN	Cardiomyopathy, dilated, 1P [MIM:609909]; Cardiomyopathy, familial hypertrophic, 18 [MIM:613874]	OMIM	HGMD	GENETEST
PLOD1	Ehlers-Danlos syndrome, type VI [MIM:225400]	OMIM	HGMD	GENETEST
PLOD2	Bruck syndrome 2 [MIM:609220]	OMIM	HGMD	GENETEST
PLOD3	Lysyl hydroxylase 3 deficiency [MIM:612394]	OMIM	HGMD
PLP1	Pelizaeus-Merzbacher disease [MIM:312080]; Spastic paraplegia 2, X-linked [MIM:312920]	OMIM	HGMD	GENETEST
PML	Leukemia, acute promyelocytic, PML/RARA type	OMIM	HGMD
PMM2	Congenital disorder of glycosylation, type Ia [MIM:212065]	OMIM	HGMD	GENETEST
PMP22	Charcot-Marie-Tooth disease, type 1A [MIM:118220]; Charcot-Marie-Tooth disease, type 1E [MIM:118300]; Dejerine-Sottas disease [MIM:145900]; Neuropathy, inflammatory demyelinating [MIM:139393]; Neuropathy, recurrent, with pressure palsies [MIM:162500]; Roussy-Levy syndrome [MIM:180800]	OMIM	HGMD	GENETEST
PMS2	Colorectal cancer, hereditary nonpolyposis, type 4 [MIM:614337]; Mismatch repair cancer syndrome [MIM:276300]	OMIM	HGMD	GENETEST
PNKD	Paroxysmal nonkinesigenic dyskinesia [MIM:118800]	OMIM	HGMD	GENETEST
PNKP	Epileptic encephalopathy, early infantile, 10 [MIM:613402]	OMIM	HGMD	GENETEST
PNLIP	Pancreatic lipase deficiency [MIM:614338]	OMIM	
PNP	Immunodeficiency due to purine nucleoside phosphorylase deficiency [MIM:613179]	OMIM	HGMD	GENETEST
PNPLA1	Ichthyosis, congenital, autosomal recessive 10 [MIM:615024]	OMIM	HGMD	GENETEST
PNPLA2	Neutral lipid storage disease with myopathy [MIM:610717]	OMIM	HGMD	GENETEST
PNPLA6	Spastic paraplegia 39, autosomal recessive [MIM:612020]	OMIM	HGMD	GENETEST
PNPO	Pyridoxamine 5'-phosphate oxidase deficiency [MIM:610090]	OMIM	HGMD	GENETEST
PNPT1	Combined oxidative phosphorylation deficiency 13 [MIM:614932]; Deafness, autosomal recessive 70 [MIM:614934]	OMIM	
POC1A	Short stature, onychodysplasia, facial dysmorphism, and hypotrichosis [MIM:614813]	OMIM	
POF1B	Premature ovarian failure 2B [MIM:300604]	OMIM	HGMD
POLG	Mitochondrial DNA depletion syndrome 4A (Alpers type) [MIM:203700]; Mitochondrial DNA depletion syndrome 4B (MNGIE type) [MIM:613662]; Mitochondrial recessive ataxia syndrome (includes SANDO and SCAE) [MIM:607459]; Progressive external ophthalmoplegia, autosomal dominant [MIM:157640]; Progressive external ophthalmoplegia, autosomal recessive [MIM:258450]	OMIM	HGMD	GENETEST
POLG2	Progressive external ophthalmoplegia with mitochondrial DNA deletions, autosomal dominant 4 [MIM:610131]	OMIM	HGMD	GENETEST
POLH	Xeroderma pigmentosum, variant type [MIM:278750]	OMIM	HGMD	GENETEST
POLR1C	Treacher Collins syndrome 3 [MIM:248390]	OMIM	HGMD	GENETEST
POLR1D	Treacher Collins syndrome 2 [MIM:613717]	OMIM	HGMD	GENETEST
POLR3A	Leukodystrophy, hypomyelinating, 7, with or without oligodontia and/or hypogonadotropic hypogonadism [MIM:607694]	OMIM	HGMD	GENETEST
POLR3B	Leukodystrophy, hypomyelinating, 8, with or without oligodontia and/or hypogonadotropic hypogonadism [MIM:614381]	OMIM	HGMD	GENETEST
POMC	Obesity, adrenal insufficiency, and red hair due to POMC deficiency [MIM:609734]	OMIM	HGMD	GENETEST
POMGNT1	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 3 [MIM:253280]; Muscular dystrophy-dystroglycanopathy (congenital with mental retardation), type B, 3 [MIM:613151]; Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 3 [MIM:613157]	OMIM	HGMD	GENETEST
POMP	Keratosis linearis with ichthyosis congenita and sclerosing keratoderma [MIM:601952]	OMIM	HGMD
POMT1	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 1 [MIM:236670]; Muscular dystrophy-dystroglycanopathy (congenital with mental retardation), type B, 1 [MIM:613155]; Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 1 [MIM:609308]	OMIM	HGMD	GENETEST
POMT2	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 2 [MIM:613150]; Muscular dystrophy-dystroglycanopathy (congenital with mental retardation), type B, 2 [MIM:613156]; Muscular dystrophy-dystroglycanopathy (limb-girdle), type C, 2 [MIM:613158]	OMIM	HGMD	GENETEST
POR	Antley-Bixler syndrome with genital anomalies and disordered steroidogenesis [MIM:201750]; Disordered steroidogenesis due to cytochrome P450 oxidoreductase [MIM:613571]	OMIM	HGMD	GENETEST
PORCN	Focal dermal hypoplasia [MIM:305600]	OMIM	HGMD	GENETEST
POU1F1	Pituitary hormone deficiency, combined, 1 [MIM:613038]	OMIM	HGMD	GENETEST
POU3F4	Deafness, X-linked 2 [MIM:304400]	OMIM	HGMD	GENETEST
POU4F3	Deafness, autosomal dominant 15 [MIM:602459]	OMIM	HGMD	GENETEST
PPARG	Carotid intimal medial thickness 1 [MIM:609338]; Insulin resistance, severe, digenic [MIM:604367]; Obesity, severe [MIM:601665]	OMIM	HGMD	GENETEST
PPIB	Osteogenesis imperfecta, type IX [MIM:259440]	OMIM	HGMD	GENETEST
PPM1D	Breast cancer [MIM:114480]	OMIM	
PPOX	Porphyria variegata [MIM:176200]	OMIM	HGMD	GENETEST
PPP1R3A	Insulin resistance, severe, digenic [MIM:604367]	OMIM	HGMD
PPP2R1B	Lung cancer [MIM:211980]	OMIM	HGMD
PPP2R2B	Spinocerebellar ataxia 12 [MIM:604326]	OMIM		GENETEST
PPT1	Ceroid lipofuscinosis, neuronal, 1 [MIM:256730]	OMIM	HGMD	GENETEST
PQBP1	Renpenning syndrome [MIM:309500]	OMIM	HGMD	GENETEST
PRCC	Renal cell carcinoma, papillary [MIM:605074]	OMIM	
PRCD	Retinitis pigmentosa 36 [MIM:610599]	OMIM	HGMD	GENETEST
PRDM5	Brittle cornea syndrome 2 [MIM:614170]	OMIM	HGMD	GENETEST
PRF1	Hemophagocytic lymphohistiocytosis, familial, 2 [MIM:603553]; Lymphoma, non-Hodgkin [MIM:605027]	OMIM	HGMD	GENETEST
PRG4	Camptodactyly-arthropathy-coxa vara-pericarditis syndrome [MIM:208250]	OMIM	HGMD
PRICKLE1	Epilepsy, progressive myoclonic 1B [MIM:612437]	OMIM	HGMD	GENETEST
PRICKLE2	Epilepsy, progressive myoclonic 5 [MIM:613832]	OMIM	HGMD	GENETEST
PRKAG2	Cardiomyopathy, familial hypertrophic 6 [MIM:600858]; Glycogen storage disease of heart, lethal congenital [MIM:261740]; Wolff-Parkinson-White syndrome [MIM:194200]	OMIM	HGMD	GENETEST
PRKAR1A	Acrodysostosis 1, with or without hormone resistance [MIM:101800]; Carney complex, type 1 [MIM:160980]; Myxoma, intracardiac [MIM:255960]; Pigmented nodular adrenocortical disease, primary, 1 [MIM:610489]	OMIM	HGMD	GENETEST
PRKCA	Pituitary tumor, invasive	OMIM	
PRKCG	Spinocerebellar ataxia 14 [MIM:605361]	OMIM	HGMD	GENETEST
PRKCSH	Polycystic liver disease [MIM:174050]	OMIM	HGMD	GENETEST
PRKRA	Dystonia 16 [MIM:612067]	OMIM	HGMD	GENETEST
PRNP	Creutzfeldt-Jakob disease [MIM:123400]; Gerstmann-Straussler disease [MIM:137440]; Huntington disease-like 1 [MIM:603218]; Insomnia, fatal familial [MIM:600072]; Prion disease with protracted course [MIM:606688]	OMIM	HGMD	GENETEST
PROC	Thrombophilia due to protein C deficiency, autosomal dominant [MIM:176860]; Thrombophilia due to protein C deficiency, autosomal recessive [MIM:612304]	OMIM	HGMD	GENETEST
PRODH	Hyperprolinemia, type I [MIM:239500]	OMIM	HGMD	GENETEST
PROK2	Hypogonadotropic hypogonadism 4 with or without anosmia [MIM:610628]	OMIM	HGMD	GENETEST
PROKR2	Hypogonadotropic hypogonadism 3 with or without anosmia [MIM:244200]	OMIM	HGMD	GENETEST
PROM1	Cone-rod dystrophy 12 [MIM:612657]; Macular dystrophy, retinal, 2 [MIM:608051]; Retinitis pigmentosa 41 [MIM:612095]; Stargardt disease 4 [MIM:603786]; Stargardt disease 4	OMIM	HGMD	GENETEST
PROP1	Pituitary hormone deficiency, combined, 2 [MIM:262600]	OMIM	HGMD	GENETEST
PROS1	Thrombophilia due to protein S deficiency, autosomal dominant [MIM:612336]; Thrombophilia due to protein S deficiency, autosomal recessive [MIM:614514]	OMIM	HGMD	GENETEST
PRPF3	Retinitis pigmentosa 18 [MIM:601414]	OMIM	HGMD	GENETEST
PRPF31	Retinitis pigmentosa 11 [MIM:600138]	OMIM	HGMD	GENETEST
PRPF6	Retinitis pigmentosa 60 [MIM:613983]	OMIM	HGMD	GENETEST
PRPF8	Retinitis pigmentosa 13 [MIM:600059]	OMIM	HGMD	GENETEST
PRPH2	Choriodal dystrophy, central areolar 2 [MIM:613105]; Macular dystrophy; Macular dystrophy, patterned [MIM:169150]; Macular dystrophy, vitelliform [MIM:608161]; Retinitis pigmentosa 7 [MIM:608133]; Retinitis punctata albescens [MIM:136880]	OMIM	HGMD	GENETEST
PRPS1	Arts syndrome [MIM:301835]; Charcot-Marie-Tooth disease, X-linked recessive, 5 [MIM:311070]; Deafness, X-linked 1 [MIM:304500]; Gout, PRPS-related [MIM:300661]	OMIM	HGMD	GENETEST
PRRT2	Convulsions, familial infantile, with paroxysmal choreoathetosis [MIM:602066]; Episodic kinesigenic dyskinesia 1 [MIM:128200]; Seizures, benign familial infantile, 2 [MIM:605751]	OMIM	HGMD	GENETEST
PRRX1	Agnathia-otocephaly complex [MIM:202650]	OMIM	HGMD
PRSS1	Pancreatitis, hereditary [MIM:167800]; Trypsinogen deficiency [MIM:614044]	OMIM	HGMD	GENETEST
PRSS12	Mental retardation, autosomal recessive 1 [MIM:249500]	OMIM	HGMD	GENETEST
PRSS56	Microphthalmia, isolated 6 [MIM:613517]	OMIM	HGMD
PRX	Charcot-Marie-Tooth disease, type 4F [MIM:614895]; Dejerine-Sottas disease, autosomal recessive [MIM:145900]	OMIM	HGMD	GENETEST
PSAP	Combined SAP deficiency [MIM:611721]; Gaucher disease, atypical [MIM:610539]; Krabbe disease, atypical [MIM:611722]; Metachromatic leukodystrophy due to SAP-b deficiency [MIM:249900]	OMIM	HGMD	GENETEST
PSAT1	Phosphoserine aminotransferase deficiency [MIM:610992]	OMIM	HGMD	GENETEST
PSEN1	Acne inversa, familial, 3 [MIM:613737]; Alzheimer disease, type 3 [MIM:607822]; Cardiomyopathy, dilated, 1U [MIM:613694]; Dementia, frontotemporal [MIM:600274]; Pick disease [MIM:172700]	OMIM	HGMD	GENETEST
PSEN2	Alzheimer disease-4 [MIM:606889]; Cardiomyopathy, dilated, 1V [MIM:613697]	OMIM	HGMD	GENETEST
PSENEN	Acne inversa, familial, 2 [MIM:613736]	OMIM	HGMD
PSMB8	Autoinflammation, lipodystrophy, and dermatosis syndrome [MIM:256040]	OMIM	HGMD	GENETEST
PSMC3IP	Ovarian dysgenesis 3 [MIM:614324]	OMIM	HGMD
PSPH	Phosphoserine phosphatase deficiency [MIM:614023]	OMIM	HGMD	GENETEST
PSTPIP1	Pyogenic sterile arthritis, pyoderma gangrenosum, and acne [MIM:604416]	OMIM	HGMD	GENETEST
PTCH1	Basal cell nevus syndrome [MIM:109400]; Holoprosencephaly-7 [MIM:610828]	OMIM	HGMD	GENETEST
PTCH2	Medulloblastoma [MIM:155255]	OMIM	HGMD
PTEN	Bannayan-Riley-Ruvalcaba syndrome [MIM:153480]; Cowden disease [MIM:158350]; Macrocephaly/autism syndrome [MIM:605309]; PTEN hamartoma tumor syndrome; VATER association with macrocephaly and ventriculomegaly [MIM:276950]	OMIM	HGMD	GENETEST
PTF1A	Diabetes mellitus, permanent neonatal, with cerebellar agenesis [MIM:609069]	OMIM	HGMD	GENETEST
PTGIS	Hypertension, essential [MIM:145500]	OMIM	HGMD
PTH	Hypoparathyroidism, autosomal dominant [MIM:146200]	OMIM	HGMD	GENETEST
PTH1R	Chondrodysplasia, Blomstrand type [MIM:215045]; Eiken syndrome [MIM:600002]; Failure of tooth eruption, primary [MIM:125350]; Metaphyseal chondrodysplasia, Murk Jansen type [MIM:156400]	OMIM	HGMD	GENETEST
PTHLH	Brachydactyly, type E2 [MIM:613382]; Humoral hypercalcemia of malignancy	OMIM	HGMD
PTPN11	LEOPARD syndrome 1 [MIM:151100]; Leukemia, juvenile myelomonocytic [MIM:607785]; Metachondromatosis [MIM:156250]; Noonan syndrome 1 [MIM:163950]	OMIM	HGMD	GENETEST
PTPN12	Colon cancer	OMIM	
PTPN14	Choanal atresia and lymphedema [MIM:613611]	OMIM	
PTPRC	Severe combined immunodeficiency, T cell-negative, B-cell/natural killer-cell positive [MIM:608971]	OMIM	HGMD
PTPRO	Nephrotic syndrome, type 6 [MIM:614196]	OMIM	HGMD
PTPRQ	Deafness, autosomal recessive 84A [MIM:613391]	OMIM	HGMD
PTRF	Lipodystrophy, congenital generalized, type 4 [MIM:613327]	OMIM	HGMD
PTS	Hyperphenylalaninemia, BH4-deficient, A [MIM:261640]	OMIM	HGMD	GENETEST
PUS1	Mitochondrial myopathy and sideroblastic anemia 1 [MIM:600462]	OMIM	HGMD	GENETEST
PVRL1	Orofacial cleft 7 [MIM:225060]	OMIM	HGMD	GENETEST
PVRL4	Ectodermal dysplasia-syndactyly syndrome 1 [MIM:613573]	OMIM	HGMD
PYCR1	Cutis laxa, autosomal recessive, type IIB [MIM:612940]; Cutis laxa, autosomal recessive, type IIIB [MIM:614438]	OMIM	HGMD	GENETEST
PYGL	Glycogen storage disease VI [MIM:232700]	OMIM	HGMD	GENETEST
PYGM	McArdle disease [MIM:232600]	OMIM	HGMD	GENETEST
QDPR	Hyperphenylalaninemia, BH4-deficient, C [MIM:261630]	OMIM	HGMD	GENETEST
RAB18	Warburg micro syndrome 3 [MIM:614222]	OMIM	HGMD	GENETEST
RAB23	Carpenter syndrome [MIM:201000]	OMIM	HGMD	GENETEST
RAB27A	Griscelli syndrome, type 2 [MIM:607624]	OMIM	HGMD	GENETEST
RAB39B	Mental retardation, X-linked 72 [MIM:300271]	OMIM	HGMD	GENETEST
RAB3GAP1	Warburg micro syndrome 1 [MIM:600118]	OMIM	HGMD	GENETEST
RAB3GAP2	Martsolf syndrome [MIM:212720]; Warburg micro syndrome 2 [MIM:614225]	OMIM	HGMD	GENETEST
RAB40AL	Mental retardation, X-linked, syndromic, Martin-Probst type [MIM:300519]	OMIM		GENETEST
RAB7A	Charcot-Marie-Tooth disease, type 2B [MIM:600882]	OMIM	HGMD	GENETEST
RAC2	Neutrophil immunodeficiency syndrome [MIM:608203]	OMIM	HGMD
RAD21	Cornelia de Lange syndrome 4 [MIM:614701]	OMIM		GENETEST
RAD50	Nijmegen breakage syndrome-like disorder [MIM:613078]	OMIM	HGMD
RAD51	Mirror movements 2 [MIM:614508]	OMIM	HGMD
RAD51C	Fanconi anemia, complementation group 0 [MIM:613390]	OMIM	HGMD	GENETEST
RAD54B	Colon adenocarcinoma; Lymphoma, non-Hodgkin	OMIM	
RAF1	LEOPARD syndrome 2 [MIM:611554]; Noonan syndrome 5 [MIM:611553]	OMIM	HGMD	GENETEST
RAG1	Alpha/beta T-cell lymphopenia with gamma/delta T-cell expansion, severe cytomegalovirus infection, and autoimmunity [MIM:609889]; Combined cellular and humoral immune defects with granulomas [MIM:233650]; Omenn syndrome [MIM:603554]; Severe combined immunodeficiency, B cell-negative [MIM:601457]	OMIM	HGMD	GENETEST
RAG2	Combined cellular and humoral immune defects with granulomas [MIM:233650]; Omenn syndrome [MIM:603554]; Severe combined immunodeficiency, B cell-negative [MIM:601457]	OMIM	HGMD	GENETEST
RAI1	Smith-Magenis syndrome [MIM:182290]	OMIM	HGMD	GENETEST
RAP1GDS1	Lymphocytic leukemia, acute T-cell	OMIM	
RAPSN	Fetal akinesia deformation sequence [MIM:208150]; Myasthenic syndrome, congenital, associated with acetylcholine receptor deficiency [MIM:608931]	OMIM	HGMD	GENETEST
RARA	Leukemia, acute promyelocytic [MIM:612376]	OMIM	
RARS2	Pontocerebellar hypoplasia, type 6 [MIM:611523]	OMIM	HGMD	GENETEST
RASA1	Capillary malformation-arteriovenous malformation [MIM:608354]; Parkes Weber slndrome [MIM:608355]	OMIM	HGMD	GENETEST
RASSF1	Lung cancer [MIM:211980]	OMIM	HGMD
RAX	Microphthalmia, isolated 3 [MIM:611038]	OMIM	HGMD	GENETEST
RAX2	Cone-rod dystrophy 11 [MIM:610381]; Macular degeneration, age-related, 6 [MIM:613757]	OMIM	HGMD	GENETEST
RB1	Retinoblastoma [MIM:180200]	OMIM	HGMD	GENETEST
RBBP8	Jawad syndrome [MIM:251255]; Seckel syndrome 2 [MIM:606744]	OMIM	HGMD	GENETEST
RBM10	TARP syndrome [MIM:311900]	OMIM	HGMD	GENETEST
RBM15	Megakaryoblastic leukemia, acute	OMIM	
RBM20	Cardiomyopathy, dilated, 1DD [MIM:613172]	OMIM	HGMD	GENETEST
RBM28	Alopecia, neurologic defects, and endocrinopathy syndrome [MIM:612079]	OMIM	HGMD
RBM8A	Thrombocytopenia-absent radius syndrome [MIM:274000]	OMIM		GENETEST
RBP4	Retinol binding protein, deficiency of	OMIM	HGMD
RBPJ	Adams-Oliver syndrome 3 [MIM:614814]	OMIM	
RD3	Leber congenital amaurosis 12 [MIM:610612]	OMIM	HGMD	GENETEST
RDH12	Leber congenital amaurosis 13 [MIM:612712]	OMIM	HGMD	GENETEST
RDH5	Fundus albipunctatus [MIM:136880]	OMIM	HGMD	GENETEST
RDX	Deafness, autosomal recessive 24 [MIM:611022]	OMIM	HGMD	GENETEST
RECQL4	Baller-Gerold syndrome [MIM:218600]; RAPADILINO syndrome [MIM:266280]; Rothmund-Thomson syndrome [MIM:268400]	OMIM	HGMD	GENETEST
REEP1	Neuronopathy, distal hereditary motor, type VB [MIM:614751]; Spastic paraplegia 31, autosomal dominant [MIM:610250]	OMIM	HGMD	GENETEST
RELN	Lissencephaly 2 (Norman-Roberts type) [MIM:257320]	OMIM	HGMD	GENETEST
REN	Hyperuricemic nephropathy, familial juvenile 2 [MIM:613092]; Renal tubular dysgenesis [MIM:267430]	OMIM	HGMD	GENETEST
RET	Central hypoventilation syndrome, congenital [MIM:209880]; Medullary thyroid carcinoma [MIM:155240]; Multiple endocrine neoplasia IIA [MIM:171400]; Multiple endocrine neoplasia IIB [MIM:162300]; Pheochromocytoma [MIM:171300]; Renal agenesis [MIM:191830]	OMIM	HGMD	GENETEST
RFT1	Congenital disorder of glycosylation, type In [MIM:612015]	OMIM	HGMD	GENETEST
RFX5	Bare lymphocyte syndrome, type II, complementation group C [MIM:209920]	OMIM	HGMD	GENETEST
RFX6	Martinez-Frias syndrome [MIM:601346]	OMIM	HGMD
RFXANK	MHC class II deficiency, complementation group B [MIM:209920]	OMIM	HGMD	GENETEST
RFXAP	Bare lymphocyte syndrome, type II, complementation group D [MIM:209920]	OMIM	HGMD	GENETEST
RGR	Retinitis pigmentosa 44 [MIM:613769]	OMIM	HGMD	GENETEST
RGS9	Bradyopsia [MIM:608415]	OMIM	HGMD
RGS9BP	Bradyopsia [MIM:608415]	OMIM	HGMD
RHAG	Anemia, hemolytic, Rh-null, regulator type [MIM:268150]; Rh-mod syndrome	OMIM	HGMD
RHBDF2	Tylosis with esophageal cancer [MIM:148500]	OMIM	HGMD	GENETEST
RHCE	Rh-null disease, amorph type	OMIM	HGMD
RHO	Night blindness, congenital stationary, autosomal dominant 1 [MIM:610445]; Retinitis pigmentosa 4, autosomal dominant or recessive [MIM:613731]; Retinitis punctata albescens [MIM:136880]	OMIM	HGMD	GENETEST
RIMS1	Cone-rod dystrophy 7 [MIM:603649]	OMIM	HGMD	GENETEST
RIN2	Macrocephaly, alopecia, cutis laxa, and scoliosis [MIM:613075]	OMIM	HGMD	GENETEST
RIPK4	Popliteal pterygium syndrome 2, lethal type [MIM:263650]	OMIM	HGMD
RLBP1	Bothnia retinal dystrophy [MIM:607475]; Fundus albipunctatus [MIM:136880]; Newfoundland rod-cone dystrophy [MIM:607476]	OMIM	HGMD	GENETEST
RMND1	Combined oxidative phosphorylation deficiency 11 [MIM:614922]	OMIM	
RMRP	Anauxetic dysplasia [MIM:607095]; Cartilage-hair hypoplasia [MIM:250250]; Metaphyseal dysplasia without hypotrichosis [MIM:250460]	OMIM	HGMD	GENETEST
RNASEH2A	Aicardi-Goutieres syndrome 4 [MIM:610333]	OMIM	HGMD	GENETEST
RNASEH2B	Aicardi-Goutieres syndrome 2 [MIM:610181]	OMIM	HGMD	GENETEST
RNASEH2C	Aicardi-Goutieres syndrome 3 [MIM:610329]	OMIM	HGMD	GENETEST
RNASEL	Prostate cancer 1 [MIM:601518]	OMIM	HGMD	GENETEST
RNASET2	Leukoencephalopathy, cystic, without megalencephaly [MIM:612951]	OMIM	HGMD	GENETEST
RNF135	Macrocephaly, macrosomia, facial dysmorphism syndrome [MIM:614192]	OMIM	HGMD
RNF139	Renal cell carcinoma [MIM:144700]	OMIM	
RNF168	RIDDLE syndrome [MIM:611943]	OMIM	HGMD	GENETEST
RNF170	Ataxia, sensory, 1, autosomal dominant [MIM:608984]	OMIM	HGMD
RNF212	Recombination rate QTL 1 [MIM:612042]	OMIM	
RNU4ATAC	Microcephalic osteodysplastic primordial dwarfism, type I [MIM:210710]	OMIM	HGMD	GENETEST
ROBO2	Vesicoureteral reflux 2 [MIM:610878]	OMIM	HGMD	GENETEST
ROBO3	Gaze palsy, horizontal, with progressive scoliosis [MIM:607313]	OMIM	HGMD	GENETEST
ROGDI	Kohlschutter-Tonz syndrome [MIM:226750]	OMIM		GENETEST
ROM1	Retinitis pigmentosa 7, digenic	OMIM	HGMD	GENETEST
ROR2	Brachydactyly, type B1 [MIM:113000]; Robinow syndrome, autosomal recessive [MIM:268310]	OMIM	HGMD	GENETEST
RP1	Retinitis pigmentosa 1 [MIM:180100]	OMIM	HGMD	GENETEST
RP1L1	Occult macular dystrophy [MIM:613587]	OMIM	HGMD	GENETEST
RP2	Retinitis pigmentosa 2 [MIM:312600]	OMIM	HGMD	GENETEST
RP9	Retinitis pigmentosa 9 [MIM:180104]	OMIM	HGMD	GENETEST
RPE65	Leber congenital amaurosis 2 [MIM:204100]; Retinitis pigmentosa 20 [MIM:613794]	OMIM	HGMD	GENETEST
RPGR	Cone-rod dystrophy-1 [MIM:304020]; Macular degeneration, X-linked atrophic [MIM:300834]; Retinitis pigmentosa 3 [MIM:300029]; Retinitis pigmentosa, X-linked, and sinorespiratory infections, with or without deafness [MIM:300455]	OMIM	HGMD	GENETEST
RPGRIP1	Cone-rod dystrophy 13 [MIM:608194]; Leber congenital amaurosis 6 [MIM:613826]	OMIM	HGMD	GENETEST
RPGRIP1L	COACH syndrome [MIM:216360]; Joubert syndrome 7 [MIM:611560]; Meckel syndrome 5 [MIM:611561]	OMIM	HGMD	GENETEST
RPIA	Ribose 5-phosphate isomerase deficiency [MIM:608611]	OMIM	HGMD	GENETEST
RPL11	Diamond-Blackfan anemia 7 [MIM:612562]	OMIM	HGMD	GENETEST
RPL26	Diamond-Blackfan anemia 11 [MIM:614900]	OMIM	
RPL35A	Diamond-Blackfan anemia 5 [MIM:612528]	OMIM	HGMD	GENETEST
RPL5	Diamond-Blackfan anemia 6 [MIM:612561]	OMIM	HGMD	GENETEST
RPS10	Diamond-Blackfan anemia 9 [MIM:613308]	OMIM	HGMD	GENETEST
RPS17	Diamond-Blackfan anemia 4 [MIM:612527]	OMIM	HGMD	GENETEST
RPS19	Diamond-Blackfan anemia 1 [MIM:105650]	OMIM	HGMD	GENETEST
RPS24	Diamond-blackfan anemia 3 [MIM:610629]	OMIM	HGMD	GENETEST
RPS26	Diamond-Blackfan anemia 10 [MIM:613309]	OMIM	HGMD	GENETEST
RPS6KA3	Coffin-Lowry syndrome [MIM:303600]; Mental retardation, X-linked 19 [MIM:300844]	OMIM	HGMD	GENETEST
RPS7	Diamond-Blackfan anemia 8 [MIM:612563]	OMIM	HGMD	GENETEST
RRAS2	Ovarian carcinoma	OMIM	
RRM2B	Mitochondrial DNA depletion syndrome 8B (MNGIE type) [MIM:612075]; Progressive external ophthalmoplegia with mitochondrial DNA deletions, autosomal dominant, 5 [MIM:613077]	OMIM	HGMD	GENETEST
RS1	Retinoschisis [MIM:312700]	OMIM	HGMD	GENETEST
RSPH4A	Ciliary dyskinesia, primary, 11 [MIM:612649]	OMIM	HGMD	GENETEST
RSPH9	Ciliary dyskinesia, primary, 12 [MIM:612650]	OMIM	HGMD	GENETEST
RSPO1	Palmoplantar hyperkeratosis and true hermaphroditism [MIM:610644]	OMIM	HGMD
RSPO4	Anonychia congenita [MIM:206800]	OMIM	HGMD	GENETEST
RTN2	Spastic paraplegia 12, autosomal dominant [MIM:604805]	OMIM	HGMD	GENETEST
RTTN	Polymicrogyria with seizures [MIM:614833]	OMIM	
RUNX1	Leukemia, acute myeloid [MIM:601626]; Platelet disorder, familial, with associated myeloid malignancy [MIM:601399]	OMIM	HGMD	GENETEST
RUNX2	Cleidocranial dysplasia [MIM:119600]; Dental anomalies, isolated	OMIM	HGMD	GENETEST
RXFP2	Cryptorchidism [MIM:219050]	OMIM	HGMD
RYR1	Central core disease [MIM:117000]; Minicore myopathy with external ophthalmoplegia [MIM:255320]	OMIM	HGMD	GENETEST
RYR2	Arrhythmogenic right ventricular dysplasia 2 [MIM:600996]; Ventricular tachycardia, catecholaminergic polymorphic, 1 [MIM:604772]	OMIM	HGMD	GENETEST
SACS	Spastic ataxia, Charlevoix-Saguenay type [MIM:270550]	OMIM	HGMD	GENETEST
SAG	Oguchi disease-1 [MIM:258100]; Retinitis pigmentosa 47 [MIM:613758]	OMIM	HGMD	GENETEST
SALL1	Townes-Brocks syndrome [MIM:107480]	OMIM	HGMD	GENETEST
SALL4	Duane-radial ray syndrome [MIM:607323]; IVIC syndrome [MIM:147750]	OMIM	HGMD	GENETEST
SAMD9	Tumoral calcinosis, familial, normophosphatemic [MIM:610455]	OMIM	HGMD
SAMHD1	Aicardi-Goutieres syndrome 5 [MIM:612952]; Chilblain lupus 2 [MIM:614415]	OMIM	HGMD	GENETEST
SAR1B	Chylomicron retention disease [MIM:246700]	OMIM	HGMD
SARS2	Hyperuricemia, pulmonary hypertension, renal failure, and alkalosis [MIM:613845]	OMIM	HGMD	GENETEST
SART3	Porokeratosis, disseminated superficial actinic, 1 [MIM:175900]	OMIM	HGMD
SAT1	Keratosis follicularis spinulosa decalvans [MIM:308800]	OMIM	HGMD
SATB2	Cleft palate and mental retardation [MIM:119540]	OMIM	HGMD
SBDS	Shwachman-Bodian-Diamond syndrome [MIM:260400]	OMIM	HGMD	GENETEST
SBF2	Charcot-Marie-Tooth disease, type 4B2 [MIM:604563]	OMIM	HGMD	GENETEST
SC5DL	Lathosterolosis [MIM:607330]	OMIM	HGMD	GENETEST
SCARB2	Epilepsy, progressive myoclonic 4, with or without renal failure [MIM:254900]	OMIM	HGMD
SCARF2	Van den Ende-Gupta syndrome [MIM:600920]	OMIM	HGMD
SCN1A	Dravet syndrome [MIM:607208]; Febrile seizures, familial, 3A [MIM:604403]; Migraine, familial hemiplegic, 3 [MIM:609634]	OMIM	HGMD	GENETEST
SCN1B	Brugada syndrome 5 [MIM:612838]; Epilepsy, generalized, with febrile seizures plus, type 1 [MIM:604233]	OMIM	HGMD	GENETEST
SCN2A	Epileptic encephalopathy, early infantile, 11 [MIM:613721]; Seizures, benign familial infantile, 3 [MIM:607745]	OMIM	HGMD	GENETEST
SCN3B	Brugada syndrome 7 [MIM:613120]	OMIM	HGMD	GENETEST
SCN4A	Hyperkalemic periodic paralysis, type 2 [MIM:170500]; Hypokalemic periodic paralysis, type 2 [MIM:613345]; Myasthenic syndrome, acetazolamide-responsive [MIM:614198]; Myotonia congenita, atypical, acetazolamide-responsive [MIM:608390]; Paramyotonia congenita [MIM:168300]	OMIM	HGMD	GENETEST
SCN4B	Long QT syndrome-10 [MIM:611819]	OMIM	HGMD	GENETEST
SCN5A	Atrial fibrillation, familial, 10 [MIM:614022]; Brugada syndrome 1 [MIM:601144]; Cardiomyopathy, dilated, 1E [MIM:601154]; Heart block, nonprogressive [MIM:113900]; Long QT syndrome-3 [MIM:603830]; Sick sinus syndrome 1 [MIM:608567]; Ventricular fibrillation, familial, 1 [MIM:603829]	OMIM	HGMD	GENETEST
SCN8A	Cognitive impairment with or without cerebellar ataxia [MIM:614306]; Epileptic encephalopathy, early infantile, 13 [MIM:614558]	OMIM	HGMD	GENETEST
SCN9A	Erythermalgia, primary [MIM:133020]; Febrile seizures, familial, 3B [MIM:613863]; Insensitivity to pain, channelopathy-associated [MIM:243000]; Paroxysmal extreme pain disorder [MIM:167400]	OMIM	HGMD	GENETEST
SCNN1A	Bronchiectasis with or without elevated sweat chloride 2 [MIM:613021]; Pseudohypoaldosteronism, type I [MIM:264350]	OMIM	HGMD	GENETEST
SCNN1B	Bronchiectasis with or without elevated sweat chloride 1 [MIM:211400]; Liddle syndrome [MIM:177200]; Pseudohypoaldosteronism, type I [MIM:264350]	OMIM	HGMD	GENETEST
SCNN1G	Bronchiectasis with or without elevated sweat chloride 3 [MIM:613071]; Liddle syndrome [MIM:177200]; Pseudohypoaldosteronism, type I [MIM:264350]	OMIM	HGMD	GENETEST
SCO1	Hepatic failure, early onset, and neurologic disorder	OMIM	HGMD	GENETEST
SCO2	Cardioencephalomyopathy, fatal infantile, due to cytochrome c oxidase deficiency [MIM:604377]	OMIM	HGMD	GENETEST
SCP2	Leukoencephalopathy with dystonia and motor neuropathy [MIM:613724]	OMIM	HGMD	GENETEST
SDCCAG8	Senior-Loken syndrome 7 [MIM:613615]	OMIM	HGMD	GENETEST
SDHA	Cardiomyopathy, dilated, 1GG [MIM:613642]; Leigh syndrome [MIM:256000]; Mitochondrial respiratory chain complex II deficiency [MIM:252011]; Paragangliomas 5 [MIM:614165]	OMIM	HGMD	GENETEST
SDHAF1	Mitochondrial complex II deficiency [MIM:252011]	OMIM	HGMD	GENETEST
SDHAF2	Paragangliomas 2 [MIM:601650]	OMIM	HGMD	GENETEST
SDHB	Cowden-like syndrome [MIM:612359]; Gastrointestinal stromal tumor [MIM:606764]; Paraganglioma and gastric stromal sarcoma [MIM:606864]; Paragangliomas 4 [MIM:115310]; Pheochromocytoma [MIM:171300]	OMIM	HGMD	GENETEST
SDHC	Gastrointestinal stromal tumor [MIM:606764]; Paraganglioma and gastric stromal sarcoma [MIM:606864]; Paragangliomas 3 [MIM:605373]	OMIM	HGMD	GENETEST
SDHD	Carcinoid tumors, intestinal [MIM:114900]; Cowden-like syndrome [MIM:612359]; Paraganglioma and gastric stromal sarcoma [MIM:606864]; Paragangliomas 1, with or without deafness [MIM:168000]; Pheochromocytoma [MIM:171300]	OMIM	HGMD	GENETEST
SEC23A	Craniolenticulosutural dysplasia [MIM:607812]	OMIM	HGMD
SEC23B	Anemia, dyserythropoietic congenital, type II [MIM:224100]	OMIM	HGMD	GENETEST
SEC63	Polycystic liver disease [MIM:174050]	OMIM	HGMD	GENETEST
SECISBP2	Thyroid hormone metabolism, abnormal [MIM:609698]	OMIM	HGMD
SELP	Platelet alpha/delta storage pool deficiency	OMIM	HGMD
SEMA3A	Hypogonadotropic hypogonadism 16 with or without anosmia [MIM:614897]	OMIM	HGMD
SEMA3E	CHARGE syndrome [MIM:214800]	OMIM	HGMD
SEMA4A	Cone-rod dystrophy 10 [MIM:610283]; Retinitis pigmentosa 35 [MIM:610282]	OMIM	HGMD	GENETEST
SEPN1	Muscular dystrophy, rigid spine, 1 [MIM:602771]; Myopathy, congenital, with fiber-type disproportion [MIM:255310]	OMIM	HGMD	GENETEST
SEPSECS	Pontocerebellar hypoplasia type 2D [MIM:613811]	OMIM	HGMD
SEPT12	Spermatogenic failure 10 [MIM:614822]	OMIM	
SEPT9	Amyotrophy, hereditary neuralgic [MIM:162100]; Leukemia, acute myeloid, therapy-related; Ovarian carcinoma	OMIM	HGMD	GENETEST
SERAC1	3-methylglutaconic aciduria with deafness, encephalopathy, and Leigh-like syndrome [MIM:614739]	OMIM	
SERPINA1	Emphysema due to AAT deficiency [MIM:613490]	OMIM	HGMD	GENETEST
SERPINA3	Alpha-1-antichymotrypsin deficiency; Cerebrovascular disease, occlusive	OMIM	HGMD
SERPINA6	Corticosteroid-binding globulin deficiency [MIM:611489]	OMIM	HGMD
SERPINA7	Thyroxine-binding globulin deficiency	OMIM	HGMD
SERPINB6	Deafness, autosomal recessive 91 [MIM:613453]	OMIM	HGMD
SERPINC1	Thrombophilia due to antithrombin III deficiency [MIM:613118]	OMIM	HGMD	GENETEST
SERPIND1	Thrombophilia due to heparin cofactor II deficiency [MIM:612356]	OMIM	HGMD
SERPINE1	Plasminogen activator inhibitor-1 deficiency [MIM:613329]	OMIM	HGMD	GENETEST
SERPINF1	Osteogenesis imperfecta, type VI [MIM:613982]	OMIM	HGMD	GENETEST
SERPINF2	Alpha-2-plasmin inhibitor deficiency [MIM:262850]	OMIM	HGMD
SERPING1	Angioedema, hereditary, types I and II [MIM:106100]; Complement component 4, partial deficiency of [MIM:120790]	OMIM	HGMD	GENETEST
SERPINH1	Osteogenesis imperfecta, type X [MIM:613848]	OMIM	HGMD	GENETEST
SERPINI1	Encephalopathy, familial, with neuroserpin inclusion bodies [MIM:604218]	OMIM	HGMD	GENETEST
SETBP1	Schinzel-Giedion midface retraction syndrome [MIM:269150]	OMIM	HGMD	GENETEST
SETX	Amyotrophic lateral sclerosis 4, juvenile [MIM:602433]; Ataxia-ocular apraxia-2 [MIM:606002]	OMIM	HGMD	GENETEST
SF3B4	Acrofacial dysostosis 1, Nager type [MIM:154400]	OMIM		GENETEST
SFTPA2	Pulmonary fibrosis, idiopathic [MIM:178500]	OMIM	HGMD
SFTPB	Surfactant metabolism dysfunction, pulmonary, 1 [MIM:265120]	OMIM	HGMD	GENETEST
SFTPC	Surfactant metabolism dysfunction, pulmonary, 2 [MIM:610913]	OMIM	HGMD	GENETEST
SGCA	Adhalinopathy, primary; Muscular dystrophy, limb-girdle, type 2D [MIM:608099]	OMIM	HGMD	GENETEST
SGCB	Muscular dystrophy, limb-girdle, type 2E [MIM:604286]	OMIM	HGMD	GENETEST
SGCD	Cardiomyopathy, dilated, 1L [MIM:606685]; Muscular dystrophy, limb-girdle, type 2F [MIM:601287]	OMIM	HGMD	GENETEST
SGCE	Dystonia-11, myoclonic [MIM:159900]	OMIM	HGMD	GENETEST
SGCG	Muscular dystrophy, limb-girdle, type 2C [MIM:253700]	OMIM	HGMD	GENETEST
SGSH	Mucopolysaccharidisis type IIIA (Sanfilippo A) [MIM:252900]	OMIM	HGMD	GENETEST
SH2D1A	Lymphoproliferative syndrome, X-linked [MIM:308240]	OMIM	HGMD	GENETEST
SH3BP2	Cherubism [MIM:118400]	OMIM	HGMD	GENETEST
SH3GL1	Leukemia, acute myeloid [MIM:601626]	OMIM	HGMD
SH3PXD2B	Frank-ter Haar syndrome [MIM:249420]	OMIM	HGMD	GENETEST
SH3TC2	Charcot-Marie-Tooth disease, type 4C [MIM:601596]; Mononeuropathy of the median nerve, mild [MIM:613353]	OMIM	HGMD	GENETEST
SHANK3	Phelan-McDermid syndrome [MIM:606232]	OMIM	HGMD	GENETEST
SHFM1	Split hand/foot malformation 1	OMIM	HGMD
SHH	Holoprosencephaly-3 [MIM:142945]; Microphthalmia with coloboma 5 [MIM:611638]; Schizencephaly [MIM:269160]; Single median maxillary central incisor [MIM:147250]	OMIM	HGMD	GENETEST
SHOC2	Noonan-like syndrome with loose anagen hair [MIM:607721]	OMIM	HGMD	GENETEST
SHOX	Langer mesomelic dysplasia [MIM:249700]; Leri-Weill dyschondrosteosis [MIM:127300]; Short stature, idiopathic familial [MIM:300582]	OMIM	HGMD	GENETEST
SHROOM4	Stocco dos Santos X-linked mental retardation syndrome [MIM:300434]	OMIM	HGMD	GENETEST
SI	Sucrase-isomaltase deficiency, congenital [MIM:222900]	OMIM	HGMD	GENETEST
SIGMAR1	Amyotrophic lateral sclerosis 16, juvenile [MIM:614373]	OMIM	HGMD
SIL1	Marinesco-Sjogren syndrome [MIM:248800]	OMIM	HGMD	GENETEST
SIM1	Obesity, severe [MIM:601665]	OMIM		GENETEST
SIPA1	Metastasis efficiency, modification of	OMIM	HGMD
SIX1	Brachiootic syndrome 3 [MIM:608389]; Deafness, autosomal dominant 23 [MIM:605192]	OMIM	HGMD	GENETEST
SIX3	Holoprosencephaly-2 [MIM:157170]; Schizensephaly [MIM:269160]	OMIM	HGMD	GENETEST
SIX5	Branchiootorenal syndrome 2 [MIM:610896]	OMIM	HGMD	GENETEST
SIX6	Microphthalmia with cataract 2 [MIM:212550]	OMIM	HGMD	GENETEST
SKI	Shprintzen-Goldberg syndrome [MIM:182212]	OMIM	HGMD
SKIV2L	Trichohepatoenteric syndrome 2 [MIM:614602]	OMIM	HGMD	GENETEST
SLC10A2	Bile acid malabsorption, primary [MIM:613291]	OMIM	HGMD
SLC11A2	Anemia, hypochromic microcytic [MIM:206100]	OMIM	HGMD	GENETEST
SLC12A1	Bartter syndrome, type 1 [MIM:601678]	OMIM	HGMD	GENETEST
SLC12A3	Gitelman syndrome [MIM:263800]	OMIM	HGMD	GENETEST
SLC12A6	Agenesis of the corpus callosum with peripheral neuropathy [MIM:218000]	OMIM	HGMD	GENETEST
SLC16A1	Erythrocyte lactate transporter defect [MIM:245340]; Hyperinsulinemic hypoglycemia, familial, 7 [MIM:610021]	OMIM	HGMD
SLC16A12	Cataract, juvenile, with microcornea and glucosuria [MIM:612018]	OMIM	HGMD
SLC16A2	Allan-Herndon-Dudley syndrome [MIM:300523]	OMIM	HGMD	GENETEST
SLC17A5	Salla disease [MIM:604369]; Sialic acid storage disorder, infantile [MIM:269920]	OMIM	HGMD	GENETEST
SLC17A8	Deafness, autosomal dominant 25 [MIM:605583]	OMIM	HGMD	GENETEST
SLC19A2	Thiamine-responsive megaloblastic anemia syndrome [MIM:249270]	OMIM	HGMD	GENETEST
SLC19A3	Thiamine metabolism dysfunction syndrome 2 (biotin- or thiamine-responsive encephalopathy type 2) [MIM:607483]	OMIM	HGMD	GENETEST
SLC1A3	Episodic ataxia, type 6 [MIM:612656]	OMIM	HGMD	GENETEST
SLC20A2	Basal ganglia cancification, idiopathic, 3 [MIM:614540]	OMIM		GENETEST
SLC22A12	Hypouricemia, renal [MIM:220150]	OMIM	HGMD	GENETEST
SLC22A5	Carnitine deficiency, systemic primary [MIM:212140]	OMIM	HGMD	GENETEST
SLC24A1	Night blindness, congenital stationary (complete), 1D, autosomal recessive [MIM:613830]	OMIM	HGMD	GENETEST
SLC25A12	Hypomyelination, global cerebral [MIM:612949]	OMIM	HGMD	GENETEST
SLC25A13	Citrullinemia, adult-onset type II [MIM:603471]; Citrullinemia, type II, neonatal-onset [MIM:605814]	OMIM	HGMD	GENETEST
SLC25A15	Hyperornithinemia-hyperammonemia-homocitrullinemia syndrome [MIM:238970]	OMIM	HGMD	GENETEST
SLC25A19	Microcephaly, Amish type [MIM:607196]; Thiamine metabolism dysfunction syndrome 4 (progressive polyneuropathy type) [MIM:613710]	OMIM	HGMD	GENETEST
SLC25A20	Carnitine-acylcarnitine translocase deficiency [MIM:212138]	OMIM	HGMD	GENETEST
SLC25A22	Epileptic encephalopathy, early infantile, 3 [MIM:609304]	OMIM	HGMD	GENETEST
SLC25A3	Micochondrial phosphate carrier deficiency [MIM:610773]	OMIM	HGMD	GENETEST
SLC25A38	Anemia, sideroblastic, pyridoxine-refractory, autosomal recessive [MIM:205950]	OMIM	HGMD	GENETEST
SLC25A4	Cardiomyopathy, familial hypertrophic [MIM:192600]; Progressive external ophthalmoplegia with mitochondrial DNA deletions 3 [MIM:609283]	OMIM	HGMD	GENETEST
SLC26A2	Achondrogenesis Ib [MIM:600972]; Atelosteogenesis II [MIM:256050]; Diastrophic dysplasia [MIM:222600]; Epiphyseal dysplasia, multiple, 4 [MIM:226900]	OMIM	HGMD	GENETEST
SLC26A3	Chloride diarrhea, congenital, Finnish type [MIM:214700]	OMIM	HGMD	GENETEST
SLC26A4	Deafness, autosomal recessive 4, with enlarged vestibular aqueduct [MIM:600791]; Pendred syndrome [MIM:274600]	OMIM	HGMD	GENETEST
SLC26A5	Deafness, autosomal recessive 61 [MIM:613865]	OMIM	HGMD	GENETEST
SLC27A4	Ichthyosis prematurity syndrome [MIM:608649]	OMIM	HGMD
SLC29A3	Histiocytosis-lymphadenopathy plus syndrome [MIM:602782]	OMIM	HGMD	GENETEST
SLC2A1	Dystonia 9 [MIM:601042]; GLUT1 deficiency syndrome 1 [MIM:606777]; GLUT1 deficiency syndrome 2 [MIM:612126]	OMIM	HGMD	GENETEST
SLC2A10	Arterial tortuosity syndrome [MIM:208050]	OMIM	HGMD	GENETEST
SLC2A2	Fanconi-Bickel syndrome [MIM:227810]	OMIM	HGMD	GENETEST
SLC2A9	Hypouricemia, renal, 2 [MIM:612076]	OMIM	HGMD	GENETEST
SLC30A10	Hypermanganesemia with dystonia, polycythemia, and cirrhosis [MIM:613280]	OMIM		GENETEST
SLC30A2	Zinc deficiency, transient neonatal [MIM:608118]	OMIM	HGMD
SLC33A1	Congenital cataracts, hearing loss, and neurodegeneration [MIM:614482]; Spastic paraplegia 42, autosomal dominant [MIM:612539]	OMIM	HGMD	GENETEST
SLC34A1	Fanconi renotubular syndrome 2 [MIM:613388]; Nephrolithiasis/osteoporosis, hypophosphatemic, 1 [MIM:612286]	OMIM	HGMD	GENETEST
SLC34A2	Pulmonary alveolar microlithiasis [MIM:265100]	OMIM	HGMD
SLC34A3	Hypophosphatemic rickets with hypercalciuria [MIM:241530]	OMIM	HGMD	GENETEST
SLC35A1	Congenital disorder of glycosylation, type IIf [MIM:603585]	OMIM	HGMD	GENETEST
SLC35C1	Congenital disorder of glycosylation, type IIc [MIM:266265]	OMIM	HGMD	GENETEST
SLC35D1	Schneckenbecken dysplasia [MIM:269250]	OMIM	HGMD
SLC36A2	Hyperglycinuria [MIM:138500]; Iminoglycinuria, digenic [MIM:242600]	OMIM	HGMD
SLC37A4	Glycogen storage disease Ib [MIM:232220]; Glycogen storage disease Ic [MIM:232240]	OMIM	HGMD	GENETEST
SLC39A13	Spondylocheirodysplasia, Ehlers-Danlos syndrome-like [MIM:612350]	OMIM	HGMD	GENETEST
SLC39A4	Acrodermatitis enteropathica [MIM:201100]	OMIM	HGMD	GENETEST
SLC3A1	Cystinuria [MIM:220100]	OMIM	HGMD	GENETEST
SLC40A1	Hemochromatosis, type 4 [MIM:606069]	OMIM	HGMD	GENETEST
SLC45A2	Oculocutaneous albinism, type IV [MIM:606574]	OMIM	HGMD	GENETEST
SLC46A1	Folate malabsorption, hereditary [MIM:229050]	OMIM	HGMD	GENETEST
SLC4A1	Ovalocytosis; Renal tubular acidosis, distal, AD [MIM:179800]; Renal tubular acidosis, distal, AR [MIM:611590]; Spherocytosis, type 4 [MIM:612653]	OMIM	HGMD	GENETEST
SLC4A11	Corneal dystrophy, Fuchs endothelial, 4 [MIM:613268]; Corneal endothelial dystrophy 2, autosomal recessive [MIM:217700]; Corneal endothelial dystrophy and perceptive deafness [MIM:217400]	OMIM	HGMD	GENETEST
SLC4A4	Renal tubular acidosis, proximal, with ocular abnormalities [MIM:604278]	OMIM	HGMD	GENETEST
SLC52A1	Riboflavin deficiency [MIM:615026]	OMIM	
SLC52A2	Brown-Vialetto-Van Laere syndrome 2 [MIM:614707]	OMIM	
SLC52A3	Brown-Vialetto-Van Laere syndrome 1 [MIM:211530]; Fazio-Londe disease [MIM:211500]	OMIM		GENETEST
SLC5A1	Glucose/galactose malabsorption [MIM:606824]	OMIM	HGMD	GENETEST
SLC5A2	Renal glucosuria [MIM:233100]	OMIM	HGMD	GENETEST
SLC5A5	Thyroid dyshormonogenesis 1 [MIM:274400]	OMIM	HGMD	GENETEST
SLC5A7	Neuronopathy, distal hereditary motor, type VIIA [MIM:158580]	OMIM	HGMD
SLC6A19	Hartnup disorder [MIM:234500]; Hyperglycinuria [MIM:138500]; Iminoglycinuria, digenic [MIM:242600]	OMIM	HGMD	GENETEST
SLC6A2	Orthostatic intolerance [MIM:604715]	OMIM	HGMD	GENETEST
SLC6A20	Hyperglycinuria [MIM:138500]; Iminoglycinuria, digenic [MIM:242600]	OMIM	HGMD	GENETEST
SLC6A3	Parkinsonism-dystonia, infantile [MIM:613135]	OMIM	HGMD	GENETEST
SLC6A5	Hyperekplexia 3 [MIM:614618]	OMIM	HGMD	GENETEST
SLC6A8	Creatine deficiency syndrome, X-linked [MIM:300352]	OMIM	HGMD	GENETEST
SLC7A7	Lysinuric protein intolerance [MIM:222700]	OMIM	HGMD	GENETEST
SLC7A9	Cystinuria [MIM:220100]	OMIM	HGMD	GENETEST
SLC9A3R1	Nephrolithiasis/osteoporosis, hypophosphatemic, 2 [MIM:612287]	OMIM	HGMD
SLC9A6	Mental retardation, X-linked syndromic, Christianson type [MIM:300243]	OMIM	HGMD	GENETEST
SLCO1B1	Hyperbilirubinemia, Rotor type, digenic [MIM:237450]	OMIM	HGMD	GENETEST
SLCO1B3	Hyperbilirubinemia, Rotor type, digenic [MIM:237450]	OMIM	HGMD	GENETEST
SLCO2A1	Hypertrophic osteoarthropathy, primary, autosomal recessive 2 [MIM:614441]	OMIM	HGMD
SLITRK1	Tourette syndrome [MIM:137580]; Trichotillomania [MIM:613229]	OMIM	HGMD	GENETEST
SLURP1	Meleda disease [MIM:248300]	OMIM	HGMD	GENETEST
SLX4	Fanconi anemia, complementation group P [MIM:613951]	OMIM	HGMD	GENETEST
SMAD3	Loeys-Dietz syndrome, type 3 [MIM:613795]	OMIM	HGMD	GENETEST
SMAD4	Juvenile polyposis/hereditary hemorrhagic telangiectasia syndrome [MIM:175050]; Myhre syndrome [MIM:139210]; Pancreatic cancer; Polyposis, juvenile intestinal [MIM:174900]	OMIM	HGMD	GENETEST
SMAD6	Aortic valve disease 2 [MIM:614823]	OMIM	
SMAD9	Pulmonary hypertension, primary [MIM:178600]	OMIM	HGMD	GENETEST
SMARCA2	Nicolaides-Baraitser syndrome [MIM:601358]	OMIM	HGMD	GENETEST
SMARCA4	Mental retardation, autosomal dominant 16 [MIM:614609]; Rhabdoid tumor predisposition syndrome 2 [MIM:613325]	OMIM	HGMD	GENETEST
SMARCAD1	Adermatoglyphia [MIM:136000]	OMIM	HGMD
SMARCAL1	Schimke immunoosseous dysplasia [MIM:242900]	OMIM	HGMD	GENETEST
SMARCB1	Mental retardation, autosomal dominant 15 [MIM:614608]	OMIM	HGMD	GENETEST
SMC1A	Cornelia de Lange syndrome 2 [MIM:300590]	OMIM	HGMD	GENETEST
SMC3	Cornelia de Lange syndrome 3 [MIM:610759]	OMIM	HGMD	GENETEST
SMCHD1	Fascioscapulohumeral muscular dystrophy 2, digenic [MIM:158901]	OMIM	
SMN1	Spinal muscular atrophy-1 [MIM:253300]; Spinal muscular atrophy-2 [MIM:253550]; Spinal muscular atrophy-3 [MIM:253400]; Spinal muscular atrophy-4 [MIM:271150]	OMIM	HGMD	GENETEST
SMOC1	Microphthalmia with limb anomalies [MIM:206920]	OMIM	HGMD
SMOC2	Dentin dysplasia, type I, with microdontia and misshapen teeth [MIM:125400]	OMIM	HGMD
SMPD1	Niemann-Pick disease, type A [MIM:257200]; Niemann-Pick disease, type B [MIM:607616]	OMIM	HGMD	GENETEST
SMPX	Deafness, X-linked 4 [MIM:300066]	OMIM	HGMD	GENETEST
SMS	Mental retardation, X-linked, Snyder-Robinson type [MIM:309583]	OMIM	HGMD	GENETEST
SNAI2	Piebaldism [MIM:172800]; Waardenburg syndrome, type 2D [MIM:608890]	OMIM	HGMD	GENETEST
SNAP29	Cerebral dysgenesis, neuropathy, ichthyosis, and palmoplantar keratoderma syndrome [MIM:609528]	OMIM	HGMD	GENETEST
SNCA	Dementia, Lewy body [MIM:127750]; Parkinson disease 1 [MIM:168601]; Parkinson disease 4 [MIM:605543]	OMIM	HGMD	GENETEST
SNCB	Dementia, Lewy body [MIM:127750]	OMIM	HGMD
SNIP1	Psychomotor retardation, epilepsy, and craniofacial dysmorphism [MIM:614501]	OMIM	HGMD
SNRNP200	Retinitis pigmentosa 33 [MIM:610359]	OMIM	HGMD	GENETEST
SNRPN	Prader-Willi syndrome [MIM:176270]	OMIM		GENETEST
SNTA1	Long QT syndrome 12 [MIM:612955]	OMIM	HGMD	GENETEST
SOBP	Mental retardation, anterior maxillary protrusion, and strabismus [MIM:613671]	OMIM	HGMD
SOD1	Amyotrophic lateral sclerosis 1 [MIM:105400]	OMIM	HGMD	GENETEST
SOS1	Fibromatosis, gingival [MIM:135300]; Noonan syndrome 4 [MIM:610733]	OMIM	HGMD	GENETEST
SOST	Craniodiaphyseal dysplasia, autosomal dominant [MIM:122860]; Sclerosteosis [MIM:269500]; Van Buchem disease [MIM:239100]	OMIM	HGMD	GENETEST
SOX10	PCWH syndrome [MIM:609136]; Waardenburg syndrome, type 2E, with or without neurologic involvement [MIM:611584]; Waardenburg syndrome, type 4C [MIM:613266]	OMIM	HGMD	GENETEST
SOX17	Vesicoureteral reflux 3 [MIM:613674]	OMIM	
SOX18	Hypotrichosis-lymphedema-telangiectasia syndrome [MIM:607823]	OMIM		GENETEST
SOX2	Microphthalmia, syndromic 3 [MIM:206900]	OMIM	HGMD	GENETEST
SOX3	Mental retardation, X-linked, with isolated growth hormone deficiency [MIM:300123]; Panhypopituitarism, X-linked [MIM:312000]	OMIM	HGMD	GENETEST
SOX9	Campomelic dysplasia [MIM:114290]	OMIM	HGMD	GENETEST
SP110	Hepatic venoocclusive disease with immunodeficiency [MIM:235550]	OMIM	HGMD	GENETEST
SP7	Osteogenesis imperfecta, type XII [MIM:613849]	OMIM	HGMD	GENETEST
SPAST	Spastic paraplegia 4, autosomal dominant [MIM:182601]	OMIM	HGMD	GENETEST
SPATA16	Spermatogenic failure 6 [MIM:102530]	OMIM		GENETEST
SPATA7	Leber congenital amaurosis 3 [MIM:604232]	OMIM	HGMD	GENETEST
SPECC1L	Facial clefting, oblique, 1 [MIM:600251]	OMIM	
SPG11	Spastic paraplegia 11, autosomal recessive [MIM:604360]	OMIM	HGMD	GENETEST
SPG20	Troyer syndrome [MIM:275900]	OMIM	HGMD	GENETEST
SPG21	Mast syndrome [MIM:248900]	OMIM	HGMD	GENETEST
SPG7	Spastic paraplegia 7, autosomal recessive [MIM:607259]	OMIM	HGMD	GENETEST
SPINK1	Pancreatitis, hereditary [MIM:167800]; Tropical calcific pancreatitis [MIM:608189]	OMIM	HGMD	GENETEST
SPINK5	Atopy [MIM:147050]; Netherton syndrome [MIM:256500]	OMIM	HGMD	GENETEST
SPINT2	Diarrhea 3, secretory sodium, congenital, syndromic [MIM:270420]	OMIM	
SPR	Dystonia, dopa-responsive, due to sepiapterin reductase deficiency [MIM:612716]	OMIM	HGMD	GENETEST
SPRED1	Legius syndrome [MIM:611431]	OMIM	HGMD	GENETEST
SPTA1	Elliptocytosis-2 [MIM:130600]; Pyropoikilocytosis [MIM:266140]; Spherocytosis, type 3 [MIM:270970]	OMIM	HGMD	GENETEST
SPTAN1	Epileptic encephalopathy, early infantile, 5 [MIM:613477]	OMIM	HGMD	GENETEST
SPTB	Anemia, neonatal hemolytic, fatal and near-fatal; Elliptocytosis-3; Spherocytosis, type 2	OMIM	HGMD	GENETEST
SPTBN2	Spinocerebellar ataxia 5 [MIM:600224]	OMIM	HGMD	GENETEST
SPTLC1	Neuropathy, hereditary sensory and autonomic, type IA [MIM:162400]	OMIM		GENETEST
SPTLC2	Neuropathy, hereditary sensory and autonomic, type IC [MIM:613640]	OMIM		GENETEST
SQSTM1	Paget disease of bone [MIM:602080]	OMIM	HGMD	GENETEST
SRC	Colon cancer, advanced	OMIM	
SRCAP	Floating-Harbor syndrome [MIM:136140]	OMIM	HGMD	GENETEST
SRD5A2	Pseudovaginal perineoscrotal hypospadias [MIM:264600]	OMIM	HGMD	GENETEST
SRD5A3	Congenital disorder of glycosylation, type Iq [MIM:612379]; Kahrizi syndrome [MIM:612713]	OMIM	HGMD	GENETEST
SRP72	Bone marrow failure, familial [MIM:614675]	OMIM		GENETEST
SRPX2	Rolandic epilepsy, mental retardation, and speech dyspraxia [MIM:300643]	OMIM		GENETEST
SRY	46XX sex reversal 1 [MIM:400045]; 46XY sex reversal 1 [MIM:400044]	OMIM	HGMD	GENETEST
SS18	Sarcoma, synovial	OMIM	
SSTR5	Somatostatin analog, resistance to [MIM:102200]	OMIM	
SSX2	Sarcoma, synovial	OMIM	
SSX4	Sarcoma, synovial	OMIM	
ST14	Ichthyosis with hypotrichosis [MIM:610765]	OMIM	HGMD
ST3GAL3	Epileptic encephalopathy, early infantile, 15 [MIM:615006]; Mental retardation, autosomal recessive 12 [MIM:611090]	OMIM	
ST3GAL5	Amish infantile epilepsy syndrome [MIM:609056]	OMIM		GENETEST
STAR	Lipoid adrenal hyperplasia [MIM:201710]	OMIM	HGMD	GENETEST
STAT1	Candidiasis, familial, 7 [MIM:614162]; Mycobacterial infection, atypical, familial disseminated [MIM:209950]	OMIM	HGMD	GENETEST
STAT3	Hyper-IgE recurrent infection syndrome [MIM:147060]	OMIM	HGMD	GENETEST
STAT5B	Growth hormone insensitivity with immunodeficiency [MIM:245590]; Leukemia, acute promyelocytic, STAT5B/RARA type	OMIM	HGMD	GENETEST
STIL	Microcephaly 7, primary, autosomal recessive [MIM:612703]	OMIM	HGMD	GENETEST
STIM1	Immune dysfunction, with T-cell inactivation due to calcium entry defect 2 [MIM:612783]	OMIM	HGMD
STK11	Melanoma, malignant sporadic; Pancreatic cancer, sporadic; Peutz-Jeghers syndrome [MIM:175200]; Testicular tumor, sporadic [MIM:273300]	OMIM	HGMD	GENETEST
STK4	T-cell immunodeficiency, recurrent infections, autoimmunity, and cardiac malformations [MIM:614868]	OMIM	
STOX1	Preeclampsia/eclampsia 4 [MIM:609404]	OMIM	
STRA6	Microphthalmia, syndromic 9 [MIM:601186]	OMIM	HGMD	GENETEST
STRADA	Polyhydramnios, megalencephaly, and symptomatic epilepsy [MIM:611087]	OMIM	
STRC	Deafness, autosomal recessive 16 [MIM:603720]	OMIM	HGMD	GENETEST
STS	Ichthyosis, X-linked [MIM:308100]	OMIM	HGMD	GENETEST
STX11	Hemophagocytic lymphohistiocytosis, familial, 4 [MIM:603552]	OMIM	HGMD	GENETEST
STX16	Pseudohypoparathyroidism, type IB [MIM:603233]	OMIM		GENETEST
STXBP1	Epileptic encephalopathy, early infantile, 4 [MIM:612164]	OMIM	HGMD	GENETEST
STXBP2	Hemophagocytic lymphohistiocytosis, familial, 5 [MIM:613101]	OMIM	HGMD	GENETEST
SUCLA2	Mitochondrial DNA depletion syndrome 5 (encephalomyopathic with methylmalonic aciduria) [MIM:612073]	OMIM	HGMD	GENETEST
SUCLG1	Mitochondrial DNA depletion syndrome 9 (encephalomyopathic type with methylmalonic aciduria) [MIM:245400]	OMIM	HGMD	GENETEST
SUFU	Medulloblastoma, desmoplastic [MIM:155255]	OMIM	HGMD	GENETEST
SUMF1	Multiple sulfatase deficiency [MIM:272200]	OMIM	HGMD	GENETEST
SUMO1	Orofacial cleft 10 [MIM:613705]	OMIM		GENETEST
SUOX	Sulfite oxidase deficiency [MIM:272300]	OMIM	HGMD	GENETEST
SURF1	Leigh syndrome, due to COX deficiency [MIM:256000]	OMIM	HGMD	GENETEST
SUZ12	Endometrial stromal tumors	OMIM	
SYCP3	Spermatogenic failure 4 [MIM:270960]	OMIM	HGMD	GENETEST
SYN1	Epilepsy, X-linked, with variable learning disabilities and behavior disorders [MIM:300491]	OMIM		GENETEST
SYNE1	Emery-Dreifuss muscular dystrophy 4, autosomal dominant [MIM:612998]; Spinocerebellar ataxia, autosomal recessive 8 [MIM:610743]	OMIM	HGMD	GENETEST
SYNE2	Emery-Dreifuss muscular dystrophy 5, autosomal dominant [MIM:612999]	OMIM		GENETEST
SYNGAP1	Mental retardation, autosomal dominant 5 [MIM:612621]	OMIM	HGMD	GENETEST
SYP	Mental retardation, X-linked 96 [MIM:300802]	OMIM	HGMD	GENETEST
SYT14	Spinocerebellar ataxia, autosomal recessive 11 [MIM:614229]	OMIM	
TAB2	Congenital heart disease, nonsyndromic, 2 [MIM:614980]	OMIM	
TAC3	Hypogonadotropic hypogonadism 10 with or without anosmia [MIM:614839]	OMIM	HGMD
TACR3	Hypogonadotropic hypogonadism 11 with or without anosmia [MIM:614840]	OMIM	HGMD	GENETEST
TACSTD2	Corneal dystrophy, gelatinous drop-like [MIM:204870]	OMIM	HGMD	GENETEST
TAF1	Dystonia-Parkinsonism, X-linked [MIM:314250]	OMIM		GENETEST
TAF15	Chondrosarcoma, extraskeletal myxoid [MIM:612237]	OMIM	
TAL1	Leukemia-1, T-cell acute lymphocytic	OMIM	
TAL2	Leukemia-2, T-cell acute lymphoblastic	OMIM	
TALDO1	Transaldolase deficiency [MIM:606003]	OMIM	HGMD	GENETEST
TAP1	Bare lymphocyte syndrome, type I [MIM:604571]	OMIM	HGMD
TAP2	Bare lymphocyte syndrome, type I, due to TAP2 deficiency [MIM:604571]; Wegener-like granulomatosis	OMIM	HGMD
TAPBP	Bare lymphocyte syndrome, type I [MIM:604571]	OMIM	
TARDBP	Frontotemporal lobar degeneration, TARDBP-related [MIM:612069]	OMIM	HGMD	GENETEST
TAT	Tyrosinemia, type II [MIM:276600]	OMIM	HGMD	GENETEST
TAZ	Barth syndrome [MIM:302060]	OMIM	HGMD	GENETEST
TBC1D24	Myoclonic epilepsy, infantile, familial [MIM:605021]	OMIM		GENETEST
TBCE	Hypoparathyroidism-retardation-dysmorphism syndrome [MIM:241410]; Kenny-Caffey syndrome-1 [MIM:244460]	OMIM	HGMD	GENETEST
TBP	Spinocerebellar ataxia 17 [MIM:607136]	OMIM		GENETEST
TBX1	Conotruncal anomaly face syndrome [MIM:217095]; DiGeorge syndrome [MIM:188400]; Velocardiofacial syndrome [MIM:192430]	OMIM	HGMD	GENETEST
TBX15	Cousin syndrome [MIM:260660]	OMIM	HGMD
TBX19	Adrenocorticotropic hormone deficiency [MIM:201400]	OMIM	HGMD	GENETEST
TBX20	Atrial septal defect 4 [MIM:611363]	OMIM		GENETEST
TBX21	Asthma and nasal polyps [MIM:208550]	OMIM	
TBX22	Cleft palate with ankyloglossia [MIM:303400]	OMIM	HGMD	GENETEST
TBX3	Ulnar-mammary syndrome [MIM:181450]	OMIM	HGMD	GENETEST
TBX4	Small patella syndrome [MIM:147891]	OMIM	HGMD	GENETEST
TBX5	Holt-Oram syndrome [MIM:142900]	OMIM	HGMD	GENETEST
TBXAS1	Ghosal hematodiaphyseal syndrome [MIM:231095]	OMIM	
TCAP	Cardiomyopathy, dilated, 1N [MIM:607487]; Muscular dystrophy, limb-girdle, type 2G [MIM:601954]	OMIM	HGMD	GENETEST
TCF3	Leukemia, acute lymphoblastic	OMIM	
TCF4	Pitt-Hopkins syndrome [MIM:610954]	OMIM	HGMD	GENETEST
TCIRG1	Osteopetrosis, autosomal recessive 1 [MIM:259700]	OMIM	HGMD	GENETEST
TCL1A	Leukemia/lymphoma, T-cell	OMIM	
TCL1B	Leukemia/lymphoma, T-cell	OMIM	
TCN2	Transcobalamin II deficiency [MIM:275350]	OMIM	HGMD	GENETEST
TCOF1	Treacher Collins syndrome 1 [MIM:154500]	OMIM	HGMD	GENETEST
TCTN1	Joubert syndrome 13 [MIM:614173]	OMIM		GENETEST
TCTN2	Meckel syndrome 8 [MIM:613885]	OMIM	HGMD	GENETEST
TCTN3	Joubert syndrome 18 [MIM:614815]; Orofaciodigital syndrome IV [MIM:258860]	OMIM	
TDGF1	Forebrain defects	OMIM	
TDP1	Spinocerebellar ataxia, autosomal recessive with axonal neuropathy [MIM:607250]	OMIM		GENETEST
TDRD7	Cataract, autosomal recessive congenital 4 [MIM:613887]	OMIM	HGMD	GENETEST
TEAD1	Sveinsson choreoretinal atrophy [MIM:108985]	OMIM	
TECPR2	Spastic paraplegia 49, autosomal recessive [MIM:615031]	OMIM	
TECR	Mental retardation, autosomal recessive 14 [MIM:614020]	OMIM	
TECTA	Deafness, autosomal dominant 8/12 [MIM:601543]; Deafness, autosomal recessive 21 [MIM:603629]	OMIM	HGMD	GENETEST
TEK	Venous malformations, multiple cutaneous and mucosal [MIM:600195]	OMIM		GENETEST
TERC	Dyskeratosis congenita, autosomal dominant 1 [MIM:127550]	OMIM	HGMD	GENETEST
TERT	Dyskeratosis congenita, autosomal dominant 2 [MIM:613989]	OMIM	HGMD	GENETEST
TF	Atransferrinemia [MIM:209300]	OMIM	HGMD	GENETEST
TFAP2A	Branchiooculofacial syndrome [MIM:113620]	OMIM	HGMD	GENETEST
TFAP2B	Char syndrome [MIM:169100]	OMIM	HGMD	GENETEST
TFE3	Renal cell carcinoma, papillary, 1 [MIM:300854]	OMIM	
TFG	Chondrosarcoma, extraskeletal myxoid [MIM:612237]; Hereditary motor and sensory neuropathy, proximal type [MIM:604484]	OMIM	
TFR2	Hemochromatosis, type 3 [MIM:604250]	OMIM	HGMD	GENETEST
TG	Thyroid dyshormonogenesis 3 [MIM:274700]	OMIM	HGMD	GENETEST
TGFB1	Camurati-Engelmann disease [MIM:131300]	OMIM	HGMD	GENETEST
TGFB2	Loeys-Dietz syndrome, type 4 [MIM:614816]	OMIM	HGMD	GENETEST
TGFB3	Arrhythmogenic right ventricular dysplasia 1 [MIM:107970]	OMIM		GENETEST
TGFBI	Corneal dystrophy, Avellino type [MIM:607541]; Corneal dystrophy, Groenouw type I [MIM:121900]; Corneal dystrophy, Reis-Bucklers type [MIM:608470]; Corneal dystrophy, Thiel-Behnke type [MIM:602082]; Corneal dystrophy, epithelial basement membrane [MIM:121820]; Corneal dystrophy, lattice type I [MIM:122200]; Corneal dystrophy, lattice type IIIA [MIM:608471]	OMIM	HGMD	GENETEST
TGFBR1	Loeys-Dietz syndrome, type 1A [MIM:609192]; Loeys-Dietz syndrome, type 2A [MIM:608967]	OMIM	HGMD	GENETEST
TGFBR2	Colorectal cancer, hereditary nonpolyposis, type 6 [MIM:614331]; Loeys-Dietz syndrome, type 1B [MIM:610168]; Loeys-Dietz syndrome, type 2B [MIM:610380]	OMIM	HGMD	GENETEST
TGIF1	Holoprosencephaly-4 [MIM:142946]	OMIM	HGMD	GENETEST
TGM1	Ichthyosis, congenital, autosomal recessive 1 [MIM:242300]	OMIM	HGMD	GENETEST
TGM5	Peeling skin syndrome, acral type [MIM:609796]	OMIM		GENETEST
TGM6	Spinocerebellar ataxia 35 [MIM:613908]	OMIM		GENETEST
TH	Segawa syndrome, recessive [MIM:605407]	OMIM	HGMD	GENETEST
THAP1	Dystonia 6, torsion [MIM:602629]	OMIM	HGMD	GENETEST
THBD	Thrombophilia due to thrombomodulin defect [MIM:614486]	OMIM	HGMD	GENETEST
THPO	Thrombocythemia 1 [MIM:187950]	OMIM	HGMD	GENETEST
THRA	Hypothyroidism, congenital, nongoitrous, 6 [MIM:614450]	OMIM	
THRB	Thyroid hormone resistance [MIM:188570]; Thyroid hormone resistance, autosomal recessive [MIM:274300]; Thyroid hormone resistance, selective pituitary [MIM:145650]	OMIM	HGMD	GENETEST
TIMM8A	Deafness, X-linked 1, progressive; Jensen syndrome [MIM:311150]; Mohr-Tranebjaerg syndrome [MIM:304700]	OMIM	HGMD	GENETEST
TIMP3	Sorsby fundus dystrophy [MIM:136900]	OMIM	HGMD	GENETEST
TINF2	Dyskeratosis congenita, autosomal dominant 3 [MIM:613990]; Revesz syndrome [MIM:268130]	OMIM	HGMD	GENETEST
TJP2	Deafness, autosomal dominant 51; Hypercholanemia, familial [MIM:607748]	OMIM	
TK2	Mitochondrial DNA depletion syndrome 2 (myopathic type) [MIM:609560]	OMIM	HGMD	GENETEST
TLL1	Atrial septal defect 6 [MIM:613087]	OMIM	
TLR4	Endotoxin hyporesponsiveness	OMIM	
TMC1	Deafness, autosomal dominant 36 [MIM:606705]; Deafness, autosomal recessive 7 [MIM:600974]	OMIM	HGMD	GENETEST
TMC6	Epidermodysplasia verruciformis [MIM:226400]	OMIM	HGMD
TMC8	Epidermodysplasia verruciformis [MIM:226400]	OMIM	HGMD
TMCO1	Craniofacial dysmorphism, skeletal anomalies, and mental retardation syndrome [MIM:614132]	OMIM	HGMD
TMEM126A	Optic atrophy-7 [MIM:612989]	OMIM		GENETEST
TMEM138	Joubert syndrome 16 [MIM:614465]	OMIM		GENETEST
TMEM165	Congenital disorder of glycosylation, type IIk [MIM:614727]	OMIM		GENETEST
TMEM216	Joubert syndrome 2 [MIM:608091]; Meckel syndrome 2 [MIM:603194]	OMIM		GENETEST
TMEM231	Joubert syndrome 20 [MIM:614970]	OMIM	
TMEM237	Joubert syndrome 14 [MIM:614424]	OMIM	HGMD	GENETEST
TMEM43	Arrhythmogenic right ventricular dysplasia 5 [MIM:604400]	OMIM		GENETEST
TMEM5	Muscular dystrophy-dystroglycanopathy (congenital with brain and eye anomalies), type A, 10 [MIM:615041]	OMIM	
TMEM67	COACH syndrome [MIM:216360]; Joubert syndrome 6 [MIM:610688]; Meckel syndrome 3 [MIM:607361]; Nephronophthisis 11 [MIM:613550]	OMIM	HGMD	GENETEST
TMEM70	Mitochondrial complex V (ATP synthase) deficiency, nuclear type 2 [MIM:614052]	OMIM	HGMD	GENETEST
TMIE	Deafness, autosomal recessive 6 [MIM:600971]	OMIM	HGMD	GENETEST
TMLHE	Epsilon-trimethyllysine hydroxylase deficiency [MIM:300872]	OMIM		GENETEST
TMPO	Cardiomyopathy, dilated, 1T [MIM:613740]	OMIM		GENETEST
TMPRSS15	Enterokinase deficiency [MIM:226200]	OMIM	HGMD
TMPRSS3	Deafness, autosomal recessive 8/10 [MIM:601072]	OMIM	HGMD	GENETEST
TMPRSS6	Iron-refractory iron deficiency anemia [MIM:206200]	OMIM	HGMD	GENETEST
TNFRSF10B	Squamous cell carcinoma, head and neck [MIM:275355]	OMIM	HGMD
TNFRSF11A	Osteolysis, familial expansile [MIM:174810]; Osteopetrosis, autosomal recessive 7 [MIM:612301]; Paget disease of bone [MIM:602080]	OMIM	HGMD	GENETEST
TNFRSF11B	Paget disease, juvenile [MIM:239000]	OMIM	HGMD	GENETEST
TNFRSF13B	Immunodeficiency, common variable, 2 [MIM:240500]; Immunoglobulin A deficiency 2 [MIM:609529]	OMIM	HGMD	GENETEST
TNFRSF13C	Immunodeficiency, common variable, 4 [MIM:613494]	OMIM		GENETEST
TNFRSF1A	Periodic fever, familial [MIM:142680]	OMIM	HGMD	GENETEST
TNFSF11	Osteopetrosis, autosomal recessive 2 [MIM:259710]	OMIM	HGMD	GENETEST
TNNC1	Cardiomyopathy, dilated, 1Z [MIM:611879]; Cardiomyopathy, familial hypertrophic, 13 [MIM:613243]	OMIM	HGMD	GENETEST
TNNI2	Arthrogryposis multiplex congenita, distal, type 2B [MIM:601680]	OMIM	HGMD	GENETEST
TNNI3	Cardiomyopathy, dilated, 1FF [MIM:613286]; Cardiomyopathy, dilated, 2A [MIM:611880]; Cardiomyopathy, familial hypertrophic, 7 [MIM:613690]; Cardiomyopathy, familial restrictive [MIM:115210]	OMIM	HGMD	GENETEST
TNNT1	Nemaline myopathy, Amish type [MIM:605355]	OMIM		GENETEST
TNNT2	Cardiomyopathy, dilated, 1D [MIM:601494]; Cardiomyopathy, familial hypertrophic, 2 [MIM:115195]; Cardiomyopathy, familial restrictive, 3 [MIM:612422]	OMIM	HGMD	GENETEST
TNNT3	Arthyrgryposis, distal, type 2B [MIM:601680]	OMIM		GENETEST
TNXB	Ehlers-Danlos syndrome, autosomal dominant, hypermobility type [MIM:130020]; Ehlers-Danlos syndrome, autosomal recessive, due to tenascin X deficiency [MIM:606408]	OMIM	HGMD	GENETEST
TOP1	DNA topoisomerase I, camptothecin-resistant	OMIM	
TOP2A	DNA topoisomerase II, resistance to inhibition of, by amsacrine	OMIM	
TOPORS	Retinitis pigmentosa 31 [MIM:609923]	OMIM	HGMD	GENETEST
TOR1A	Dystonia, early-onset atypical, with myoclonic features; Dystonia-1, torsion [MIM:128100]	OMIM	HGMD	GENETEST
TP53	Adrenal cortical carcinoma [MIM:202300]; Breast cancer [MIM:114480]; Choroid plexus papilloma [MIM:260500]; Colorectal cancer [MIM:114500]; Hepatocellular carcinoma [MIM:114550]; Li-Fraumeni syndrome [MIM:151623]; Nasopharyngeal carcinoma [MIM:607107]; Osteosarcoma [MIM:259500]; Pancreatic cancer [MIM:260350]	OMIM	HGMD	GENETEST
TP63	ADULT syndrome [MIM:103285]; Ectrodactyly, ectodermal dysplasia, and cleft lip/palate syndrome 3 [MIM:604292]; Hay-Wells syndrome [MIM:106260]; Limb-mammary syndrome [MIM:603543]; Orofacial cleft 8 [MIM:129400]; Split-hand/foot malformation 4 [MIM:605289]	OMIM	HGMD	GENETEST
TPI1	Hemolytic anemia due to triosephosphate isomerase deficiency	OMIM	HGMD	GENETEST
TPK1	Thiamine metabolism dysfunction syndrome 5 (episodic encephalopathy type) [MIM:614458]	OMIM	HGMD
TPM1	Cardiomyopathy, dilated, 1Y [MIM:611878]; Cardiomyopathy, familial hypertrophic, 3 [MIM:115196]	OMIM	HGMD	GENETEST
TPM2	Arthrogryposis multiplex congenita, distal, type 1 [MIM:108120]; Arthrogryposis, distal, type 2B [MIM:601680]; Nemaline myopathy [MIM:609285]	OMIM	HGMD	GENETEST
TPM3	CAP myopathy [MIM:609284]; Myopathy, congenital, with fiber-type disproportion [MIM:255310]	OMIM	HGMD	GENETEST
TPMT	6-mercaptopurine sensitivity [MIM:610460]	OMIM	HGMD	GENETEST
TPO	Thyroid dyshormonogenesis 2A [MIM:274500]	OMIM	HGMD	GENETEST
TPP1	Ceroid lipofuscinosis, neuronal, 2 [MIM:204500]	OMIM	HGMD	GENETEST
TPRN	Deafness, autosomal recessive 79 [MIM:613307]	OMIM	HGMD	GENETEST
TRA@	Leukemia/lymphoma, T-cell	OMIM	
TRAPPC2	Spondyloepiphyseal dysplasia tarda [MIM:313400]	OMIM	HGMD	GENETEST
TRAPPC9	Mental retardation, autosomal recessive 13 [MIM:613192]	OMIM	HGMD	GENETEST
TREH	Trehalase deficiency [MIM:612119]	OMIM	
TREM2	Nasu-Hakola disease [MIM:221770]	OMIM	HGMD	GENETEST
TREX1	Aicardi-Goutieres syndrome 1, dominant and recessive [MIM:225750]; Chilblain lupus [MIM:610448]; Vasculopathy, retinal, with cerebral leukodystrophy [MIM:192315]	OMIM	HGMD	GENETEST
TRH	Thyrotropin-releasing hormone deficiency [MIM:275120]	OMIM	
TRHR	Thyrotropin-releasing hormone resistance, generalized	OMIM	HGMD
TRIM24	Thyroid carcinoma, papillary [MIM:188550]	OMIM	
TRIM32	Bardet-Biedl syndrome 11 [MIM:209900]; Muscular dystrophy, limb-girdle, type 2H [MIM:254110]	OMIM	HGMD	GENETEST
TRIM33	Thyroid carcinoma, papillary [MIM:188550]	OMIM	
TRIM37	Mulibrey nanism [MIM:253250]	OMIM	HGMD	GENETEST
TRIOBP	Deafness, autosomal recessive 28 [MIM:609823]	OMIM	HGMD	GENETEST
TRIP11	Achondrogenesis, type IA [MIM:200600]	OMIM		GENETEST
TRMU	Liver failure, transient infantile [MIM:613070]	OMIM	HGMD	GENETEST
TRPA1	Episodic pain syndrome, familial [MIM:615040]	OMIM	
TRPC6	Glomerulosclerosis, focal segmental, 2 [MIM:603965]	OMIM	HGMD	GENETEST
TRPM1	Night blindness, congenital stationary (complete), 1C, autosomal recessive [MIM:613216]	OMIM	HGMD	GENETEST
TRPM4	Progressive familial heart block, type IB [MIM:604559]	OMIM		GENETEST
TRPM6	Hypomagnesemia 1, intestinal [MIM:602014]	OMIM	HGMD	GENETEST
TRPS1	Trichorhinophalangeal syndrome, type I [MIM:190350]; Trichorhinophalangeal syndrome, type III [MIM:190351]	OMIM	HGMD	GENETEST
TRPV3	Olmsted syndrome [MIM:614594]	OMIM		GENETEST
TRPV4	Brachyolmia type 3 [MIM:113500]; Digital arthropathy-brachydactyly, familial [MIM:606835]; Hereditary motor and sensory neuropathy, type IIc [MIM:606071]; Metatropic dysplasia [MIM:156530]; Parastremmatic dwarfism [MIM:168400]; SED, Maroteaux type [MIM:184095]; Scapuloperoneal spinal muscular atrophy [MIM:181405]; Spinal muscular atrophy, distal, congenital nonprogressive [MIM:600175]; Spondylometaphyseal dysplasia, Kozlowski type [MIM:184252]	OMIM	HGMD	GENETEST
TSC1	Focal cortical dysplasia, Taylor balloon cell type [MIM:607341]; Lymphangioleiomyomatosis [MIM:606690]; Tuberous sclerosis-1 [MIM:191100]	OMIM	HGMD	GENETEST
TSC2	Tuberous sclerosis-2 [MIM:613254]	OMIM	HGMD	GENETEST
TSEN2	Pontocerebellar hypoplasia type 2B [MIM:612389]	OMIM	HGMD	GENETEST
TSEN34	Pontocerebellar hypoplasia type 2C [MIM:612390]	OMIM		GENETEST
TSEN54	Pontocerebellar hypoplasia type 2A [MIM:277470]; Pontocerebellar hypoplasia type 4 [MIM:225753]	OMIM	HGMD	GENETEST
TSFM	Combined oxidative phosphorylation deficiency 3 [MIM:610505]	OMIM		GENETEST
TSHB	Hypothryoidism, congenital, nongoitrous 4 [MIM:275100]	OMIM	HGMD	GENETEST
TSHR	Hyperthyroidism, familial gestational [MIM:603373]; Hyperthyroidism, nonautoimmune [MIM:609152]; Hypothyroidism, congenital, nongoitrous, 1 275200; Thyroid carcinoma with thyrotoxicosis	OMIM	HGMD	GENETEST
TSHZ1	Aural atresia, congenital [MIM:607842]	OMIM	HGMD	GENETEST
TSPAN12	Exudative vitreoretinopathy 5 [MIM:613310]	OMIM	HGMD	GENETEST
TSPAN7	Mental retardation, X-linked 58 [MIM:300210]	OMIM	HGMD	GENETEST
TSPEAR	Deafness, autosomal recessive 98 [MIM:614861]	OMIM	
TSPYL1	Sudden infant death with dysgenesis of the testes syndrome [MIM:608800]	OMIM	HGMD
TTBK2	Spinocerebellar ataxia 11 [MIM:604432]	OMIM	HGMD	GENETEST
TTC19	Mitochondrial complex III deficiency [MIM:124000]	OMIM		GENETEST
TTC21B	Asphyxiating thoracic dystrophy 4 [MIM:613819]; Nephronophthisis 12 [MIM:613820]	OMIM	HGMD	GENETEST
TTC37	Trichohepatoenteric syndrome 1 [MIM:222470]	OMIM	HGMD
TTC8	Bardet-Biedl syndrome 8 [MIM:209900]; Retinitis pigmentosa 51 [MIM:613464]	OMIM	HGMD	GENETEST
TTN	Cardiomyopathy, dilated, 1G [MIM:604145]; Cardiomyopathy, familial hypertrophic, 9 [MIM:613765]; Muscular dystrophy, limb-girdle, type 2J [MIM:608807]; Myopathy, early-onset, with fatal cardiomyopathy [MIM:611705]; Myopathy, proximal, with early respiratory muscle involvement [MIM:603689]; Tibial muscular dystrophy, tardive [MIM:600334]	OMIM	HGMD	GENETEST
TTPA	Ataxia with isolated vitamin E deficiency [MIM:277460]	OMIM	HGMD	GENETEST
TTR	Amyloidosis, hereditary, transthyretin-related [MIM:105210]; Carpal tunnel syndrome, familial [MIM:115430]	OMIM	HGMD	GENETEST
TUBA1A	Lissencephaly 3 [MIM:611603]	OMIM		GENETEST
TUBA8	Polymicrogyria with optic nerve hypoplasia [MIM:613180]	OMIM	HGMD	GENETEST
TUBB1	Macrothrombocytopenia, autosomal dominant, TUBB1-related [MIM:613112]	OMIM	HGMD
TUBB2B	Polymicrogyria, symmetric or asymmetric [MIM:610031]	OMIM		GENETEST
TUBB3	Cortical dysplasia, complex, with other brain malformations [MIM:614039]; Fibrosis of extraocular muscles, congenital, 3A [MIM:600638]	OMIM		GENETEST
TUBGCP6	Microcephaly and chorioretinopathy with or without mental retardation [MIM:251270]	OMIM	
TUFM	Combined oxidative phosphorylation deficiency 4 [MIM:610678]	OMIM		GENETEST
TULP1	Leber congenital amaurosis 15 [MIM:613843]; Retinitis pigmentosa 14 [MIM:600132]	OMIM	HGMD	GENETEST
TUSC3	Mental retardation, autosomal recessive 7 [MIM:611093]	OMIM	HGMD	GENETEST
TWIST1	Craniosynostosis, type 1 [MIM:123100]; Robinow-Sorauf syndrome [MIM:180750]; Saethre-Chotzen syndrome [MIM:101400]	OMIM	HGMD	GENETEST
TWIST2	Focal facial dermal dysplasia 3, Setleis type [MIM:227260]	OMIM	HGMD
TYK2	Tyrosine kinase 2 deficiency [MIM:611521]	OMIM	HGMD	GENETEST
TYMP	Mitochondrial DNA depletion syndrome 1 (MNGIE type) [MIM:603041]	OMIM	HGMD	GENETEST
TYR	Albinism, oculocutaneous, type IA [MIM:203100]; Albinism, oculocutaneous, type IB [MIM:606952]; Waardenburg syndrome/albinism, digenic [MIM:103470]	OMIM	HGMD	GENETEST
TYROBP	Nasu-Hakola disease [MIM:221770]	OMIM	HGMD	GENETEST
TYRP1	Albinism, oculocutaneous, type III [MIM:203290]; Skin/hair/eye pigmentation, variation in, 11 (Melanesian blond hair) [MIM:612271]	OMIM	HGMD	GENETEST
UBA1	Spinal muscular atrophy, X-linked 2, infantile [MIM:301830]	OMIM		GENETEST
UBB	Cleft palate, isolated [MIM:119540]	OMIM	
UBE2A	Mental retardation, X-linked syndromic, Nascimento-type [MIM:300860]	OMIM		GENETEST
UBE3A	Angelman syndrome [MIM:105830]	OMIM	HGMD	GENETEST
UBIAD1	Corneal dystrophy, crystalline, of Schnyder [MIM:121800]	OMIM		GENETEST
UBQLN2	Amyotrophic lateral sclerosis 15, with or without frontotemporal dementia [MIM:300857]	OMIM		GENETEST
UBR1	Johanson-Blizzard syndrome [MIM:243800]	OMIM	HGMD
UGT1A1	Crigler-Najjar syndrome, type I [MIM:218800]; Crigler-Najjar syndrome, type II [MIM:606785]; Hyperbilirubinemia, familial transcient neonatal [MIM:237900]	OMIM	HGMD	GENETEST
UMOD	Glomerulocystic kidney disease with hyperuricemia and isosthenuria [MIM:609886]; Hyperuricemic nephropathy, familial juvenile 1 [MIM:162000]; Medullary cystic kidney disease 2 [MIM:603860]	OMIM	HGMD	GENETEST
UMPS	Orotic aciduria [MIM:258900]	OMIM		GENETEST
UNC119	Cone-rod dystrophy	OMIM		GENETEST
UNC13D	Hemophagocytic lymphohistiocytosis, familial, 3 [MIM:608898]	OMIM	HGMD	GENETEST
UNG	Immunodeficiency with hyper IgM, type 5 [MIM:608106]	OMIM	HGMD	GENETEST
UPB1	Beta-ureidopropionase deficiency [MIM:613161]	OMIM		GENETEST
UPF3B	Mental retardation, X-linked, syndromic 14 [MIM:300676]	OMIM	HGMD	GENETEST
UPK3A	Renal adysplasia [MIM:191830]	OMIM		GENETEST
UQCRB	Mitochondrial complex III deficiency [MIM:124000]	OMIM	HGMD	GENETEST
UQCRQ	Mitochondrial complex III deficiency [MIM:124000]	OMIM		GENETEST
UROC1	Urocanase deficiency [MIM:276880]	OMIM	
UROD	Porphyria cutanea tarda [MIM:176100]	OMIM	HGMD	GENETEST
UROS	Porphyria, congenital erythropoietic [MIM:263700]	OMIM	HGMD	GENETEST
USB1	Poikiloderma with neutropenia [MIM:604173]	OMIM		GENETEST
USH1C	Deafness, autosomal recessive 18A [MIM:602092]; Usher syndrome, type 1C [MIM:276904]	OMIM	HGMD	GENETEST
USH1G	Usher syndrome, type 1G [MIM:606943]	OMIM	HGMD	GENETEST
USH2A	Retinitis pigmentosa 39 [MIM:613809]; Usher syndrome, type 2A [MIM:276901]	OMIM	HGMD	GENETEST
USP9Y	Spermatogenic failure, Y-linked, 2 [MIM:415000]	OMIM	HGMD	GENETEST
UVSSA	UV-sensitive syndrome 3 [MIM:614640]	OMIM		GENETEST
VANGL1	Caudal regression syndrome [MIM:600145]; Neural tube defects [MIM:182940]	OMIM		GENETEST
VAPB	Amyotrophic lateral sclerosis 8 [MIM:608627]; Spinal muscular atrophy, late-onset, Finkel type [MIM:182980]	OMIM	HGMD	GENETEST
VAX1	Microphthalmia, syndromic 11 [MIM:614402]	OMIM	HGMD	GENETEST
VCAN	Wagner syndrome 1 [MIM:143200]	OMIM		GENETEST
VCL	Cardiomyopathy, dilated, 1W [MIM:611407]; Cardiomyopathy, familial hypertrophic, 15 [MIM:613255]	OMIM		GENETEST
VCP	Amyotrophic lateral sclerosis 14, with or without frontotemporal dementia [MIM:613954]; Inclusion body myopathy with early-onset Paget disease and frontotemporal dementia [MIM:167320]	OMIM		GENETEST
VDR	Rickets, vitamin D-resistant, type IIA [MIM:277440]	OMIM	HGMD	GENETEST
VHL	Erythrocytosis, familial, 2 [MIM:263400]; Pheochromocytoma [MIM:171300]; von Hippel-Lindau syndrome [MIM:193300]	OMIM	HGMD	GENETEST
VIL1	Cholestasis, progressive canalicular	OMIM	
VIM	Cataract, pulverulent, autosomal dominant	OMIM	
VIPAS39	Arthrogryposis, renal dysfunction, and cholestasis 2 [MIM:613404]	OMIM		GENETEST
VKORC1	Vitamin K-dependent clotting factors, combined deficiency of, 2 [MIM:607473]; Warfarin resistance [MIM:122700]	OMIM		GENETEST
VLDLR	Cerebellar hypoplasia and mental retardation with or without quadrupedal locomotion 1 [MIM:224050]	OMIM	HGMD	GENETEST
VMA21	Myopathy, X-linked, with excessive autophagy	OMIM	
VPS13A	Choreoacanthocytosis [MIM:200150]	OMIM	HGMD	GENETEST
VPS13B	Cohen syndrome [MIM:216550]	OMIM	HGMD	GENETEST
VPS33B	Arthrogryposis, renal dysfunction, and cholestasis 1 [MIM:208085]	OMIM	HGMD	GENETEST
VPS35	Parkinson disease 17 [MIM:614203]	OMIM		GENETEST
VPS37A	Spastic paraplegia 53, autosomal recessive [MIM:614898]	OMIM	
VRK1	Pontocerebellar hypoplasia type 1A [MIM:607596]	OMIM		GENETEST
VSX1	Corneal dystrophy, hereditary polymorphous posterior [MIM:122000]; Craniofacial anomalies and anterior segment dysgenesis syndrome [MIM:614195]; Keratoconus 1 [MIM:148300]	OMIM	HGMD	GENETEST
VSX2	Microphthalmia with coloboma 3 [MIM:610092]; Microphthalmia, isolated 2 [MIM:610093]	OMIM	HGMD	GENETEST
VWF	von Willebrand disease, type 1 [MIM:193400]; von Willebrand disease, types 2A, 2B, 2M, and 2N [MIM:613554]; von Willibrand disease, type 3 [MIM:277480]	OMIM	HGMD	GENETEST
WAS	Neutropenia, severe congenital, X-linked [MIM:300299]; Thrombocytopenia, X-linked [MIM:313900]; Wiskott-Aldrich syndrome [MIM:301000]	OMIM	HGMD	GENETEST
WDPCP	Bardet-Biedl syndrome 15 [MIM:209900]	OMIM		GENETEST
WDR11	Hypogonadtropic hypogonadism 14 with or without anosmia [MIM:614858]	OMIM	
WDR19	Asphyxiating thoracic dystrophy 5 [MIM:614376]; Cranioectodermal dysplasia 4 [MIM:614378]; Nephronophthisis 13 [MIM:614377]	OMIM	HGMD	GENETEST
WDR35	Cranioectodermal dysplasia 2 [MIM:613610]; Short rib-polydactyly syndrome, type V [MIM:614091]	OMIM	HGMD	GENETEST
WDR36	Glaucoma 1, open angle, G [MIM:609887]	OMIM	HGMD	GENETEST
WDR62	Microcephaly 2, primary, autosomal recessive, with or without cortical malformations [MIM:604317]	OMIM	HGMD	GENETEST
WDR72	Amelogenesis imperfecta, hypomaturation type, IIA3 [MIM:613211]	OMIM	HGMD	GENETEST
WDR81	Cerebellar ataxia, mental retardation, and dysequilibrium syndrome 2 [MIM:610185]	OMIM	
WFS1	Deafness, autosomal dominant 6/14/38 [MIM:600965]; Wolfram syndrome [MIM:222300]; Wolfram-like syndrome, autosomal dominant [MIM:614296]	OMIM	HGMD	GENETEST
WHSC1L1	Leukemia, acute myeloid [MIM:601626]	OMIM	
WIPF1	Wiskott-Aldrich syndrome 2 [MIM:614493]	OMIM	
WISP3	Arthropathy, progressive pseudorheumatoid, of childhood [MIM:208230]	OMIM	HGMD	GENETEST
WNK1	Neuropathy, hereditary sensory and autonomic, type II [MIM:201300]; Pseudohypoaldosteronism, type IIC [MIM:614492]	OMIM	HGMD	GENETEST
WNK4	Pseudohypoaldosteronism, type IIB [MIM:614491]	OMIM		GENETEST
WNT10A	Odontoonychodermal dysplasia [MIM:257980]; Schopf-Schulz-Passarge syndrome [MIM:224750]; Tooth agenesis, selective, 4 [MIM:150400]	OMIM	HGMD	GENETEST
WNT10B	Split-hand/foot malformation 6 [MIM:225300]	OMIM	HGMD
WNT3	Tetra-amelia, autosomal recessive [MIM:273395]	OMIM		GENETEST
WNT4	Mullerian aplasia and hyperandrogenism [MIM:158330]; SERKAL syndrome [MIM:611812]	OMIM		GENETEST
WNT5A	Robinow syndrome, autosomal dominant [MIM:180700]	OMIM	HGMD	GENETEST
WNT7A	Fuhrmann syndrome [MIM:228930]; Ulna and fibula, absence of, with sever limb deficiency [MIM:276820]	OMIM		GENETEST
WRAP53	Dyskeratosis congenita, autosomal recessive 3 [MIM:613988]	OMIM		GENETEST
WRN	Werner syndrome [MIM:277700]	OMIM	HGMD	GENETEST
WT1	Denys-Drash syndrome [MIM:194080]; Frasier syndrome [MIM:136680]; Meacham syndrome [MIM:608978]; Nephrotic syndrome, type 4 [MIM:256370]; Wilms tumor, type 1 [MIM:194070]	OMIM	HGMD	GENETEST
WWOX	Esophageal squamous cell carcinoma [MIM:133239]	OMIM	
XDH	Xanthinuria, type I [MIM:278300]	OMIM	HGMD	GENETEST
XIAP	Lymphoproliferative syndrome, X-linked, 2 [MIM:300635]	OMIM	HGMD	GENETEST
XIST	X-inactivation, familial skewed [MIM:300087]	OMIM	
XK	McLeod syndrome with or without chronic granulomatous disease [MIM:300842]	OMIM	HGMD	GENETEST
XPA	Xeroderma pigmentosum, group A [MIM:278700]	OMIM	HGMD	GENETEST
XPC	Xeroderma pigmentosum, group C [MIM:278720]	OMIM	HGMD	GENETEST
XPNPEP3	Nephronophthisis-like nephropathy 1 [MIM:613159]	OMIM	HGMD	GENETEST
YARS	Charcot-Marie-Tooth disease, dominant intermediate C [MIM:608323]	OMIM	HGMD	GENETEST
YARS2	Myopathy, lactic acidosis, and sideroblastic anemia 2 [MIM:613561]	OMIM		GENETEST
ZAP70	Selective T-cell defect [MIM:269840]	OMIM	HGMD	GENETEST
ZBTB16	Leukemia, acute promyelocytic, PL2F/RARA type; Skeletal defects, genital hypoplasia, and mental retardation [MIM:612447]	OMIM	
ZBTB24	Immunodeficiency-centromeric instability-facial anomalies syndrome-2 [MIM:614069]	OMIM	HGMD
ZDHHC15	Mental retardation, X-linked 91 [MIM:300577]	OMIM		GENETEST
ZDHHC9	Mental retardation, X-linked syndromic, Raymond type [MIM:300799]	OMIM	HGMD	GENETEST
ZEB1	Corneal dystrophy, Fuchs endothelial, 6 [MIM:613270]; Corneal dystrophy, posterior polymorphous, 3 [MIM:609141]	OMIM	HGMD
ZEB2	Mowat-Wilson syndrome [MIM:235730]	OMIM	HGMD	GENETEST
ZFP57	Diabetes mellitus, transient neonatal, 1 [MIM:601410]	OMIM	HGMD	GENETEST
ZFPM2	Diaphragmatic hernia 3 [MIM:610187]; Tetralogy of Fallot [MIM:187500]	OMIM	
ZFYVE26	Spastic paraplegia 15, autosomal recessive [MIM:270700]	OMIM	HGMD	GENETEST
ZFYVE27	Spastic paraplegia 33, autosomal dominant [MIM:610244]	OMIM		GENETEST
ZIC2	Holoprosencephaly-5 [MIM:609637]	OMIM	HGMD	GENETEST
ZIC3	Congenital heart defects, nonsyndromic, 1, X-linked [MIM:306955]; Heterotaxy, visceral, 1, X-linked 306955; VACTERL association, X-linked [MIM:314390]	OMIM	HGMD	GENETEST
ZMPSTE24	Mandibuloacral dysplasia with type B lipodystrophy [MIM:608612]; Restrictive dermopathy, lethal [MIM:275210]	OMIM	HGMD	GENETEST
ZNF41	Mental retardation, X-linked 89 [MIM:300848]	OMIM		GENETEST
ZNF423	Joubert syndrome 19 [MIM:614844]	OMIM	
ZNF469	Brittle cornea syndrome [MIM:229200]	OMIM	HGMD	GENETEST
ZNF513	Retinitis pigmentosa 58 [MIM:613617]	OMIM		GENETEST
ZNF592	Spinocerebellar ataxia, autosomal recessive 5 [MIM:606937]	OMIM	
ZNF644	Myopia 21, autosomal dominant [MIM:614167]	OMIM	
ZNF674	Mental retardation, X-linked 92 [MIM:300851]	OMIM		GENETEST
ZNF711	Mental retardation, X-linked 97 [MIM:300803]	OMIM	HGMD	GENETEST
ZNF750	Seborrhea-like dermatitis with psoriasiform elements [MIM:610227]	OMIM	HGMD
ZNF81	Mental retardation, X-linked 45 [MIM:300498]	OMIM		GENETEST
CLMP			HGMD
SLC18A1			HGMD
CD44			HGMD
A4GNT			HGMD
ZHX3			HGMD
EDN1			HGMD
DECR1				GENETEST
ZNF799			HGMD
HYMAI				GENETEST
NAGPA			HGMD
IRAK1			HGMD
ANGPTL5			HGMD
SLC6A11			HGMD
MYO9B			HGMD
MMP7			HGMD
NOS2			HGMD
DDX5			HGMD
SOD2			HGMD
CCDC28B			HGMD
HLA-DRB4			HGMD
KCNK6			HGMD
ADAM7			HGMD
BANK1			HGMD
MAX			HGMD	GENETEST
NR4A2			HGMD	GENETEST
KIAA1199			HGMD
DMC1			HGMD
SLC22A2			HGMD
CCL22			HGMD
OR10X1			HGMD
PTPN22			HGMD
CYP2F1			HGMD
BRCA1			HGMD	GENETEST
KIAA1033			HGMD
CYP2D6			HGMD
SLC26A10			HGMD
RUNX3			HGMD
PRKCB			HGMD
ACSM3			HGMD
SLCO2B1			HGMD
LMNB2			HGMD
C11orf93			HGMD
ROCK2			HGMD
FEV			HGMD
GRK5			HGMD
PDCD5			HGMD
SLC8A1			HGMD
IGKV@			HGMD
ISL1			HGMD
NUDT1			HGMD
PRDM2			HGMD
CD1A			HGMD
OR2J1			HGMD
SELL			HGMD
WDR45				GENETEST
NEIL1			HGMD
GFPT2			HGMD
PYY			HGMD
GPR55			HGMD
RAD23B			HGMD
HIST3H3			HGMD
CD38			HGMD
NEFH			HGMD
GSTA2			HGMD
SMUG1			HGMD
GYPC			HGMD
C6orf15			HGMD
F2RL1			HGMD
PIWIL3			HGMD
NTHL1			HGMD
ADH5			HGMD
SHBG			HGMD
CYP2G2P			HGMD
GCLM			HGMD
SLC24A5			HGMD
HBZ				GENETEST
HCRTR2			HGMD
DRD3			HGMD	GENETEST
SNX19			HGMD
CHFR			HGMD
ak2b			HGMD
PIK3CB			HGMD
PXDN			HGMD
A4GALT			HGMD
CARD8			HGMD
ELAC2			HGMD	GENETEST
MTMR14			HGMD
NPR1			HGMD
SLC9A9			HGMD
GSTM4			HGMD
IRS1			HGMD
mocs2b			HGMD
CYP1A1			HGMD
GBGT1			HGMD
HTR3A			HGMD
COX7A2			HGMD
NCAM1			HGMD
ACADL			HGMD	GENETEST
catsper2t2			HGMD
SLC22A14			HGMD
CGA			HGMD
FGF1			HGMD
CHRM1			HGMD
IL6R			HGMD
SEZ6			HGMD
NQO2			HGMD
C6orf105			HGMD
GSTP1			HGMD
CCR3			HGMD
ADRA1A			HGMD
PTPN2			HGMD
GIPR			HGMD
BST1			HGMD
MIR206			HGMD
FAM175A			HGMD
mgc16169			HGMD
AHR			HGMD
C17orf53			HGMD
MAD2L1			HGMD
NFE2L2			HGMD
IL23R			HGMD
CYP4A22			HGMD
HP			HGMD	GENETEST
PRND			HGMD
CLCA1			HGMD
HS1BP3			HGMD
mecp2e1			HGMD
ascc3tv2			HGMD
UIMC1			HGMD
KCNJ6			HGMD
PPARGC1A			HGMD
CASP5			HGMD
AHRR			HGMD
NDUFA13			HGMD
HRH2			HGMD
CYP3A5			HGMD
OAS1			HGMD
LIN28B			HGMD
ERMAP			HGMD
APBA2			HGMD
GRIP1			HGMD	GENETEST
MUC2			HGMD
ATP2B2			HGMD
CMA1			HGMD
HCRTR1			HGMD
PAWR			HGMD
TLK1			HGMD
slc9a6tv1			HGMD
GPATCH8			HGMD
SIX2			HGMD
SNCAIP			HGMD	GENETEST
CSMD3			HGMD
HLA-DOA			HGMD
RCAN1				GENETEST
IL8			HGMD
OVCH2			HGMD
IRF7			HGMD
PECR			HGMD
SH2B1			HGMD
CD177			HGMD
BICD1			HGMD
CASP1			HGMD
PLA2G4C			HGMD
JRK			HGMD
KALRN			HGMD
IFNAR1			HGMD
OR8K3			HGMD
MIRLET7E			HGMD
OLR1			HGMD
AGER			HGMD
GPR33			HGMD
MICA			HGMD
ELF4			HGMD
IL20RA			HGMD
H2BFWT			HGMD
CLPS			HGMD
BTBD9			HGMD
GCGR			HGMD
IL18			HGMD
NPY			HGMD
ADD1			HGMD
KDM6B			HGMD
CLEC4M			HGMD
ACLY			HGMD
GYPA			HGMD
CYP4F12			HGMD
FKBP5			HGMD
PARD6A			HGMD
GPX4			HGMD
TYMS			HGMD
MCM5			HGMD
CPA4			HGMD
MAP2K4			HGMD
CDKN2B			HGMD
scn1bb			HGMD
VEGFA			HGMD
LAMA1			HGMD
APOL1			HGMD	GENETEST
ITGA2			HGMD	GENETEST
EEF2K			HGMD
MAST4			HGMD
MFI2			HGMD
SOCS3			HGMD
CCNA2			HGMD
OR1B1			HGMD
MT-ND6				GENETEST
SLC14A2			HGMD
SLC11A1			HGMD
EIF3H			HGMD
GSK3B			HGMD
KIR2DL1			HGMD
PLA2G10			HGMD
APOM			HGMD
AMPD3			HGMD	GENETEST
HLA-DQA1			HGMD	GENETEST
IL18RAP			HGMD
OR2T5			HGMD
msrb3i2			HGMD
dyrk1atv3			HGMD
CD109			HGMD
SFTPA1			HGMD
SLC22A3			HGMD
P2RY4			HGMD
GADD45B			HGMD
TAAR6				GENETEST
GRIN3A			HGMD
FPR1			HGMD
SERPINB11			HGMD
PPARD			HGMD
plec1f			HGMD
LGALS2			HGMD
ABCD3			HGMD
NEU2			HGMD
CCL11			HGMD
IDO1			HGMD
ptch1am			HGMD
FCGR2A			HGMD
GRM3			HGMD
GPIHBP1			HGMD
ALOX12			HGMD
RB1CC1			HGMD
NEIL2			HGMD
EIF4E			HGMD
GSC			HGMD
MMP3			HGMD
CRHR1			HGMD
TRAF6			HGMD
AXL			HGMD
PNPLA3			HGMD	GENETEST
CSNK1E			HGMD
col18a1l			HGMD
CXCR1			HGMD
PTGER2			HGMD
HMHA1			HGMD
MMP8			HGMD
SLC31A1			HGMD
ESAM			HGMD
PKN3			HGMD
COMMD1			HGMD
BLMH			HGMD
ADCYAP1			HGMD
MFGE8			HGMD
KIAA0513			HGMD
IL10			HGMD
CNPY3			HGMD
IRX4			HGMD
NFKBIL1			HGMD
PAK7			HGMD
APBB3			HGMD
SLC30A8			HGMD
IAPP			HGMD
ALOX5AP			HGMD
KLK7			HGMD
LRP1			HGMD
NKX2-3			HGMD
RIPK3			HGMD
RAET1L			HGMD
SCG2			HGMD
MMP14			HGMD
MDM2			HGMD
CALHM1			HGMD
EGFR			HGMD	GENETEST
MAP3K15			HGMD
FMO6P			HGMD
SNORD50A			HGMD
gcktv3			HGMD
SIRT5			HGMD
CYSLTR1			HGMD
PAPD7			HGMD
ZFP36L1			HGMD
NKX3-1			HGMD
GALP			HGMD
CREB1			HGMD
ERBB2			HGMD
LGALS3			HGMD
UGT1A7			HGMD
FUT3			HGMD
KCNA3			HGMD
DBI			HGMD
PIF1			HGMD
serca2b			HGMD
CGB			HGMD
LRP8			HGMD	GENETEST
TPSB2			HGMD
wnk1tv3			HGMD
LOC643714			HGMD
HS6ST1			HGMD
OAS2			HGMD
KLF5			HGMD
NUDC			HGMD
HBE1			HGMD
BCAT2				GENETEST
NRG3			HGMD
MOCOS			HGMD
MT-TQ				GENETEST
CALCR			HGMD
CHRFAM7A			HGMD
gfpt1msv			HGMD
MT-TY				GENETEST
DIO2			HGMD
CABIN1			HGMD
NCOA1			HGMD
CDK7			HGMD
CRELD1			HGMD	GENETEST
GAS2L2			HGMD
ADH4			HGMD
GRPR			HGMD
C16orf57			HGMD
DCAF13			HGMD
NXNL1			HGMD
PTPN6			HGMD
ARMS2			HGMD	GENETEST
GRIK3			HGMD
HBM			HGMD
EN2			HGMD
HEY1			HGMD
KNG1			HGMD
GPAM			HGMD
dnmt3bdel			HGMD
IRF2			HGMD
PGR			HGMD
MT-CO1				GENETEST
GRK4			HGMD
PRPH			HGMD
ODC1			HGMD
SDC3			HGMD
MC3R			HGMD
MSMO1			HGMD
cacnb2i5			HGMD
PTGES2			HGMD
GAS1			HGMD
CXCL10			HGMD
MIR140			HGMD
SHANK2			HGMD	GENETEST
SLC41A1			HGMD
LRCH1			HGMD
RBMXL2			HGMD
CDKN1A			HGMD
SOHLH1			HGMD
CLEC2D			HGMD
MAGEE2			HGMD
DIO1			HGMD
SLC6A12			HGMD
EXO1			HGMD
HRC			HGMD
PIK3R1			HGMD
PTPRJ			HGMD
ADRB3			HGMD
MS4A12			HGMD
FPR2			HGMD
FOXH1			HGMD	GENETEST
FZD3			HGMD
DLG5			HGMD
PER1			HGMD
SAGE1			HGMD
BMI1			HGMD
MYCL1			HGMD
MIA3			HGMD
CPE			HGMD
POLD1			HGMD
MIR196A2			HGMD
MT-TR				GENETEST
APOA4			HGMD
PMS1			HGMD	GENETEST
IL9			HGMD
RAB28			HGMD
RPN2			HGMD
IGFBP3			HGMD
MIR2861			HGMD
GAK			HGMD
PSMA6			HGMD
ARHGAP24			HGMD
C4BPA			HGMD
PRB4			HGMD
NINJ1			HGMD
FOXF2			HGMD
HLA-C			HGMD
IFNAR2			HGMD
SCN10A			HGMD
C11orf65			HGMD
P2RY11			HGMD
CX3CR1			HGMD
ITGAE			HGMD
FUT2			HGMD
PTCHD1			HGMD	GENETEST
NARS2			HGMD
LIN28A			HGMD
SERPINB3			HGMD
BPI			HGMD
BNC2			HGMD
FABP2			HGMD
MT2A			HGMD
BMP2K			HGMD
MAP2K3			HGMD
OMG			HGMD
OR52N4			HGMD
SCAP			HGMD
FKBP6			HGMD
EPO			HGMD
AANAT			HGMD
LY96			HGMD
IL1R1			HGMD
KLK3			HGMD
nos1e1c			HGMD
DDX20			HGMD
KIR2DL5A			HGMD
PROCR			HGMD
PASK			HGMD
PHF11			HGMD
GGT5			HGMD
KCNE4			HGMD
APOC1			HGMD
KCNS3			HGMD
MBD1			HGMD
CYP4B1			HGMD
COL12A1			HGMD
NRXN2			HGMD
ABCA13			HGMD
MAPK8IP1			HGMD
GNB3			HGMD
MYB			HGMD
ERBB4			HGMD
DNASE1			HGMD	GENETEST
PTPRCAP			HGMD
IL12RB1			HGMD	GENETEST
DMRT1			HGMD
ACTN3			HGMD
RYK			HGMD
HSPB6			HGMD
IRS4			HGMD
NMB			HGMD
GSTA1			HGMD
MIR146A			HGMD
CSNK2A1P			HGMD
ARVCF			HGMD
ank1tv10			HGMD
NID1			HGMD
ID3			HGMD
CSNK1A1L			HGMD
HCP5			HGMD
NDST1			HGMD
MBL2			HGMD	GENETEST
KCNJ18			HGMD
PLIN4			HGMD
GTF2E1			HGMD
KIAA2022				GENETEST
MYOM1			HGMD
FCGR2B			HGMD
NFATC4			HGMD
NOS1			HGMD
RAB7L1			HGMD
PRL			HGMD
YBX2			HGMD
ABCG1			HGMD
ARL11			HGMD
CREB3L3			HGMD
SPAG16			HGMD
opa1tv8			HGMD
MT-TA				GENETEST
TMEM127			HGMD	GENETEST
GLUD2			HGMD
CD55			HGMD
PRDM9			HGMD
asb10i3			HGMD
RHD			HGMD
HMOX2			HGMD
PTGDR			HGMD
PLP2			HGMD
HTR2C			HGMD
MDH1			HGMD
CACNA1E			HGMD
MURC			HGMD
FMO4			HGMD
OTOR			HGMD
sgk110			HGMD
FBLIM1			HGMD
MT-TN				GENETEST
C1orf227			HGMD
PLTP			HGMD
CNTN4			HGMD
DNAJA4			HGMD
pax6tv2			HGMD
MYO1C			HGMD
FAS			HGMD	GENETEST
KIFAP3			HGMD
PON1			HGMD
SPRN			HGMD
HBEGF			HGMD
SOD3			HGMD
CYSLTR2			HGMD
DDAH1			HGMD
ACBD5			HGMD
MIR502			HGMD
MIR27A			HGMD
ARF4			HGMD
OPN4			HGMD
OR13G1			HGMD
GABRR2			HGMD
HUS1B			HGMD
PIK3C3			HGMD
NEFM			HGMD
BCL9			HGMD
ABO			HGMD
NIPSNAP1			HGMD
LIPE			HGMD
HMCN1			HGMD	GENETEST
PDXK			HGMD
FCRL3			HGMD
VIPAR			HGMD
EHMT2			HGMD
OVGP1			HGMD
HACE1			HGMD
HAL			HGMD	GENETEST
BCL2L2			HGMD
AQP4			HGMD
SLC47A1			HGMD
ORMDL3			HGMD
ALOX15			HGMD
TBXA2R			HGMD
CCL7			HGMD
TP73			HGMD
GRIK4			HGMD
ATP13A4			HGMD
SLC6A18			HGMD
FADS2			HGMD
KIR3DL2			HGMD
ALDH1A2			HGMD
CCL17			HGMD
KHK			HGMD	GENETEST
GLP1R			HGMD
CD58			HGMD
NLGN2			HGMD
SELE			HGMD
PROKR1			HGMD
CNR1			HGMD
ABCB1			HGMD
ABCC4			HGMD
PLAGL1				GENETEST
NR2E1			HGMD
FAM188A			HGMD
MS4A6A			HGMD
FAAH			HGMD
IL17A			HGMD
ACCS			HGMD
fhl1tv1			HGMD
PGBD1			HGMD
ILK			HGMD
SLC22A1			HGMD
GJA4			HGMD
FABP3			HGMD
CAMKK1			HGMD
MYPN			HGMD
RNF113A			HGMD
CLCN2			HGMD	GENETEST
KCNJ9			HGMD
MFSD2A			HGMD
CHL1			HGMD
CNTF			HGMD
AKAP10			HGMD
ldb3z4			HGMD
SLC13A2			HGMD
AKR7A2			HGMD
SLC1A2			HGMD
ABCC3			HGMD
LINS			HGMD
HLA-DMB			HGMD
HOXA10			HGMD
CLUL1			HGMD
HLA-A			HGMD
CD27			HGMD
NR1H2			HGMD
CD226			HGMD
MBD4			HGMD
TSSK3			HGMD
MAD1L1			HGMD
APAF1			HGMD
IFNGR2			HGMD	GENETEST
NDUFA4			HGMD
SEZ6L2			HGMD
DDAH2			HGMD
igf2tv2			HGMD
CIDEA			HGMD
MIR24-1			HGMD
GALNT12			HGMD
C6orf97			HGMD
MADD			HGMD
HSPA1A			HGMD
IL17RB			HGMD
PARP2			HGMD
GSTT2			HGMD
CAMP			HGMD
CYP2A13			HGMD
UGT1A4			HGMD
ACSL5			HGMD
UGT1A6			HGMD
OR4A8P			HGMD
RRP1B			HGMD
PER3			HGMD
SCARB1			HGMD
GREM1			HGMD
AGXT2			HGMD
UBE2B			HGMD
MST1			HGMD
MUC4			HGMD
HAVCR1			HGMD
GABRA6			HGMD
MMEL1			HGMD
TRAPPC10				GENETEST
MGMT			HGMD
AIF1			HGMD
FFAR1			HGMD
MT-ND1				GENETEST
MAP4K5			HGMD
ACHE			HGMD
SLC28A1			HGMD
EGR3			HGMD
IFRD1			HGMD
LCE3B			HGMD
MTNR1A			HGMD
DARC			HGMD
SHMT1			HGMD
ADCY10			HGMD
FOXA3			HGMD
KLK15			HGMD
IL6			HGMD
CTGF			HGMD
POLB			HGMD
MTMR9			HGMD
EPOR			HGMD	GENETEST
nrxn1b			HGMD
CASP3			HGMD
CCRL2			HGMD
MT-TE				GENETEST
RNF213			HGMD
ITGAM			HGMD
RGS2			HGMD
MST1R			HGMD
MIR126			HGMD
ARHGEF11			HGMD
PRKAA2			HGMD
PIK3R4			HGMD
NDUFV3			HGMD
ABCG2			HGMD
PACRG			HGMD
inpp4ab			HGMD
GRB10			HGMD
NIPSNAP3A			HGMD
INSIG2			HGMD
FUT1			HGMD
C6orf204			HGMD
PECAM1			HGMD
PTPN1			HGMD
DNMT3L			HGMD
B3GNT3			HGMD
CNR2			HGMD
lhcgr6a			HGMD
HRH3			HGMD
CAPN13			HGMD
HTR2B			HGMD
PGRMC1			HGMD
MAOB			HGMD
ntrk3i1			HGMD
PTGDS			HGMD
NCS1			HGMD
CYP1A2			HGMD
BPIFA1			HGMD
LYN			HGMD
ELK1			HGMD
KLF7			HGMD
B3GALNT1			HGMD
ADAM33			HGMD
DNASE2			HGMD
MSH5			HGMD
TCN1			HGMD
MT-TF				GENETEST
CTSG			HGMD
GRIK1			HGMD
ICAM4			HGMD
FPGS			HGMD
NOD1			HGMD
KIF6			HGMD
DSCAM			HGMD
IL12RB2			HGMD
IL9R			HGMD
RNASE3			HGMD
PIK3CG			HGMD
LPA			HGMD
NQO1			HGMD
CYP3A7			HGMD
HSPA9			HGMD
MIR934			HGMD
nrg1smdf			HGMD
CIC			HGMD
S1PR1			HGMD
C20orf7			HGMD
HCN2			HGMD
KDM4C			HGMD
DAZL			HGMD
HAND1			HGMD
CYP2C18			HGMD
IGFBP1			HGMD
IFI44L			HGMD
SLC1A1			HGMD	GENETEST
loc344967			HGMD
PTPN21			HGMD
MOK			HGMD
IQGAP1			HGMD
IFNG			HGMD	GENETEST
RETN			HGMD
APH1A			HGMD
HTR6			HGMD
SMC1B			HGMD
FGF2			HGMD
CLU			HGMD
CXCL12			HGMD
CORO1A			HGMD
OPRD1			HGMD
MT-ND3				GENETEST
GYPB			HGMD
FEN1			HGMD
KIR3DS1			HGMD
DEFB126			HGMD
MIR191			HGMD
PKD1L1			HGMD
ALDH1A1			HGMD
FMO5			HGMD
DNAH9			HGMD
SHROOM3			HGMD
RAD54L			HGMD
cacna1ct23			HGMD
GJD2			HGMD
SETDB2			HGMD
CARTPT			HGMD
FRK			HGMD
OR6Q1			HGMD
CDK5R1			HGMD
HIF1A			HGMD
SLC2A4			HGMD
SLC26A9			HGMD
NOS3			HGMD	GENETEST
C21orf91			HGMD
GSTM3			HGMD
SLC47A2			HGMD
NOS1AP			HGMD
PRMT3			HGMD
PPAT			HGMD
SIRT3			HGMD
AQP1			HGMD
LCE5A			HGMD
ACVR1B			HGMD
MIR17			HGMD
CD1E			HGMD
SLC29A2			HGMD
MPP3			HGMD
DEAF1			HGMD
ITGA11			HGMD
MT-TK				GENETEST
PTCHD3			HGMD
MBD3			HGMD
HLA-DRB1			HGMD
PEMT			HGMD
MCM3AP			HGMD
MYO1F			HGMD
HLA-B			HGMD	GENETEST
MT-CO2				GENETEST
GPD2			HGMD
ITGA9			HGMD
18srRNA			HGMD
DAOA			HGMD
FABP4			HGMD
GPANK1			HGMD
DDX58			HGMD
AKT1			HGMD	GENETEST
GBA3			HGMD
ABCA7			HGMD
FRZB			HGMD
APOBEC3G			HGMD
CATSPER2				GENETEST
fgfr18a			HGMD
PTCD1			HGMD
SCRIB			HGMD
CAMKK2			HGMD
PON2			HGMD
KLK1			HGMD
MLXIPL			HGMD
DYX1C1			HGMD
CDH12			HGMD
COX4I1			HGMD
OAZ1			HGMD
KCNK18			HGMD
PRSS8			HGMD
FOXD4			HGMD
AKR1C3			HGMD
SATL1			HGMD
OR1S1			HGMD
F3			HGMD
DCTD			HGMD
CTSZ			HGMD
NR1I2			HGMD
LARS2			HGMD
MCF2L2			HGMD
LPAR1			HGMD
SCN2B			HGMD
HAS1			HGMD
C11orf46			HGMD
CASP2			HGMD
hnf4atv8			HGMD
ATG16L1			HGMD
JUN			HGMD
ADAMTSL3			HGMD
AOAH			HGMD
CA6			HGMD
MYO18B			HGMD
PGD			HGMD
MPG			HGMD
CASP12			HGMD
DHX36			HGMD
MIR30C1			HGMD
HDC			HGMD
SCGB3A2			HGMD
ADCY9			HGMD
PYCRL			HGMD
PTPN13			HGMD
DAPK1			HGMD
GSTT1			HGMD
TRAF3IP1			HGMD
SMARCE1				GENETEST
ICAM5			HGMD
CYP3A4			HGMD
SLC27A5			HGMD
ACSM2B			HGMD
IL7			HGMD
flg10.2			HGMD
POU5F1B			HGMD
HLX			HGMD
MDM4			HGMD
ODZ4			HGMD
NDUFB9			HGMD
HELQ			HGMD
ITPR3			HGMD
CBR1			HGMD
RNLS			HGMD
HMSD			HGMD
CYP26A1			HGMD
HSD17B1			HGMD
ADAM12			HGMD
HSD17B2			HGMD
NUP155			HGMD
GDF15			HGMD
MT-TG				GENETEST
BTN2A1			HGMD
CACNA2D1			HGMD
PON3			HGMD
RPA4			HGMD
HCN1			HGMD
FXYD6				GENETEST
MTNR1B			HGMD
HLA-DRB5			HGMD
FRY			HGMD
DKK2			HGMD
HNMT			HGMD	GENETEST
PIK3R5			HGMD
CDK11A			HGMD
PALLD			HGMD	GENETEST
IMPDH2			HGMD
MT-ATP6				GENETEST
HSPA1L			HGMD
BIRC5			HGMD
CHRNA5			HGMD
CES2			HGMD
DUX4				GENETEST
MT-ND4L				GENETEST
HTR7			HGMD
ASB10			HGMD
MS4A2			HGMD
BHMT			HGMD
AVPR1B			HGMD
MSMB			HGMD
PIN1			HGMD
FOXA2			HGMD
APOC4			HGMD
GSDMA			HGMD
NDUFA8			HGMD
MIR34B			HGMD
DNM1			HGMD
SORT1			HGMD
KIR2DL4			HGMD
ASIP			HGMD
ALCAM			HGMD
MPP4				GENETEST
SLC22A6			HGMD
BCAM			HGMD
ADAM19			HGMD
HLA-DRA			HGMD
ADRA2A			HGMD
dyt3			HGMD
DAO			HGMD
ADAMTS16			HGMD
pragmin			HGMD
GHRL			HGMD
EFHC1			HGMD	GENETEST
SLC17A3			HGMD
HVCN1			HGMD
CYP2D7P1			HGMD
PENK			HGMD
LTBP1			HGMD
LIF			HGMD
OXTR			HGMD
KDM5A			HGMD
FAM47B			HGMD
ATF1			HGMD
IL5			HGMD
otofe48			HGMD
CLSTN2			HGMD
KRT37			HGMD
C6orf221			HGMD
OPRK1			HGMD
CHI3L1			HGMD
DHX16			HGMD
CRP			HGMD
NEBL			HGMD
HSPA8			HGMD
OR4X1			HGMD
AGGF1			HGMD
ARPC3			HGMD
MYH13			HGMD
neb171			HGMD
ABCC11			HGMD
CYP7A1			HGMD
AURKA			HGMD
AKR7A3			HGMD
MT-ND2				GENETEST
MIR182			HGMD
LOXL1			HGMD
SETD8			HGMD
NR1I3			HGMD
KLHL9			HGMD
RPL10			HGMD	GENETEST
GDF9			HGMD
HCK			HGMD
LIPI			HGMD
GABBR1			HGMD
DISC1			HGMD
MIR890			HGMD
SCN3A			HGMD
CATSPER4			HGMD
CCL26			HGMD
NCOA3			HGMD
MTHFD1			HGMD
GC			HGMD
ADC			HGMD
ADRB1			HGMD
G6PC2			HGMD
MUC5B			HGMD
CTSB			HGMD
PGAM1			HGMD
NGFR			HGMD
MEIS1			HGMD
KLHL10			HGMD
NEDD4L			HGMD
IL1A			HGMD
CACNA1H			HGMD	GENETEST
KCND3			HGMD
AKR1C4			HGMD
PAX1			HGMD
COQ5			HGMD
SGK1			HGMD
AGXT2L1			HGMD
SIGLEC16			HGMD
EPHA7			HGMD
HAND2			HGMD
ANTXR1			HGMD
DGAT1			HGMD
ATG7			HGMD
SPP1			HGMD
GLI1			HGMD
BARD1			HGMD	GENETEST
SFTPD			HGMD
FDFT1			HGMD
PTGS2			HGMD
BMP7			HGMD
CFHR1			HGMD	GENETEST
GALNT2			HGMD
NAV2			HGMD
DND1			HGMD
ADH1C			HGMD
FCGR3A			HGMD
OR5AL1			HGMD
DNMT3A			HGMD
FCAR			HGMD
GAD2			HGMD
C1GALT1			HGMD
CCND1			HGMD
PIK3C2G			HGMD
PRKDC			HGMD
IMPA2			HGMD
rpgr11a			HGMD
S100B			HGMD
NPY1R			HGMD
CHDH			HGMD
GCNT2			HGMD	GENETEST
KCNN3			HGMD
CDK4			HGMD	GENETEST
ITIH3			HGMD
IRS2			HGMD
ANAPC1			HGMD
GPR1			HGMD
HTR5A			HGMD
ROPN1L			HGMD
GEMIN4			HGMD
C20orf54			HGMD
KCNMB3			HGMD
lmna1			HGMD
KLK12			HGMD
arhgef9tv2			HGMD
RRH			HGMD
DRP2			HGMD
FGFR4			HGMD
SLC19A1			HGMD
MT-TC				GENETEST
PIK3CD			HGMD
APEX1			HGMD
EOMES			HGMD
CEP68			HGMD
KRT31			HGMD
PTGIR			HGMD
ART4			HGMD
PRM1			HGMD
NLGN3			HGMD	GENETEST
GP2			HGMD
CHIT1			HGMD	GENETEST
PCSK2			HGMD
PI3			HGMD
MRC1			HGMD
MAVS			HGMD
SMG1			HGMD
IL13			HGMD
CD86			HGMD
OR10C1			HGMD
GPT			HGMD
CHD1L			HGMD
MT-TS1				GENETEST
CSAG1			HGMD
IBSP			HGMD
FUT8			HGMD
SNURF			HGMD
C7orf11			HGMD
IGFBP5			HGMD
ATXN3L			HGMD
NRTN			HGMD	GENETEST
MMP12			HGMD
GABRA1			HGMD	GENETEST
HABP2			HGMD	GENETEST
BMP10			HGMD
MYOCD			HGMD
CER1			HGMD
ATP2A3			HGMD
PTGER4			HGMD
CCR7			HGMD
MT-RNR1				GENETEST
BCL2A1			HGMD
PLXND1			HGMD
BSG			HGMD
SLC26A6			HGMD
PDE7B			HGMD
FN3K			HGMD
FGFBP1			HGMD
GLCCI1			HGMD
OLFM2			HGMD
kif1asv			HGMD
DUSP23			HGMD
CD14			HGMD
HMGCR			HGMD
INSL6			HGMD
NPAS2			HGMD
IL19			HGMD
CHGB			HGMD
DOC2A			HGMD
GGH			HGMD
ADARB1			HGMD
GPC4				GENETEST
C2orf64			HGMD
LUM			HGMD
GLO1			HGMD
FLT1			HGMD
ERAP2			HGMD
PFAS			HGMD
SMAD2			HGMD
OR1P1			HGMD
KIAA0415			HGMD
PLD2			HGMD
ALG10B			HGMD
ANGPTL4			HGMD
HHEX			HGMD
GTF2H1			HGMD
NAMPT			HGMD
ABCA10			HGMD
SCGB1A1			HGMD
GSTM1			HGMD	GENETEST
CRH				GENETEST
PRSS2			HGMD
CTRC			HGMD	GENETEST
MSH4			HGMD
DKK3			HGMD
p2rx5e10			HGMD
SPI1			HGMD
dysftv11			HGMD
PTPRF			HGMD
MT-TS2				GENETEST
POLL			HGMD
PIP4K2A			HGMD
CYP4F2			HGMD
UNC5C			HGMD
CXCR3			HGMD
KIF17			HGMD
GPBAR1			HGMD
CHI3L2			HGMD
CBR3			HGMD
CTLA4			HGMD
PLA2G2D			HGMD
AQP3			HGMD
KRT6C			HGMD
CSGALNACT1			HGMD
APOH			HGMD
SMAD1			HGMD
orf15			HGMD
PRMT10			HGMD
IL4			HGMD
SELPLG			HGMD
NAT2			HGMD
POU6F2			HGMD
ALDH16A1			HGMD
KRT38			HGMD
HLA-DPB1			HGMD
ARL6IP5			HGMD
C10orf137			HGMD
GABRD			HGMD	GENETEST
LIPG			HGMD
dvwa			HGMD
MGST2			HGMD
APOD			HGMD
NELF			HGMD
PLCZ1			HGMD
SIGLEC12			HGMD
F2R			HGMD
KLB			HGMD
ADORA3			HGMD
COL6A5			HGMD
ASMTL			HGMD
GZMB			HGMD
CYP3A43			HGMD
AKR1B1			HGMD
HLA-G			HGMD
SART1			HGMD
SEMA6D			HGMD
PMAIP1			HGMD
RPS6KL1			HGMD
NTF3			HGMD
GCKR			HGMD
MT-TH				GENETEST
GSDMB			HGMD
EXTL3			HGMD
DLGAP3			HGMD
SOCS1			HGMD
CDK5RAP3			HGMD
CAMK4			HGMD
CPLX2			HGMD
MT-ND5				GENETEST
C2orf56			HGMD
POP1			HGMD
SLC29A1			HGMD
SAA1			HGMD
OR11H7			HGMD
lamp2b			HGMD
ADIPOR1			HGMD
FABP6			HGMD
SCG3			HGMD
CD209			HGMD
EIF2C2			HGMD
GRM7			HGMD
LGALS13			HGMD
IL4R			HGMD
BTNL2			HGMD
CCL5			HGMD
ENTPD1			HGMD
sels			HGMD
MX1			HGMD
mocs1l			HGMD
flg11			HGMD
ofd1_2			HGMD
LOX			HGMD
NLRP1			HGMD
CASP9			HGMD
PDCD1			HGMD
neb170			HGMD
ATP6V0A1			HGMD
SLC7A1			HGMD
APH1B			HGMD
CHRNA3			HGMD
CNDP1			HGMD
CFLAR			HGMD
PRKCH			HGMD
NRXN3			HGMD
KIAA0226			HGMD
ACACB			HGMD
CDKN2C			HGMD
ADM			HGMD
RHPN2			HGMD
CD22			HGMD
FCGR1A			HGMD
C12orf62			HGMD
PPP1R1A			HGMD
NMU			HGMD
IFIH1			HGMD
IDH1			HGMD
AHSG			HGMD
POU5F1			HGMD
INHA			HGMD
PMS2P3			HGMD
NFKB1			HGMD
SIRT1			HGMD
ABCC1			HGMD
GFRA1			HGMD
RBP3			HGMD	GENETEST
PRM2			HGMD
MUC13			HGMD
IL1B			HGMD
SP8			HGMD
KCND2			HGMD
ELP2			HGMD
INPP4A			HGMD
SIAE			HGMD
MT1A			HGMD
MT-TM				GENETEST
DDX25			HGMD
NCAN			HGMD
ASMT			HGMD
TXN2			HGMD
CLEC11A			HGMD
SREBF1			HGMD
IDE			HGMD
IL21			HGMD
GPR68			HGMD
LTK			HGMD
HTR2A			HGMD
FUT7			HGMD
PHB			HGMD
TPH2				GENETEST
MT-TD				GENETEST
TNP1			HGMD
HSPB7			HGMD
TLR2			HGMD
HTR3E			HGMD
P2RX7			HGMD
POLR2E			HGMD
PSCA			HGMD
IL18R1			HGMD
BCL10			HGMD
GAS6			HGMD
ACCN3			HGMD
NAT1			HGMD
SULT2B1			HGMD
CYBRD1			HGMD
MTCH2			HGMD
PEAR1			HGMD
MMP10			HGMD
CDA			HGMD
PPARGC1B			HGMD
MT-TV				GENETEST
PLAUR			HGMD
BMP5			HGMD
CKM			HGMD
ESR2			HGMD
BHLHE41			HGMD
PZP			HGMD
MEP1B			HGMD
KCNJ8			HGMD
ITIH4			HGMD
SERPINA10			HGMD
INSIG1			HGMD
SYNGR1			HGMD
COMT			HGMD
CACNA1G			HGMD
PDLIM5			HGMD
ROS1			HGMD
AS3MT			HGMD
MT-TL1				GENETEST
KRT75			HGMD
CD3EAP			HGMD
PVR			HGMD
DRD1			HGMD
CCL13			HGMD
OR52H1			HGMD
RYR3			HGMD
NDUFB1			HGMD
SLC5A11			HGMD
ADRA2C			HGMD
SLC17A1			HGMD
RAC1			HGMD
ARSF			HGMD
SLC28A3			HGMD
KIR2DL2			HGMD
CILP			HGMD
PROZ			HGMD
BTLA			HGMD
SERPINB5			HGMD
DCK			HGMD
pml4			HGMD
SLC6A4			HGMD	GENETEST
NDUFA6			HGMD
SLC22A4			HGMD
DPYSL2			HGMD
FABP7			HGMD
KEL			HGMD
FTHL17			HGMD
DSCR8			HGMD
ALOX5			HGMD
CDH13			HGMD
FASN			HGMD
PHLPP2			HGMD
KIR2DS3			HGMD
cacnb2i1			HGMD
ASCC3			HGMD
DEFB1			HGMD
ARHGEF7			HGMD
NR1H3			HGMD
SLC44A2			HGMD
ATF3			HGMD
TRDN				GENETEST
UCHL1				GENETEST
RTN4R			HGMD
mvcl			HGMD
FAM75C1			HGMD
NPPB			HGMD
oas1i3			HGMD
IFNA2			HGMD
PLA2G2A			HGMD
FOLH1			HGMD
ALK			HGMD	GENETEST
PCMT1			HGMD
HLA-E			HGMD
GON4L			HGMD
MGST3			HGMD
PNMT			HGMD
BTRC			HGMD
OR51F1			HGMD
ACBD6			HGMD
gabrb3i2			HGMD
CSF1			HGMD
MUC1			HGMD
C3AR1			HGMD
KIF5B			HGMD
LBP			HGMD
BDKRB2			HGMD
DCLK1			HGMD
TLR6			HGMD
MEF2A			HGMD
RAD9A			HGMD
HTN3			HGMD
SLC4A3			HGMD
ADORA2A			HGMD
CDKN2B-AS1			HGMD
FOXD3			HGMD
CCHCR1			HGMD
RPS27A			HGMD
NPAT			HGMD
RASGRP2			HGMD
PRKD3			HGMD
PIGR			HGMD
NRIP1			HGMD
NRP2			HGMD
PTPRB			HGMD
FGF20			HGMD
ERAP1			HGMD
GIP			HGMD
PSPN			HGMD
HOXB13			HGMD
APLNR			HGMD
CHGA			HGMD
CALCA			HGMD
HTR3C			HGMD
CXCL11			HGMD
DLL1			HGMD
MYBL2			HGMD
GNB1L			HGMD
GFI1B			HGMD
PPIG			HGMD
C12orf10			HGMD
HLA-DPB2			HGMD
HOXD4			HGMD
HLA-DQB1			HGMD	GENETEST
MT-CYB				GENETEST
CHRNB4			HGMD
OGG1			HGMD
AFP			HGMD
CPB2			HGMD
MT-TI				GENETEST
CTF1			HGMD
USP9X			HGMD
FCN2			HGMD
DLX6			HGMD
MT-ATP8				GENETEST
CYP3A5P1			HGMD
HTR3B			HGMD
CBLB			HGMD
MIIP			HGMD
SLC22A11			HGMD
crb1a			HGMD
MRRF			HGMD
GSTO2			HGMD
MT-TL2				GENETEST
KLRK1			HGMD
FURIN			HGMD
ADH7			HGMD
P2RX5			HGMD
NCR3			HGMD
FKBPL			HGMD
CCR2			HGMD
GMIP			HGMD
RIMS3			HGMD
SMAD7			HGMD
CFHR4				GENETEST
FCER1A			HGMD
CALR			HGMD
NUDT6			HGMD
KCNMB1			HGMD
S100A14			HGMD
GH2			HGMD
REV3L			HGMD
HSD3B1			HGMD
RAD52			HGMD
RGS7			HGMD
CD207			HGMD
DISP1			HGMD
FEM1A			HGMD
PDPK1			HGMD
KYNU			HGMD
CPT1B			HGMD
STK32A			HGMD
SMN2			HGMD	GENETEST
MT-ND4				GENETEST
OPTC			HGMD
PCK1			HGMD	GENETEST
NPR3			HGMD
IRAK3			HGMD
ADAM10			HGMD
MT-CO3				GENETEST
LHX8			HGMD
KIAA1303			HGMD
MCHR1			HGMD
CIDEC			HGMD
CYP2E1			HGMD
tp73lae3			HGMD
ATF5			HGMD
MT-TW				GENETEST
TAF1L			HGMD
STK33			HGMD
SLCO1A2			HGMD
ECSIT			HGMD
MC1R			HGMD	GENETEST
OBSCN			HGMD
CLCA2			HGMD
CYP2G1P			HGMD
PPIA			HGMD
NDOR1			HGMD
CSNK1D			HGMD
PRKAG3			HGMD
KIR3DL1			HGMD
CD46			HGMD	GENETEST
RALGDS			HGMD
GPR44			HGMD
KCNE1L			HGMD
CCKBR			HGMD
CCK			HGMD
OR5H6			HGMD
NDUFB6			HGMD
RPH3AL			HGMD
CSMD1			HGMD
SLC24A2			HGMD
MIR510			HGMD
IL3			HGMD
SLC7A10			HGMD
mocs1b			HGMD
CYP4A11			HGMD
cdkn2ai3			HGMD
CRYGB			HGMD
CRISP2			HGMD
NTRK3			HGMD
FMO1			HGMD
PICK1			HGMD
MIAT			HGMD
C12orf57			HGMD
OR12D2			HGMD
BEX4			HGMD
TMEM187			HGMD
SLC6A14			HGMD
CTNNA3			HGMD
GAB2			HGMD
p14arf			HGMD
LAMA5			HGMD
HNRNPH3			HGMD
IL12A			HGMD
PRB3			HGMD
DROSHA			HGMD
CCL2			HGMD
MIR125A			HGMD
KPNA1			HGMD
LAMC1			HGMD
EFHC2			HGMD
MS4A6E			HGMD
ANXA5			HGMD
EPHX2			HGMD
KRTAP1-1			HGMD
ANGPT1			HGMD
FAM123B			HGMD
PRLHR			HGMD
HMGA2			HGMD
GJC3			HGMD
ISYNA1			HGMD
HSP90AA1			HGMD
SEL1L			HGMD
NDUFC2			HGMD
PARP1			HGMD
FGFRL1			HGMD
BAG6			HGMD
LHX1			HGMD
RPS15			HGMD
ITGA4			HGMD
CLOCK			HGMD
JAG2			HGMD
ROCK1			HGMD
RXRG			HGMD
KDR			HGMD
GIT1			HGMD
shank3e11			HGMD
C7orf10			HGMD
MYLIP			HGMD
RMI1			HGMD
BRAP			HGMD
RPL36			HGMD
LRP6			HGMD
PPARA			HGMD
CD244			HGMD
MGLL			HGMD
ATP5SL			HGMD
PTPRD			HGMD
PLDN			HGMD
MYH15			HGMD
CD24			HGMD
MIR892B			HGMD
ARHGAP9			HGMD
BACE1			HGMD
SLC28A2			HGMD
IFNA17			HGMD
BTC			HGMD
SEPP1			HGMD
LAMB1			HGMD
LOXL2			HGMD
IGF2			HGMD	GENETEST
PROK1			HGMD
RPL21			HGMD
GPR77			HGMD
HOMER2			HGMD
HTR1B			HGMD
KCNS1			HGMD
ADRA2B			HGMD
KIR2DL3			HGMD
SLC7A5			HGMD
FABP1			HGMD
GLTSCR1			HGMD
SORBS1			HGMD
SLC15A1			HGMD
NPC1L1			HGMD
DMBT1			HGMD
GSTK1			HGMD
C9orf86			HGMD
NLRP2			HGMD
NELL1			HGMD
ADORA1			HGMD
HES6			HGMD
POLE2			HGMD
FOXA1			HGMD
OSR1			HGMD
ITPA			HGMD
HSPA5			HGMD
CMPK1			HGMD
RHOB			HGMD
ENSA			HGMD
PRB1			HGMD
APOBEC3H			HGMD
IRF5			HGMD
ACAT2			HGMD
PPP2R1A			HGMD
CCKAR			HGMD
gcnt2c			HGMD
RPA1			HGMD
IFI30			HGMD
HK2			HGMD
MICB			HGMD
neb172			HGMD
C19orf48			HGMD
C8orf38			HGMD
ICAM1			HGMD
CELSR1			HGMD
LTF			HGMD
ETS1			HGMD
AGRP			HGMD
HSP90B1			HGMD
GSTA3			HGMD
HOXB6			HGMD
USP26			HGMD
SH2B3			HGMD
CYP2W1			HGMD
PARL			HGMD
BICC1			HGMD
HOXA4			HGMD
ADCY6			HGMD
PRLR			HGMD
CHIA			HGMD
CATSPER3			HGMD
INMT			HGMD
NPSR1			HGMD
NPPC			HGMD
LNX2			HGMD
HIF1AN			HGMD
hk1e			HGMD
MIR16-1			HGMD
CHRM2			HGMD
PRRC2A			HGMD
MIR499			HGMD
NR1H4			HGMD
kcnh2tv3			HGMD
RRM1			HGMD
OR52B4			HGMD
NOTCH4			HGMD
CADM1			HGMD
OPRM1			HGMD
CALM3			HGMD
sep15			HGMD
CNKSR1			HGMD
AQP5			HGMD
MPDZ			HGMD
ATF6			HGMD
FMO2			HGMD
ITIH1			HGMD
IL16			HGMD
PKM2			HGMD
hsf4b			HGMD
nlrp7v3			HGMD
PTAFR			HGMD
ABP1			HGMD
RGS6			HGMD
NCALD			HGMD
AKAP13			HGMD
shoxb			HGMD
ALS2CL			HGMD
HHIP			HGMD
RAD51D			HGMD	GENETEST
ADH1B			HGMD
SARDH				GENETEST
RANGRF			HGMD
HBS1L			HGMD
KIAA0319			HGMD
NEDD9			HGMD
HSPA1B			HGMD
FCER2			HGMD
CXCL5			HGMD
GSTO1			HGMD
sgcdp			HGMD
C16orf61			HGMD
P2RX4			HGMD
CFB			HGMD	GENETEST
CDC42BPB			HGMD
NPY2R			HGMD
NPTN			HGMD
CAPN10			HGMD
NDUFS5			HGMD
CCR5			HGMD
EPHB6			HGMD
PDLIM3			HGMD
UNC93B1			HGMD
LILRA3			HGMD
EDN2			HGMD
PSMD7			HGMD
ITPKC			HGMD
PPP1R3C			HGMD
MIF			HGMD
MT-TT				GENETEST
IRF8			HGMD
CHRNA9			HGMD
CFHR3			HGMD	GENETEST
MAP7D3			HGMD
NLGN4Y			HGMD
FZD1			HGMD
ANKRD1			HGMD	GENETEST
DDR1			HGMD
PTGS1			HGMD
LAMA4			HGMD
TACO1			HGMD	GENETEST
KLF10			HGMD
LTA			HGMD
IFNA10			HGMD
MGEA5			HGMD
PVT1			HGMD
CYP46A1			HGMD
BCAT1				GENETEST
PARD3B			HGMD
HMGA1			HGMD
SLC14A1			HGMD
pvrl1b			HGMD
CA1			HGMD
RANBP2			HGMD	GENETEST
LIG3			HGMD
DCP1B			HGMD
SERPINI2			HGMD
KCNJ15			HGMD
ECI1			HGMD
CXCL16			HGMD
ATOH7			HGMD
NRG1			HGMD
NPL			HGMD
CAST			HGMD
lrtomt2			HGMD
DGCR2			HGMD
CISH			HGMD
CYP2J2			HGMD
APOL3			HGMD
OR51G1			HGMD
AHSP			HGMD
SEMA4C			HGMD
PDGFC			HGMD
ANXA11			HGMD
NLRP14			HGMD
PSMB9			HGMD
ADRBK2			HGMD
HCLS1			HGMD
CSF2			HGMD
ITIH5L			HGMD
RPS6KB1			HGMD
AQP7			HGMD
MPST			HGMD";
  }

  },
}

