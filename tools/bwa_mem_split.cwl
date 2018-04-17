class: CommandLineTool
cwlVersion: v1.0
id: bwa_mem_split
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 14000
    coresMin: 16
  - class: DockerRequirement
    dockerPull: 'zhangb1/kf-bwa-bundle'
  - class: InlineJavascriptRequirement
baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: |-
      ${
          var cmd = "";
          if (inputs.reads.nameext == ".bam") {
              cmd += "bamtofastq tryoq=1 filename=" + inputs.reads.path;
          } else {
              cmd += "cat " + inputs.reads.path;
          }
          cmd += " | bwa mem -K 100000000 -p -v 3 -t 16 -Y " + inputs.ref.path;
          cmd += " -R '" + inputs.rg.contents.split('\n')[0] + "' -";
          cmd += " | samblaster -i /dev/stdin -o /dev/stdout";
          cmd += " | sambamba view -t 16 -f bam -l 0 -S /dev/stdin";
          cmd += " | sambamba sort -t 16 --natural-sort -m 5GiB --tmpdir ./";
          cmd += " -o " + inputs.reads.nameroot + ".unsorted.bam -l 5 /dev/stdin";
          return cmd;
      }
inputs:
  ref:
    type: File
    secondaryFiles: [.64.amb, .64.ann, .64.bwt, .64.pac,
      .64.sa, .64.alt, ^.dict, .amb, .ann, .bwt, .pac, .sa]
  reads: File
  rg: { type: File, inputBinding: { loadContents: true } }

outputs:
  output: { type: File, outputBinding: { glob: '*.bam' } }
