
cwlVersion: v1.0
class: CommandLineTool
id: mov
baseCommand: [cp, -r]
inputs:
  infile:
    type: File
    inputBinding:
      position: 1
  outdir:
    type: string
    inputBinding:
      position: 2

outputs:
  example_out:
    type: Directory
    outputBinding:
      glob: .