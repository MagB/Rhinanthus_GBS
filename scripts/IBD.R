Distance=read.csv("/Users/Maggie/Documents/Rhinanthus/output/distances/Sample_Site_Details.csv",header=T)
head(Distance)
str(Distance)

#gotta order Distance 
target <- colnames(Fst[2:26])
Distance=Distance[match(target, Distance$site_id),]

#propagate a distance matrix
distance_matrix=matrix(0,ncol=25, nrow=25)
colnames(distance_matrix)=Distance$site_id
rownames(distance_matrix)=Distance$site_id

#https://www.r-bloggers.com/great-circle-distance-calculations-in-r/
# Calculates the geodesic distance between two points specified by radian latitude/longitude using the
# Haversine formula (hf)
gcd.hf <- function(long1, lat1, long2, lat2) {
        R <- 6371 # Earth mean radius [km]
        delta.long <- (long2 - long1)
        delta.lat <- (lat2 - lat1)
        a <- sin(delta.lat/2)^2 + cos(lat1) * cos(lat2) * sin(delta.long/2)^2
        c <- 2 * asin(min(1,sqrt(a)))
        d = R * c
        return(d) # Distance in km
}
deg2rad <- function(deg) return(deg*pi/180)
gcd <- function(long1, lat1, long2, lat2) {
        # Convert degrees to radians
        long1 <- deg2rad(long1)
        lat1 <- deg2rad(lat1)
        long2 <- deg2rad(long2)
        lat2 <- deg2rad(lat2)
        return(haversine = gcd.hf(long1, lat1, long2, lat2) )
}


for(coli in colnames(distance_matrix)){

        for(rowi in rownames(distance_matrix)){
                long1=Distance$long[Distance$site_id==coli]
                long2=Distance$long[Distance$site_id==rowi]
                lat1=Distance$lat[Distance$site_id==coli]
                lat2=Distance$lat[Distance$site_id==rowi]
                dist_calc=gcd(long1, lat1, long2, lat2)
                distance_matrix[rowi,coli]=dist_calc # Distance in km
        }
}


class(distance_matrix)
#write.csv(distance_matrix, file="/Users/Maggie/Dropbox/AndyWong/1. Hierarchical Structure/Maggie_Hierarchy/data/Hierstruct_dist_matrix.csv")


#TRY DISTANCE BUT DISTANCE IN ELEVATION
elevation_matrix=matrix(0,ncol=25, nrow=25)
colnames(elevation_matrix)=Distance$site_id
rownames(elevation_matrix)=Distance$site_id

for(coli in colnames(elevation_matrix)){
        
        for(rowi in rownames(elevation_matrix)){
                elevation1=Distance$elevation[Distance$site_id==coli]
                elevation2=Distance$elevation[Distance$site_id==rowi]
                dist_calc=abs(elevation1-elevation2)
                elevation_matrix[rowi,coli]=dist_calc # Distance in km
        }
}


class(distance_matrix)

#pull in Fst matrix from stacks populations
Fst_stacks=read.csv("/Users/Maggie/Documents/Rhinanthus/output/populations_nov24_2016/batch_1.fst_summary.csv", header=T, sep=",")
Fst.matrix=matrix(0,ncol=25, nrow=25)
row.names(Fst_stacks)=Fst_stacks$X
colnames(Fst.matrix)=colnames(distance_matrix)
rownames(Fst.matrix)=colnames(distance_matrix)  
#in the distance matrix KobHi but in this Fst matrix it's KoHi
row.names(Fst_stacks)[row.names(Fst_stacks)=="KobHi"]="KoHi"
colnames(Fst_stacks)[colnames(Fst_stacks)=="KobHi"]="KoHi"

"NkSML" %in% row.names(Fst_stacks)


for(coli in colnames(Fst.matrix)){
        #coli="SSHi"
        #rowi="SSML"
        for(rowi in rownames(Fst.matrix)){
                if(!(rowi %in% row.names(Fst_stacks))){next}
                Fst_calc=Fst_stacks[which(row.names(Fst_stacks)==rowi),which(colnames(Fst_stacks)==coli)]
                if(is.na(Fst_calc)){Fst_calc=Fst_stacks[which(row.names(Fst_stacks)==coli),which(colnames(Fst_stacks)==rowi)]}
                if(is.na(Fst_calc)==FALSE){Fst.matrix[rowi,coli]=Fst_calc } # Distance in km
                if(is.na(Fst_calc)==FALSE){  Fst.matrix[coli,rowi]=Fst_calc } # Distance in km
                
        }
}

#Fst from popgenreport
Fst=read.csv("/Users/Maggie/Documents/Rhinanthus/output/popgenreport_output/results/PopGenReport-pairwise_Fst.csv", header=TRUE)
row.names(Fst)=colnames(Fst[2:26])
Fst.matrix=matrix(0,ncol=25, nrow=25)

colnames(Fst.matrix)=colnames(distance_matrix)
rownames(Fst.matrix)=colnames(distance_matrix)        

for(coli in colnames(Fst.matrix)){
        #coli="SSHi"
        #rowi="SSML"
        for(rowi in rownames(Fst.matrix)){
                Fst_calc=Fst[which(row.names(Fst)==rowi),which(colnames(Fst)==coli)]
                if(is.na(Fst_calc)==FALSE){Fst.matrix[rowi,coli]=Fst_calc } # Distance in km
                if(is.na(Fst_calc)==FALSE){  Fst.matrix[coli,rowi]=Fst_calc } # Distance in km
                
        }
}

#Need to make rectangle dataframe
count=0
n=0
IBD_rhina={}
for(coli in colnames(Fst.matrix)){
        n=n+1
        for(rowi in rownames(Fst.matrix)[n:length(rownames(Fst.matrix))]){
                if(coli==rowi){next}
                new_row=cbind(coli,rowi,Fst.matrix[coli,rowi],distance_matrix[coli,rowi])
                print(new_row[1,])
                count=count+1
                IBD_rhina=rbind(IBD_rhina, new_row)
        }
}
IBD_rhina=as.data.frame(IBD_rhina)

colnames(IBD_rhina)=c("site1", "site2", "Fst", "Km")
i="site1"
for(i in colnames(IBD_rhina)){
        IBD_rhina[,which(colnames(IBD_rhina)==i)]=as.character(IBD_rhina[,which(colnames(IBD_rhina)==i)])
        if(i=="Fst") {IBD_rhina[,which(colnames(IBD_rhina)==i)]=as.numeric(IBD_rhina[,which(colnames(IBD_rhina)==i)])}
        if(i=="Km"){IBD_rhina[,which(colnames(IBD_rhina)==i)]=as.numeric(IBD_rhina[,which(colnames(IBD_rhina)==i)])}
}


str(IBD_rhina)

library(vegan)
#note both matrices have to be in same order
Mantel_Fst=mantel(distance_matrix,Fst.matrix,method="spear",permutations=10000)
#Results:
#Mantel statistic r: 0.2518 
#Significance: 0.0031997

#for Kd only
elevation_matrix
KD_matrix=elevation_matrix[rownames(elevation_matrix) %in%]
MAntel_Fst_elevation=mantel(elevation_matrix,Fst.matrix,method="spear",permutations=10000)
#Mantel statistic r: -0.03859 
#Significance: 0.68693 

#Save the permuted correlation coefficients. These saved correlations will be used to make a plot
#of the distribution of permuted r values. This is Supplemental Figure 2
Mantel_Fst_perm_r=as.data.frame(Mantel_Fst$perm)
Mantel_Fst_perm_r=rbind(Mantel_Fst_perm_r,Mantel_Fst$statistic )

colnames(Mantel_Fst_perm_r)="permuted_r"

write.csv(Mantel_Morph_perm_r, "/Users/Maggie/Dropbox/AndyWong/1. Hierarchical Structure/Maggie_Hierarchy/Figures/Supplemental_Figure_2_Mantel_test/Mantel_Morph.csv")





#PLOT
library(ggplot2)
#plot
IBD_rhinanthis_plot1=ggplot(IBD_rhina, aes(x = IBD_rhina$Km, y = IBD_rhina$Fst))+
        geom_point(data = IBD_rhina, aes(x = IBD_rhina$Km, y = IBD_rhina$Fst))+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("Km") + 
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

IBD_rhina_Alberta=IBD_rhina[IBD_rhina$Km<5000,]

IBD_rhinanthis_plot2=ggplot(IBD_rhina_Alberta, aes(x = IBD_rhina_Alberta$Km, y = IBD_rhina_Alberta$Fst))+
        geom_point(data = IBD_rhina_Alberta, aes(x = IBD_rhina_Alberta$Km, y = IBD_rhina_Alberta$Fst))+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("Km") + 
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
Kd=IBD_rhina$site1[grep("Kd",IBD_rhina$site1)]
Nk=IBD_rhina$site1[grep("Nk",IBD_rhina$site1)]
sites=c(Kd, Nk)
IBD_rhina_Dave_temp=filter(IBD_rhina, site1 %in% sites, site2 %in% sites)


IBD_rhinanthis_plot3=ggplot(IBD_rhina_Dave_temp, aes(x = IBD_rhina_Dave_temp$Km, y = IBD_rhina_Dave_temp$Fst))+
        geom_point(data = IBD_rhina_Dave_temp, aes(x = IBD_rhina_Dave_temp$Km, y = IBD_rhina_Dave_temp$Fst))+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("Km") + 
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

#Now do Fst by Elevation

