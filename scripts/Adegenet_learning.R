
library(pegas)
library(adegenet)




#mygenos=read.snp("output/snp_files/batch1.snp")
#mygenos=snp2gp(infile = "output/snp_file.txt", prefix_length = 6)

data("nancycats", package = "adegenet")  
summary(platy)
View(nancycats)
head(nancycats)
file.show(system.file("files/nancycats.dat", package="adegenet"))
file.copy(system.file("files/nancycats.dat", package = "adegenet"), getwd())
file.copy(system.file("files/nancycats.str", package = "adegenet"), getwd())

#mygenos2=read.structure(file="/Users/Maggie/Documents/Rhinanthus/output/no_pop_map_snp_data.str", onerowperind=TRUE,NA.char="-9", n.ind=96, n.loc=15421, col.lab=1, col.pop=2,  sep="\t",ask=F)

#at lab meeting use this
mygenos2=read.structure(file="/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1_no_pop_map_75_percent_sample_at_site.str", onerowperind=TRUE,NA.char="-9", n.ind=96, n.loc=2213, col.lab=1, col.pop=2,  sep="\t",ask=F)


table(mygenos2$pop)
table(mygenos2$pop)
library("hierfstat")
matFst <- pairwise.fst(mygenos2)

mygenos3=genind2hierfstat(mygenos2)
basic.stats(mygenos3)


library("PopGenReport")


platy.complete <- popgenreport(mygenos2, path.pgr = "/Users/Maggie/Documents/Rhinanthus/output/popgenreport_output",mk.complete=TRUE, mk.Rcode=TRUE, mk.pdf = FALSE)




#NEw after 5pm
#at lab meeting use this
mygenos_Kd_Nk_only=read.structure(file="/Users/Maggie/Documents/Rhinanthus/output/summary_files/batch1_no_pop_map_75_percent_sample_at_site_Kd_Nk_only.str", onerowperind=TRUE,NA.char="-9", n.ind=72, n.loc=2213, col.lab=1, col.pop=2,  sep="\t",ask=F)

mygenos_Kd_Nk_only_popgenreport <- popgenreport(mygenos_Kd_Nk_only, path.pgr = "/Users/Maggie/Documents/Rhinanthus/output/popgenreport_output_Kd_Nk_only",mk.complete=TRUE, mk.Rcode=TRUE, mk.pdf = FALSE)


