install.packages("ggplot2")
library(ggplot2)
library(gridExtra)
library(grid)
het_homs_calls=read.table("output/summary_stats/Het_Hom_alt_Missing_counts_by_sample.txt", header=T, sep="\t")

summary(het_homs_calls)
#range of het proportion
summary(het_homs_calls$Prop_het)
#10 pop groups ignoring year and elevation
#organize samples into populations
Kidd=het_homs_calls[grepl("Kd",het_homs_calls$Sample_ID),]
NkN=het_homs_calls[grepl("NkN",het_homs_calls$Sample_ID),]
NkS=het_homs_calls[grepl("NkS",het_homs_calls$Sample_ID),]
APK=het_homs_calls[grepl("APK",het_homs_calls$Sample_ID),]
APR=het_homs_calls[grepl("APR",het_homs_calls$Sample_ID),]
HB=het_homs_calls[grepl("HB",het_homs_calls$Sample_ID),]
Kob=het_homs_calls[grepl("Kob",het_homs_calls$Sample_ID),]
Pho=het_homs_calls[grepl("Pho",het_homs_calls$Sample_ID),]
SP=het_homs_calls[grepl("SP",het_homs_calls$Sample_ID),]
SS=het_homs_calls[grepl("SS",het_homs_calls$Sample_ID),]


Kidd_plot=ggplot(Kidd, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Kidd")

NkN_plot=ggplot(NkN, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("NkN")

NkS_plot=ggplot(NkS, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("NkS")

APK_plot=ggplot(APK, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("APK")

APR_plot=ggplot(APR, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("APR")
                
HB_plot=ggplot(HB, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
    
          panel.background=element_blank(),  
                axis.line = element_line(colour = "black"))+
                theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
                ylab("Proportion heterozygote calls") +
                ggtitle("HB")

Kob_plot=ggplot(Kob, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Kob")
                
Pho_plot=ggplot(Pho, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
        axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Pho")

SP_plot=ggplot(SP, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x.x = element_text(size=14,angle = 270, hjust=1),

        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("SP")

SS_plot=ggplot(SS, aes(x = Sample_ID, y = Prop_het)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("SS")

grid.arrange(Kidd_plot,NkN_plot, ncol=1)
grid.arrange(NkS_plot, APK_plot, ncol=1)
grid.arrange( APR_plot, HB_plot, Kob_plot,Pho_plot, ncol=2)
grid.arrange(SP_plot, SS_plot, ncol=2)


#Proportion Alternate genotypes:

Kidd_plot=ggplot(Kidd, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Kidd")

NkN_plot=ggplot(NkN, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("NkN")
NkS_plot=ggplot(NkS, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("NkS")

APK_plot=ggplot(APK, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("APK")

APR_plot=ggplot(APR, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("APR")

HB_plot=ggplot(HB, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("HB")

Kob_plot=ggplot(Kob, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Kob")

Pho_plot=ggplot(Pho, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("Pho")

SP_plot=ggplot(SP, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x.x = element_text(size=14,angle = 270, hjust=1),
        
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("SP")

SS_plot=ggplot(SS, aes(x = Sample_ID, y = Prop_alt)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("Proportion heterozygote calls") +
        ggtitle("SS")

grid.arrange(Kidd_plot,NkN_plot, ncol=1)
grid.arrange(NkS_plot, APK_plot, ncol=1)
grid.arrange( APR_plot, HB_plot, Kob_plot,Pho_plot, ncol=2)
grid.arrange(SP_plot, SS_plot, ncol=2)

#distribution of SNP sites in each samples
pop_codes=c("Kd", "NkN", "NkS", "APK", "APR", "HB", "Kob", "Ph", "SP", "SS" )
sites=c("9359", "9359", "6317", "2227", "3050", "6074", "2362", "2071", "5547", "8844")
pop_sites=data.frame(pop_codes, sites)
pop_sites$sites=as.numeric(as.character(pop_sites$sites))
mean(pop_sites$sites)

ggplot(pop_sites, aes(x = pop_codes, y = sites)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(size=14,angle = 270, hjust=1),
        panel.background=element_blank(),  
        axis.line = element_line(colour = "black"))+
        theme(axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("# SNP sites") + xlab("Population")+
     #   ylim(0, 8000)+
        geom_hline(yintercept=5521)

#pairs <- read.table(pipe('pbpaste'),header=F, sep="")

colnames(pairs)
colnames(pairs)=c("pop1", "pop2", "shared_sites", "pop1_count", "pop2_count", "fraction_pop1", "fraction_pop2")

pairs[grepl("Kob",pairs$pop1) | grepl("Kob",pairs$pop2) ,]

#association between no samples at site and sample number
sites_no_data=read.table("output/summary_stats/missing_sites_by_pop.txt", header=F, sep="")
ggplot(sites_no_data, aes(x=V3, y=V2)) + geom_point()+
        theme( text = element_text(size=14),
                panel.background = element_blank(),
                axis.line.x = element_line(color="black"),
                axis.line.y = element_line(color="black"))+
        ylab("# sites with no data") + xlab("Sample size within pop")

