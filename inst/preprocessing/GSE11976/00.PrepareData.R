## Data can be retrieved from http://cbbp.thep.lu.se/~markus/software/BAFsegmentation/
## genomic DNA of breast carcinoma cells mixed with DNA from lymphoblastoid
## cells at known proportions.  Genotypes are from lymphoblastoid cells.

if (FALSE) {
        url <- "http://cbbp.thep.lu.se/~markus/software/BAFsegmentation/CRL2324_dilutionSeries_TableExport.zip"
        tf <- "~/Downloads/CRL2324_dilutionSeries_TableExport.zip"
        download.file(url, tf)
}
dat <- readr::read_tsv(tf)

## Keep only interesting columns
nms <- names(dat)
nms <- gsub("CRL2325\\.", "CRL2324_0pc_Tum\\.", nms)
nms <- gsub("CRL2324\\.", "CRL2324_100pc_Tum\\.", nms)
names(dat) <- nms
nC <- nms[grep("Log R Ratio", nms)]
pcts <- gsub("CRL2324_([0-9]+)pc_Tum.Log R Ratio", "\\1", nC)

datN <- dat[,c("Chr", "Position", "CRL2324_0pc_Tum.GType")]
names(datN) <-  c("chromosome", "position", "genotype")
                 
BAF <- sprintf("CRL2324_%spc_Tum.%s", pcts, "B Allele Freq")
datBAF <- dat[, BAF]
names(datBAF) <- sprintf("BAF_%s", pcts)

LRR <- sprintf("CRL2324_%spc_Tum.%s", pcts, "Log R Ratio")
datLRR <- dat[, LRR]
names(datLRR) <- sprintf("LRR_%s", pcts)

df <- cbind(datN, datLRR, datBAF)

## Map genotype to 0,1/2,1
fgeno <- gsub("A", "", df$genotype)
fgeno[fgeno=="NC"] <- NA
df$muN <- nchar(fgeno)
saveRDS(df,"CRL2324_dilutionSeries.rds")
