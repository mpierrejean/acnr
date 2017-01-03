library("acnr")

context("Germline genotypes in 'GSE11976_CRL2324'")
test_that("Genotypes AA, AB and BB are represented'", {
    dataSet <- "GSE11976_CRL2324"
    for (tumorFraction in listTumorFractions(dataSet)) {
        dat <- loadCnRegionData(dataSet=dataSet, tumorFraction=tumorFraction)
        tab <- table(dat$genotype, exclude = NULL)
        gens <- as.numeric(names(tab))
        gens <- sort(gens[which(!is.na(gens))])
        expect_equal(gens, c(0, 0.5, 1))
    }
})

context("Germline genotypes in 'GSE13372_HCC1143'")
test_that("Genotypes AA, AB and BB are represented'", {
    dataSet <- "GSE13372_HCC1143"
    for (tumorFraction in listTumorFractions(dataSet)) {
        dat <- loadCnRegionData(dataSet=dataSet, tumorFraction=tumorFraction)
        tab <- table(dat$genotype, exclude = NULL)
        gens <- as.numeric(names(tab))
        gens <- sort(gens[which(!is.na(gens))])
        expect_equal(gens, c(0, 0.5, 1))
    }
})

context("Germline genotypes in 'GSE29172_H1395'")
test_that("Genotypes AA, AB and BB are represented'", {
    dataSet <- "GSE29172_H1395"
    for (tumorFraction in listTumorFractions(dataSet)) {
        dat <- loadCnRegionData(dataSet=dataSet, tumorFraction=tumorFraction)
        tab <- table(dat$genotype, exclude = NULL)
        gens <- as.numeric(names(tab))
        gens <- sort(gens[which(!is.na(gens))])
        expect_equal(gens, c(0, 0.5, 1))
    }
})
