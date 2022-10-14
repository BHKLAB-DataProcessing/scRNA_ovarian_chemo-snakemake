library(SummarizedExperiment)
library(stringr)

args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

se_files <- files.list(input_dir)
experiment_list <- list()
names <- str_replace(se_files, '.rds$', '')
for (file in se_files) {
  se <- readRDS(file.path(input_dir, file))
  experiment_list <- append(experiment_list, list(se))
}

names(experiment_list) <- names
saveRDS(expriment_list, file.path(output, 'scRNA_ovarian_chemo.rds'))
