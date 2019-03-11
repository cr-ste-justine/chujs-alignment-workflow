cwlVersion: v1.0
class: Workflow
id: wgs_fastqc
requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  sorted_bam:
    type: File
    secondaryFiles: ['.bai']

outputs:
  fastqc_reports: {type: 'File[]', outputSource: fastqc/zippedFiles}
steps:

  fastqc:
    run: ../tools/fastqcBAM.cwl
    in:
      bam: sorted_bam
    out: [zippedFiles, report]