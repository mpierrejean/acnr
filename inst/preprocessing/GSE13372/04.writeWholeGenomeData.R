## Adapted from http://aroma-project.org/vignettes/PairedPSCBS-lowlevel

dataSet <- "GSE13372";
chipType <- "GenomeWideSNP_6"

if (FALSE) {
    rpn <- sprintf("testScripts/system/preprocessing/%s/02.doASCRMAv2.R", dataSet)
    pn <- system.file(rpn, package="acnr")
    file.exists(pn)
    source(pn)
}

## tumor samples
dsT <- resR$total
dsN <- resN$total
dsRef <- resRef$total

tumorName <- "HCC1143_GLEYS"
normalName <- "HCC1143BL_GLEYS"

## Naming
## Extract (total,beta) estimates for the tumor-normal pair
dataT <- extractPSCNArray(dsT);
str(dataT);
dataN <- extractPSCNArray(dsN);
str(dataN);
dataRef <- extractPSCNArray(dsRef);
str(dataRef);

## Get (chromosome, position) annotation data
ugp <- getAromaUgpFile(dsT);
chromosome <- ugp[,1,drop=TRUE];
x <- ugp[,2,drop=TRUE];

## Total intensities and Allele B fractions for the normal
thetaN <- dataRef[,"total", 1];
betaN <- dataRef[,"fracB", ];

datPath <- "wholeGenomeData";
## A symbolic link to "/home/share/Data/wholeGenomeData"
datPath <- Arguments$getWritablePath(datPath);
chipType <- getChipType(dsT, full=FALSE)
dsName <- getName(dsT)
dataSet <- sprintf("%s,ASCRMAv2", dataSet)
path <- file.path(datPath, dataSet, chipType);
path <- Arguments$getWritablePath(path);


idxs <- seq(length=dim(dataT)[3])
for (ss in idxs) {
    pairName <- sprintf("%svs%s,100", tumorName, normalName)

    ## Total CNs for the tumor relative to the matched normal
    CT <- 2 * dataT[,"total", ss] / thetaN;
    
    ## Allele B fractions for the tumor
    betaT <- dataT[,"fracB", ss];
    
    ## Setup data structure
    df <- data.frame(chromosome=chromosome, x=x, CT=CT, betaT=betaT, betaN=betaN);

    dfC <- subset(df, !is.na(df$chromosome) & !is.na(df$x))
    str(dfC)
    
    ## save  
    fileName <- sprintf("%s.rds", pairName)
    pathname <- file.path(path, fileName)
    saveRDS(dfC, file=pathname)
    
    ## chromosome by chromosome
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


idxs <- seq(length=dim(dataN)[3])
for (ss in idxs) {
    pairName <- sprintf("%svs%s,0", tumorName, normalName)

    ## Total CNs for the tumor relative to the matched normal
    CT <- 2 * dataN[,"total", ss] / thetaN;
    
    ## Allele B fractions for the tumor
    betaT <- dataN[,"fracB", ss];
    
    ## Setup data structure
    df <- data.frame(chromosome=chromosome, x=x, CT=CT, betaT=betaT, betaN=betaN);

    dfC <- subset(df, !is.na(df$chromosome) & !is.na(df$x))
    str(dfC)
    
    ## save  
    fileName <- sprintf("%s.rds", pairName)
    pathname <- file.path(path, fileName)
    saveRDS(dfC, file=pathname)
    
    ## chromosome by chromosome
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
