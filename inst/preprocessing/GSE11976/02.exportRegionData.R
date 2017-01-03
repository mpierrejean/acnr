sf <- system.file("preprocessing/GSE11976/01.defineCopyNumberSegments.R", package="acnr")
source(sf)
str(regDat)

dataSet <- "GSE11976"
chipType <- "HumanCNV370v1"

datPath <- "wholeGenomeData"; ## A symbolic link to "/home/share/Data/wholeGenomeData"
datPath <- Arguments$getReadablePath(datPath);
ds <- sprintf("%s,BeadStudio", dataSet)
path <- file.path(datPath, ds, chipType);
path <- Arguments$getReadablePath(path);

## read
fileName <- sprintf("CRL2324_dilutionSeries.rds", dataSet)
pathname <- file.path(path, fileName)
datI <- readRDS(pathname)

datI$posMb <- datI$position/1e6;
nms <- names(datI)[grep("^LRR", names(datI))]
pcts <- gsub("LRR_([0-9]+)", "\\1", nms)

sampleName <- "CRL2324"
savPath <- "cnRegionData"
savPath <- Arguments$getWritablePath(savPath)
path <- file.path(savPath, ds, chipType);
path <- Arguments$getWritablePath(path)

for (rr in 1:nrow(regDat)) {
    chr <- regDat[rr, "chr"]
    reg <- c(regDat[rr, "begin"], regDat[rr, "end"])
    type <- regDat[rr, "type"]
    datCC <- subset(datI, chromosome==chr)
    datRR <- subset(datCC, posMb>=reg[1] & posMb<=reg[2])
    opos <- order(datRR$posMb)
    datRRo <- datRR[opos, ]
    datRRo <- na.omit(datRRo)
        
    for(pp in pcts){
        cols <- c(sprintf("LRR_%s", pp), sprintf("BAF_%s", pp), "muN")
        datSS <- na.omit(datRRo[, cols])
        names(datSS) <- c("c","b","genotype")
        datSS$c <- 2^(datSS$c + 1)
        tgb <- tan(datSS$b*pi/2)
        datSS$b <- tgb/(1+tgb)
        datSS <- round(datSS, 3)
        filename <- sprintf("%s,%s,%s.rds", sampleName, pp, type)
        pathname <- file.path(path,filename)
        saveRDS(datSS, file=pathname)
    }
}
