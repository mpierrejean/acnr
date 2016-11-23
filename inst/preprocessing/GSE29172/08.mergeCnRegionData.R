library("R.utils");

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

regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

ds <- sprintf("%s,ASCRMAv2", dataSet)
chipType <- "GenomeWideSNP_6"

path <- file.path(regPath, ds, chipType);
path <- Arguments$getReadablePath(path);

sampleName <- "H1395vsBL1395"
pattern <- sprintf("%s,([0-9]+),\\(([0-9]),([0-9])\\).rds", sampleName)
filenames <- list.files(path, pattern=pattern)
pcts <- unique(gsub(pattern, "\\1", filenames))

savPath <- file.path("extdata", "GSE29172", chipType)
savPath <- Arguments$getWritablePath(savPath);
  
types <- regDat[["type"]]
for (pct in pcts) {
  print(pct)
  pattern <- sprintf("H1395vsBL1395,%s,(.*).rds", pct)
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
  rownames(dat) <- NULL
  filename <- sprintf("%s,%s,%s,cnRegions.rds", ds, sampleName, pct)
  pathname <- file.path(savPath, filename)
  saveRDS(dat, file=pathname)
}


