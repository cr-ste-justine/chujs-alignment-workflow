#!/usr/bin/env cwl-runner

class: Workflow

cwlVersion: v1.0

inputs:
  genome:
    type: string
  infile:
    type: File
    doc: VCF file to annotate

outputs:
  outfile:
    type: File
    outputSource: snpeff/output
  statsfile:
    type: File
    outputSource: snpeff/stats
  genesfile:
    type: File
    outputSource: snpeff/genes

steps:
  snpeff:
    run: snpeff.cwl
    in:
      input_vcf: infile
      genome: genome
    out: [output, stats, genes]

doc: |
  Annotate variants provided in a VCF using SnpEff
