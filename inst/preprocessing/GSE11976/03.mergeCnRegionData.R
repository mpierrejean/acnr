library("R.utils")
sf <- system.file("preprocessing/GSE11976/01.defineCopyNumberSegments.R", package="acnr")
source(sf)
str(regDat)

regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

dataSet <- "GSE11976,BAF"
chipType <- "HumanCNV370v1"

path <- file.path(regPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

sampleName <- "CRL2324"
pattern <- sprintf("%s,([0-9]+),\\(([0-9]),([0-9])\\).rds", sampleName)
filenames <- list.files(path, pattern=pattern)
pcts <- unique(gsub(pattern, "\\1", filenames))

savPath <- Arguments$getWritablePath("inst/extdata")

types <- regDat[["type"]]
datList <- list()

toExclude <- c("23", "45", "47") ## tumorFractions to exclude (clear inconsistencies between reported fraction and experimental results, see Table 3 in Staaf (2008))

for (pct in pcts) {
    if (pct %in% toExclude) {
        next;
    }
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

dsName <- "GSE11976_CRL2324"
filename <- sprintf("%s.rds", dsName)
pathname <- file.path(savPath, filename)
saveRDS(dat, file=pathname)
