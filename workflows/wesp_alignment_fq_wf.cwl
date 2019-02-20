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
  bam_r1: {type: Directory, outputSource: copy_result_r1/example_out}
  bam_r2: {type: Directory, outputSource: copy_result_r2/example_out}

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

  copy_result_r1:
    run: ../tools/mov.cwl
    in:
      infile: bwa_mem_r1/output
      outdir: output_dir
    out: [example_out]

  copy_result_r2:
    run: ../tools/mov.cwl
    in:
      infile: bwa_mem_r2/output
      outdir: output_dir
    out: [example_out]
