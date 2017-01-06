C1C2 <- rbind(c(0,2), c(1,2), c(0,1), c(1,1))
colnames(C1C2) <- c("C1", "C2")
regDat <- data.frame(C1=C1C2[, "C1"],
                     C2=C1C2[, "C2"],
                     chr=c(5, 8, 4, 19),
                     begin=c(75, 75, 180, 35),
                     end=c(100, 100, Inf, Inf),
                     stringsAsFactors=FALSE)
regDat$type <- sprintf("(%s,%s)", regDat[["C1"]], regDat[["C2"]])
