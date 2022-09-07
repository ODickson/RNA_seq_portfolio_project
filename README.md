# RNA_seq_portfolio_project
Portfolio project for the processing and analysis of raw FASTQ files from E-MTAB-11605 (Genomewide expression profiling of multibacillary leprosy lesions before and after multi-drug therapy)

## What data  is there?
- 10 Individuals
  - 2 samples each
  - 1 before MDT
  - 1 after MDT
  - 30% were responders to the treatment
  
## What research questions:
1. Is there any differentially expressed genes between the responders and non responders?
2. Is there any differentially expressed genes between before treatement and after treatment?
3. Given 1. or 2. Can a ML classifier be created?

## RNA seq Workflow
![rnaseq_workflow](https://user-images.githubusercontent.com/59836053/188562342-930d3864-1345-439f-b895-8443a6ce268e.jpg)

### 1. Download and unzip the data
The raw data was downloaded from the European Nucleotide Archive using FTP under the accession PRJEB52164 using this bash script.

### 2. FastQC
Next FastQC was performed using this bash script.
FastQC provides a quick way to perform some quality control checks on the raw data.

### 3. Trim_Galore!
Trim Galore! is a wrapper for both Cutadapt and FastQC and removes low quality sequences. The settings used were a Phred score of 20 and a miniumum of 50% sequence length.
This uses this bash script

### 4. SortMeRNA
SortMeRNA is used to remove the rRNA, low quality, and adapter sequences.

```SHELL
# Read the json containing the sample_name : ftp_link mappings
# json is a list of dictionaries so get key for each dictionary
arr=()
while IFS='' read -r line; do
   arr+=("$line")
done < <(jq 'keys[]' filereport_read_run_PRJEB52164_json.txt)

for value in ${arr[@]}
do
    # extract sample title and ftp_link
    sample_title="$(jq ".[$value].sample_title" filereport_read_run_PRJEB52164_json.txt)"
    fastq_ftp="$(jq ".[$value].fastq_ftp" filereport_read_run_PRJEB52164_json.txt)"

    # sample_title= $(jq ".sample_title" $temp )
    echo $sample_title

    # some sample_titles map to two ftp_links so iterate through them
    for i in $(echo $fastq_ftp | tr ";" "\n")
    do
    echo ftp://"${i//[$'\t\r\n"']}"

    # download using FTP
    wget ftp://"${i//[$'\t\r\n"']}"
    done
done

# unzip the .gz files
gunzip *.gz
```

### 
