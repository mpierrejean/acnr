#' List of available tumor fractions for a data set
#'
#' @param dataSet  The name of a data set from the package, see
#'
#' @return A numeric vector, the available tumor fractions for a data set
#' @export
#'
#' @examples
#' dataSets <- listDataSets()
#' fracs <- listTumorFractions(dataSets[1])
#'
listTumorFractions <- function(dataSet) {
    ds <- listDataSets()
    if( !(dataSet %in% ds)) {
        stop("Argument 'dataSet' should be one of ", paste(ds, collapse=","))
    }
    path <- system.file("extdata", package="acnr")
    patt <- "(.*),([0-9]+),cnRegions.rds"

    dpath <- file.path(path, dataSet)
    chipType <- list.files(dpath)
    dpath <- file.path(dpath, chipType)
    fl <- list.files(dpath, pattern=patt)
    pcts <- as.numeric(gsub(patt, "\\2", fl))/100
    sort(pcts)
}
