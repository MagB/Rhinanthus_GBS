import sys


#my_vcf = open(sys.argv[1],'r')
my_vcf=open("/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1.summary",'r')


indIDs=[]

print "samp1", " ", "samp2"," ", "num_sites_where_both_havedata", " ", "N_both_het"," ",   "N_hom_het"," ", "N_hom_alt_hom_ref", " ", "N_hom_hom_ref", " ", " ", "N_hom_hom_alt", " ", "pairwise_pi", " ", "pairwise_geno"


def CalcWind(N_both_het, N_hom_het, N_hom_alt_hom_ref,  N_hom_hom,N_hom_hom_alt, pairwise_geno, pairwise_pi, site_num):

    for key in pairwise_pi.keys():
        #print key #keys' are sample names
        # v is the dictionary of stuff 
        for keys in pairwise_pi[key].keys():
            print key, keys, site_num[key][keys], N_both_het[key][keys], N_hom_het[key][keys], N_hom_alt_hom_ref[key][keys],  N_hom_hom[key][keys], N_hom_hom_alt[key][keys], pairwise_pi[key][keys], pairwise_geno[key][keys]
            #print chrom, mid, key, keys, pairwise_pi[key][keys], site_num[key]




                    
                    
                    
def ResetDicts():
    site_num={}
    pairwise_pi={}
    pairwise_geno={}
    N_both_het={}
    N_hom_het={}
    N_hom_alt_hom_ref={}
    N_hom_hom={}
    N_hom_hom_alt={}

    indIDs2=indIDs
    for x in indIDs:
        #pairwise_pi is a dictionary where the keys aresample_ID names, and then each sample name is associated with a dictionary of all pairwise comparisons among samples.
        site_num[x]={}
        pairwise_pi[x]={}
        pairwise_geno[x]={}
        N_both_het[x]={}
        N_hom_het[x]={}
        N_hom_alt_hom_ref[x]={}
        N_hom_hom[x]={}
        N_hom_hom_alt[x]={}
  
        indIDs2=[item for item in indIDs2 if item != x]

        for k in (indIDs2):
            pairwise_pi[x][k]=0.0
            pairwise_geno[x][k]=0.0
            site_num[x][k]=0.0
            N_both_het[x][k]=0.0
            N_hom_het[x][k]=0.0
            N_hom_alt_hom_ref[x][k]=0.0
            N_hom_hom[x][k]=0.0
            N_hom_hom_alt[x][k]=0.0


    return N_both_het, N_hom_het, N_hom_alt_hom_ref,  N_hom_hom, N_hom_hom_alt,pairwise_geno, pairwise_pi, site_num


N_both_het, N_hom_het, N_hom_alt_hom_ref,  N_hom_hom, N_hom_hom_alt,pairwise_geno, pairwise_pi, site_num = ResetDicts()    




start=-1
new_line=[]
sample2={}
last_pos=0
variant_sites=0




count=0
for line in my_vcf:
    count+=1
    

    if line[0]=="#" and line[0:2]!="#C":
        continue
    if line[0:2]=="#C":
        sline=line.split()
        indIDs = sline[9:]
        N_both_het, N_hom_het, N_hom_alt_hom_ref,  N_hom_hom, N_hom_hom_alt, pairwise_geno, pairwise_pi, site_num = ResetDicts()
        continue
    if line[0]=='\n':
        continue       
    

    
    sline=line.split()

    currentChrom=sline[0]
    


    genos=sline[9:]    

    for k in range(0,len(indIDs)):
        #print k
        samp1=indIDs[k]
        
        #if this sample has no data then skip doing all the comparisons for it
        if genos[k]!="N":
            #this will compare the first sample to all others in the row
            for i in range(k+1,len(indIDs)):
                
                samp2=indIDs[i]
                #print i, samp2
                #print "samp1 has data", sline[k2], sline
        
                if genos[i]!="N":
           #both samples have to have data (meaning both are not  N for this section to compute)
                    site_num[samp1][samp2]+=1
                    #both sames are homozygote for same alleles
                    if (genos[k]=="R" and genos[i]=="R"):
                        N_hom_hom[samp1][samp2]+=1
                    elif (genos[k]=="A" and genos[i]=="A"):
                        N_hom_hom_alt[samp1][samp2]+=1
                    #samples are alt homoz to each other
                    elif (genos[k]=="R" and genos[i]=="A") or (genos[k]=="A" and genos[i]=="R"):
                        N_hom_alt_hom_ref[samp1][samp2]+=1
                        pairwise_geno[samp1][samp2]+=1
                        pairwise_pi[samp1][samp2]+=float(4.0/6)
                        #print  pairwise_pi[samp1][samp2]
                    # one sample is het and other is hom
                    elif (genos[k]=="R" and genos[i]=="H") or (genos[k]=="A" and genos[i]=="H") or (genos[k]=="H" and genos[i]=="R") or (genos[k]=="H" and genos[i]=="A"):
                        N_hom_het[samp1][samp2]+=1
                        pairwise_geno[samp1][samp2]+=0.5
                        pairwise_pi[samp1][samp2]+=float(3.0/6)
                        #print  pairwise_pi[samp1][samp2]
                    #both hets
                    elif (genos[k]=="H" and genos[i]=="H"):
                        N_both_het[samp1][samp2]+=1
                        pairwise_pi[samp1][samp2]+=float(4.0/6)
                       # print  pairwise_pi[samp1][samp2]
    
             






CalcWind(N_both_het, N_hom_het, N_hom_alt_hom_ref,  N_hom_hom, N_hom_hom_alt,pairwise_geno, pairwise_pi, site_num)