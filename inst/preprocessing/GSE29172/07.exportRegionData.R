library("R.utils");
library("aroma.light");

dataSet <- "GSE29172"
chipType <- "GenomeWideSNP_6"

if (FALSE) {
    ## Define CN regions:
    rpn <- sprintf("preprocessing/%s/05.defineCopyNumberSegments.R", dataSet)
    pn <- system.file(rpn, package="acnr")
    file.exists(pn)
    source(pn)
    str(regDat)
}

datPath <- "wholeGenomeData";
datPath <- Arguments$getReadablePath(datPath);

regPath <- "png/regions"
regPath <- file.path(regPath, dataSet)
regPath <- Arguments$getWritablePath(regPath)

savPath <- "cnRegionData"
savPath <- Arguments$getWritablePath(savPath)
opath <- file.path(savPath, sprintf("%s,ASCRMAv2", dataSet), chipType);
opath <- Arguments$getWritablePath(opath)

path <- file.path(datPath, sprintf("%s,ASCRMAv2", dataSet), chipType);
path <- Arguments$getReadablePath(path);

patt <- "H1395vsBL1395,([0-9]+).rds"
filenames <- list.files(path, pattern=patt)
pathnames <- file.path(path, filenames)
rm(path)
pct <- as.numeric(gsub(patt, "\\1", filenames))

for (kk in seq(along=pct)) {
    pathname <- pathnames[kk]
    sampleName <- gsub("(.*)\\.rds$", "\\1", filenames[kk])
    
    print(sampleName)
    
    dat <- loadObject(pathname)
    dat$posMb <- dat$x/1e6;
    rm(pathname)
    
    ## run TumorBoost
    betaTN <- normalizeTumorBoost(betaT=dat$betaT,betaN=dat$betaN)
    muN <- callNaiveGenotypes(dat$betaN)
    dat.norm <- cbind(dat, muN, betaTN, b=2*abs(betaTN-1/2))
    
    bkp <- function(pos) abline(v=pos, col=5, lwd=2)
    
    for (rr in 1:nrow(regDat)) {
        chr <- regDat[rr, "chr"]
        reg <- c(regDat[rr, "begin"], regDat[rr, "end"])
        type <- regDat[rr, "type"]
        print(type)
        
        datCC <- subset(dat.norm, chromosome==chr)
        minR <- reg[1]
        maxR <- reg[2]
        
        datRR <- subset(datCC, posMb>minR & posMb<maxR)
        str(datRR)
        
        opos <- order(datRR$x)
        datRRo <- datRR[opos, ]
        
        datSS <- datRRo[, c("CT", "betaTN", "muN", "betaT", "betaN")]
        names(datSS) <- c("c","b","genotype", "bT", "bN")
        datSS <- round(datSS, 3)
        
        filename <- sprintf("%s,%s.rds", sampleName, type)
        pathname <- file.path(opath, filename)
        saveRDS(datSS, file=pathname)
    }
}
