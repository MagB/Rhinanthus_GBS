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

head(Dave_Distance)
#propagate a distance matrix
distance_matrix_dave=matrix(0,ncol=12, nrow=12)
colnames(distance_matrix_dave)=Dave_Distance$site_id
rownames(distance_matrix_dave)=Dave_Distance$site_id

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


for(coli in colnames(distance_matrix_dave)){
        
        for(rowi in rownames(distance_matrix_dave)){
                long1=Dave_Distance$long[Dave_Distance$site_id==coli]
                long2=Dave_Distance$long[Dave_Distance$site_id==rowi]
                lat1=Dave_Distance$lat[Dave_Distance$site_id==coli]
                lat2=Dave_Distance$lat[Dave_Distance$site_id==rowi]
                dist_calc=gcd(long1, lat1, long2, lat2)
                distance_matrix_dave[rowi,coli]=dist_calc # Distance in km
        }
}

#Now propagate an Fst matrix

Dave_Fst=read.csv("/Users/Maggie/Documents/Rhinanthus/output/popgenreport_output_Kd_Nk_only/results/PopGenReport-pairwise_Fst.csv", header=TRUE)
row.names(Dave_Fst)=colnames(Dave_Fst)[2:13]
Dave_Fst.matrix=matrix(0,ncol=12, nrow=12)
rownames(Dave_Fst.matrix)=row.names(Dave_Fst)
colnames(Dave_Fst.matrix)=colnames(Dave_Fst)[2:13]

for(coli in colnames(Dave_Fst.matrix)){
        for(rowi in rownames(Dave_Fst.matrix)){
                Fst_calc=Dave_Fst[which(row.names(Dave_Fst)==rowi),which(colnames(Dave_Fst)==coli)]
                if(is.na(Fst_calc)==FALSE){Dave_Fst.matrix[rowi,coli]=Fst_calc }
                if(is.na(Fst_calc)==FALSE){Dave_Fst.matrix[coli,rowi]=Fst_calc }
                
        }
}



#Mantel test
library(vegan)
#note both matrices have to be in same order
Dave_Mantel_Fst=mantel(distance_matrix_dave,Dave_Fst.matrix,method="spear",permutations=10000)
#Mantel statistic r: 0.1754 
#Significance: 0.09799 

# to plot the IBD pattern I need to make a rectangle dataframe
count=0
n=0
IBD_dave_euclid={}
for(coli in colnames(Dave_Fst.matrix)){
        n=n+1
        for(rowi in rownames(Dave_Fst.matrix)[n:length(rownames(Dave_Fst.matrix))]){
                if(coli==rowi){next}
                new_row=cbind(coli,rowi,Dave_Fst.matrix[coli,rowi],distance_matrix_dave[coli,rowi])
                print(new_row[1,])
                count=count+1
                IBD_dave_euclid=rbind(IBD_dave_euclid, new_row)
        }
}
IBD_dave_euclid=as.data.frame(IBD_dave_euclid)
colnames(IBD_dave_euclid)=c("site1", "site2", "Fst", "Km")
for(i in colnames(IBD_dave_euclid)){
        IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)]=as.character(IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)])
        if(i=="Fst") {IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)]=as.numeric(IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)])}
        if(i=="Km"){IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)]=as.numeric(IBD_dave_euclid[,which(colnames(IBD_dave_euclid)==i)])}
}


#
library(ggplot2)
Dave_euclid_plot_all_comps=ggplot(IBD_dave_euclid, aes(x = IBD_dave_euclid$Km, y = IBD_dave_euclid$Fst))+
        geom_point(data = IBD_dave_euclid, aes(x = IBD_dave_euclid$Km, y = IBD_dave_euclid$Fst))+
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

#within Kd only
Kd=Distance$site_id[grep("Kd",Distance$site_id)]
sites_kd =c(Kd)
IBD_dave_euclid_Kd= IBD_dave_euclid %>% filter(site1 %in% sites_kd, site2 %in% sites_kd)

#NK only
Nk=Distance$site_id[grep("Nk",Distance$site_id)]
sites_Nk =c(Nk)
IBD_dave_euclid_Nk= IBD_dave_euclid %>% filter(site1 %in% sites_Nk, site2 %in% sites_Nk)

#NkN
NkN=Distance$site_id[grep("NkN",Distance$site_id)]
sites_NkN =c(NkN)
IBD_dave_euclid_NkN= IBD_dave_euclid %>% filter(site1 %in% sites_NkN, site2 %in% sites_NkN)

#NkS
NkS=Distance$site_id[grep("NkS",Distance$site_id)]
sites_NkS =c(NkS)
IBD_dave_euclid_NkS= IBD_dave_euclid %>% filter(site1 %in% sites_NkS, site2 %in% sites_NkS)

#plot Kd only
IBD_dave_euclid_Kd$points_label=paste(IBD_dave_euclid_Kd$site1, IBD_dave_euclid_Kd$site2, sep="-")

Dave_euclid_plot_Kd=ggplot(IBD_dave_euclid_Kd, aes(x = IBD_dave_euclid_Kd$Km, y = IBD_dave_euclid_Kd$Fst, label=IBD_dave_euclid_Kd$points_label))+
        #geom_point(data = IBD_dave_kd, aes(x = IBD_dave_kd$Km, y = IBD_dave_kd$Fst))+
        geom_text()+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("km") + 
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

Dave_euclid_plot_Kd_dots=ggplot(IBD_dave_euclid_Kd, aes(x = IBD_dave_euclid_Kd$Km, y = IBD_dave_euclid_Kd$Fst, label=IBD_dave_euclid_Kd$points_label))+
        geom_point(data = IBD_dave_euclid_Kd, aes(x = IBD_dave_euclid_Kd$Km, y = IBD_dave_euclid_Kd$Fst))+
        #geom_text()+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("km") + 
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
IBD_dave_euclid_Nk$points_label=paste(IBD_dave_euclid_Nk$site1, IBD_dave_euclid_Nk$site2, sep="-")

Dave_euclid_plot_Nk=ggplot(IBD_dave_Nk, aes(x = IBD_dave_euclid_Nk$Km, y = IBD_dave_euclid_Nk$Fst, label=IBD_dave_euclid_Nk$points_label))+
        geom_point(data = IBD_dave_euclid_Nk, aes(x = IBD_dave_euclid_Nk$Km, y = IBD_dave_euclid_Nk$Fst))+
        #geom_text()+
        #  geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("km") + 
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
IBD_dave_euclid_NkN$points_label=paste(IBD_dave_euclid_NkN$site1, IBD_dave_euclid_NkN$site2, sep="-")

Dave_euclid_plot_NkN=ggplot(IBD_dave_euclid_NkN, aes(x = IBD_dave_euclid_NkN$Km, y = IBD_dave_euclid_NkN$Fst, label=IBD_dave_euclid_NkN$points_label))+
        geom_point(data = IBD_dave_euclid_NkN, aes(x = IBD_dave_euclid_NkN$Km, y = IBD_dave_euclid_NkN$Fst))+
        # geom_text()+
        # geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("km") + 
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

#NkS
IBD_dave_euclid_NkS$points_label=paste(IBD_dave_euclid_NkS$site1, IBD_dave_euclid_NkS$site2, sep="-")
Dave_euclid_plot_NkS=ggplot(IBD_dave_euclid_NkS, aes(x = IBD_dave_euclid_NkS$Km, y = IBD_dave_euclid_NkS$Fst, label = IBD_dave_euclid_NkS$points_label))+
        geom_point(data = IBD_dave_euclid_NkS, aes(x = IBD_dave_euclid_NkS$Km, y = IBD_dave_euclid_NkS$Fst))+
        #geom_text()+
        #geom_smooth(method='lm',formula=y~x,se=FALSE)+
        xlab("km") + 
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
library(gridExtra)
library(grid)
require(cowplot)
grid.arrange(Dave_euclid_plot_Nk,Dave_euclid_plot_NkN,Dave_euclid_plot_NkS)
plot_grid(Dave_euclid_plot_Nk ,Dave_euclid_plot_NkN,Dave_euclid_plot_NkS,ncol = 1, nrow = 3)

setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Nk_IBD_euclid_nov_2016.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_euclid_plot_Nk ,Dave_euclid_plot_NkN,Dave_euclid_plot_NkS,ncol = 1, nrow = 3)
dev.off()

setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Nk_IBD_euclid_nov_2016_w_dots.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_euclid_plot_Nk ,Dave_euclid_plot_NkN,Dave_euclid_plot_NkS,ncol = 1, nrow = 3)
dev.off()


setEPS()
postscript(file="/Users/Maggie/Documents/Rhinanthus/output/IBD_plots/Kd_IBD_euclid_nov_2016.eps",  bg = "transparent", family="Helvetica",width=10, height=15)
#par(mar = c(4, 4, 4, 4)) 
plot_grid(Dave_euclid_plot_Kd_dots ,Dave_euclid_plot_Kd,ncol = 1, nrow = 2)
dev.off()


