# Here I explore patterns of IBS in NK and Kd transects only. 
#Note that you will have problems running the mantel test if the two matrices are not in the same order
#the point here is to look for a pattern between elevation and Fst

library(dplyr)
Distance=read.csv("/Users/Maggie/Documents/Rhinanthus/output/distances/Sample_Site_Details.csv",header=T)
head(Distance)
str(Distance)


#gotta order Distance 
target <- c( "APHi","APMd","HBLo","HBMd","KdHi","KdLo","KdMH","KdML","KoHi","NkNHi", "NkNLo", "NkNMH","NkNML","NkSHi", "NkSLo", "NkSMH", "NkSML" ,"PhoMH", "SPHi","SPLo","SPMd","SSHi","SSLo","SSMH" ,"SSML" )
Distance=Distance[match(target, Distance$site_id),]
Distance$site_id=as.character(Distance$site_id)
str(Distance)

Kd=Distance$site_id[grep("Kd",Distance$site_id)]
Nk=Distance$site_id[grep("Nk",Distance$site_id)]
sites=c(Kd, Nk)
Dave_Distance=filter(Distance, site_id %in% sites)


        
#propagate a distance matrix
Dave_elevation_matrix=matrix(0,ncol=12, nrow=12)
colnames(Dave_elevation_matrix)=Dave_Distance$site_id
rownames(Dave_elevation_matrix)=Dave_Distance$site_id

for(coli in colnames(Dave_elevation_matrix)){
        
        for(rowi in rownames(Dave_elevation_matrix)){
                elevation1=Dave_Distance$elevation[Dave_Distance$site_id==coli]
                elevation2=Dave_Distance$elevation[Dave_Distance$site_id==rowi]
                dist_calc=abs(elevation1-elevation2)
                Dave_elevation_matrix[rowi,coli]=dist_calc # Distance in km
        }
}

#Now propagate an Fst matrix
#PopGenReport matrix
Dave_Fst=read.csv("/Users/Maggie/Documents/Rhinanthus/output/popgenreport_output_Kd_Nk_only/results/PopGenReport-pairwise_Fst.csv", header=TRUE)
row.names(Dave_Fst)=colnames(Dave_Fst)[2:13]
Dave_Fst.matrix=matrix(0,ncol=12, nrow=12)
rownames(Dave_Fst.matrix)=rownames(Dave_elevation_matrix)
colnames(Dave_Fst.matrix)=colnames(Dave_elevation_matrix)

for(coli in colnames(Dave_Fst.matrix)){
        for(rowi in rownames(Dave_Fst.matrix)){
                Fst_calc=Dave_Fst[which(row.names(Dave_Fst)==rowi),which(colnames(Dave_Fst)==coli)]
                if(is.na(Fst_calc)==FALSE){Dave_Fst.matrix[rowi,coli]=Fst_calc }
                if(is.na(Fst_calc)==FALSE){Dave_Fst.matrix[coli,rowi]=Fst_calc }
                
        }
}


#pull in Fst matrix from stacks populations
Fst_stacks=read.csv("/Users/Maggie/Documents/Rhinanthus/output/populations_nov24_2016/batch_1.fst_summary.csv", header=T, sep=",")


Dave_Fst.matrix=matrix(0,ncol=12, nrow=12)
rownames(Dave_Fst.matrix)=rownames(Dave_elevation_matrix)
colnames(Dave_Fst.matrix)=colnames(Dave_elevation_matrix)


#in the distance matrix KobHi but in this Fst matrix it's KoHi
row.names(Fst_stacks)[row.names(Fst_stacks)=="KobHi"]="KoHi"
colnames(Fst_stacks)[colnames(Fst_stacks)=="KobHi"]="KoHi"

"NkSML" %in% row.names(Fst_stacks)


for(coli in colnames(Dave_Fst.matrix)){
       # coli="KdHi"
#        rowi="KdLo"
#        coli %in% colnames(Fst_stacks)
        
        for(rowi in rownames(Dave_Fst.matrix)){
                if(!(rowi %in% row.names(Fst_stacks))){next}
                Fst_calc=Fst_stacks[which(row.names(Fst_stacks)==rowi),which(colnames(Fst_stacks)==coli)]
                if(coli==rowi){Fst_calc=0}
                if(is.na(Fst_calc)){Fst_calc=Fst_stacks[which(row.names(Fst_stacks)==coli),which(colnames(Fst_stacks)==rowi)]}
                if(is.na(Fst_calc)==FALSE){Dave_Fst.matrix[rowi,coli]=Fst_calc } # Distance in km
                if(is.na(Fst_calc)==FALSE){  Dave_Fst.matrix[coli,rowi]=Fst_calc } # Distance in km
                
        }
}

#Mantel test
library(vegan)
#note both matrices have to be in same order
Dave_Mantel_Fst=mantel(Dave_elevation_matrix,Dave_Fst.matrix,method="spear",permutations=10000)
#Mantel statistic r: 0.1754 
#Significance: 0.09799 

# to plot the IBD pattern I need to make a rectangle dataframe
count=0
n=0
IBD_dave={}
for(coli in colnames(Dave_Fst.matrix)){
        n=n+1
        for(rowi in rownames(Dave_Fst.matrix)[n:length(rownames(Dave_Fst.matrix))]){
                if(coli==rowi){next}
                new_row=cbind(coli,rowi,Dave_Fst.matrix[coli,rowi],Dave_elevation_matrix[coli,rowi])
                print(new_row[1,])
                count=count+1
                IBD_dave=rbind(IBD_dave, new_row)
        }
}
IBD_dave=as.data.frame(IBD_dave)
colnames(IBD_dave)=c("site1", "site2", "Fst", "Km")
for(i in colnames(IBD_dave)){
        IBD_dave[,which(colnames(IBD_dave)==i)]=as.character(IBD_dave[,which(colnames(IBD_dave)==i)])
        if(i=="Fst") {IBD_dave[,which(colnames(IBD_dave)==i)]=as.numeric(IBD_dave[,which(colnames(IBD_dave)==i)])}
        if(i=="Km"){IBD_dave[,which(colnames(IBD_dave)==i)]=as.numeric(IBD_dave[,which(colnames(IBD_dave)==i)])}
}


#
library(ggplot2)
Dave_elevation_plot_all_comps=ggplot(IBD_dave, aes(x = IBD_dave$Km, y = IBD_dave$Fst))+
        geom_point(data = IBD_dave, aes(x = IBD_dave$Km, y = IBD_dave$Fst))+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("m") + 
        ylab("Fst")+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(0.5,0.5,0,0.5), "cm"),
                axis.text = element_text(size=12),
                axis.title=element_text(colour="black", size="12"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())

library(dplyr)
#within Kd only
Kd=Distance$site_id[grep("Kd",Distance$site_id)]
sites_kd =c(Kd)
IBD_dave_kd= IBD_dave %>% filter(site1 %in% sites_kd, site2 %in% sites_kd)

#NK only
Nk=Distance$site_id[grep("Nk",Distance$site_id)]
sites_Nk =c(Nk)
IBD_dave_Nk= IBD_dave %>% filter(site1 %in% sites_Nk, site2 %in% sites_Nk)

#NkN
NkN=Distance$site_id[grep("NkN",Distance$site_id)]
sites_NkN =c(NkN)
IBD_dave_NkN= IBD_dave %>% filter(site1 %in% sites_NkN, site2 %in% sites_NkN)

#NkS
NkS=Distance$site_id[grep("NkS",Distance$site_id)]
sites_NkS =c(NkS)
IBD_dave_NkS= IBD_dave %>% filter(site1 %in% sites_NkS, site2 %in% sites_NkS)

#plot Kd only
IBD_dave_kd$points_label=paste(IBD_dave_kd$site1, IBD_dave_kd$site2, sep="-")
library(ggplot2)
Dave_elevation_plot_Kd=ggplot(IBD_dave_kd, aes(x = IBD_dave_kd$Km, y = IBD_dave_kd$Fst, label=IBD_dave_kd$points_label))+
        #geom_point(data = IBD_dave_kd, aes(x = IBD_dave_kd$Km, y = IBD_dave_kd$Fst))+
        geom_text(size=6)+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        scale_x_continuous(limits = c(150,850))+
        xlab("Change in elevation (m)") + 
        ylab("Fst")+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(1,1,1,1), "cm"),
                axis.text = element_text(size=20),
                axis.title=element_text(colour="black", size="20"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())

Dave_elevation_plot_Kd_dots=ggplot(IBD_dave_kd, aes(x = IBD_dave_kd$Km, y = IBD_dave_kd$Fst, label=IBD_dave_kd$points_label))+
        geom_point(data = IBD_dave_kd, aes(x = IBD_dave_kd$Km, y = IBD_dave_kd$Fst))+
        #geom_text()+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("m") + 
        ylab("Fst")+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(0.5,0.5,0,0.5), "cm"),
                axis.text = element_text(size=12),
                axis.title=element_text(colour="black", size="12"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())

#Nk
IBD_dave_Nk$points_label=paste(IBD_dave_Nk$site1, IBD_dave_Nk$site2, sep="-")

Dave_elevation_plot_Nk=ggplot(IBD_dave_Nk, aes(x = IBD_dave_Nk$Km, y = IBD_dave_Nk$Fst, label=IBD_dave_Nk$points_label))+
        geom_point(data = IBD_dave_Nk, aes(x = IBD_dave_Nk$Km, y = IBD_dave_Nk$Fst))+
        #geom_text()+
         geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("m") + 
        ylab("Fst")+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(0.5,0.5,0,0.5), "cm"),
                axis.text = element_text(size=12),
                axis.title=element_text(colour="black", size="12"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())

#NkN
IBD_dave_NkN$points_label=paste(IBD_dave_NkN$site1, IBD_dave_NkN$site2, sep="-")

Dave_elevation_plot_NkN=ggplot(IBD_dave_NkN, aes(x = IBD_dave_NkN$Km, y = IBD_dave_NkN$Fst, label=IBD_dave_NkN$points_label))+
        #geom_point(data = IBD_dave_NkN, aes(x = IBD_dave_NkN$Km, y = IBD_dave_NkN$Fst))+
        geom_text(size=6)+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("Change in elevation (m)") + 
        ylab("Fst")+
        scale_x_continuous(limits = c(150,950))+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(1,1,1,1), "cm"),
                axis.text = element_text(size=20),
                axis.title=element_text(colour="black", size="20"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())

#NkS
IBD_dave_NkS$points_label=paste(IBD_dave_NkS$site1, IBD_dave_NkS$site2, sep="-")
Dave_elevation_plot_NkS=ggplot(IBD_dave_NkS, aes(x = IBD_dave_NkS$Km, y = IBD_dave_NkS$Fst, label = IBD_dave_NkS$points_label))+
       #geom_point(data = IBD_dave_NkS, aes(x = IBD_dave_NkS$Km, y = IBD_dave_NkS$Fst))+
        geom_text(size=6)+
         #geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("m") + 
        ylab("Fst")+
        scale_x_continuous(limits = c(150,950))+
        theme_bw() + #scale_x_continuous(limits = c(-2000,2000))+
        #  geom_text(data = data.frame(), aes(-1990, 2, label = "A"))+
        #top, right, bottom, and left margins
        theme(  plot.margin = unit(c(1,1,1,1), "cm"),
                axis.text = element_text(size=20),
                axis.title=element_text(colour="black", size="20"),
                axis.title.y=element_text(margin=margin(0,18,0,0)),
                axis.line = element_line(colour = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_rect(colour = "black"),
                panel.background = element_blank())
library(gridExtra)
library(grid)
require(cowplot)
grid.arrange(Dave_elevation_plot_Nk,Dave_elevation_plot_NkN,Dave_elevation_plot_NkS)
plot_grid(Dave_elevation_plot_Nk ,Dave_elevation_plot_NkN,Dave_elevation_plot_NkS,ncol = 1, nrow = 3)

setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Nk_IBD_elevation_nov_2016.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_elevation_plot_Nk ,Dave_elevation_plot_NkN,Dave_elevation_plot_NkS,ncol = 1, nrow = 3)
dev.off()

setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Nk_IBD_elevation_nov_2016.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_elevation_Nk ,Dave_elevation_plot_NkN,Dave_elevation_plot_NkS,ncol = 1, nrow = 3)
dev.off()


setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Kd_IBD_elevation_nov_2016.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_elevation_plot_Kd_dots ,Dave_elevation_plot_Kd,ncol = 1, nrow = 2)
dev.off()


