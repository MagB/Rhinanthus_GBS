import sys

file= open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/summarized_sumstats_tsv.txt", 'r')

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
#First thing I do is find all populations that have a genotype call for a given catalog and site
    if catalog not in pop_at_sites.keys():
        pop_at_sites[catalog]={}
    if site not in pop_at_sites[catalog].keys():
        pop_at_sites[catalog][site]=[]

    pop_at_sites[catalog][site].append(new_pop)
count_sites=0

#This prints the catalog and site ID along with all populations that have a genotype call for that site.
#print "Catalog_ID", "Site_ID", "Populations"
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
            #print set(pop_at_sites[catalog][site])
            if pop not in pop_site_count.keys():
                pop_site_count[pop]=1
            else:
                pop_site_count[pop]+=1
#for pop in pop_site_count:
#    print pop, pop_site_count[pop]
        
 
                
                
                
#print number of unique sites per population:
print "pop_name", "unique_sites", "all_sites", "fraction_unique"
for pop_name in unique_sites.keys():
    print pop_name, float(unique_sites[pop_name]),float(pop_site_count[pop_name]), float(unique_sites[pop_name])/float(pop_site_count[pop_name])
    
    
#how many times does a given pop appear with each of the other pops?
pairwise_pop_counts={}
for catalog in pop_at_sites.keys():
    for site in pop_at_sites[catalog].keys():
        i=0
      #  print [(i, pop_at_sites[catalog][site].count(i)) for i in set(pop_at_sites[catalog][site])] 
        if len(set(pop_at_sites[catalog][site])) >1:
            #print site,list(set(pop_at_sites[catalog][site]))
            
            pop1 = list(set(pop_at_sites[catalog][site]))[0]
                
            for pop2 in list(set(pop_at_sites[catalog][site]))[1:]:
                    #if pop1 is not in either pair of copmarisons then add it 
                #if pop1=="Kob" and pop2=="Kd" or pop2=="Kob" and pop1=="Kd":
                   # print "stop"
                #pop1 and pop2 are newadd them to the dictionary
                if pop1 not in pairwise_pop_counts.keys() and pop2 not in pairwise_pop_counts.keys():
                    pairwise_pop_counts[pop1]={}
                    pairwise_pop_counts[pop1][pop2]=1
                #check if pop2 is already is comparison set
                elif pop1 in pairwise_pop_counts.keys() and pop2 not in pairwise_pop_counts[pop1].keys():
                    #makes sure reverse is not present:
                    if pop2 not in pairwise_pop_counts.keys(): 
                        pairwise_pop_counts[pop1][pop2]=1
                    #pop2 is already a key check if pop1 is a key for second pop
                    elif pop1 in pairwise_pop_counts[pop2].keys():
                        pairwise_pop_counts[pop2][pop1]+=1
                        
                #check if pop2 is in the first key
               # elif pop2 in pairwise_pop_counts.keys()  and pop1 not in pairwise_pop_counts[pop2].keys():
                #    pairwise_pop_counts[pop2][pop1]=1
                
                elif pop1 in  pairwise_pop_counts.keys() and pop2 in pairwise_pop_counts[pop1].keys():
                    pairwise_pop_counts[pop1][pop2]+=1                   
                elif pop2 in  pairwise_pop_counts.keys() and pop1 in pairwise_pop_counts[pop2].keys():
                    pairwise_pop_counts[pop2][pop1]+=1
                    


                                

            

#print number of times each pop appears with another pop
print "pop1", "pop2", "number_sites_together", "pop1_site_count", "pop2_site_count", "fraction_pop1", "fraction_pop2"
for pop1 in pairwise_pop_counts.keys():
    for pop2 in pairwise_pop_counts[pop1]:
        print pop1, pop2, pairwise_pop_counts[pop1][pop2], pop_site_count[pop1],pop_site_count[pop2], float(pairwise_pop_counts[pop1][pop2])/pop_site_count[pop1],float(pairwise_pop_counts[pop1][pop2])/pop_site_count[pop2]



#check if any population combo does not exist:
pop_list=[]
pop_codes=["Kd", "NkN", "NkS", "APK", "APR", "HB", "Kob", "Ph", "SP", "SS" ]

    
pop_list={}
for i in pop_codes:
    pop_list[i]=[]
    
for x in pop_codes:
    #print x
    
    if x in pairwise_pop_counts.keys():
        for y in pairwise_pop_counts[x]:
            pop_list[x].append(y)
        #loop thru all pairs and find first pop anywhere
        
    for first_key in  pairwise_pop_counts.keys():
        for second_key in pairwise_pop_counts[first_key].keys():
            if second_key ==x:
                pop_list[x].append(first_key)
                
print "pop", "missing"
for x in pop_list.keys():
    t=list(set(pop_codes)-set(pop_list[x])  )
    t.remove(x)
    print x, t