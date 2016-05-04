library(R.utils);

if (FALSE) {
  ## Define CN regions:
  ## source("05.defineCopyNumberSegments.R")
  source("trunk/inst/testScripts/system/preprocessing/GSE29172/05.defineCopyNumberSegments.R")
  str(regDat)
}

regPath <- "cnRegionData";
regPath <- Arguments$getReadablePath(regPath);

dataSet <- "GSE13372,ASCRMAv2"
chipType <- "GenomeWideSNP_6"


path <- file.path(regPath, dataSet, chipType);
path <- Arguments$getReadablePath(path);

sampleName <- "HCC1143_GLEYSvsHCC1143BL_GLEYS"
pattern <- sprintf("%s,([0-9]+),\\(([0-9]),([0-9])\\).rds", sampleName)
filenames <- list.files(path, pattern=pattern)
pcts <- unique(gsub(pattern, "\\1", filenames))

savPath <- file.path("extdata", "GSE13372", chipType)
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
  filename <- sprintf("%s,%s,%s,cnRegions.rds", dataSet, sampleName, pct)
  pathname <- file.path(savPath, filename)
  saveRDS(dat, file=pathname)
}


