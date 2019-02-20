cwlVersion: v1.0
class: Workflow
id: wgs2_alignment_fq_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  files_bams: File[]
  output_basename: string

outputs:
  sorted_bam: {type: File, outputSource: sambamba_sort/sorted_bam}

steps:

  sambamba_merge:
    run: ../tools/sambamba_merge_one_local.cwl
    in:
      bams: files_bams
      base_file_name: output_basename
    out: [merged_bam]

  sambamba_sort:
    run: ../tools/sambamba_sort_local.cwl
    in:
      bam: sambamba_merge/merged_bam
      base_file_name: output_basename
    out: [sorted_bam]
