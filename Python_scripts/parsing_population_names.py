file= open("/Users/Maggie/Desktop/barcodes.txt", 'r')


#I need to remove the numbers from the end of the popcode
for line in file:    
    line=line.strip('\n')
    sline=line.split('   ')
    sline=line.split('\t')
    #print sline
    to_chop=0
    for character in sline[-1][::-1]:
        
        if sline[-1]=="2014NkSLo1702":
            print "stope me"
            
        if to_chop==0:
            to_chop=1
            continue
            
        try:

            end_char=int(character)
            to_chop+=1

        except:
            print sline[-1], sline[-1][:-to_chop]
            break