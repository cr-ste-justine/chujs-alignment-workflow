cwlVersion: v1.0
class: Workflow
id: wesp_alignment_fq_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  output_basename: string
  file_R1_l1: File
  file_R2_l1: File
  file_R1_l2: File
  file_R2_l2: File
  rg: string
  indexed_reference_fasta:
    type: File
    secondaryFiles: ['.64.amb', '.fai', '^.dict',
                     '.64.ann', '.64.bwt', '.64.pac', '.64.sa',
                     '.64.alt', '^.dict', '.amb', '.ann', '.bwt',
                     '.pac', '.sa']

outputs:
  sorted_bam: {type: File, outputSource: sambamba_sort/sorted_bam}

steps:
  bwa_mem_l1:
    run: ../tools/bwa_mem_fqp.cwl
    in:
      file_R1: file_R1_l1
      file_R2: file_R2_l1
      rg: rg
      ref: indexed_reference_fasta
    out: [output]

  bwa_mem_l2:
    run: ../tools/bwa_mem_fqp.cwl
    in:
      file_R1: file_R1_l2
      file_R2: file_R2_l2
      rg: rg
      ref: indexed_reference_fasta
    out: [output]

  sambamba_merge:
    run: ../tools/sambamba_merge_one.cwl
    in:
      bams: [bwa_mem_l1/output, bwa_mem_l2/output]
      base_file_name: output_basename
    out: [merged_bam]

  sambamba_sort:
    run: ../tools/sambamba_sort.cwl
    in:
      bam: sambamba_merge/merged_bam
      base_file_name: output_basename
    out: [sorted_bam]
