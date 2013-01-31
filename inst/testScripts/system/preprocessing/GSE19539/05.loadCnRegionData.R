library(R.utils);

regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

dataSet <- "GSE19539"
chipType <- "GenomeWideSNP_6"

path <- file.path(regPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

sampleName <- "IC288"
pattern <- sprintf("%s,TvsN,(.*).xdr", sampleName)
filenames <- list.files(path, pattern=pattern)
type <-gsub(pattern, "\\1", filenames)

pathnames <- file.path(path, filenames)
names(pathnames) <- type
datList <- lapply(pathnames, loadObject)
regDat <- NULL
for (dd in names(datList)) {
  datDD <- datList[[dd]]
  datDD$region <- dd
  regDat <- rbind(regDat, datDD)
}
str(regDat)

dsTag <- "ASCRMAv2";  ## todo: automatize this tag...
filename <- sprintf("%s,%s,%s,cnRegions.xdr", dataSet, dsTag, sampleName)
path <- "extdata/cnData"  ## points to inst/extdata/cnData
path <- Arguments$getWritablePath(path);

pathname <- file.path(path, filename)
saveObject(regDat, file=pathname)

