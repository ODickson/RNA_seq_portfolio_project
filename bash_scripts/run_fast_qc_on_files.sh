#!/bin/bash
cd ../..
pwd
ls
for filename in input/*.fastq;do
    echo $filename
    fastqc -o results/1_initial_qc/ --noextract $filename
done