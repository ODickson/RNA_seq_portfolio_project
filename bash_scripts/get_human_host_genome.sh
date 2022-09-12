# bash scrip to get the annotation and genome for release 41 and unzip
cd ..
mkdir annotation
cd annotation
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_41/gencode.v41.annotation.gtf.gz
gunzip gencode.v41.annotation.gtf.gz

cd ..
mkdir genome
cd genome
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_41/GRCh38.p13.genome.fa.gz