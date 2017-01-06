library("R.utils");

dataSet <- "GSE29172"
chipType <- "GenomeWideSNP_6"
sampleName <- "H1395vsBL1395"

## Define CN regions
regFile <- "05.defineCopyNumberSegments.R"
pn <- file.path("preprocessing", dataSet, regFile)
sf <- system.file(pn, package="acnr")
source(sf)
str(regDat)

regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

ds <- sprintf("%s,ASCRMAv2", dataSet)

path <- file.path(regPath, ds, chipType);
path <- Arguments$getReadablePath(path);

pattern <- sprintf("%s,([0-9]+),\\(([0-9]),([0-9])\\).rds", sampleName)
filenames <- list.files(path, pattern=pattern)
pcts <- unique(gsub(pattern, "\\1", filenames))

savPath <- Arguments$getWritablePath("inst/extdata")

types <- regDat[["type"]]
datList <- list()
for (pct in pcts) {
    print(pct)
    pattern <- sprintf("%s,%s,(.*).rds", sampleName, pct)
    filenames <- list.files(path, pattern=pattern)
    types <- gsub(pattern, "\\1", filenames)
    
    pathnames <- file.path(path, filenames)
    for (tt in seq(along=types)) {
        pathname <- pathnames[tt]
        typ <- types[tt]
        dat <- readRDS(pathname)
        dat$region <- typ
        dat$cellularity <- as.numeric(pct)/100
        tag <- sprintf("%s,%s", pct, typ)
        datList[[tag]] <- dat
    } 
}
dat <- do.call("rbind", datList)
rownames(dat) <- NULL
str(dat)

dsName <- "GSE29172_H1395"
filename <- sprintf("%s.rds", dsName)
pathname <- file.path(savPath, filename)
saveRDS(dat, file=pathname)
