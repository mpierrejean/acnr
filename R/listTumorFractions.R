#' List of available tumor fractions for a data set
#'
#' @param dataSet  The name of a data set from the package, see \link{listDataSets}
#'
#' @return A numeric vector, the available tumor fractions for a data set
#' @export
#'
#' @examples
#' dataSets <- listDataSets()
#' fracs <- listTumorFractions(dataSets[1])
#'
listTumorFractions <- function(dataSet) {
    dataSets <- listDataSets()
    if( !(dataSet %in% dataSets)) {
        stop("Argument 'dataSet' should be one of ", paste(dataSets, collapse=", "))
    }
    path <- system.file("extdata", package="acnr")
    filename <- sprintf("%s.rds", dataSet)
    pathname <- file.path(path, filename)
    dat <- readRDS(pathname)
    pcts <- unique(dat$cellularity)
    sort(pcts, decreasing=TRUE)
}
