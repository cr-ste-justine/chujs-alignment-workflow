cwlVersion: v1.0
class: CommandLineTool
id: picard_intervallisttools
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: 'kfdrc/picard:2.18.2-dev'
  - class: ResourceRequirement
    ramMin: 5000
baseCommand: [java, -Xmx4000m, -jar, /picard.jar]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      IntervalListTools
      SCATTER_COUNT=10
      SUBDIVISION_MODE=BALANCING_WITHOUT_INTERVAL_SUBDIVISION
      UNIQUE=true
      SORT=true
      INPUT=$(inputs.interval_list.path)
      OUTPUT=$(runtime.outdir)
inputs:
  interval_list: File
outputs:
  output:
    type: File[]
    outputBinding:
      glob: 'temp*/*.interval_list'
