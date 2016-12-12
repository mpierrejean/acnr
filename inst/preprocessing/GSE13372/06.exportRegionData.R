library(R.utils);

if (FALSE) {
  ## Define CN regions:
  ## source("05.defineCopyNumberSegments.R")
  source("trunk/inst/testScripts/system/preprocessing/GSE13372/05.defineCopyNumberSegments.R")
  str(regDat)
}

datPath <- "wholeGenomeData";
datPath <- Arguments$getReadablePath(datPath);

dataSet <- "GSE13372,ASCRMAv2"
chipType <- "GenomeWideSNP_6"

path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

filenames <- list.files(path, pattern="HCC1143_GLEYSvsHCC1143BL_GLEYS,([0-9]+).rds")
sampleNames <- gsub("(.*)\\.rds$", "\\1", filenames)

pathnames <- file.path(path, filenames)

for (kk in seq(along=filenames)) {
  filename <- filenames[kk]
  sampleName <- gsub("(.*)\\.rds$", "\\1", filename)
  pathname <- file.path(path, filename)
  
  print(sampleName)
  pathname <- pathnames[kk];
  
  dat <- readRDS(pathname)
  dat$posMb <- dat$x/1e6;
  rm(pathname)
  
  ## run TumorBoost
  betaTN <- normalizeTumorBoost(betaT=dat$betaT,betaN=dat$betaN)
  muN <- callNaiveGenotypes(dat$betaN)
  dat.norm <- cbind(dat, muN, betaTN, b=2*abs(betaTN-1/2))
  
  regPath <- "png/regions"
  regPath <- file.path(regPath, dataSet)
  regPath <- Arguments$getWritablePath(regPath)
  
  savPath <- "cnRegionData"
  savPath <- Arguments$getWritablePath(savPath)
  path <- file.path(savPath, dataSet, chipType);
  path <- Arguments$getWritablePath(path)
  
  bkp <- function(pos) abline(v=pos, col=5, lwd=2)
  
  for (rr in 1:nrow(regDat)) {
    chr <- regDat[rr, "chr"]
    reg <- c(regDat[rr, "begin"], regDat[rr, "end"])
    type <- regDat[rr, "type"]
    print(type)
    
    datCC <- subset(dat.norm, chromosome==chr)
    datRR <- subset(datCC, posMb>reg[1] & posMb<reg[2])
    str(datRR)
    
    opos <- order(datRR$x)
    datRRo <- datRR[opos, ]
    
    datSS <- datRRo[, c("CT", "betaTN", "muN", "betaT", "betaN")]
    names(datSS) <- c("c","b","genotype", "bT","bN")
    datSS <- round(datSS, 3)
    
    filename <- sprintf("%s,%s.rds", sampleName, type)
    pathname <- file.path(path,filename)
    saveRDS(datSS, file=pathname)
  }
}
