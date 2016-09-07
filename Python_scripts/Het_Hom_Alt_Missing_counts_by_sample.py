import sys

#my_summary_file=open(sys.argv[1], 'r')
my_summary_file=open( "/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1.summary",'r')
total_sites=0

for line in my_summary_file:
    if "#CATALOG" in line:
        line=line.strip()
        sline=line.split("\t")
        indIDs = sline[9:]
        #print indIDs
        indID_dict={}
        for i in indIDs:
            indID_dict[i]={}
            for x in ["REF", "ALT", "HET", "MISSING"]:
                indID_dict[i][x]=0
        continue        
           
    if "#" in line:
        continue
    
    geno_pos=9
    line=line.strip()
    sline=line.split("\t")
    
    for i in indIDs:
        print i
        #count missing site:
        #print geno_pos, sline[geno_pos]
        
        if sline[geno_pos] =="N":
            indID_dict[i]["MISSING"]+=1
        elif sline[geno_pos]=="R":
            indID_dict[i]["REF"]+=1
        elif sline[geno_pos]=="A":
            indID_dict[i]["ALT"]+=1
        elif sline[geno_pos]=="H":
            indID_dict[i]["HET"]+=1
        geno_pos+=1        
        
            
            
           
        
    geno_pos=9
    total_sites+=1

new_line=[]
print "Sample_ID", "\t", "REF_count", "\t", "ALT_count", "\t", "HET_count", "\t" , "MISSING", "\t", "Total_sites", "\t", "Prop_ref", "\t", "Prop_alt", "\t", "Prop_het", "\t", "Prop_missing"


for i in indIDs:
    new_line.append(i)

    for x in ["REF", "ALT", "HET", "MISSING"]:
        #new_line.append(x)
        new_line.append(str(indID_dict[i][x]))
    new_line.append(str(total_sites))
    total_count=sum(map(float, [indID_dict[i]["REF"], indID_dict[i]["ALT"], indID_dict[i]["HET"]]))
    for x in ["REF", "ALT", "HET"]:    
        new_line.append(str(float(indID_dict[i][x])/total_count))
    new_line.append(str(float(indID_dict[i]["MISSING"])/total_sites))
    print "\t".join(new_line)
    new_line=[]
