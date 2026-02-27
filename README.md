# HCMV Transcriptome Analysis Pipeline
## Author: Neel Patel  
## Course: COMP 383 Computational Biology

### Description: 
#### This Snakemake pipeline automates the analysis of HCMV transcriptomes from two patient donors at 2- and 6-days post-infection. The pipeline performs: 
#### 1. Genome indexing and read filtering (Bowtie2).
#### 2. De novo assembly (SPAdes).
#### 3. Assembly statistics and longest contig extraction.
#### 4. Local BLAST identification against the Betaherpesvirinae subfamily.

#### Instructions on how to run the code: 
#### 1. The following tools are required to run the pipeline:
#### Copy and paste the following in the terminal.  
    conda create -n pipeline_env -c bioconda -c conda-forge \
    snakemake bowtie2 spades blast-plus biopython datasets -y 
#### Activate the environment by pasting the following into the terminal.
    conda activate pipeline_env

#### 2. Next, clone the pipeline to the local environment using the following in the terminal. 
    git clone [Your GitHub URL]
    cd [Your Repo Name]

#### 3. There is test_data included so that the pipeline runs in a timely manner. 
#### In the snakefile, make the following changes to use the test file for a faster run (<2 min)
#### Copy and paste: 
    # For the test data 
    SAMPLES, = glob_wildcards("test_data/{sample}_1.fastq") 
#### where it states:
    # For the actual donor data
    SAMPLES, = glob_wildcards("donor_data/{sample}_1.fastq")
#### Copy and paste: 
        # For the test data 
        r1 = "test_data/{sample}_1.fastq",
        r2 = "test_data/{sample}_2.fastq",
        idx = "ref/HCMV_idx.1.bt2"
#### Where it states:
        # For the actual donor data 
        r1 = "donor_data/{sample}_1.fastq",
        r2 = "donor_data/{sample}_2.fastq",
        idx = "ref/HCMV_idx.1.bt2"
###### Note: If you want to run the code using don_data rather than test_data, the above changes do not need to be made; both are included in the pipeline. 
#### Additionally, the user can change the name of the final file. 
#### 4. Once the changes above have been made, it is time to run the pipeline 
#### First, paste the following into the terminal for a dry run to ensure all of the jobs are downloaded. 
    snakemake -n
#### If it states a long list of jobs, then the pipeline is good to go. 
#### Now run the following in the terminal to do an actual run.  
    snakemake --cores 4
#### If conducting a longer run, feel free to use 
    nohup snakemake --cores 4 
#### This will allow the user to close their laptop in case they have to leave, as the run could take a large amount of time. 
#### To check the progress of the run, paste the following in the terminal 
    tail -f snakemake.log
#### Once the pipeline is complete, there will be a message at the bottom after running the above code stating: 
[ day/time ]
Finished job 0.
n of n steps (100%) done
Complete log: .snakemake/log/---------------.snakemake.log 
#### Open and check the final file by pasting the following into the terminal 
    cat pipeline_name








