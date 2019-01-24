class: CommandLineTool
cwlVersion: v1.0
id: bwa_mem_split_sambamba
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 25000
    coresMin: 17
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/bogdang/bwa-kf-bundle:0.1.17'
  - class: InlineJavascriptRequirement
baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      date
      && echo "Start align"
      && bwa mem -K 100000000 -p -v 3 -t 36 -Y $(inputs.ref.path) -R '$(inputs.rg)' $(inputs.reads.path) | /opt/sambamba_0.6.3/sambamba_v0.6.3 view -t 17 -f bam -l 0 -S /dev/stdin > $(inputs.reads.nameroot).bwa.bam
      && date
      && echo "Finished align"
      && /opt/sambamba_0.6.3/sambamba_v0.6.3 sort -t 17 -m 15GiB --tmpdir ./ -o $(inputs.reads.nameroot).sorted.bam -l 5 $(inputs.reads.nameroot).bwa.bam
      && date
      && echo "Finished coord sort"
      && /opt/sambamba_0.6.3/sambamba_v0.6.3 markdup -t 17 --tmpdir MDUP_TMP $(inputs.reads.nameroot).sorted.bam $(inputs.reads.nameroot).sorted.mdup.bam
inputs:
  ref:
    type: File
    secondaryFiles: [.64.amb, .64.ann, .64.bwt, .64.pac,
      .64.sa, .64.alt, ^.dict, .amb, .ann, .bwt, .pac, .sa]
  reads: File
  rg: string

outputs:
  output: { type: File, outputBinding: { glob: '*.sorted.bam' } }
