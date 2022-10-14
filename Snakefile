from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"],
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)
prefix = config["prefix"]
filename = config["filename"]

samples = ["P01","P02","P03","P04","P05","P06","P07","P08","P09","P10","P11","P12","P13","P14","P15","P16","P17","P18","P19","P20","P21","P23","P24"]

rule get_SE:
  input:
    S3.remote(expand(prefix + "processed/{sample}.rds", sample=samples))
  output:
    S3.remote(prefix + 'scRNA_ovarian_chemo.rds')
  shell:
    """
    Rscript scripts/get_SE.R \
    {prefix}processed \
    {prefix}
    """

rule process_GSE158722:
  input:
    S3.remote(expand(prefix + "download/GSE158722_{sample}.counts.txt.gz", sample=samples))
  output:
    S3.remote(expand(prefix + "processed/{sample}.rds", sample=samples))
  shell:
    """
    Rscript scripts/process_GSE158722.R \
    {prefix}download \
    {prefix}processed
    """

rule download_data:
  output:
    S3.remote(expand(prefix + "download/GSE158722_{sample}.counts.txt.gz", sample=samples))
  shell:
    """
    Rscript scripts/download_GSE158722.R \
    {prefix}download
    """
