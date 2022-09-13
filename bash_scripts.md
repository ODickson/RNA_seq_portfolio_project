# Bash Scripts for the processing of raw RNA Seq files

## 1. Download files
For the E-MTAB-11605 entry there was a json available containing the FTP links to each of the raw RNA Seq files saved as `*.fastq.gz`.
In this case all we need to do is read the json and loop through the FTP links calling wget on each and saving them to the `/input` folder. Which can be done using the following code. The files can then be unzipped by the `gunzip` command.

```bash
#!/usr/bin/env bash

cd input # change directory into the input directory
arr=()
while IFS='' read -r line; do # get key for each line in the json
   arr+=("$line")
done < <(jq 'keys[]' filereport_read_run_PRJEB52164_json.txt)

for value in ${arr[@]}
do
    # for each key get sample title and ftp link
    sample_title="$(jq ".[$value].sample_title" filereport_read_run_PRJEB52164_json.txt)"
    fastq_ftp="$(jq ".[$value].fastq_ftp" filereport_read_run_PRJEB52164_json.txt)"

    for i in $(echo $fastq_ftp | tr ";" "\n")
    do
    # call wget on the ftp link
    wget ftp://"${i//[$'\t\r\n"']}"q
    done
done
```

## 2. Quality Analysis - FastQC
The first step in any pipeline is to analyse the quality of the data. `.fastq` files already have some quality information with each base call. FastQC performs some simple quality controll checks on the raw sequence data using this information and determines any irregularities that could effect the results.

```bash
#!/usr/bin/env bash

for filename in input/*.fastq;do # loop through each filename
    # run tfastqc outputting to the results/1_initial_qc/ folder
    fastqc -o results/1_initial_qc/ --noextract $filename 
done
```

## 3. Base Quality Filtering - Trim Galore!
After looking at the FastQC results the next step is to remove those sequences that do not meet the quality standards. Trim Galore! does this by wrapping Cutadapt and FastQC to remove the low quality and adapter sequences and performing quality analysis to see the effect of this filtering.

```Bash
#!/usr/bin/env bash
for filename in input/*.fastq;
    # loop through each file in the input directory
    # output to results/2_trimmed_output/ directory
    trim_galore \
    --quality 20 \
    --fastqc \
    --length 25 \
    --cores 4 \
    --output_dir results/2_trimmed_output/ \
    $filename
done
```

## 4. Ribosomal Sequence Filtering - SortMeRNA
Once the low quality and adapter sequences have been removed, ribosomal RNA sequences can then be removed incase the samples were not prepared with an rRNA depletion protocol. This can be done by using SortMeRNA which filters out rRNA from metatranscriptomic data. For SortMeRNA to work effectively we need to first generate indexes in the `/sortmerna_db` folder by using the eukaryotic, archeal and bacterial rRNA databases.

### 4.1 Generate SortMeRNA indexes
```bash
#!/usr/bin/env bash
# Download the sortmerna package (~2min) into sortmerna_db folder
wget -P sortmerna_db https://github.com/biocore/sortmerna/archive/2.1b.zip

# Decompress folder 
unzip sortmerna_db/2.1b.zip -d sortmerna_db

# Move the database into the correct folder
mv sortmerna_db/sortmerna-2.1b/rRNA_databases/ sortmerna_db/

# Remove unnecessary folders
rm sortmerna_db/2.1b.zip
rm -r sortmerna_db/sortmerna-2.1b

# Save the location of all the databases into one folder
sortmernaREF=sortmerna_db/rRNA_databases/silva-arc-16s-id95.fasta,sortmerna_db/index/silva-arc-16s-id95:\
sortmerna_db/rRNA_databases/silva-arc-23s-id98.fasta,sortmerna_db/index/silva-arc-23s-id98:\
sortmerna_db/rRNA_databases/silva-bac-16s-id90.fasta,sortmerna_db/index/silva-bac-16s-id95:\
sortmerna_db/rRNA_databases/silva-bac-23s-id98.fasta,sortmerna_db/index/silva-bac-23s-id98:\
sortmerna_db/rRNA_databases/silva-euk-18s-id95.fasta,sortmerna_db/index/silva-euk-18s-id95:\
sortmerna_db/rRNA_databases/silva-euk-28s-id98.fasta,sortmerna_db/index/silva-euk-28s-id98

# Run the indexing command (~8 minutes)
indexdb_rna --ref $sortmernaREF 
```
### 4.2 Perform SortMeRNA
```bash
#!/usr/bin/env bash
# Save the location of all the databases into one variable
sortmernaREF=sortmerna_db/rRNA_databases/silva-arc-16s-id95.fasta,sortmerna_db/index/silva-arc-16s-id95:\
sortmerna_db/rRNA_databases/silva-arc-23s-id98.fasta,sortmerna_db/index/silva-arc-23s-id98:\
sortmerna_db/rRNA_databases/silva-bac-16s-id90.fasta,sortmerna_db/index/silva-bac-16s-id95:\
sortmerna_db/rRNA_databases/silva-bac-23s-id98.fasta,sortmerna_db/index/silva-bac-23s-id98:\
sortmerna_db/rRNA_databases/silva-euk-18s-id95.fasta,sortmerna_db/index/silva-euk-18s-id95:\
sortmerna_db/rRNA_databases/silva-euk-28s-id98.fasta,sortmerna_db/index/silva-euk-28s-id98


for filename in 2_trimmed_output/*.fq;
    sortmerna \
    --ref $sortmernaREF \
    --reads results/2_trimmed_output/ $filename \
    --aligned results/3_rRNA/aligned/$filename \
    --other results/3_rRNA/filtered/$filename \
    --fastx \
    --log \
    -a 4 \
    -v
done

# Move logs into the correct folder
mv -v results/3_rRNA/aligned//sample_aligned.log results/3_rRNA/logs
```

## 5. Genome Alignment - STAR-aligner
Next the RNA Seq data needs to be aligned to the human genome. This can be done by using STAR-aligner producing a `.BAM` file. Like SortMeRNA STAR-aligner needs an index of the genome we want to align.

### 5.1 Create STAR index
```bash
STAR \
--runMode genomeGenerate \
--genomeDir star_index \
--genomeFastaFiles genome/* \ # input genome
--sjdbGTFfile annotation/* \ # input annotation file
--runThreadN 4
```

### 5.2 STAR-aligner command
```bash

for filename in filtered/*.fq;
STAR \
--genomeDir star_index \
--readFilesIn filtered/$filename  \
--runThreadN 4 \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts
done

# Move the BAM file into the correct folder
mv -v results/4_aligned_sequences/sampleAligned.sortedByCoord.out.bam results/4_aligned_sequences/aligned_bam/

# Move the logs into the correct folder
mv -v results/4_aligned_sequences/${BN}Log.final.out results/4_aligned_sequences/aligned_logs/
mv -v results/4_aligned_sequences/sample*Log.out results/4_aligned_sequences/aligned_logs/
```
## 6. Count Mapped Reads - featureCounts
Finally, we can summarise the .BAM files into genes and abundaces using featureCounts producing a final gene sample raw abunace table for statistical analysis.

```bash
# Store list of files as a variable
dirlist=$(ls -t ./*.bam | tr '\n' ' ')

featureCounts \
-a ../../annotation/* \
-o ../../results/5_final_counts/final_counts.txt \
-g 'gene_name' \
-T 4 \
```

## 7. Cleaning Analysis Report - multiQC (optional)
During the previous steps lots of log files containing quality metrics were created which multiQC can iterate through and produce rich figures enabling us to determine how well sequences where alighend and how many sequences were lost at each step.

```bash
# Run multiqc and output results into final folder
multiqc results \
--outdir results/6_multiQC
```
