cwlVersion: v1.0
class: CommandLineTool
id: picard_intervallisttools
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
  - class: ResourceRequirement
      ramMin: 5000
    dockerPull: 'kfdrc/picard:2.18.2-dev'
baseCommand: [java, -Xmx4000m, -jar, /picard.jar]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      BedToIntervalList
      UNIQUE=true
      SORT=true
      INPUT=$(inputs.intervals_bed.path)
      OUTPUT=$(inputs.intervals_bed.nameroot).tmp.interval_list
      SD=$(inputs.reference_dict.path)
inputs:
  intervals_bed: File
  reference_dict: File
outputs:
  output:
    type: File
    outputBinding:
      glob: '*.interval_list'