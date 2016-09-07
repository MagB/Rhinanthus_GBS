import sys

#print 
#TYPE intergene 0
#TYPE intron 1
#TYPE exon 2
#TYPE 0fold 3
#TYPE 4fold 4
#TYPE 3utr 5
#TYPE 5utr 6
#TYPE istop 7
#TYPE stop 8
#TYPE unknown 9
#TYPE cnc 10
#CHROM  POS     REF     ALT     REF_NUMBER      ALT_NUMBER      TOTAL   SITE_TYPE       DIVERGENCE

#my_file = open(sys.argv[1],'r')
vcf_ish=open("/Users/Maggie/Dropbox/Spirodela diversity/site_types_dist/count site types/annotated file",'r')


indIDs = ['BP1', 'CC1_1', 'CC3_3', 'CC4_1', 'DD7', 'GP10_3', 'GP14_4', 'GP2_3', 'GP4_2', 'GP6_5', 'GP8_1', 'HFA10', 'HFB11', 'ML1_1', 'ML3_1', 'RB1_1', 'RB2_7', 'RB3_7', 'RC1_1', 'RC3_2', 'RC_2_3', 'RD24', 'RL1_1', 'RL2_1', 'RR2_1', 'RR3_6', 'RU100', 'RU102', 'RU103', 'RU186', 'RU195', 'RU206', 'RU408', 'RU410', 'RU448', 'RU99']

#this prints the header for robert's vcf summarizer 
#check that these annotations matach RAobets annotated vcf codes.
#whats the deal with sites without two site types.

print "#TYPE intergene 0"
print "#TYPE intron 1"
print "#TYPE exon 2"
print "#TYPE 0fold 3"
print "#TYPE 4fold 4"
print "#TYPE 3utr 5"
print "#TYPE 5utr 6"
print "#TYPE istop 7"
print "#TYPE stop 8"
print "#TYPE unknown 9"
print "#TYPE cnc 10"
print "#GENOTYPE;homozygote reference;R"
print "#GENOTYPE;homozygote alternate;A"
print "#GENOTYPE;heterozygote;H"
print "#GENOTYPE;unknown;N"
print "#CHROM  POS     REF     ALT     REF_NUMBER      ALT_NUMBER      TOTAL   SITE_TYPE       DIVERGENCE       BP1     CC1_1     CC3_3     CC4_1     DD7     GP10_3     GP14_4     GP2_3     GP4_2     GP6_5     GP8_1     HFA10     HFB11     ML1_1     ML3_1     RB1_1     RB2_7     RB3_7     RC1_1     RC3_2     RC_2_3     RD24     RL1_1     RL2_1     RR2_1     RR3_6     RU100     RU102     RU103     RU186     RU195     RU206     RU408     RU410     RU448     RU99"

def my_condition(x):
    return x != "M"

def is_ref(x):
    return x ==  "0"

def is_het(x):
    return x ==  "1"

def is_alt(x):
    return x ==  "2"

#take my vcf like file:
for line in vcf_ish:
    #this ensures that the counts are not carried over from the last line in the vcf ish file

    total_ref_count=0
    total_alt_count=0
    total_alleles=0
    
    
    sline=line.split()
    #will write out the scaffold name position Ref ALT
   
   # print sline[0], sline[1], sline[8], sline[9], ref_allele_count
    
    # genotypes start at position 11 and go to end in intervals of 3
    genos=sline[11: :3]
    depth=sline[12: :3]
    gq=sline[13: :3]    
    
    #Note that if the site is invariant then there will be no GQ scrores, only DP scores.
    
#this makes a list of the genotypes for all samples at a site
    list_samps_w_geno_data= list((x for x in genos if my_condition(x)))
#the length of this list is simply the number of genotypes with data
    total_alleles=2*len(list_samps_w_geno_data)
    

    
    
    
#at an invariant site you only need to count the number of reference alleles
    if sline[9]==".":
	ref_allele_count_list=list((x for x in list_samps_w_geno_data if is_ref(x)))
	ref_allele_count=len(ref_allele_count_list)
	total_ref_count= ref_allele_count * 2
    else:
#this counts the alleles that are the same as the alternative allele a list of all 
	het_allele_count_list=list((x for x in list_samps_w_geno_data if is_het(x)))
	het_allele_count=len(het_allele_count_list)
	
#this counts the alleles that are the same as the reference allele a list of all 
        ref_allele_count_list=list((x for x in list_samps_w_geno_data if is_ref(x)))
        ref_allele_count=len(ref_allele_count_list)     
        total_ref_count=(2*ref_allele_count) + het_allele_count
	
#this counts the alleles that are the same as the alternative allele a list of all 
        alt_allele_count_list=list((x for x in list_samps_w_geno_data if is_alt(x)))
        alt_allele_count=len(alt_allele_count_list)     
	total_alt_count=(2*alt_allele_count) + het_allele_count
	

    genos2= ["H" if (x=="1") else ("A" if(x=="2") else ("R" if(x=="0") else "N")) for x in genos]
    #print genos
    #print genos2
    end= '\t'.join(str(p) for p in genos2)
    
    #print '\t'.join(str(p) for p in genos2)
    front1=[str(sline[0]) , str(sline[1]) , str(sline[8]) , str(sline[9]) , str(total_ref_count) , str(total_alt_count) , str(total_alleles), str(sline[5]), "-1"]
   # print front1
    front= '\t'.join(front1)   
    print front, '\t', end
    #print sline[0], sline[1], sline[8], sline[9], total_ref_count, total_alt_count, total_alleles, sline[5], "-1"