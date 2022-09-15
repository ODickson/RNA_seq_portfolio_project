# RNA Seq Portfolio Project
Portfolio project for the processing and analysis of raw FASTQ files from E-GEOD-50760 (RNA-seq of 54 samples (normal colon, primary tumor, and liver metastases) from 18 colorectal cancer patients). Here I provide bash scripts for use on Linux HPC to filter and align the raw RNA seq data before analysing the cleaned data in R and applying machine learning classification approaches to the data using Python.

## What data is there?
- 18 Individuals
  - three samples each:
    - normal colonic epithelium
    - primary tumour
    - colorectal cancer metastatic in the liver
  
## What research questions:
1. Are there any differentially expressed genes between the three groups?
2. Can we create an ML classifier to classify test samples to each group?

## RNA seq Workflow
![rnaseq_workflow](https://user-images.githubusercontent.com/59836053/188562342-930d3864-1345-439f-b895-8443a6ce268e.jpg)

### Processing the Raw Seq Data using Bash Scripts
A breakdown of the bash scripts used for the alignment section of this project can be found in this [markdown file](bash_scripts.md).

### Differential Gene Expression and Pathway Analysis using R

A breakdown of the RNA Seq analysis using R can be found in this [README file]().

## Machine Learning using Python

