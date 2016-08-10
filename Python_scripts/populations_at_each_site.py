import sys

file= open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/summarized_sumstats_tsv.txt", 'r')
#file= open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/temp", 'r')

#catalog=
#site
#pop

pop_at_sites={}

#I need to remove the numbers from the end of the popcode
for line in file:    
    line=line.strip('\n')
    sline=line.split('   ')
    sline=line.split('\t')
    

    
#pop I don't want the hi mid, low and year, I just want the pop code:    
    pop=sline[2][4:]
    to_chop=0
    for character in pop[::-1]:
        if character in ["H", "L", "M", "i", "o", "d", "A"]:
            to_chop+=1
        else:
            try:
                
                end_char=int(character)
                to_chop+=1
    
            except:
                new_pop=pop[:-to_chop]
                if new_pop=="K":
                    new_pop="Kd"
                break
    
    catalog=sline[0]
    site=sline[1]
    if catalog not in pop_at_sites.keys():
        pop_at_sites[catalog]={}
    if site not in pop_at_sites[catalog].keys():
        pop_at_sites[catalog][site]=[]

    pop_at_sites[catalog][site].append(new_pop)
count_sites=0
for catalog in pop_at_sites.keys():
    for site in pop_at_sites[catalog].keys():
        pop_at_sites[catalog][site].sort()
        print catalog, site, " ".join(pop_at_sites[catalog][site])
        count_sites+=1
        
        #counts number of each population at a site
        #[(i, pop_at_sites[catalog][site].count(i)) for i in set(pop_at_sites[catalog][site])] 
print "total number of sites", count_sites
#how many sites are unique to each population? 38 pops in total, but with year and elevation removed should have 10 pops
unique_sites={}

#counts how mnay sites are unique to each population
for catalog in pop_at_sites.keys():
    for site in pop_at_sites[catalog].keys():
      #  print [(i, pop_at_sites[catalog][site].count(i)) for i in set(pop_at_sites[catalog][site])] 
        if len(set(pop_at_sites[catalog][site])) <2:
            pop_name="".join(list(set(pop_at_sites[catalog][site])))
            
            if pop_name not in unique_sites.keys():
                unique_sites[pop_name]=0
            else:
                unique_sites[pop_name]+=1
#count how many sites for each pop
pop_site_count={}
for catalog in pop_at_sites.keys():
    
    for site in pop_at_sites[catalog].keys():
        for pop in set(pop_at_sites[catalog][site]):
            if pop not in pop_site_count.keys():
                pop_site_count[pop]=1
            else:
                pop_site_count[pop]+=1
#for pop in pop_site_count:
#    print pop, pop_site_count[pop]
        
 
                
                
                
#print number of unique sites per population:
print "pop_name", "unique_sites", "all_sites", "fraction_unique"
for pop_name in unique_sites.keys():
    print pop_name, float(unique_sites[pop_name]),float(pop_site_count[pop]), float(unique_sites[pop_name])/float(pop_site_count[pop])
    
    
#how many times does Kd appear with each of the other pops?
pairwise_pop_counts={}
for catalog in pop_at_sites.keys():
    for site in pop_at_sites[catalog].keys():
        i=0
      #  print [(i, pop_at_sites[catalog][site].count(i)) for i in set(pop_at_sites[catalog][site])] 
        if len(set(pop_at_sites[catalog][site])) >1:
            #print site,list(set(pop_at_sites[catalog][site]))
            
            for pop1 in list(set(pop_at_sites[catalog][site]))[0:-1]:
                i+=1
                for pop2 in list(set(pop_at_sites[catalog][site]))[i:]:
                    if pop1!=pop2:
                        #if pop1 is not in either pair of copmarisons then add it 
                        #checks if pop1 and pop2 are in either set of existing comparisons. If pop1 (pop2) are not in a comparison set yet then add it 
                        
                        if pop1 not in pairwise_pop_counts.keys() and pop2 not in pairwise_pop_counts.keys():
                            pairwise_pop_counts[pop1]={}
                    
                        #check if pop2 is already is comparison set
                        if pop2 not in pairwise_pop_counts.keys() and pop2 not in pairwise_pop_counts[pop1].keys():
                            pairwise_pop_counts[pop1][pop2]=1
                            
                        elif pop2 in  pairwise_pop_counts.keys() and pop1 in pairwise_pop_counts[pop2].keys():
                            pairwise_pop_counts[pop2][pop1]+=1
                            
                        elif pop1 in  pairwise_pop_counts.keys() and pop2 in pairwise_pop_counts[pop1].keys():
                            pairwise_pop_counts[pop1][pop2]+=1

                                

            

#print number of times each pop appears with another pop
print "pop1", "pop2" "number_sites_together", "pop1_site_count", "pop2_site_count", "fraction_together"
for pop1 in pairwise_pop_counts.keys():
    for pop2 in pairwise_pop_counts[pop1]:
        print pop1, pop2, pairwise_pop_counts[pop1][pop2], pop_site_count[pop1],pop_site_count[pop2], float(pairwise_pop_counts[pop1][pop2])/min(int(pop_site_count[pop1]), int(pop_site_count[pop2]))


    