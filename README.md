# acnr: annotated copy-number regions

This data package contains SNP array data from different platforms (Affymetrix and Immumina) and different types of copy-number regions. These regions were identified manually by the authors of the package and may be used to generate realistic data sets with known truth.

Currently the `acnr` package  contains three data sets curated from GEO:

    > library("acnr")
    > listDataSets()
    [1] "GSE11976_CRL2324" "GSE13372_HCC1143" "GSE29172_H1395"  

This package was initially built to serve as a data package for the [jointseg](https://github.com/mpierrejean/jointseg) package.

## Software status

| Resource:     | CRAN        | Travis CI      | Appveyor         |
| ------------- | ------------------- | -------------- | ---------------- |
| _Platforms:_  | _Multiple_          | _Linux & OS X_ | _Windows_        |
| R CMD check   | <a href="https://cran.r-project.org/web/checks/check_results_acnr.html"><img border="0" src="http://www.r-pkg.org/badges/version/acnr" alt="CRAN version"></a> || <a href="https://travis-ci.org/mpierrejean/acnr"><img src="https://travis-ci.org/mpierrejean/acnr.svg" alt="Build status"></a> | <a href="https://ci.appveyor.com/project/mpierrejean/acnr"><img src="https://ci.appveyor.com/api/projects/status/github/mpierrejean/acnr?svg=true" alt="Build status"></a> |
| Test coverage | | <a href="https://codecov.io/gh/mpierrejean/acnr"><img src="https://codecov.io/gh/mpierrejean/acnr/branch/master/graph/badge.svg" alt="Coverage Status"/></a> | |
