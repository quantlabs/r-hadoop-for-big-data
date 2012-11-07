#!/usr/bin/env Rscript

#

URL <- "http://ichart.finance.yahoo.com/table.csv?s=GE"
df <- read.csv(URL)
df$stock <- apply(df,1,function(row) "GE")
write.table(df,file = "ge.txt", append = FALSE, quote = FALSE, sep = ",", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = FALSE, qmethod = "double")
