% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extdata.R
\name{GSE29172_H1395}
\alias{GSE29172_H1395}
\title{Annotated copy-number regions from the GEO GSE29172 (and GSE26302) data sets.}
\format{A data frame with 770668 observations of 7 variables: \describe{ 
  \item{c}{total copy number (not log-scaled)} \item{b}{allelic ratios in the
  diluted tumor sample (after TumorBoost)} \item{genotype}{germline 
  genotypes} \item{bT}{allelic ratios in the diluted tumor sample (before 
  TumorBoost)} \item{bN}{allelic ratios in the matched normal sample} 
  \item{region}{a character value, annotation label for the region. Should be
  encoded as \code{"(C1,C2)"}, where \code{C1} denotes the minor copy number 
  and \code{C2} denotes the major copy number.  For example, \describe{ 
  \item{(1,1)}{Normal} \item{(0,1)}{Hemizygous deletion} 
  \item{(0,0)}{Homozygous deletion} \item{(1,2)}{Single copy gain} 
  \item{(0,2)}{Copy-neutral LOH} \item{(2,2)}{Balanced two-copy gain} 
  \item{(1,3)}{Unbalanced two-copy gain} \item{(0,3)}{Single-copy gain with 
  LOH} } } \item{genotype}{the (germline) genotype of SNPs. By definition, rows 
  with missing genotypes are interpreted as non-polymorphic loci (a.k.a. copy
  number probes).} \item{cellularity}{A numeric value between 0 and 1, the
  percentage of tumor cells in the  sample.} }}
\source{
\url{http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE29172} 
\url{http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE26302}
}
\description{
The GEO GSE29172 data set is a dilution series from the Affymetrix 
GenomeWideSNP_6 chip type. The GEO GSE26302 data set contains the experiment 
corresponding to the matched normal (i.e. 0\% dilution).
}
\details{
These data have been processed from the files available from GEO using 
scripts that are included in the 'inst/preprocessing/GSE29172' directory of
this package. This processing includes normalization of the raw CEL files
using the CRMAv2 method implemented in the aroma.affymetrix package.
}
\examples{
dat <- loadCnRegionData("GSE29172_H1395")
unique(dat$region)
}
\references{
Rasmussen, M., Sundstr\"om, M., Kultima, H. G., Botling, J., 
  Micke, P., Birgisson, H., Glimelius, B. & Isaksson, A. (2011). 
  Allele-specific copy number analysis of tumor samples with aneuploidy and 
  tumor heterogeneity. Genome Biology, 12(10), R108.#'

Bengtsson, H., Wirapati , P. & Speed, T.P. (2009). A single-array
  preprocessing method for estimating full-resolution raw copy numbers from 
  all Affymetrix genotyping arrays including GenomeWideSNP 5 & 6, 
  Bioinformatics 25(17), pp. 2149-56.

Bengtsson H., Neuvial, P. and Speed, T. P. (2010) TumorBoost:
  normalization of allele-specific tumor copy numbers from a single pair of
  tumor-normal genotyping microarrays. BMC bioinformatics 11 (2010), p. 245.
}

