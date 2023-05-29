
process bm2_index {
    
    container "${params.bwa_mem2_docker}"
    
    input:
    path ref
    output:
    path bwa 

    """ 
    bwa-mem2 index -p bwa_idx ${ref}
    mkdir bwa
    mv bwa_idx* bwa
    """
}

process bm2_mapping { 

    container "${params.bwa_mem2_docker}"

    input:
    tuple val(pair_id), path(reads)
    path index

    output:       
    tuple val(pair_id), path("${pair_id}.bam"), emit: bam_file_with_id

    script:
    """
    bwa-mem2 mem ${index}/bwa_idx ${reads[0]} ${reads[1]} > ${pair_id}.bam
    """
    }

process bam_sort {
    container "${params.samtools_docker}"

    input:
    tuple val(pair_id), path(bam_files)

    output:
    tuple val(pair_id), path("${pair_id}.sorted.bam")

    """
    samtools sort $bam_files -o ${pair_id}.sorted.bam
    """
}

process samtools_stats {
    container "${params.samtools_docker}"

    input:
    tuple val(pair_id), path(bam_files)

    output:
    path "*stats.txt"

    script:
    """
    samtools stat $bam_files > ${pair_id}.stats.txt 
    """
}


process multiqc {
    
    container "${params.multiqc_docker}"
    publishDir "${params.outdir}/multiqc"
    
    input:
    path stats

    output:
    path "*"

    script:
    """
    multiqc ${stats}
    """
    
}

