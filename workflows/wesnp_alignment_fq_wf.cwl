cwlVersion: v1.0
class: Workflow
id: wesnp_alignment_fq_input_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  output_dir: string
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
  bam: {type: Directory, outputSource: copy_result/example_out}

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
    
  copy_result:
    run: ../tools/mov.cwl
    in:
      infile: bwa_mem/output
      outdir: output_dir
    out: [example_out]
