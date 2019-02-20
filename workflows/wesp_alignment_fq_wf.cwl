cwlVersion: v1.0
class: Workflow
id: wesp_alignment_fq_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  output_dir: string
  output_basename: string
  file_R1: File
  file_R2: File
  rg: string
  indexed_reference_fasta:
    type: File
    secondaryFiles: ['.64.amb', '.fai', '^.dict',
                     '.64.ann', '.64.bwt', '.64.pac', '.64.sa',
                     '.64.alt', '^.dict', '.amb', '.ann', '.bwt',
                     '.pac', '.sa']

outputs:
  bam: {type: File, outputSource: sambamba_merge/merged_bam}

steps:
  bwa_mem_r1:
    run: ../tools/bwa_mem_fq_1r.cwl
    in:
      file_R: file_R1
      rg: rg
      ref: indexed_reference_fasta
    out: [output]

  bwa_mem_r2:
    run: ../tools/bwa_mem_fq_1r.cwl
    in:
      file_R: file_R2
      rg: rg
      ref: indexed_reference_fasta
    out: [output]

#  copy_result:
#    run: ../tools/mov.cwl
#    in:
#      infile: bwa_mem_r1/output
#      outdir: output_dir
#    out: [example_out]

  sambamba_merge:
    run: ../tools/sambamba_merge_one_local.cwl
    in:
      bams: [bwa_mem_r1/output, bwa_mem_r2/output]
      base_file_name: output_basename
    out: [merged_bam]
    scatter: [bams]
    scatterMethod: dotproduct