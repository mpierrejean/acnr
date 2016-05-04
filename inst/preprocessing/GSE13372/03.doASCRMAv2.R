##########################################################################
# Allele-specific CRMAv2
##########################################################################
library("aroma.affymetrix");
verbose <- Arguments$getVerbose(-8, timestamp=TRUE);


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dataSet <- "GSE13372";
chipType <- "GenomeWideSNP_6,Full";

cdf <- AffymetrixCdfFile$byChipType("GenomeWideSNP_6", tags="Full")
print(cdf)

csR <- AffymetrixCelSet$byName(dataSet, chipType=chipType, cdf=cdf);
print(csR);


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# AS-CRMAv2
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
nn <- names(csR)
resR <- doASCRMAv2(csR[which(nn=="GSM337641")], verbose=verbose);
resN <- doASCRMAv2(csR[which(nn=="GSM337663")], verbose=verbose);
resRef <- doASCRMAv2(csR[which(nn=="GSM337662")], verbose=verbose);
