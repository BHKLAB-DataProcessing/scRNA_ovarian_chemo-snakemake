library(GEOquery)

args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

getGEOSuppFiles("GSE158722", makeDirectory=FALSE, baseDir=work_dir)
file.remove(file.path(work_dir, 'GSE158722.cell_annotations.txt.gz'))