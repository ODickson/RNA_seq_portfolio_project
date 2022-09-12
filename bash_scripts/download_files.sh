cd ..
cd input
arr=()
while IFS='' read -r line; do
   arr+=("$line")
done < <(jq 'keys[]' filereport_read_run_PRJEB52164_json.txt)


for value in ${arr[@]}
do
    sample_title="$(jq ".[$value].sample_title" filereport_read_run_PRJEB52164_json.txt)"
    fastq_ftp="$(jq ".[$value].fastq_ftp" filereport_read_run_PRJEB52164_json.txt)"

    # sample_title= $(jq ".sample_title" $temp )
    echo $sample_title

    for i in $(echo $fastq_ftp | tr ";" "\n")
    do
    echo ftp://"${i//[$'\t\r\n"']}"
    wget ftp://"${i//[$'\t\r\n"']}"
    done


done