#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: splitByChrom 
doc: |
     splitByChrom
        split files (.ped .map) by chromosome 

requirements:
  ResourceRequirement:
    coresMax: 1
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}  # add prefix '/bin/sh -c' at the beginning of the commandline

baseCommand: [] # splitByChrom.sh

inputs:
  map: 
    type: File
    inputBinding:
      prefix: -m
  ped: 
    type: File
    inputBinding:
      prefix: -p
  out_prefix: 
    type: string
  chromosome: 
    type: string
    inputBinding:
      prefix: -c

arguments:
 - mkdir
 - -p 
 - splitByChrom
 - $('splitByChrom/' + inputs.chromosome)
 - '&&'
 - ~/WMS-benchmark/LodSeq/scripts/splitByChrom.sh
 - -o
 - $('splitByChrom/' + inputs.chromosome)
 - -s
 - $(inputs.out_prefix + '_vcftools_filled_chr')
 - -t
 - $(runtime.cores)

outputs:
  out_chr_map:
    type: File
    outputBinding: { glob: splitByChrom/$(inputs.chromosome)/$(inputs.out_prefix)_vcftools_filled_chr$(inputs.chromosome).map }
  out_chr_ped:
    type: File
    outputBinding: { glob: splitByChrom/$(inputs.chromosome)/$(inputs.out_prefix)_vcftools_filled_chr$(inputs.chromosome).ped }
  out_dir_sbc:
    type: Directory
    outputBinding: { glob: splitByChrom }

stdout: splitByChrom/$(inputs.chromosome)/splitByChrom.o
stderr: splitByChrom/$(inputs.chromosome)/splitByChrom.e

