sortmernaREF=sortmerna_db/rRNA_databases/silva-arc-16s-id95.fasta,sortmerna_db/index/silva-arc-16s-id95:\
sortmerna_db/rRNA_databases/silva-arc-23s-id98.fasta,sortmerna_db/index/silva-arc-23s-id98:\
sortmerna_db/rRNA_databases/silva-bac-16s-id90.fasta,sortmerna_db/index/silva-bac-16s-id95:\
sortmerna_db/rRNA_databases/silva-bac-23s-id98.fasta,sortmerna_db/index/silva-bac-23s-id98:\
sortmerna_db/rRNA_databases/silva-euk-18s-id95.fasta,sortmerna_db/index/silva-euk-18s-id95:\
sortmerna_db/rRNA_databases/silva-euk-28s-id98.fasta,sortmerna_db/index/silva-euk-28s-id98

count=0
cd results/2_trimmed_output
for filename in *.fq;do
    count=$((count+1))
    filename="${filename%.*}"
    echo $count/26
    echo $filename
    cd /mnt/d/GitHub/RNA_seq_portfolio_project
    sortmerna \
    --ref $sortmernaREF \
    --reads results/2_trimmed_output/$filename.fq \
    --aligned results/3_rRNA/aligned/$filename _aligned.fq \
    --other results/3_rRNA/filtered/$filename _filtered.fq \
    --fastx \
    --log \
    -a 4 \
    -v
    mv -v results/3_rRNA/aligned//$filename _aligned.log results/3_rRNA/logs
    rm results/2_trimmed_output/$filename.fq
done