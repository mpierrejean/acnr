library(R.utils);
library(aroma.light);

plotTracks <- FALSE

datPath <- "wholeGenomeData";
datPath <- Arguments$getReadablePath(datPath);

dataSet <- "GSE19539"
chipType <- "GenomeWideSNP_6"
path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

filenames <- list.files(path, pattern="TvsN.xdr")
filename <- filenames[2]
sampleName <- gsub("(.*)\\.xdr$", "\\1", filename)
print(sampleName)

pathname <- file.path(path, filename)
dat <- loadObject(pathname)
dat$posMb <- dat$x/1e6;
rm(filename, pathname)

## run TumorBoost
betaTN <- normalizeTumorBoost(betaT=dat$betaT,betaN=dat$betaN)
muN <- callNaiveGenotypes(dat$betaN)
dat.norm <- cbind(dat, muN, betaTN, b=2*abs(betaTN-1/2))

if (plotTracks) {
  ## some plots
  chrs <- sort(unique(dat.norm$chromosome))
  
  figPath <- "png/tracks"
  figPath <- Arguments$getWritablePath(figPath)
  
  for (cc in seq(along=chrs)) {
    chr <- chrs[cc]
    print(chr)
    
    datCC <- subset(dat.norm, chromosome==chr)
    
    figName <- sprintf("%s,chr%02d,tracks.png", sampleName, chr)
    pathname <- file.path(figPath, figName)
    
    png(pathname, width=1200, height=800)
    par(mfrow=c(2,1))
    plot(CT~posMb, data=datCC, cex=0.2, ylim=c(0,5), pch=19, xlab="position (Mb)", ylab="copy number")
    plot(betaTN~posMb, data=datCC, cex=0.2, ylim=c(0,1), pch=19, xlab="position (Mb)", ylab="B allele Fraction")
    dev.off()
  }
}
  
  
## regDat <- data.frame(type=c("normal", "gain", "loss", "cnloh"),
##                      chr=c(1, 1, 6, 21),
##                      begin=c(60, 160, 100, 15),
##                      end=c(120, Inf, Inf, Inf),
##                      stringsAsFactors=FALSE)
regDat <- data.frame(type=c("normal", "gain", "loss", "cnloh"),
                     chr=c(1, 1, 6, 21),
                     begin=c(60, 160, 100, 15),
                     end=c(100, 200, 140, Inf),
                     stringsAsFactors=FALSE)
str(regDat)

regPath <- "png/regions"
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
  datSS <- datRR[opos, c("CT", "betaTN", "muN")]
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
geno/matrix(colSums(geno), 4, 4, byrow=TRUE)

cMeans <- sapply(resList, FUN=function(dat) by(dat, dat$genotype, FUN=function(x) mean(x$c, na.rm=TRUE)))
cMeans

bMeans <- sapply(resList, FUN=function(dat) by(dat, dat$genotype, FUN=function(x) mean(2*abs(x$b-1/2), na.rm=TRUE)))
bMeans

if (FALSE) {
  plot(NA, xlim=c(1,4), ylim=range(cMeans))
  for (rr in 1:nrow(cMeans)) points(cMeans[rr, ], pch=19, cex=0.3, col=rr)
  plot(NA, xlim=c(1,4), ylim=range(bMeans))
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
