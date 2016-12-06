library("PopGenReport")
library("adegenet")
library("hierfstat")

mygenos2=read.structure(file="/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1_no_pop_map_75_percent_sample_at_site.str", onerowperind=TRUE,NA.char="-9", n.ind=96, n.loc=2213, col.lab=1, col.pop=2,  sep="\t",ask=F)

pairwise.fstb(mygenos2)
