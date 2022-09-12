#!/bin/bash
ls
count=0
for filename in input/*.fastq;do
    count=$((count+1))
    echo $count/26
    echo $filename

    trim_galore \
    --quality 20 \
    --fastqc \
    --length 25 \
    --cores 4 \
    --output_dir results/2_trimmed_output/ \
    $filename
done