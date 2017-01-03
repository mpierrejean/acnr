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
    dat <- loadDataSet(dataSet)
    pcts <- unique(dat$cellularity)
    sort(pcts, decreasing=TRUE)
}
