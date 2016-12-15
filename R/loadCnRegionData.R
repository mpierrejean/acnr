#' loadCnRegionData
#' 
#' Load real, annotated copy number data
#' 
#' This function is a wrapper to load real genotyping array data taken from
#' 
#' * a dilution series from the Affymetrix GenomeWideSNP_6 chip type (Rasmussen
#' et al, 2011), see \code{\link{ GSE29172_H1395}} * a dilution series from the
#' Illumina HumanCNV370v1 chip type (Staaf et al, 2008), see
#' \code{\link{GSE11976_CRL2324}} * a tumor/normal pair from the Affymetrix
#' GenomeWideSNP_6 chip type (Chiang et al, 2008), see
#' \code{\link{GSE13372_HCC1143}}
#' 
#' @param dataSet name of one of the data sets of the package, see 
#'   \code{\link{listDataSets}}
#' @param tumorFraction proportion of tumor cells in the "tumor" sample (a.k.a.
#'   tumor cellularity). See \code{\link{listTumorFractions}}.
#' @return a data.frame containing copy number data for different types of copy 
#'   number regions.  Columns:\describe{ \item{c}{Total copy number} 
#'   \item{b}{Allele B fraction (a.k.a. BAF)} \item{region}{a character value, 
#'   annotation label for the region.  Preferably encoded as \code{"(C1,C2)"}, 
#'   where \code{C1} denotes the minor copy number and \code{C2} denotes the 
#'   major copy number.  For example, \describe{ \item{(1,1)}{Normal} 
#'   \item{(0,1)}{Hemizygous deletion} \item{(0,0)}{Homozygous deletion} 
#'   \item{(1,2)}{Single copy gain} \item{(0,2)}{Copy-neutral LOH} 
#'   \item{(2,2)}{Balanced two-copy gain} \item{(1,3)}{Unbalanced two-copy gain}
#'   \item{(0,3)}{Single-copy gain with LOH} }} \item{muN}{the (germline) 
#'   genotype of SNPs. By definition, rows with missing genotypes are 
#'   interpreted as non-polymorphic loci (a.k.a. copy number probes).}}
#' @author Morgane Pierre-Jean and Pierre Neuvial
#' @examples
#' 
#' affyDat <- loadCnRegionData(dataSet="GSE29172_H1395", tumorFraction=1)
#' str(affyDat)
#' 
#' illuDat <- loadCnRegionData(dataSet="GSE11976_CRL2324", tumorFraction=.79)
#' str(illuDat)
#' 
#' affyDat2 <- loadCnRegionData(dataSet="GSE13372_HCC1143", tumorFraction=1)
#' str(affyDat2)
#' 
#' @export loadCnRegionData
loadCnRegionData <- function(dataSet=listDataSets(), tumorFraction=1){
    dataSet <- match.arg(dataSet)
    tumorFractions <- listTumorFractions(dataSet)
    if(!(tumorFraction %in% tumorFractions)) {
        stop("Invalid 'tumorFraction' ", tf, ". 'tumorFraction' should be in c(",
             paste(tumorFractions, collapse=", "), ") for dataSet ", dataSet)
    }
    filename <- sprintf("%s.rds", dataSet)
    relPath <- file.path("extdata", filename)
    pathname <- system.file(relPath, package="acnr")
    dat <- readRDS(pathname)
    cellularity <- NULL; rm(cellularity); ## To avoid a NOTE from R CMD check
    sdat <- subset(dat, cellularity==tumorFraction)
    sdat
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

