library(ggplot2)
library(gridExtra)
genotype_depth=read.table("/Users/Maggie/Documents/Rhinanthus/output/associations_w_depth/genotype_call_depth_distribution.txt",header=F)

colnames(genotype_depth)=c("genotype", "depth", "count")
sum_het=sum(genotype_depth$count[genotype_depth$genotype=="Het"])
sum_hom=sum(genotype_depth$count[genotype_depth$genotype=="Hom"])
sum_alt=sum(genotype_depth$count[genotype_depth$genotype=="Alt"])

genotype_depth$freq[genotype_depth$genotype=="Het"]=genotype_depth$count[genotype_depth$genotype=="Het"]/sum_het
genotype_depth$freq[genotype_depth$genotype=="Hom"]=genotype_depth$count[genotype_depth$genotype=="Hom"]/sum_hom
genotype_depth$freq[genotype_depth$genotype=="Alt"]=genotype_depth$count[genotype_depth$genotype=="Alt"]/sum_alt


        
ggplot(genotype_depth[genotype_depth$genotype=="Het",], aes(x = factor(depth), y = count)) + geom_bar(stat = "identity")
ggplot(genotype_depth[genotype_depth$genotype=="Hom",], aes(x = factor(depth), y = count)) + geom_bar(stat = "identity")


ggplot(genotype_depth,aes(x=factor(depth),y=freq,fill=factor(genotype)), color=factor(genotype)) +  
        stat_summary(fun.y=mean, geom="bar") +
        facet_wrap(~genotype)

#depth stats by population
genotype_depth_by_pop=read.csv("/Users/Maggie/Documents/Rhinanthus/output/associations_w_depth/site_level_counts_depth_by_pop.csv",header=T)
dim(genotype_depth_by_pop)
head(genotype_depth_by_pop)
