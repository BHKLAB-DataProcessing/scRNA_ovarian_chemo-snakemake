library(GEOquery)
library(SummarizedExperiment)
library(stringr)

args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]


files <- list.files(input_dir)
matrix_list <- list()
names_list <- c()

for (file in files) {
  gunzip(file.path(input_dir, file))
  txtfile <- str_replace(file, ".gz$", "")
  print(txtfile)
  matrix <- read.table(file.path(input_dir, txtfile), sep = "\t", header = TRUE, row.names = 1)
  matrix <- matrix[, !(colnames(matrix) %in% c("Gene.ID"))]
  # matrix_list <- append(matrix_list,list(matrix))
  name_split <- unlist(strsplit(txtfile, "_"))[2]
  name <- unlist(strsplit(name_split, "[.]"))[1]
  # names_list <- append(names_list, unlist(strsplit(name_split, "[.]"))[1])

  columns <- colnames(matrix)
  split <- (strsplit(columns, "_"))
  cell_list <- c()
  sample_list <- c()
  time_list <- c()
  for (j in 1:length(split)) {
    cell_list <- append(cell_list, columns[j])
    sample_list <- append(sample_list, split[[j]][1])
    time_list <- append(time_list, split[[j]][2])
  }
  colData <- data.frame(cell = cell_list, sample = sample_list, timepoint = time_list)
  rowData <- data.frame(genes = rownames(matrix))
  saveRDS(SummarizedExperiment(assay = matrix, rowData = rowData, colData = colData), file.path(output_dir, paste0(name, ".rds")))
  file.remove(file.path(input_dir, txtfile))
}
