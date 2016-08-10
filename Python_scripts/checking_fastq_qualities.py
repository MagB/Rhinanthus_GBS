from math import e, log, exp, expm1
import sys

    

#each quality score is phred33 format
#myfastq=sys.argv[1]
myfastq="/Users/Maggie/Documents/IPython Notebooks/SRR835775_1.first1000.fastq"


file_name="".join(["/Users/Maggie/Documents/IPython Notebooks/SRR835775_1.first1000.fastq"[:-7],"_gc_output.csv"])
#file_name="".join([str(sy.argv[:-7]),"_gc_output.csv"])

gc_output=open(file_name, 'w')


file_name="".join(["/Users/Maggie/Documents/IPython Notebooks/SRR835775_1.first1000.fastq"[:-7],"_qual_scores.csv"])
#file_name="".join([str(sy.argv[:-7]),"_qual_scores.csv"])


qual_scores=open(file_name, 'w')

# this scipt does the following:
#1. Converst the raw quality scores output from Illumina phred33 scores into  Q scores
#2.the average quality score of each read for each position
#3. the average gc content per position for each read

#First step is to read in the fastq file and load up the sequence and the quality scores information
def readFastq(my_file):
    sequences=[]
    qualities=[]
    with open(my_file) as myfastq:
        while True:
            #first line is header info
            myfastq.readline()
            #second line is the sequence
            seq=myfastq.readline().rstrip()
            #third line is  a +
            myfastq.readline()
            #fourth line is quality scores
            qual=myfastq.readline().rstrip()
            if len(seq)==0:
                break
            sequences.append(seq)
            qualities.append(qual)
    return sequences, qualities

seqs, quals=readFastq(myfastq)

#first convert phred33 quality to pure quality score
def phred33toQ(qual):
    #ord takes a alphanumeric symbol and converts it to its ascii number
    #note:ascii is: each alphabetic, numeric, or special character is represented with a 7-bit binary number (a string of seven 0s or 1s)
    return ord(qual)-33



def phred33toQ(qualities):
    #highest qual score is about 41
    #initialist dictionary
    his={}
    #make a dictionary with the each qual 
    for i in range(0,150):
        his[i]=0
    
    #in this case qualities is the list of quality scroes for each read

    for qual in qualities:
        pos=0
        number_of_reads=len(qualities)
        #for each basepair in a read convert its phred score to a quality score
        for phred in qual:
            #ord takes a alphanumeric symbol and converts it to its ascii number
            #note:ascii is: each alphabetic, numeric, or special character is represented with a 7-bit binary number (a string of seven 0s or 1s)
            #a hashtag symbol correspinds to a Qscore=2, this corresponds to a 1 in 100 chance that the basepair is incorrect
            #Qphred=-10*log(e)
            #J corresponds to Qscore of 41,             
            converted_qual_score=ord(phred)-33
            #add up the scores for each of the positions
            his[pos]+=converted_qual_score
            pos+=1
            
    return his, number_of_reads
#recall that quals was defined from that first function that read in the fastQ file
h,number_of_reads=phred33toQ(quals)
#print "position", "read_num", "avg_qual"
qual_scores.write(",".join(["position", "read_num","avg_qual", "\n"]))

for i in range(0,len(h)):
    if h[i]==0:
        break
    line=map(str, [str(i), number_of_reads,h[i]/number_of_reads])
    qual_scores.write(",".join([str(i), str(number_of_reads),str(h[i]/number_of_reads), "\n"]))
    #print i, number_of_reads, h[i]/number_of_reads
    #print i, h[i],number_of_reads, h[i]/number_of_reads
qual_scores.close()

def findGCByPos(reads):
    gc=[0]*150
    totals=[0]*150
    average_gc=[0]*150
    #keep track of GC bases and total number of bases at each position
    #then find average GC content by position across all reads.
    for read in reads:
        for i in range(len(read)):
            #the length of read goes to 100bp
            if read[i] =="C" or read[i]=="G":
                gc[i]+=1
            #totals[0] should be number of sequences
            totals[i]+=1
            
    for i in range(len(gc)):
        if totals[i]>0:
            average_gc[i]=gc[i]/float(totals[i])
    return average_gc
gc=findGCByPos(seqs)

gc_output.write(",".join(["position", "proportion_gc","\n"]))
for i in range(0,len(gc)):
    if gc[i]==0:
        break
    gc_output.write(",".join([ str(i), str(gc[i]), "\n"]))
gc_output.close()