loadDataSet <- function(dataSet) {
    dataSet <- match.arg(dataSet, listDataSets())
    path <- system.file("extdata", package="acnr")
    filename <- sprintf("%s.rds", dataSet)
    pathname <- file.path(path, filename)
    dat <- readRDS(pathname)
}
