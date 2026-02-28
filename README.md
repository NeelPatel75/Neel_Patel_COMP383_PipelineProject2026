# HCMV Transcriptome Analysis Pipeline
# Author: Neel Patel  
# Course: COMP 383 Computational Biology

## Description: 
#### This Snakemake pipeline automates the analysis of HCMV transcriptomes from two patient donors at 2- and 6-days post-infection. The pipeline performs: 
#### 1. Genome indexing and read filtering (Bowtie2).
#### 2. De novo assembly (SPAdes).
#### 3. Assembly statistics and longest contig extraction.
#### 4. Local BLAST identification against the Betaherpesvirinae subfamily.

## Instructions on how to run the code: 
#### First, clone the pipeline to the local environment using the following in the terminal. 
    git clone https://github.com/NeelPatel75/Neel_Patel_COMP383_PipelineProject2026.git
    cd Neel_Patel_COMP383_PipelineProject2026
#### Then install the following tools required to run the pipeline:
#### Copy and paste the following in the terminal to create a conda environment. 
    conda create -n pipeline_env -y
    conda activate pipeline_env 
#### Then copy this to the terminal, install all of the necessary packages and programs. 
    conda install -c bioconda -c conda-forge snakemake bowtie2 spades blast biopython ncbi-datasets-cli -y
###### Note: the user can change the name of the final file by editing the input and output in the Snakefile ( Not necessary).  
#### 3. Once the environment is set up, it is time to run the pipeline 
#### First, make sure all of the old files created in the pipeline are deleted so that snakmake starts fresh. To do so paste the following in the terminal:  
    rm -rf mapped/ spades/ ref/ reports/ blast_db/ 
    rm nohup.out
    rm -rf .snakemake/
#### Next, paste the following into the terminal for a dry run to ensure all of the jobs are downloaded. 
    snakemake -n
#### If it states a long list of jobs, then the pipeline is good to go. 
#### Now run the following in the terminal to do an actual run.  
    snakemake --cores 1
#### If conducting a longer run (not with this dataset), feel free to use the following 
    nohup snakemake --cores 4 
#### This will allow the user to close their laptop in case they have to leave, as the run could take a large amount of time. 
#### To check the progress of the run, paste the following in the terminal 
    tail -f nohup.out
#### Once the pipeline is complete, there will be a message at the bottom after running the above code stating: 
    Finished job 0.
    n of n steps (100%) done
    Complete log: .snakemake/log/---------------.snakemake.log 
###### Note: if running with the data from test_data, there is no need for nohup, and updates will be shown in the terminal.
#### Open and check the final file by pasting the following into the terminal 
    cat PipelineReport.txt
## Sources 
#### https://ablab.github.io/spades/installation.html
#### https://snakemake.readthedocs.io/en/master/tutorial/basics.html
#### https://www.geeksforgeeks.org/python/python-lambda-anonymous-functions-filter-map-reduce/
#### https://www.geeksforgeeks.org/python/python-sys-module/
#### https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html









