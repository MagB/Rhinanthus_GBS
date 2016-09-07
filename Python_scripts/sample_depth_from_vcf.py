import sys


#vcf = open(sys.argv[1],'r')
vcf=open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/vcf.txt",'r')




#this prints the header for robert's vcf summarizer 
#check that these annotations match RAobets annotated vcf codes.
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
#print "#CHROM  POS     REF     ALT     REF_NUMBER      ALT_NUMBER      TOTAL   SITE_TYPE       DIVERGENCE       BP1     CC1_1     CC3_3     CC4_1     DD7     GP10_3     GP14_4     GP2_3     GP4_2     GP6_5     GP8_1     HFA10     HFB11     ML1_1     ML3_1     RB1_1     RB2_7     RB3_7     RC1_1     RC3_2     RC_2_3     RD24     RL1_1     RL2_1     RR2_1     RR3_6     RU100     RU102     RU103     RU186     RU195     RU206     RU408     RU410     RU448     RU99"

def my_condition(x):
    return x != "M"

def is_ref(x):
    return x ==  "0"

def is_het(x):
    return x ==  "1"

def is_alt(x):
    return x ==  "2"

#take my vcf like file:
for line in vcf:
    if "#" in line and "#CHROM" not in line:
	continue
    if "#CHROM" in line:
	sline=line.split()
	indIDs = sline[9:]
	
	indID_depth={}
	indID_count={}
	for i in indIDs:
	    indID_depth[i]=0
	    indID_count[i]=0	    

	continue
    #this ensures that the counts are not carried over from the last line in the vcf ish file

    total_ref_count=0
    total_alt_count=0
    total_alleles=0
    
    
    sline=line.split()
    geno_pos=8
    
    genos=sline[9:]
    for i in range(0,96):

	geno_pos+=1  	
	
	if genos[i].split(":")[0] == "./.":
	    continue
	
	samp_dep1=genos[i].split(":")[2]
	samp_dep2=samp_dep1.split(",")
	samp_depth=int(samp_dep2[0])+int(samp_dep2[1])
	

	indID_depth[indIDs[i]]+=samp_depth
	indID_count[indIDs[i]]+=1
	

print "Sample_ID", "\t", "Avg_depth"
for i in indIDs:
    print i,  float(indID_depth[i]),float(indID_count[i])