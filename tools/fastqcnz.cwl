#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: chusj/fastqc

inputs:
  file_R1:
    type: File
    inputBinding:
      position: 1
  file_R2:
    type: File
    inputBinding:
      position: 2

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
