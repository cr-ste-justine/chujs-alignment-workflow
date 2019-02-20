class: CommandLineTool
cwlVersion: v1.0
id: bwa_mem_fq
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6000
    coresMin: 3
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/bogdang/bwa-kf-bundle:0.1.17'
  - class: InlineJavascriptRequirement
baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      bwa mem -K 10000000 -v 2 -t 3
      -Y $(inputs.ref.path)
      -R '$(inputs.rg)' $(inputs.file_R1.path)
      | /opt/samblaster/samblaster -i /dev/stdin -o /dev/stdout
      | /opt/sambamba_0.6.3/sambamba_v0.6.3 view -t 3 -f bam -l 0 -S /dev/stdin
      | /opt/sambamba_0.6.3/sambamba_v0.6.3 sort -t 3 --natural-sort -m 2GiB --tmpdir ./
      -o $(inputs.file_R1.nameroot).unsorted.bam -l 5 /dev/stdin
inputs:
  ref:
    type: File
    secondaryFiles: [.64.amb, .64.ann, .64.bwt, .64.pac,
      .64.sa, .64.alt, ^.dict, .amb, .ann, .bwt, .pac, .sa]
  file_R1: File
  file_R2: File
  rg: string

outputs:
  output: { type: File, outputBinding: { glob: '*.bam' } }
