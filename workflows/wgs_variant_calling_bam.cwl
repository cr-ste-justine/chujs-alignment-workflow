cwlVersion: v1.0
class: Workflow
id: wgs_variant_calling_bam
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  output_basename: string
  sorted_bam:
    type: File
    secondaryFiles: ['.bai']
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
  wgs_calling_interval_list: File
  wgs_coverage_interval_list: File
  wgs_evaluation_interval_list: File
  genome: string

outputs:
  gvcf: {type: File, outputSource: picard_mergevcfs/output}
  verifybamid_output: {type: File, outputSource: verifybamid/output}
  bqsr_report: {type: File, outputSource: gatk_gatherbqsrreports/output}
  gvcf_calling_metrics: {type: 'File[]', outputSource: picard_collectgvcfcallingmetrics/output}
  aggregation_metrics: {type: 'File[]', outputSource: picard_collectaggregationmetrics/output}
  wgs_metrics: {type: File, outputSource: picard_collectwgsmetrics/output}
  annotated_vcf: {type: File, outputSource: snpeff_g_vcf/outfile}

steps:
  python_createsequencegroups:
    run: ../tools/python_createsequencegroups.cwl
    in:
      ref_dict: reference_dict
    out: [sequence_intervals]

  gatk_baserecalibrator:
    run: ../tools/gatk_baserecalibrator.cwl
    in:
      input_bam: sorted_bam
      knownsites: knownsites
      reference: indexed_reference_fasta
      sequence_interval: python_createsequencegroups/sequence_intervals
    scatter: [sequence_interval]
    out: [output]

  gatk_gatherbqsrreports:
    run: ../tools/gatk_gatherbqsrreports.cwl
    in:
      input_brsq_reports: gatk_baserecalibrator/output
      output_basename: output_basename
    out: [output]

  gatk_applybqsr:
    run: ../tools/gatk_applybqsr.cwl
    in:
      bqsr_report: gatk_gatherbqsrreports/output
      input_bam: sorted_bam
      reference: indexed_reference_fasta
      sequence_interval: python_createsequencegroups/sequence_intervals
    scatter: [sequence_interval]
    out: [recalibrated_bam]

  picard_gatherbamfiles:
    run: ../tools/picard_gatherbamfiles.cwl
    in:
      input_bam: gatk_applybqsr/recalibrated_bam
      output_bam_basename: output_basename
    out: [output]

  picard_collectaggregationmetrics:
    run: ../tools/picard_collectaggregationmetrics.cwl
    in:
      input_bam: picard_gatherbamfiles/output
      reference: indexed_reference_fasta
    out: [output]

  picard_collectwgsmetrics:
    run: ../tools/picard_collectwgsmetrics.cwl
    in:
      input_bam: picard_gatherbamfiles/output
      intervals: wgs_coverage_interval_list
      reference: indexed_reference_fasta
    out: [output]

  picard_intervallisttools:
    run: ../tools/picard_intervallisttools.cwl
    in:
      interval_list: wgs_calling_interval_list
    out: [output]

  verifybamid:
    run: ../tools/verifybamid.cwl
    in:
      contamination_sites_bed: contamination_sites_bed
      contamination_sites_mu: contamination_sites_mu
      contamination_sites_ud: contamination_sites_ud
      input_bam: sorted_bam
      ref_fasta: indexed_reference_fasta
      output_basename: output_basename
    out: [output]

  checkcontamination:
    run: ../tools/expression_checkcontamination.cwl
    in:
      verifybamid_selfsm: verifybamid/output
    out: [contamination]

  gatk_haplotypecaller:
    run: ../tools/gatk_haplotypecaller.cwl
    in:
      contamination: checkcontamination/contamination
      input_bam: picard_gatherbamfiles/output
      interval_list: picard_intervallisttools/output
      reference: indexed_reference_fasta
    scatter: [interval_list]
    out: [output]

  picard_mergevcfs:
    run: ../tools/picard_mergevcfs.cwl
    in:
      input_vcf: gatk_haplotypecaller/output
      output_vcf_basename: output_basename
    out: [output]

  snpeff_g_vcf:
    run: ../tools/snpeff-workflow.cwl
    in:
      genome: genome
      infile: picard_mergevcfs/output
    out: [outfile, statsfile, genesfile]

  picard_collectgvcfcallingmetrics:
    run: ../tools/picard_collectgvcfcallingmetrics.cwl
    in:
      dbsnp_vcf: dbsnp_vcf
      final_gvcf_base_name: output_basename
      input_vcf: picard_mergevcfs/output
      reference_dict: reference_dict
      wgs_evaluation_interval_list: wgs_evaluation_interval_list
    out: [output]

$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:AWSInstanceType'
    value: c4.8xlarge;ebs-gp2;850
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 4
