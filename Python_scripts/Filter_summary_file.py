#filter summary file:
import sys

my_summary_file=open( "/Users/Maggie/Documents/Rhinanthus/output/batch_1.summary",'r')

for line in my_summary_file:
    if "#" in line:
        print line.strip()
        continue
    
    line=line.strip()
    sline=line.split("\t")
    genos=sline[10:]
    
    number_of_called_genos= sum([1 for x in genos if x!="N"])
    
    if float(number_of_called_genos)/96 > 0.8:
        print line
    else:
        continue
    