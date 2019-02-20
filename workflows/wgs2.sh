#!/usr/bin/env
# bwa_mem to wgs sub directory -- 11180_S12_L008_R1_001.fastq.unsorted.bam
rabix wgs1_alignment_fq_wf.cwl test-input.json
# merge and sort from and to wgs sub dir 11180_S12_L008.bam
rabix wgs2_alignment_fq_wf.cwl test-input.json