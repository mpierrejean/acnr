library(R.utils)
source("01.defineCopyNumberSegments.R")
str(regDat)

datI <- readRDS("CRL2324_dilutionSeries.rds")
datI$posMb <- datI$Position/1e6;
## Define genotypes


pct <- c("100","79", "50", "34", "0") 
dataSet <- "CRL2324,BAF"
chipType <- "HumanCNV370v1"
savPath <- "cnRegionData"
savPath <- Arguments$getWritablePath(savPath)
path <- file.path(savPath, dataSet, chipType);
path <- Arguments$getWritablePath(path)
for(pp in pct){
    sampleName <- sprintf("CRL2324,BAF,%s",pp)
    for (rr in 1:nrow(regDat)) {
        chr <- regDat[rr, "chr"]
        reg <- c(regDat[rr, "begin"], regDat[rr, "end"])
        type <- regDat[rr, "type"]
        datCC <- subset(datI, chromosome==chr)
        datRR <- subset(datCC, posMb>=reg[1] & posMb<=reg[2])
        opos <- order(datRR$posMb)
        datRRo <- datRR[opos, ]
        datRRo <- na.omit(datRRo)
        
        columns <- c(sprintf("logR_%s",pp), sprintf("baf_%s",pp), "muN")
        datSS <- na.omit(datRRo[, columns])
        names(datSS) <- c("c","b","genotype")
        datSS$c <- 2^(datSS$c + 1)
        tgb <- tan(datSS$b*pi/2)
        datSS$b <- tgb/(1+tgb)
        datSS <- round(datSS, 3)
        filename <- sprintf("%s,%s.rds", sampleName, type)
        pathname <- file.path(path,filename)
        saveRDS(datSS, file=pathname)
    }
}
