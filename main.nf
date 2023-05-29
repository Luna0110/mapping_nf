#!/usr/bin/env nextflow

include{
    bm2_index;
    bm2_mapping;
    samtools_stats;
    multiqc;
    bam_sort
} from './module/process.nf'


workflow{
    
    Channel
        .fromFilePairs( params.reads)
        .set{ ch_reads }
    ch_reads.view()

    bm2_index(params.ref)
    bm2_mapping(ch_reads, bm2_index.out)
    bam_sort(bm2_mapping.out)
    samtools_stats(bam_sort.out)
    multiqc(samtools_stats.out.collect())
}
