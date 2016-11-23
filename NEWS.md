# Package: acnr

## Version: 0.2.7 [2016-11-24]

* Updated scripts for the preprocessing of data set GSE29172
* Now exporting 'betaT' and 'betaN' for data set GSE29172

## Version: 0.2.6 [2016-11-23]

* Moved to roxygen2 documentation using package 'Rd2roxygen'
* Cleaned up DESCRIPTOIN
* Passes R CMD check locally with one NOTE (long file paths)

## Version: 0.2.5 [2016-05-04]

* Add a new dataSet GSE13372 
* Change directory structure in inst/exdata: now inst/exdata/dataSet/chipType
* Save all files in '.rds'
* Add a 0% dillution in 'GSE11976' dataset 

## Version: 0.2.4 [2014-11-17]

* Used tools::resaveRdaFiles to compress data

## Version: 0.2.3 [2014-10-27]

* Changed ‘Affymetrix’ data, package is now less than 5MB.

## Version: 0.2.2 [2014-09-08]

* Added a mini-vignette.

## Version: 0.2.1 [2014-05-30]

* Moved inst/testScripts/system/preprocessing to inst/preprocessing.

## Version: 0.2.0 [2014-05-30]

* Changed ‘platform’ to ‘dataSet’.

## Version: 0.1.7 [2014-05-27]

* Changed ‘Illumina’ to ‘GSE11976’ and ‘Affymetrix’ to ‘GSE29172’. 

## Version: 0.1.6 [2014-05-14]

* Bumped up version number to trigger build of 'jointSeg' by R-forge.

## Version: 0.1.5 [2014-02-20]

* Added a succinct vignette.

## Version: 0.1.4 [2013-12-04]

* Changed (1,2) region in Illumina Data.

## Version: 0.1.3 [2013-04-13]

* Now 'c' is on the non-log scale for both Affy and Illumina.
* In 'loadCnRegionData': more informative error message when desired
tumor fraction is not available.

## Version: 0.1.2 [2013-03-15]

* Added more regions for Illumina platform

## Version: 0.1.1 [2013-02-07]

* Renamed 'inst/extData' to 'inst/extdata'

## Version: 0.1.0 [2013-01-31]

* Created from package 'jointSeg'.
