path <- system.file("testScripts/R", package="aroma.affymetrix");
pathname <- file.path(path, "downloadUtils.R");
source(pathname);

verbose && enter(verbose, "Downloading raw data");



##########################################################################
# Data set:
# GSE13372
#   GenomeWideSNP_6/
#    GSM337641.CEL, ..., GSM337708.CEL [68]
#
# Overall design:
#  21 replicates of HCC1143 (breast ductal carcinoma), 21 replicates of
#  HCC1143BL (matched normal), 13 replicates of HCC1954 (breast ductal
#  carcinoma), 11 replicates of HCC1954BL (matched normal), 1 replicate of
#  NCI-H2347 (lung adenocarcinoma), 1 replicate of NCI-H2347BL (matched normal)
#
# URL: http://www.ncbi.nlm.nih.gov/projects/geo/query/acc.cgi?acc=GSE13372
##########################################################################
dataSet <- "GSE13372";
chipType <- "GenomeWideSNP_6";

verbose && cat(verbose, "Data set: ", dataSet);

ds <- downloadGeoRawDataSet(dataSet, chipType=chipType, 
                   chipTypeAliases=c("GenomeWideEx_6"="GenomeWideSNP_6"));
print(ds);
## AffymetrixCelSet:
## Name: GSE13372
## Tags:
## Path: rawData/GSE13372/GenomeWideSNP_6
## Platform: Affymetrix
## Chip type: GenomeWideSNP_6
## Number of arrays: 68
## Names: GSM337641, GSM337642, GSM337643, ..., GSM337708 [68]
## Time period: 2007-05-17 16:13:28 -- 2008-09-11 21:06:39
## Total file size: 4480.08MB
## RAM: 0.07MB


verbose && exit(verbose);
