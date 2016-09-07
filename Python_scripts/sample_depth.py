#get sample depth from matches.rsv file
#7th column is #reads at locus, called stack depth
import sys
import getopt

for x in sys.argv[1:]:
    file= open(x, 'r')
    new_file_name="".join([x,"_depth",".txt"])
    output_file= open(new_file_name, 'w')

    #file= open("/Users/Maggie/Documents/Rhinanthus/Python_scripts/2012HBLo01.matches.tsv_head", 'r')


    #file=open(sys.argv[1],'r')

    depth={}

    for line in file:
        if "#" in line:
            continue
        line=line.strip('\n')
        #sline=line.split("       ")
        sline=line.split("\t")

        stack_dep=sline[6]

        if stack_dep not in depth.keys():
            depth[stack_dep]=1
        else:
            depth[stack_dep]+=1

    dep_max= max([int(i) for i in depth.keys()])

    #print "depth", "count"
    newline=" ".join(["depth", "count","\n"])
    output_file.write(newline)
    for i in range(0, dep_max+1):
        if str(i) in depth.keys():
            #print i, depth[str(i)]
            newline=" ".join([str(i), str(depth[str(i)]),"\n"])
            output_file.write(newline)
        else:
            #print i, 0
            newline=" ".join([str(i), "0","\n"])
            output_file.write(newline)
    output_file.close()