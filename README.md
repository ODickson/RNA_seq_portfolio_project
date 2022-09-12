# RNA Seq Portfolio Project
Portfolio project for the processing and analysis of raw FASTQ files from E-MTAB-11605 (Genomewide expression profiling of multibacillary leprosy lesions before and after multi-drug therapy). Here I provide bash scripts for use on Linux HPC to filter and align the raw RNA seq data before analysing the cleaned data in R and applying machine learning classification approaches to the data using Python.

## What data  is there?
- 10 Individuals
  - 2 samples each
  - 1 before MDT
  - 1 after MDT
  - 30% were responders to the treatment
  
## What research questions:
1. Is there any differentially expressed genes or pathways between the responders and non responders?
2. Is there any differentially expressed genes or pathways between before treatement and after treatment?
3. Given 1. or 2. Can a ML classifier be created?

## RNA seq Workflow
![rnaseq_workflow](https://user-images.githubusercontent.com/59836053/188562342-930d3864-1345-439f-b895-8443a6ce268e.jpg)

### Processing the Raw Seq Data using Bash Scripts
A breakdown of the bash scripts used for the alignment section of this project can be found in this [README file]().

### Differential Gene Expression and Pathway Analysis using R

A breakdown of the RNA Seq analysis using R can be found in this [README file]().

## Machine Learning using Python

A breakdown of the machine learning I applied to this data set can be found in this [README file]().
