# mapping_nf

A nextflow pipeline takes reference genome and reads, output the alignment stats.

**workflow:**

bwa-mem2 index -- bwa-mem2 mapping -- samtools sort -- samtools stats -- multiqc report


**Parameter:**

nextflow run /path/to/main.nf -- ref "path/to/reference/genome" -- reads "path/to/reads" -- outdir "path/to/output"


