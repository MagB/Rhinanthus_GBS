library(ggplot2)

#this script summarizes read lengths, read counts and the last section does sample depth

#summarize read length count after demultiplexing:
read_lengths=read.table("output/read_lenght_counts_post_ustack/read_length_count_by_sample2.txt",header=F, sep=" ")
colnames(read_lengths)=c("read_count", "read_length", "sample_ID")

#how many reads were recovered in total?
HI.3644.007.Ensing1_R1.fastq=169881729
HI.3674.001.Ensing1_R1.fastq=169881729
total_read_count=sum(HI.3644.007.Ensing1_R1.fastq,HI.3674.001.Ensing1_R1.fastq)
total_read_count_after_demultiplexing=sum(read_lengths$read_count)
total_read_count_after_demultiplexing/total_read_count

#What's the max number of catalogs I expect to recover?
total_read_count/(10*96)
#353920.3 possible catalogs could be recovered assuming an average sample depth at a site of 10 reads, and
#if each sample has 10 reads at a site then if the stacks for each sample merge into a stack I could recover around 
#350K catalog sites. But some samples won't have overlaping catalogs. Some of these stacks and subsequent catalogs will be unusable



#What % of reads are assigned to an individual following demultiplexing?
total_read_count_after_demultiplexing/total_read_count

ggplot(read_lengths, aes(x = sample_ID, y = read_count)) + geom_bar(stat = "identity") +
        theme(axis.text = element_text(size=24),text=element_text(size=24),
                axis.text.x=element_blank(),
                panel.background=element_blank(),  
                axis.line = element_line(colour = "black"))+
      #  theme(axis.line.x = element_line(color="black"),
       #         axis.line.y = element_line(color="black"))+
        xlab("Sample") + ylab("Read count (millions of reads)") +
        scale_y_continuous(expand = c(0,0)) +
       # ggtitle("Average read number per sample following demultiplexing" )

new_name=paste(i,".pdf", sep="")


#Average number of reads per individual
mean(read_lengths$read_count, na.rm =T)
summary(read_lengths$read_count,digits=max(10, getOption("digits")))

#What is the CV of read counts? 
#CV is a good measure because it is unitless and independent of the mean, thereby making it comparable across studies with different units
#or for comparisons in studies with widely different means. 
CV <- function(average, stand_dev){
        (stand_dev/average)
}

CV(average = mean(read_lengths$read_count), stand_dev=sd(read_lengths$read_count))

#samples in the lowest quantile
read_lengths[read_lengths$read_count<2523975,c(1,3)]

#samples is highest quantile
read_lengths[read_lengths$read_count>4035963,c(1,3)]

file_list <- list.files(path="depth", pattern="*.txt", full.names=T, recursive=FALSE)
i="depth/2015SPLo16.matches.tsv_depth.txt"
#file_list is a list of files in the directory "depth". Each file is a distribution of the number of reads for each individual sample
#the following loop, reads each file sequentially and calculates for each file the mean depth of that sample
list_samp_mean={}
for( i in file_list){
        
       temp_file= read.table(i, header = T, sep=" ")
       #find mean depth
       if(i !="all_samples_depth.txt"){
               
       
       samp_mean=round(sum((temp_file$depth*temp_file$count))/sum(temp_file$count), digits=2)
       sample_name=unlist(strsplit(i,"matches.tsv"))
       sample_name2=unlist(strsplit(sample_name[1], "/"))
       title_name=paste(sample_name2[2], "mean=",samp_mean,  sep=" " )
       
       }  else{title_name=paste(i,samp_mean, sep=" " )}
       temp_plot=ggplot(temp_file, aes(x = depth, y = count)) + geom_bar(stat = "identity") +
                       theme(axis.text = element_text(size=14),text=element_text(size=15),
                               panel.background=element_blank(),  
                               axis.line = element_line(colour = "black"))+
                        xlab("Depth") + ylab("Count") +
                   
                       scale_y_continuous(expand = c(0,0)) +
                       scale_x_continuous(limits=c(0,100), breaks=seq(0,100,by=10)) +
                        ggtitle(title_name)
       
               new_name=paste(i,".pdf", sep="")
       ggsave(filename=new_name, plot=temp_plot,  device="pdf")

       list_samp_mean=rbind(list_samp_mean,c(sample_name2[2], samp_mean))
}
list_samp_mean=as.data.frame(list_samp_mean)
colnames(list_samp_mean)=c("Sample_ID", "Depth")
summary(list_samp_mean$Depth)
list_samp_mean$Depth=as.numeric(as.character(list_samp_mean$Depth))

#Average depth after applying 80% genotype at site filter:
samp_dep_filter=read.table("depth/depth_80_percent_genotypes_at_site.txt", header=T, sep=" ")

ggplot(samp_dep_filter, aes(x = Sample_ID, y = Avg_depth)) + geom_bar(stat = "identity") 

summary(samp_dep_filter$Avg_depth)

