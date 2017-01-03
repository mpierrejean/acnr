loadDataSet <- function(dataSet) {
    dataSets <- listDataSets()
    if( !(dataSet %in% dataSets)) {
        stop("Argument 'dataSet' should be one of ", paste(dataSets, collapse=", "))
    }
    path <- system.file("extdata", package="acnr")
    filename <- sprintf("%s.rds", dataSet)
    pathname <- file.path(path, filename)
    dat <- readRDS(pathname)
}