## Adapted from http://aroma-project.org/vignettes/PairedPSCBS-lowlevel

## source("02.doASCRMAv2.R")
ds <- res$total
print(ds)

sampleID <- c("IC288", "IC026")[1]
ids <- grep(sampleID, getNames(ds))
dsPT <- extract(res$total, ids)

## Naming
nms <- getNames(dsPT)
pattern <- "(GSM[0-9]+)_(IC[0-9]+)(T|N)"
type <- gsub(pattern, "\\3", nms)
sids <- gsub(pattern, "\\2", nms)
stopifnot(sids[1]==sids[2])
snames <- gsub(pattern, "\\1", nms)
stopifnot(snames[1]==snames[2])
pairName <- sprintf("%s,TvsN", sids[1])
print(pairName)

## Extract (total,beta) estimates for the tumor-normal pair
data <- extractPSCNArray(dsPT);
dimnames(data)[[3]] <- type;
str(data);

## Total CNs for the tumor relative to the matched normal
CT <- 2 * (data[,"total","T"] / data[,"total","N"]);

## Allele B fractions for the tumor
betaT <- data[,"fracB","T"];

## Allele B fractions for the normal
betaN <- data[,"fracB","N"];

## Get (chromosome, position) annotation data
ugp <- getAromaUgpFile(ds);
chromosome <- ugp[,1,drop=TRUE];
x <- ugp[,2,drop=TRUE];

## Setup data structure
df <- data.frame(chromosome=chromosome, x=x, CT=CT, betaT=betaT, betaN=betaN);

dfC <- subset(df, !is.na(df$chromosome) & !is.na(df$x))
str(dfC)

## save
datPath <- "wholeGenomeData";
## A symbolic link to "/home/share/Data/wholeGenomeData"
datPath <- Arguments$getWritablePath(datPath);
chipType <- getChipType(ds, full=FALSE)
path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getWritablePath(path);

fileName <- sprintf("%s.xdr", pairName)
pathname <- file.path(path, fileName)
saveObject(dfC, file=pathname)

## chromosome by chromosome
for (cc in 1:24) {
  fileName <- sprintf("%s,chr=%02d.xdr", pairName, cc)
  pathname <- file.path(path, fileName)
  saveObject(dfC, file=pathname)

  datCC <- subset(dfC, chromosome==cc)
  o <- order(datCC$x)
  datCC <- datCC[o, ]
  str(datCC)
  save(datCC, file=pathname)
}
