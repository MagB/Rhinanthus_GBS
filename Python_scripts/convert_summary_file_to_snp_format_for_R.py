import sys


#my_file = open(sys.argv[1],'r')
#my_file=open("/Users/Maggie/Dropbox/Spirodela diversity/Python scripts/vcf_summary_example_file_genes.txt",'r')
my_file=open("/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1.summary",'r')

genos_snps={}
position=[]
#scaffold=int(sys.argv[2])
#scaffold=str(1)

sys.argv=[]
#user must select what scaffolds are desired to convert, if no scaffold is chosen by the user then all scaffolds will be processed

#basically I make a list of all genotype calls for each sample
if len(sys.argv) >1:
    scaffold=int(sys.argv[2])
else:
    scaffold=33
chroms=[]
alleles=[]

for line in my_file:
    if line[0:2]=="#T" or line[0:2]=="#G":
        continue
    elif line[0:2]=="#C":
        sline=line.split()       
        
        if sline[-1]=="gene_name":
            genos_names=sline[9:-1]
            x=-1
        else:
            genos_names=sline[9:]
        for i in genos_names:
            genos_snps[i]=[]
        continue
    

    sline=line.split()       
    genos=sline[9:9+len(genos_names)]
    index=0
    
    #user must select what scaffolds are desired to convert, if no scaffold is chosen by the user then all scaffolds will be processed
    if scaffold!=33:
        if scaffold!=sline[0][6:]:
            if int(sline[0][6:]) > scaffold:
                break
            else:
                continue
    
    if sline[4]!=sline[6] and sline[5]!=sline[6]:
        position.append(sline[1])
        for i in genos:
            genos_snps[genos_names[index]].append(i)
            index+=1
        chroms.append(sline[0][6:])
        al="/".join([sline[2], sline[3]])
        alleles.append(al)

def change_geno(x):
    if x =="N":
        return "-"
    elif x=="R":
        return 0
    elif x=="H":
        return 1
    elif x=="A":
        return 2
    

#print ">> chromosome"
#print " ".join(chroms)
print ">> position"
print " ".join([str(y) for y in position])

print ">> sample names"
print " ".join(genos_names)

if len(genos_names)>12:
    
    print ">> population"


    def minusing2(x): return x-1

    Grp_name={}
    for i in range(1,11):
        Grp_name[i]={}
    Grp_name[1]["Kob"] = [i for i in genos_names if "Kob" in i]
    Grp_name[2]["Kd"] = [i for i in genos_names if "Kd" in i]
    Grp_name[3]["SS"] = [i for i in genos_names if "SS" in i]
    Grp_name[4]["SP"] = [i for i in genos_names if "SP" in i]
    Grp_name[5]["APR"] = [i for i in genos_names if "APR" in i]
    Grp_name[6]["NkS"] = [i for i in genos_names if "NkS" in i]
    Grp_name[7]["APK"] = [i for i in genos_names if "APK" in i]
    Grp_name[8]["HB"] = [i for i in genos_names if "HB" in i]
    Grp_name[9]["Ph"] = [i for i in genos_names if "Ph" in i]
    Grp_name[10]["NkN"] = [i for i in genos_names if "NkN" in i]
   

    pop_name_list=[]
    for i in genos_names:
        for count in Grp_name.keys():
            for pop_name in Grp_name[count].keys():
                if i in Grp_name[count][pop_name]:
                    pop_name_list.append(pop_name)
    print " ".join(pop_name_list)

#print ">> population"
#print " ". join(["BP", "CC",  "CC" , "CC" , "DD" ,   "GP" ,"GP", "GP" , "GP" , "GP",  "GP",  "HF"  ,"HF" , "OTT" , "OTT"  ,"RB" , "RB" , "RB",  "RC" , "RC" , "RC","RD"   ,"RL" , "RL" , "RR"  ,"RR"  ,"RU100" , "RU102" ,"RU103" , "RU186",  "RU195",  "RU206",  "RU408" , "RU410" , "RU448" , "RU99"])
print ">> ploidy"
print "2"

print ">> allele"
alleles=[x.lower() for x in alleles]
print " ".join(alleles)


for i in genos_names:
    vec0=[change_geno(x) for x in genos_snps[i]]
    
    print ">", " " , i
    print "".join([str(x) for x in (vec0)])
    
#print len(genos_snps[i])
          