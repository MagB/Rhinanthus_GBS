import sys


#vcf = open(sys.argv[1],'r')
vcf=open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/vcf.txt",'r')



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