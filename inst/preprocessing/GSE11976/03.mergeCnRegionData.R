library(R.utils)
source("trunk/inst/testScripts/system/preprocessing/GSE11976/01.defineCopyNumberSegments.R")
str(regDat)


regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

dataSet <- "CRL2324,BAF"
chipType <- "HumanCNV370v1"

path <- file.path(regPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

sampleName <- "CRL2324,BAF"
pattern <- sprintf("%s,([0-9]+),\\(([0-9]),([0-9])\\).rds", sampleName)
filenames <- list.files(path, pattern=pattern)
pcts <- unique(gsub(pattern, "\\1", filenames))

savPath <- file.path("extdata", "GSE11976", chipType)
savPath <- Arguments$getWritablePath(savPath);

types <- regDat[["type"]]
pct <- c("100","79", "50", "34", "0") 
for (pp in pct) {
    print(pp)
    pattern <- sprintf("CRL2324,BAF,%s,(.*).rds", pp)
    filenames <- list.files(path, pattern=pattern)
    types <- gsub(pattern, "\\1", filenames)
    
    pathnames <- file.path(path, filenames)
    names(pathnames) <- types
    datList <- lapply(pathnames, readRDS)
    dat <- NULL
    for (dd in names(datList)) {
        datDD <- datList[[dd]]
        datDD$region <- dd
        dat <- rbind(dat, datDD)
    }
    str(dat)

    filename <- sprintf("%s,%s,cnRegions.rds", dataSet, pp)
    pathname <- file.path(savPath, filename)
    saveRDS(dat, file=pathname)
}


