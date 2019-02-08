#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
      dockerPull: cr-ste-justine/fastqc

inputs:
  file_R1: File
  file_R2: File
  fastqFile:
    type: File # No reason to accept multiple files as no overall report is generated
    inputBinding:
      position: 1

baseCommand: [fastqc, --outdir, ., --extract]
outputs:
  zippedFile:
    type: File
    outputBinding:
      glob: '*.zip'
  report:
    type: Directory
    outputBinding:
      glob: .
