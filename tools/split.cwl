cwlVersion: v1.0
class: CommandLineTool
baseCommand: [split, -l]

inputs:
  pattern:
    type: string
    inputBinding:
      position: 1
  fileToSearch:
    type: File
    inputBinding:
      position: 2
  outFileName:
    type: string
outputs:
  grepOut:
    type: stdout