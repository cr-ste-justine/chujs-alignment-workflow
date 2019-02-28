cwlVersion: v1.0
class: Workflow
id: wesp_alignment_fq_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  output_basename: string
  file_R1: File
  file_R2: File
  lineCounts: string
  out_R1: string
  out_R2: string
  rg: string
  indexed_reference_fasta:
    type: File
    secondaryFiles: ['.64.amb', '.fai', '^.dict',
                     '.64.ann', '.64.bwt', '.64.pac', '.64.sa',
                     '.64.alt', '^.dict', '.amb', '.ann', '.bwt',
                     '.pac', '.sa']

outputs:
  r1_array: {type: 'File[]', outputSource: bwa_split_r1/split_reads}
  r2_array: {type: 'File[]', outputSource: bwa_split_r2/split_reads}

steps:
  bwa_split_r1:
    run: ../tools/split_bwa.cwl
    in:
      gzipFiles: file_R1
      lineCounts: lineCounts
      outFiles: out_R1
    out: [split_reads]

  bwa_split_r2:
    run: ../tools/split_bwa.cwl
    in:
      gzipFiles: file_R2
      lineCounts: lineCounts
      outFiles: out_R2
    out: [split_reads]

  bwa_mem:
    run: ../tools/bwa_mem_fq_local.cwl
    in:
      file_R1: bwa_split_r1/split_reads
      file_R2: bwa_split_r2/split_reads
      rg: rg
      ref: indexed_reference_fasta
    out: [output]
    scatter: [file_R1, file_R2]
    scatterMethod: dotproduct

  sambamba_merge:
    run: ../tools/sambamba_merge_one.cwl
    in:
      bams: [bwa_mem/output]
      base_file_name: output_basename
    out: [merged_bam]

  sambamba_sort:
    run: ../tools/sambamba_sort.cwl
    in:
      bam: sambamba_merge/merged_bam
      base_file_name: output_basename
    out: [sorted_bam]
