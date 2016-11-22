#In this script, I generate 2 PCA plots and a NJ tree based on euclidean distance.
#To generate the PCA and the NJ tree I convert my snp data from a .summary file format to a .snp file format
#the adegenet package and functions like pca require that snp data be converted into a genligth or gen object.

#this is the path to an example of the .snp file format
#file.show(system.file("files/exampleSnpDat.snp",package="adegenet"))
# See this tutorial for details on this package
#https://github.com/thibautjombart/adegenet/wiki/Tutorials
#I have a copy here file:///Users/Maggie/Dropbox/Spirodela%20diversity/PCA/tutorial-genomics.pdf
install.packages("adegenet")
install.packages("ape")
library("adegenet")
citation(package = "adegenet", lib.loc = NULL)
citation(package = "base", lib.loc = NULL)
citation("ape")
library(help = adegenet )
library(ape)
R.Version() 
search()
?"adegenet"
mygenos=read.snp("output/snp_files/batch1.snp")
class(mygenos)
#alleles(mygenos36_scaff1)=rep("a/t", 417867)

#You don't need populations for the glpca or the k-means. populations are required for doing a dpca and some other functions
#If pops are required be careful of how they are defined.
pop(mygenos)


mygenos$pop
names(mygenos)

#this was a plot of snp density, which can be done if you have unique sequential positions for all snps.
#max(mygenos36_scaff1$position)
#snpposi.plot(position(mygenos36_scaff1), genome.size=8941088)
#glPlot(mygenos36_scaff1, posi="topleft")

pca1 <- glPca(mygenos)
#I chose to retain 4 axes. 
pca1$eig
pca1$scores
pca1$loadings
pca1$sdev
scatter(pca1)
?ade4
#get %variance explained:
variance_explained=pca1$eig/sum(pca1$eig)
print("Var explained")
print(c("PCA1, PCA2, PCA3"))

print(c(variance_explained[1], variance_explained[2],variance_explained[3]))

#Here I make a composite plot of a NJ tree and a PCA plot such that the colours and labels on the tree match that of the PCA
library(ape)
# The defualt uses the Euclidean distance on allele frequencies. Originally I used raw genetic distance calculated as the average of the per locus distance 
#for pairs of individuals. This explains why the new nj tree looks nicer.
tre <- nj(dist(as.matrix(mygenos)))
plot(tre, typ="phylogram",cex=0.41,label.offset=8)



#colors are obtained from using the colorplot function. 
myCol2 <- colorplot(pca1$scores[,1:2],pca1$scores[,1:2],transp=TRUE, cex=1, ylab="PCA3", xlab="PCA2")

#the list of colors is just the vector myCol2, but here I can more easily alter colours for specific samples
#myCols_unrotated_tree_colors=c("#E94E0080" ,"#2F060080", "#360D0080", "#2B000080", "#C58C0080", "#D9CE0080", "#C28B0080", "#D5C90080","#BAB10080", "#DACF0080", "#DDD20080", "#FF810080", "#FA800080", "#B1592080", "#B1592080", "#ED4B0080","#E1510080", "#EB4B0080", "#31080080", "#3A140080", "#51320080", "#C4950080", "#26C30080", "#19CD0080","#8D810080", "#F4470080", "#03DA0080", "#00DB0080", "#5D240080", "#04D80080", "#58810080", "#581A0080", "#1FC80080", "#00DA0080", "#5D800080", "#5D7E0080")
#Here I find the index of the sample I am interested in. Once I know the index I can pull out the color for that sample
#my_list=which(tre$tip.label %in% tre$tip.label[grepl("RR3_6", tre$tip.label)])
#myCols_unrotated_tree_colors[c(29,32)]="#000000"
#myCols_unrotated_tree_colors[c(my_list)]




#maybe label by area: 10 areas
#first generate a list of regions to add onto or replace the tip labels
my_region_list=c()
for(i in tre$tip.label){
       l= ifelse(grepl("Kd",i)==TRUE,"Kd", 
                ifelse(grepl("Kob",i)==TRUE,"Kob",
                        ifelse(grepl("SS",i)==TRUE, "SS",
                                ifelse(grepl("SP",i)==TRUE, "SP",
                                        ifelse(grepl("APR",i)==TRUE, "APR",
                                                ifelse(grepl("NkS",i)==TRUE, "NkS",
                                                        ifelse(grepl("NkN",i)==TRUE, "NkN",
                                                                ifelse(grepl("HB",i)==TRUE, "HB",
                                                                        ifelse(grepl("Ph",i)==TRUE, "Ph",
                                                                                ifelse(grepl("APK",i)==TRUE, "APK",0))))))))))
        my_region_list=c(my_region_list, l)
}
tre$tip.label=paste(c(tre$tip.label),my_region_list, sep=" ")
tre$tip.label=my_region_list

#make a new region list where elevation is included in the name
my_region_list2=c()
for(i in tre$tip.label){
        l= ifelse(grepl("Kd",i)==TRUE & grepl("H",i)==TRUE,"KdH", 
                ifelse(grepl("Kd",i)==TRUE & grepl("M",i)==TRUE,"KdM",
                        ifelse(grepl("Kd",i)==TRUE & grepl("L",i)==TRUE,"KdL",
                ifelse(grepl("Kob",i)==TRUE & grepl("H",i)==TRUE,"KobH",
                        ifelse(grepl("Kob",i)==TRUE & grepl("M",i)==TRUE,"KobM",
                                ifelse(grepl("Kob",i)==TRUE & grepl("L",i)==TRUE,"KobL",
                        ifelse(grepl("SS",i)==TRUE & grepl("H",i)==TRUE, "SSH",
                                ifelse(grepl("SS",i)==TRUE & grepl("M",i)==TRUE, "SSM",
                                        ifelse(grepl("SS",i)==TRUE & grepl("L",i)==TRUE, "SSL",
                                ifelse(grepl("SP",i)==TRUE  & grepl("H",i)==TRUE, "SPH",
                                        ifelse(grepl("SP",i)==TRUE  & grepl("M",i)==TRUE, "SPM",
                                                ifelse(grepl("SP",i)==TRUE  & grepl("L",i)==TRUE, "SPL",
                                        ifelse(grepl("APR",i)==TRUE & grepl("H",i)==TRUE, "APRH",
                                                ifelse(grepl("APR",i)==TRUE & grepl("M",i)==TRUE, "APRM",
                                                        ifelse(grepl("APR",i)==TRUE & grepl("L",i)==TRUE, "APRL",
                                                ifelse(grepl("NkS",i)==TRUE & grepl("H",i)==TRUE, "NkSH",
                                                        ifelse(grepl("NkS",i)==TRUE & grepl("M",i)==TRUE, "NkSM",
                                                                ifelse(grepl("NkS",i)==TRUE & grepl("L",i)==TRUE, "NkSL",
                                                        ifelse(grepl("NkN",i)==TRUE & grepl("H",i)==TRUE, "NkNH",
                                                                ifelse(grepl("NkN",i)==TRUE & grepl("M",i)==TRUE, "NkNM",
                                                                        ifelse(grepl("NkN",i)==TRUE & grepl("L",i)==TRUE, "NkNL",
                                                                ifelse(grepl("HB",i)==TRUE & grepl("H",i)==TRUE, "HBHH",
                                                                        ifelse(grepl("HB",i)==TRUE & grepl("M",i)==TRUE, "HBHM",
                                                                                ifelse(grepl("HB",i)==TRUE & grepl("L",i)==TRUE, "HBHL",
                                                                        ifelse(grepl("Ph",i)==TRUE & grepl("H",i)==TRUE, "PhM",
                                                                                ifelse(grepl("Ph",i)==TRUE & grepl("M",i)==TRUE, "PhM",
                                                                                        ifelse(grepl("Ph",i)==TRUE & grepl("L",i)==TRUE, "PhL",
                                                                                ifelse(grepl("APK",i)==TRUE & grepl("H",i)==TRUE, "APKH",
                                                                                        ifelse(grepl("APK",i)==TRUE & grepl("M",i)==TRUE, "APKM",
                                                                                                ifelse(grepl("APK",i)==TRUE & grepl("L",i)==TRUE, "APKL",0))))))))))))))))))))))))))))))
        my_region_list2=c(my_region_list2, l)
}
#HERE I START THE PLOTTING OF NJ AND PCA
tre$tip.label=my_region_list2

dev.off()
quartz("new_fig", width=10, height=10)
nf <- layout(matrix(c(1,1,2,3), 2, 2, byrow=FALSE), respect=TRUE)
layout.show(nf)
par(oma=c(1,2,2,2))
par(mar=c(2,2,2,2))

#first plot the NJ tree
#I had used this object first, plot(tre, typ="phylogram",cex=0.81,label.offset=14)
#Tree before rotation is tre
plot(tre, typ="phylogram",cex=0.81,label.offset=8)


#note: before running tiplabels run this line that appears below
#to generate colors for each sample : myCol2 <- colorplot(pca1$scores[,2:3],pca1$scores[,2:3],transp=TRUE, cex=1, ylab="PCA3", xlab="PCA2")
tiplabels(pch=15, col=myCol2, cex=1)
mtext(side=3, text="a)",line=-2, adj=0, outer=T) 


#next plot PCA 1 vs 2 and 2 vs 3
plot(pca1$scores[,1],pca1$scores[,2], col=myCol2, pch=19, cex=0.7,)
#myCol <- colorplot(pca1$scores[,1:2],pca1$scores[,1:2], transp=TRUE, cex=1)
abline(h=0,v=0, col="grey")
title(ylab="PCA2", xlab="PCA1")
mtext(side=1, text='PCA1', cex=0.81, line=2)
mtext(side=2, text='PCA2', cex=0.81, line=2)
mtext(side=3, text="b)", line=1, adj=-0.4) 


#Note you need to run the line the following line defining myCol2 to obtain colours for the group points
#but plot PCA 3 vs PCA2 using the plot function
#myCol2 <- colorplot(pca1$scores[,2:3],pca1$scores[,2:3],transp=TRUE, cex=1, ylab="PCA3", xlab="PCA2")


plot(pca1$scores[,3],pca1$scores[,2], col=myCol2, pch=19,cex=0.7,)

#text(pca1$scores[,3]~pca1$scores[,2], labels=rownames(pca1$scores), cex= 0.3, pos=pos_vector)
abline(h=0,v=0, col="grey")
mtext(side=1, text='PCA3', cex=0.81, line=2)
mtext(side=2, text='PCA2', cex=0.81, line=2)
mtext(side=3, text="c)", line=1, adj=-0.4) 

quartz.save("output/PCA_tree/PCA_tree_default_stacks2.pdf", type = "pdf", device = dev.cur(), dpi = 600)

dev.off()





###KMeans clustering: This is an interactive function.
#of assigning an individual sample to its genotype grouping. The maximum number of groups here is 18

#I'm trying to find the % of variance explained to justify my choice of 20 PC.
grp=find.clusters(mygenos36, clust=NULL, n.pca=NULL,n.clust=NULL, stat=c("BIC"),choose.n.clust=TRUE, criterion=c("diffNgroup"),max.n.clust=round(nInd(x)/2), n.iter=1e5,n.start=10,  scale=FALSE, pca.select=c("percVar"), perc.pca=NULL,glPca=NULL)
#This function called find.clusters
#here I keep 36 PC because there are not so many. I also keep 13 clusters because this is the lowest BIC value






# Here I play with a function to look at group assigment. It's not hugely informative so I dropped this.
#find.clusters() function.
#NOTE WHEN I set the pop to be 13 groups identified using the cluster, then the probabiltiy of membership is 100%
#so I dont think this is very informative. If I wanted probability of assigninment to region, then something informative happend
#I have left the pop groupings as regions. As is currently the case in the original data.
#in this case the probabiltiy of assignment was interesting but not hugely informative for the task at hand.
#Just for kicks I redid this with the region assignment while biking.
#mygenos36_for_group_assignment=mygenos36

#pop(mygenos36_for_group_assignment)=as.vector(unlist(grp[3]))
#pop(mygenos36_for_group_assignment)=mygenos36$pop




