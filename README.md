# Rhinanthus GBS project

#Currently, we are using the stacks pipeline created by the Catchen lab to call SNPs (http://catchenlab.life.illinois.edu/stacks/).

#The data represents Illumina Sequence Data obtained for a reduced representation genomic library sequenced at McGill.
##Here I present basic summary statistics on the quality of data we obtained from our first pass at generating GBS data for 96 samples.
##The GBS library was constructed using double digest with Pst1/Msp1 and was prepared at Laval University's IBIS centre. The sample DNA was pooled into a single GBS library and sequenced across 2 HiSeq Illumina lanes. We used stacks pipeline to obtain genotype calls. In this repo, you will find some of our preliminary analysis exploring the quality of those calls and performance of stacks. 
##I begin by exploring: 1. the coverage obtained after genotyping using stacks, 2. the number of genotype calls per sample and population and 3. The distribution of missing genotypes across sites, samples and populations. I also perform a few exploratory tests to see how altering a few of the parameters in stacks alters the number of loci and samples for which genotypes are obtained. The most striking result of this section is that although we obtained approx. 15000 loci most samples only have genotype calls for approx. 2000 loci and the overlap between samples and populations of sites with genotype calls is poor. This could be a problem with the coverage, the enzymes used or something else.
