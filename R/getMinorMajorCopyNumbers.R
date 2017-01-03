#' Get minor and major copy number labels from region annotation labels
#' 
#' @param region A character value, the annotation label for a copy number
#'   region.  Should be encoded as \code{"(C1,C2)"},  where \describe{ 
#'   \item{\code{C1}}{denotes the minor copy number, that is, the smallest of
#'   the two parent-specific copy numbers} \item{\code{C2}}{denotes the minor
#'   copy number, that is, the smallest of the two parent-specific copy
#'   numbers}}
#'   
#' @return A \code{matrix} with \code{length(region)} rows and two columns:
#'   \code{C1} and \code{C2}, as described above.
#'   
#' @references Bengtsson H., Neuvial, P. and Speed, T. P. (2010) TumorBoost: 
#'   normalization of allele-specific tumor copy numbers from a single pair of 
#'   tumor-normal genotyping microarrays. BMC bioinformatics 11 (2010), p. 245.
#'   
#' @references Neuvial, P., Bengtsson H., and Speed, T. P. (2011) Statistical
#'   analysis of Single Nucleotide Polymorphism microarrays in cancer studies.
#'   Chapter 11 in *Handbook of Statistical Bioinformatics*,  Springer.
#'   
#' @export
#' 
#' @examples
#' 
#' dat <- loadCnRegionData(dataSet="GSE29172_H1395", tumorFraction=1)
#' regions <- unique(dat$region)
#' getMinorMajorCopyNumbers(regions)
#' 

getMinorMajorCopyNumbers <- function(region) {
    pattern <- "\\(([0-9]+),([0-9]+)\\)"
    C1 <- gsub(pattern, "\\1", region)
    C2 <- gsub(pattern, "\\2", region)
    mat <- cbind(C1=as.numeric(C1), C2=as.numeric(C2))
    rownames(mat) <- region
    mat
}

