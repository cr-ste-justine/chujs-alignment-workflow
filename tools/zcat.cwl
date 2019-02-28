cwlVersion: v1.0
class: CommandLineTool
baseCommand: [gunzip, -c]
stdout: $(inputs.unzippedFileName)
inputs:
  gzipFile:
    type: File
    inputBinding:
      position: 1
  unzippedFileName:
    type: string
outputs:
  unzippedFile:
    type: stdout