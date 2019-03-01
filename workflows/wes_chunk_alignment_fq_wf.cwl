cwlVersion: v1.0
class: Workflow
id: wes_alignment_fq_input_wf
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
  dbsnp_vcf:
    type: File
    secondaryFiles: ['.idx']
  knownsites: File[]
  reference_dict: File
  contamination_sites_bed: File
  contamination_sites_mu: File
  contamination_sites_ud: File
  intervals_bed: File
  wgs_evaluation_interval_list: File
  genome: string

outputs:
  fastqc_reports: {type: 'File[]', outputSource: fastqc/zippedFiles}

steps:
  bwa_mem:
    run: ../tools/bwa_mem_fqp.cwl
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

  sambamba_sort:
    run: ../tools/sambamba_sort.cwl
    in:
      bam: sambamba_merge/merged_bam
      base_file_name: output_basename
    out: [sorted_bam]

  fastqc:
    run: ../tools/fastqc.cwl
    in:
      file_R1: files_R1
      file_R2: files_R2
    scatter: [file_R1, file_R2]
    scatterMethod: dotproduct
    out: [zippedFiles, report]
