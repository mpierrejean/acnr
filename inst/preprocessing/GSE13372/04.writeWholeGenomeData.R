## Adapted from http://aroma-project.org/vignettes/PairedPSCBS-lowlevel
library("aroma.affymetrix")

dataSet <- "GSE13372";
chipType <- "GenomeWideSNP_6"

tags <- "ACC,ra,-XY,BPN,-XY,AVG,FLN,-XY"
ds <- AromaUnitTotalCnBinarySet$byName(dataSet, tags=tags, chipType=chipType)
length(ds)

## Extract only one tumor and two matching normals
nms <- c(T="GSM337641", N="GSM337662", R="GSM337663")
dsE <- extract(ds, indexOf(ds, nms))
tumorName <- "HCC1143_GLEYS"
normalName <- "HCC1143BL_GLEYS"
sampleName <- "HCC1143"

## Naming
## Extract (total,beta) estimates for the tumor-normal pair
dat <- extractPSCNArray(dsE);
dn3 <- dimnames(dat)[[3]]
dimnames(dat)[[3]] <- names(nms)[match(dn3, nms)]

## Get (chromosome, position) annotation data
ugp <- getAromaUgpFile(dsE);
chromosome <- ugp[,1,drop=TRUE];
x <- ugp[,2,drop=TRUE];

## Total intensities and Allele B fractions for the normal
thetaN <- dat[,"total", "R"];
betaN <- dat[,"fracB", "R" ];

datPath <- "wholeGenomeData";
datPath <- Arguments$getWritablePath(datPath);
chipType <- getChipType(dsT, full=FALSE)
dsName <- getName(dsT)
dataSet <- sprintf("%s,ASCRMAv2", dataSet)
path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getWritablePath(path);


idxs <- c("N", "T")
for (ss in idxs) {
    if (ss == "N") {
        pairName <- sprintf("%svs%s,0", tumorName, normalName)
    } else if (ss=="T") {
        pairName <- sprintf("%svs%s,100", tumorName, normalName)
    }
    ## Total CNs for the tumor relative to the matched normal
    CT <- 2 * dat[,"total", ss] / thetaN;
    
    ## Allele B fractions for the tumor
    betaT <- dat[,"fracB", ss];
    
    ## Setup data structure
    df <- data.frame(chromosome=chromosome, x=x, CT=CT, betaT=betaT, betaN=betaN);

    dfC <- subset(df, !is.na(df$chromosome) & !is.na(df$x))
    str(dfC)
    
    ## save  
    fileName <- sprintf("%s.rds", pairName)
    pathname <- file.path(path, fileName)
    saveRDS(dfC, file=pathname)
    
    ## chromosome by chromosome
    if (FALSE) {
        for (cc in 1:24) {
            print(cc)
            fileName <- sprintf("%s,chr=%02d.rds", pairName, cc)
            pathname <- file.path(path, fileName)
            saveRDS(dfC, file=pathname)
            
            datCC <- subset(dfC, chromosome==cc)
            o <- order(datCC$x)
            datCC <- datCC[o, ]
            str(datCC)
            save(datCC, file=pathname)
        }
    }
}

