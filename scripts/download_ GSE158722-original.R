library(GEOquery)
library(SummarizedExperiment)
setwd("/scratch/")
getGEOSuppFiles("GSE158722")
files <- list.files("./GSE158722/")
for (i in files) {
  gunzip(paste("./GSE158722/",i,sep = ""))
}
setwd("./GSE158722/")
matrix_list <- list()
files <- list.files(".")
files <- files[-24]
names_list <- c()
for (i in 1:length(files)) {
  print(i)
  matrix <- read.table(files[i],sep = "\t",header = TRUE,row.names = 1)
  matrix <- matrix[, !(colnames(matrix) %in% c("Gene.ID"))]
  matrix_list <- append(matrix_list,list(matrix))
  name_split <- unlist(strsplit(files[i],"_"))[2]
  names_list <- append(names_list,unlist(strsplit(name_split,"[.]"))[1])
}
experiment_list <- list()
for (i in 1:length(matrix_list)) {
  columns <- colnames(matrix_list[[i]])
  split <- (strsplit(columns,"_"))
  cell_list <- c()
  sample_list <- c()
  time_list <- c()
  for (j in 1:length(split)) {
    cell_list <- append(cell_list,columns[j])
    sample_list <- append(sample_list,split[[j]][1])
    time_list <- append(time_list,split[[j]][2])
  }
  colData <- data.frame(cell=cell_list,sample=sample_list,timepoint=time_list)
  rowData <- data.frame(genes=rownames(matrix_list[[i]]))
  experiment_list <- append(experiment_list,list(SummarizedExperiment(assay=matrix_list[[i]],rowData = rowData,colData = colData)))
}
names(experiment_list) <- names_list
