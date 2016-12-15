#' List available data sets
#'
#' @return name of one of the data sets of the package, see
#'   \link{listDataSets}
#' @export
#'
#' @examples
#' listDataSets()
#' 
listDataSets <- function() {
    path <- system.file("extdata", package="acnr")
    files <- list.files(path)
    gsub(".rds$", "", files)
}


