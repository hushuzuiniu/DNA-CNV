library(numDeriv)
library(ABSOLUTE)
library(splitstackshape)
args<-commandArgs(T)
setwd(args[1])
RunAbsolute(seg.dat.fn = paste(args[2],"called.absolute.seg",sep="."),  min.ploidy = 0.5,  max.ploidy = 8,  max.sigma.h = 0.2,  platform = "Illumina_WES",  
            copy_num_type = "total",  sigma.p = 0,  
            results.dir = "./",  
            primary.disease = "NA",  
            sample.name = args[2],  max.as.seg.count = 1500,  max.non.clonal = 1,  max.neg.genome = 0.005)

load(paste(args[2],"ABSOLUTE.RData",sep="."))
write.table(seg.dat[["mode.res"]][["mode.tab"]],file=paste(args[2],"ABSOLUTE.purity_ploidy.xls",sep="."),sep="\t",col.names=TRUE)
