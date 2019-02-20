cwlVersion: v1.0
class: Workflow
id: wesnp_alignment_fq_input_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  files_R1: File[]
  files_R2: File[]
  rgs: string[]
  output_basename: string
  indexed_reference_fasta:
    type: File
    secondaryFiles: ['.64.amb', '.fai', '^.dict',
                     '.64.ann', '.64.bwt', '.64.pac', '.64.sa',
                     '.64.alt', '^.dict', '.amb', '.ann', '.bwt',
                     '.pac', '.sa']

outputs:
  bam: {type: File, outputSource: sambamba_merge/merged_bam}

steps:
  bwa_mem:
    run: ../tools/bwa_mem_fq.cwl
    in:
      file_R1: files_R1
      file_R2: files_R2
      rg: rgs
      ref: indexed_reference_fasta
    scatter: [file_R1, file_R2, rg]
    scatterMethod: dotproduct
    out: [output]
    
  sambamba_merge:
    run: ../tools/sambamba_merge_one.cwl
    in:
      bams: bwa_mem/output
      base_file_name: output_basename
    out: [merged_bam]

