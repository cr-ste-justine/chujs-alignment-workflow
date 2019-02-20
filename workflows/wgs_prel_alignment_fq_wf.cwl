cwlVersion: v1.0
class: Workflow
id: wgs_alignment_fq_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  files_R1: File[]
  files_R2: File[]

outputs:
  fastqc_reports: {type: 'File[]', outputSource: fastqc/zippedFiles}
steps:

  fastqc:
    run: ../tools/fastqc.cwl
    in:
      file_R1: files_R1
      file_R2: files_R2
    scatter: [file_R1, file_R2]
    scatterMethod: dotproduct
    out: [zippedFiles, report]