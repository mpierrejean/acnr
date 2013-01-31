library(R.utils);
library(aroma.light);

if (FALSE) {
  ## Define CN regions:
  ## source("05.defineCopyNumberSegments.R")
  source("trunk/inst/testScripts/system/preprocessing/GSE29172/05.defineCopyNumberSegments.R")
  str(regDat)
}

datPath <- "wholeGenomeData";
datPath <- Arguments$getReadablePath(datPath);

dataSet <- "GSE29172,ASCRMAv2"
chipType <- "GenomeWideSNP_6"
path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

filenames <- list.files(path, pattern="H1395vsBL1395,([0-9]+).xdr")
kk <- grep(100, filenames)  ## pure tumor
filename <- filenames[kk]
sampleName <- gsub("(.*)\\.xdr$", "\\1", filename)
pathname <- file.path(path, filename)

print(sampleName)
pathname <- pathnames[kk];

dat <- loadObject(pathname)
dat$posMb <- dat$x/1e6;
rm(pathname)

## run TumorBoost
betaTN <- normalizeTumorBoost(betaT=dat$betaT,betaN=dat$betaN)
muN <- callNaiveGenotypes(dat$betaN)
dat.norm <- cbind(dat, muN, betaTN, b=2*abs(betaTN-1/2))

## some plots
chrs <- sort(unique(dat.norm$chromosome))
  
regPath <- "png/regions"
regPath <- file.path(regPath, dataSet)
regPath <- Arguments$getWritablePath(regPath)

savPath <- "cnRegionData"
savPath <- Arguments$getWritablePath(savPath)
path <- file.path(savPath, dataSet, chipType);
path <- Arguments$getWritablePath(path)

bkp <- function(pos) abline(v=pos, col=5, lwd=2)

resList <- NULL

for (rr in 1:nrow(regDat)) {
  chr <- regDat[rr, "chr"]
  reg <- c(regDat[rr, "begin"], regDat[rr, "end"])
  type <- regDat[rr, "type"]
  print(type)
  
  datCC <- subset(dat.norm, chromosome==chr)
  datRR <- subset(datCC, posMb>reg[1] & posMb<reg[2])
  str(datRR)
  
  figName <- sprintf("%s,chr%02d,%s-%s,%s.png", sampleName, chr, reg[1], reg[2], type)
  pathname <- file.path(regPath, figName)
  png(pathname, width=1200, height=900)
  par(mfrow=c(3,1))
  plot(CT~posMb, data=datRR, cex=0.2, ylim=c(0,5), pch=19, xlab="position (Mb)", ylab="copy number")
  plot(betaTN~posMb, data=datRR, cex=0.2, ylim=c(0,1), pch=19, xlab="position (Mb)", ylab="B allele Fraction (tumor)")
  plot(betaN~posMb, data=datRR, cex=0.2, ylim=c(0,1), pch=19, xlab="position (Mb)", ylab="B allele Fraction (normal)")
  dev.off()

  opos <- order(datRR$x)
  datRRo <- datRR[opos, ]

  figName <- sprintf("%s,chr%02d,%s-%s,%s,order.png", sampleName, chr, reg[1], reg[2], type)
  pathname <- file.path(regPath, figName)
  png(pathname, width=1200, height=900)
  par(mfrow=c(3,1))
  plot(datRRo$CT, cex=0.2, ylim=c(0,5), pch=19, xlab="position (order)", ylab="copy number")
  plot(datRRo$betaTN, cex=0.2, ylim=c(0,1), pch=19, xlab="position (order)", ylab="B allele Fraction (tumor)")
  plot(datRRo$betaN, cex=0.2, ylim=c(0,1), pch=19, xlab="position (order)", ylab="B allele Fraction (normal)")
  dev.off()

  datSS <- datRRo[, c("CT", "betaTN", "muN")]
  names(datSS) <- c("c","b","genotype")
  datSS <- round(datSS, 3)

  filename <- sprintf("%s,%s.xdr", sampleName, type)
  pathname <- file.path(path,filename)
  saveObject(datSS, file=pathname)

  resList[[type]] <- datSS
}

## Some statistics
geno <- sapply(resList, FUN=function(dat) table(dat$genotype, useNA="always"))
geno
geno/matrix(colSums(geno), nrow(geno), ncol(geno), byrow=TRUE)

cMeans <- sapply(resList, FUN=function(dat) by(dat, dat$genotype, FUN=function(x) mean(x$c, na.rm=TRUE)))
cMeans

bMeans <- sapply(resList, FUN=function(dat) by(dat, dat$genotype, FUN=function(x) mean(2*abs(x$b-1/2), na.rm=TRUE)))
bMeans

if (FALSE) {
  plot(NA, xlim=c(1, ncol(cMeans)), ylim=range(cMeans))
  for (rr in 1:nrow(cMeans)) points(cMeans[rr, ], pch=19, cex=0.3, col=rr)
  plot(NA, xlim=c(1, ncol(bMeans)), ylim=range(bMeans))
  for (rr in 1:nrow(bMeans)) points(bMeans[rr, ], pch=19, cex=0.3, col=rr)
}  

c1 <- cMeans*(1-bMeans)/2
c1
c2 <- cMeans*(1+bMeans)/2
c2

if (FALSE) {
  plot(bMeans[2,], ylim=c(0,1))
  plot(c1[2,], c2[2,], xlim=c(0,2), ylim=c(0,3))
}



