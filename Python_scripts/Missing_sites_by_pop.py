import sys

#my_summary_file=open(sys.argv[1], 'r')
my_summary_file=open( "/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1.summary",'r')
total_sites=0
pops_list=['Kob','Kd','SS','APR','SP','NkN','APK', 'NkS','HB' , 'Ph']
counts=0
for line in my_summary_file:
    counts+=1
    if counts>20000:
        break
    if "#CATALOG" in line:
        line=line.strip()
        sline=line.split("\t")
        indIDs = sline[9:]
        #print indIDs
        indID_dict={}
        for pop in pops_list:
            indID_dict[pop]={}
        
        for pop_names in indID_dict.keys():
            indID_dict[pop_names]=0
        continue        
           
    if "#" in line:
        continue
    
    line=line.strip()
    sline=line.split("\t")
    missing_list=[]
    
    for i in pops_list:
        missing_list=[]
        
        #print i
        pop_name=[y for y in indIDs if i in y]
        #now check if any of the samples from this populaiton are missing?
        
        for samples in pop_name:
            geno_pos=indIDs.index(samples)+9
            
           # print samples,indIDs.index(samples)+9
            sline[geno_pos]
        #count missing site
            if sline[geno_pos] =="N":
                missing_list.append("N")
                
        if len(missing_list)==len(pop_name):
            indID_dict[i]+=1
            
       

for pop in  indID_dict.keys():
    pop_list=[]

    pop_list=[y for y in indIDs if pop in y]


    print pop, indID_dict[pop], len(pop_list)
 
 
        
           


