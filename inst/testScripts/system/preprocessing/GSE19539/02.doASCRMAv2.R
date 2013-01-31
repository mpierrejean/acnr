## Required local file structure:
## (see http://aroma-project.org/setup for details)
## 
## rawData/
##   GSE19539/
##     GenomeWideSNP_6/
##       GSM492520_IC434N.CEL
##       GSM492520_IC434T.CEL
##       GSM492522_IC487N.CEL
##       GSM492522_IC487T.CEL
##       ...
## totalAndFracBData/
##   GSE19539,ACC,ra,-XY,BPN,-XY,AVG,FLN,-XY/
##     GenomeWideSNP_6/
##       GSM492520_IC434N,fracB.asb
##       GSM492520_IC434N,total.asb
##       GSM492520_IC434T,fracB.asb
##       GSM492520_IC434T,total.asb
##       ...


library("aroma.affymetrix")
log <- verbose <- Arguments$getVerbose(-8, timestamp=TRUE)
options(digits=4) # Don't display too many decimals.

## Setup raw data set
cdf <- AffymetrixCdfFile$byChipType("GenomeWideSNP_6", tags="Full")
print(cdf)

dataSet <- "GSE19539"
## dataSet <- "GSE19539,subset"

csR <- AffymetrixCelSet$byName(dataSet, cdf=cdf)
print(csR)

res <- doASCRMAv2(csR, verbose=verbose)
