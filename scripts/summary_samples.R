library(xlsx)
library(dplyr)
rh=read.xlsx("/Users/Maggie/Dropbox/Dave Chris Maggie/Good_Samples_19April2016.xlsx",1)
str(rh)

rh %>% select(Site_ID, Year_collected, No) %>% group_by(Site_ID, Year_collected) %>% summarize_each(funs(n()))

rh_laval=read.xlsx("/Users/Maggie/Documents/Rhinanthus/data/Samples_sent_to_Laval_April_2016.xlsx",1)

site_names=c("Kd","NkN", "NkS", "APK", "APR", "HB", "Kob", "Pho", "SS", "SP")

Kd=rh_laval[grepl("Kd",rh_laval$Sample_name),]
nrow(Kd)
nrow(Kd[Kd$Year_collected==2014,])

NkN=rh_laval[grepl("NkN",rh_laval$Sample_name),]
nrow(NkN)
nrow(NkN[NkN$Year_collected==2014,])

NkS=rh_laval[grepl("NkS",rh_laval$Sample_name),]
nrow(NkS)
nrow(NkS[NkS$Year_collected==2014,])

nrow(rh_laval[rh_laval$Year_collected==2014,])

