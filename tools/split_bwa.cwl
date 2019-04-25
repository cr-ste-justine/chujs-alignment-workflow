cwlVersion: v1.0
class: CommandLineTool
id: split_bwa

baseCommand: [unpigz, -c]

inputs:
  gzipFiles:
    type: File
    streamable: true
    inputBinding:
      position: 1
  lineCounts:
    type: string
    inputBinding:
      prefix: "| split -l"
      position: 2
  outFiles:
    type: string
    inputBinding:
      prefix: "-"
      position: 3


outputs:
  split_reads:
    type: File[]
    outputBinding:
      glob: '*'