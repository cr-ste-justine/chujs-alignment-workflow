#!/usr/bin/env cwl-runner
cwlVersion: v1.0
id: fastqcBAM
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: chusj/fastqc

inputs:
  bam:
    type: File
    inputBinding:
      position: 1

baseCommand: [fastqc, --outdir, .]
outputs:
  zippedFiles:
    type: File[]
    outputBinding:
      glob: '*.zip'
  report:
    type: Directory
    outputBinding:
      glob: .
