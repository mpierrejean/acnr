#' loadCnRegionData
#'
#' Load real, annotated copy number data
#'
#' This function is a wrapper to load real genotyping array data taken from
#' dilution series from the Affymetrix GenomeWideSNP_6 chip type (Rasmussen et
#' al, 2011) or from the Illumina HumanCNV370v1 chip type (Staaf et al, 2008)
#'
#' @param dataSet microarray dataSet from which the data was generated.
#' @param tumorFraction proportion of tumor cells in the "tumor" sample. Should
#' be in .3, .5, .7, 1 if \code{dataSet=="GSE29172"}, and in .14,.34,.50,.79,1
#' when \code{dataSet=="GSE11976"}.
#' @return a data.frame containing copy number data for different types of copy
#' number regions.  Columns:\describe{ \item{c}{Total copy number}
#' \item{b}{Allele B fraction (a.k.a. BAF)} \item{region}{a character value,
#' annotation label for the region.  Preferably encoded as \code{"(C1,C2)"},
#' where \code{C1} denotes the minor copy number and \code{C2} denotes the
#' major copy number.  For example, \describe{ \item{(1,1)}{Normal}
#' \item{(0,1)}{Hemizygous deletion} \item{(0,0)}{Homozygous deletion}
#' \item{(1,2)}{Single copy gain} \item{(0,2)}{Copy-neutral LOH}
#' \item{(2,2)}{Balanced two-copy gain} \item{(1,3)}{Unbalanced two-copy gain}
#' \item{(0,3)}{Single-copy gain with LOH} }} \item{muN}{the (germline)
#' genotype of SNPs. By definition, rows with missing genotypes are interpreted
#' as non-polymorphic loci (a.k.a. copy number probes).}}
#' @author Morgane Pierre-Jean and Pierre Neuvial
#' @references Staaf, J., Lindgren, D., Vallon-Christersson, J., Isaksson, A.,
#' Goransson, H., Juliusson, G., ... & Ringn\'er, M. (2008). Segmentation-based
#' detection of allelic imbalance and loss-of-heterozygosity in cancer cells
#' using whole genome SNP arrays. Genome Biol, 9(9), R136.
#'
#' GEO data set: http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE11976
#'
#' Rasmussen, M., Sundstr\"om, M., Kultima, H. G., Botling, J., Micke, P.,
#' Birgisson, H., Glimelius, B. & Isaksson, A. (2011). Allele-specific copy
#' number analysis of tumor samples with aneuploidy and tumor heterogeneity.
#' Genome Biology, 12(10), R108.
#'
#' GEO data sets: http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE29172
#' http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE26302
#' @examples
#'
#' affyDat <- loadCnRegionData(dataSet="GSE29172", tumorFraction=1)
#' str(affyDat)
#'
#' illuDat <- loadCnRegionData(dataSet="GSE11976", tumorFraction=.79)
#' str(illuDat)
#'
#' @export loadCnRegionData
loadCnRegionData <- function(
    dataSet=c("GSE29172", "GSE11976", "GSE13372"),
    tumorFraction=1){
    dataSet <- match.arg(dataSet)
    tumorFractions <- switch(dataSet,
                             GSE13372=c(0,1),
                             GSE29172=c(.3, .5, .7, 1),
                             GSE11976=c(0,.14,.34,.50,.79,1))
    if(!(tumorFraction %in% tumorFractions)) {
        stop("'tumorFraction' should be in c(",
             paste(tumorFractions, collapse=", "), ") for dataSet ", dataSet)
    }

    sampleName <- switch(dataSet,
                         GSE29172="H1395vsBL1395",
                         GSE13372="HCC1143,GLEYSvsBL_GLEYS",
                         GSE11976="CRL2324,BAF")
    chipType <- switch(dataSet,
                       GSE13372="GenomeWideSNP_6",
                       GSE29172="GenomeWideSNP_6",
                       GSE11976="HumanCNV370v1")
    filename <- sprintf("%s,%s,cnRegions.rds", sampleName, 100*tumorFraction)
    relPath <- file.path("extdata", dataSet, chipType, filename)
    pathname <- system.file(relPath, package="acnr")
    readRDS(pathname)
}
############################################################################
## HISTORY:
## 2016-11-23
## o Moved to roxygen2 documentation.
## 2013-04-13
## o More informative error message when desired tumor fraction is not
## available.
## 2013-01-22
## o Updated doc.
## 2013-01-15
## o Created.
############################################################################

