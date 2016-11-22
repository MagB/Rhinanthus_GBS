install.packages("xlsx")
install.packages("dplyr")
library(xlsx)
library(dplyr)
library(ggplot2)
pairwise_differences=read.xlsx("output/summary_stats/pairwise_differences.xlsx", header=T, 1)
pairwise_differences=read.csv("output/summary_stats/pairwise_differences.csv", header=T)

head(pairwise_differences)
str(pairwise_differences)
pairwise_differences$samp1=as.character(pairwise_differences$samp1)
pairwise_differences$samp2=as.character(pairwise_differences$samp2)

pairwise_differences=mutate(pairwise_differences, N_same=N_both_het+N_hom_hom_ref+N_hom_hom_alt, N_different=N_hom_het+N_hom_alt_hom_ref)

#avg distance to members of same pop , to other pops , to all samples

#each sample average to all other samples
i="2015KobHi14"
avg_distances_data_all={}
for(i in unique(c(pairwise_differences$samp1, pairwise_differences$samp2))){
        temp=pairwise_differences[pairwise_differences$samp1==i | pairwise_differences$samp2==i,  ]
        #I could also try doing a weighted contribution to differences?
        avg_distance_het_hom=mean(temp$N_hom_het)
        avg_distance_hom_alt=mean(temp$N_hom_alt_hom_ref)
        avg_distance_total=mean(temp$N_different)
        avg_num_where_both_have_data=mean(temp$num_sites_where_both_havedata)
        
        t=cbind(i, avg_distance_het_hom, avg_distance_hom_alt,avg_distance_total,avg_num_where_both_have_data)
        avg_distances_data_all=rbind(avg_distances_data_all, t)
}
avg_distances_data_all=as.data.frame(avg_distances_data_all)
colnames(avg_distances_data_all)=c("sample", "avg_distance_het_hom", "avg_distance_hom_alt","avg_distance_total","avg_num_where_both_have_data")
str(avg_distances_data_all)
avg_distances_data_all$avg_distance_het_hom=as.numeric(as.character(avg_distances_data_all$avg_distance_het_hom))
avg_distances_data_all$avg_distance_hom_alt=as.numeric(as.character(avg_distances_data_all$avg_distance_hom_alt))

avg_distances_data_all %>% summarise_each(funs(mean))
class(avg_distances_data_all)
#make new column of popnames


pop_name_list=c("Kob", "Kd", "SS","APR","SP","NkN","APK","NkS","HB","Ph")

avg_distances_data_within_pop={}
distances_data_within_pop={}
for(population_name in unique(c(pop_name_list))){
        
        temp=pairwise_differences[grep(population_name,pairwise_differences$samp1),]
        temp2=temp[grep(population_name, temp$samp2),]
        head(temp2)
        distances_data_within_pop=rbind(distances_data_within_pop, temp2)
        
        #I could also try doing a weighted contribution to differences?
        temp3=summarise_each(temp2, funs(mean))
        
        t=cbind(population_name, temp3[,3:12])
        avg_distances_data_within_pop=rbind(avg_distances_data_within_pop, t)
}

#2014NkSML2605TGCGA
#2014NkSML2605
pairwise_differences[pairwise_differences$samp1=="2014NkSML2605" & pairwise_differences$samp2=="2014NkSML2605TGCGA",]

pairwise_differences[pairwise_differences$samp1=="2014NkSML2605" & pairwise_differences$samp2=="2014NkSML2605TGCGA",]
NkS_dups=pairwise_differences %>% filter((grepl("NkS",samp1) & grepl("NkS",samp2)))
head(NkS_dups)
ggplot(NkS_dups,aes(N_hom_het)) +geom_histogram()+ geom_vline(xintercept=26) +
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.1),
                axis.line.y = element_line(color="black", size = 0.1))

ggplot(NkS_dups,aes(N_hom_alt_hom_ref)) +geom_histogram()+ geom_vline(xintercept=26) +
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.1),
                axis.line.y = element_line(color="black", size = 0.1))

#there are 133 differences these are het to hom and hom to hom differences between samples that are supposed to be identical
#but there are on average 78.16667 differences among samples within this population NKS, 47.73188 are hom to het and 30.43478 are hom to hom
#but within the two "duplicated samples" there are 107 het to hom differences and 26 hom to hom differences. 
#this suggests to me that either these two samples are not duplicates or we have high genotype calling errors. 
# to figure out if its genotype calling errors we could pull out those sites that are het to hom and see if coverage is different at those sites relative to where
#these two samples are homs 

avg_distances_data_within_pop %>% select(population_name, N_hom_het, N_hom_alt_hom_ref)


#avg distance betwwen pops
avg_distances_data_between_pop={}
distances_data_between_pop={}
#population_name="Kd"
population_name2="NkS"
for(population_name in unique(c(pop_name_list))){
        #pull out all comparisons between 2 pops
        temp= pairwise_differences %>% filter(grepl(population_name,samp1) | grepl(population_name,samp2))
        #remove within the same population comparison
        temp2= temp %>% filter(!(grepl(population_name,samp1) & grepl(population_name,samp2)))
        #now get the average distance of one pop to all others:
        
        
        #I have to pull out now current focal pop and get average fot that to each other pop one ata time
        for(population_name2 in unique(c(pop_name_list))){
                if(population_name==population_name2) next
                #pull out only data for population_name2
                temp3= temp2 %>% filter(grepl(population_name2,samp1) | grepl(population_name2,samp2))
                new_row1=cbind(population_name, population_name2,temp3)
                distances_data_between_pop=rbind(distances_data_between_pop, new_row1)
                
                temp4=temp3 %>% summarise_each(funs(mean))
                
                        
                temp5=temp3 %>% summarise(n=n())
                new_row=cbind(population_name, population_name2,temp4[3:length(temp4)], temp5)
                avg_distances_data_between_pop=rbind(avg_distances_data_between_pop, new_row)
                
        }
}

write.csv(avg_distances_data_between_pop, file = "output/avg_distances_data_between_pop.csv", row.names = FALSE)


head(distances_data_between_pop)
ggplot(distances_data_between_pop,aes(N_hom_het)) +geom_histogram()+ 
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.1),
                axis.line.y = element_line(color="black", size = 0.1))


ggplot(distances_data_between_pop,aes(N_hom_alt_hom_ref)) +geom_histogram()+ 
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.1),
                axis.line.y = element_line(color="black", size = 0.1))

#make overlapping distribution of het to hom differences
between_pop=distances_data_between_pop %>%  mutate(type_dist = "between") %>% select(type_dist,N_hom_het)
within_pop=distances_data_within_pop %>% mutate(type_dist = "within") %>% select(type_dist,N_hom_het)

joined_data=bind_rows(between_pop,within_pop)

ggplot(joined_data, aes(x=N_hom_het, fill=type_dist, color=type_dist)) + geom_histogram( position="identity", alpha=0.5)+
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.2),
                axis.line.y = element_line(color="black", size = 0.2))+
        scale_color_manual(values=c("#FF0000", "#0000FF"))+
        scale_fill_manual(values=c("#FF0000", "#0000FF"))


ggplot(joined_data, aes(x=N_hom_het, fill=type_dist, color=type_dist)) + geom_histogram(aes(y=..density..), position="identity", alpha=0.5)+
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.2),
                axis.line.y = element_line(color="black", size = 0.2))+
        scale_color_manual(values=c("#FF0000", "#0000FF"))+
        scale_fill_manual(values=c("#FF0000", "#0000FF"))

#make overlapping distribution of hom to hom differences
between_pop2=distances_data_between_pop%>%  mutate(type_dist = "between")  %>% select(type_dist,N_hom_alt_hom_ref)
within_pop2=distances_data_within_pop %>% mutate(type_dist = "within") %>% select(type_dist,N_hom_alt_hom_ref)

joined_data2=bind_rows(between_pop2,within_pop2)

ggplot(joined_data2, aes(x=N_hom_alt_hom_ref, fill=type_dist, color=type_dist)) + geom_histogram( position="identity", alpha=0.5)+
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.2),
                axis.line.y = element_line(color="black", size = 0.2))+
        scale_color_manual(values=c("#FF0000", "#0000FF"))+
        scale_fill_manual(values=c("#FF0000", "#0000FF"))


ggplot(joined_data2, aes(x=N_hom_alt_hom_ref, fill=type_dist, color=type_dist)) + geom_histogram(aes(y=..density..), position="identity", alpha=0.5)+
        theme_bw() + 
        theme(plot.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank() )+
        theme(panel.border= element_blank())+
        theme(axis.line.x = element_line(color="black", size = 0.2),
                axis.line.y = element_line(color="black", size = 0.2))+
        scale_color_manual(values=c("#FF0000", "#0000FF"))+
        scale_fill_manual(values=c("#FF0000", "#0000FF"))
