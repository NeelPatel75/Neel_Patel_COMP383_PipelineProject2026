import os
from snakemake.io import glob_wildcards

# Identify sample names based on the files 
SAMPLES, = glob_wildcards("test_data/{sample}_1.fastq")
# Defines the final file 
# Chnage the name of the final file depending on whatever the user wants 
rule all:
    input:
        "PipelineReport.txt"

# Step 2: Download HCMV genome and create Bowtie2 index
# Create ref directory
# Download HCMV genome from NCBI
# Extract the DNA sequence from the downloaded package
# Remove temporary zip file
# Create a searchable index for Bowtie2 mapping
rule get_genome_and_index: 
    output:
        genome = "ref/HCMV_genome.fna",
        idx1 = "ref/HCMV_idx.1.bt2"
    shell:
        """
        mkdir -p ref
        datasets download genome accession GCF_000845245.1 --filename ref/dataset.zip
        unzip -p ref/dataset.zip ncbi_dataset/data/GCF_000845245.1/*_genomic.fna > {output.genome}
        rm ref/dataset.zip
        bowtie2-build {output.genome} ref/HCMV_idx
        """

# Aligns data against the HCMV genome and saves matches in new file 
# Create directories for the results
# Run Bowtie2 to align paired-end reads to the HCMV reference
# Only save the reads that successfully map to the virus
# Delete the large SAM file to save space
# Use a custom Python script to log read counts before and after filtering
rule map_reads: 
    input:
        r1 = "test_data/{sample}_1.fastq",
        r2 = "test_data/{sample}_2.fastq",
        idx = "ref/HCMV_idx.1.bt2"
    output:
        mapped_1 = "mapped/{sample}_mapped_1.fastq",
        mapped_2 = "mapped/{sample}_mapped_2.fastq",
        report = "reports/{sample}_mapping_report.txt"
    shell:
        """
        mkdir -p mapped reports
        bowtie2 -x ref/HCMV_idx -1 {input.r1} -2 {input.r2} \
            --al-conc mapped/{wildcards.sample}_mapped_%.fastq \
            -S mapped/{wildcards.sample}.sam      
        rm mapped/{wildcards.sample}.sam
        python scripts/count_reads.py {wildcards.sample} {input.r1} {output.mapped_1} {output.report}
        """

# Step 3: SPAdes Assembly
# Identify forward and reverse reads 
# Uses SPAdes to reconstruct the viral genome from filtered reads
# -k 99 specifies the k-mer length 
rule spades_assembly:
    input:
        r1 = "mapped/{sample}_mapped_1.fastq",
        r2 = "mapped/{sample}_mapped_2.fastq"
    output:
        contigs = "spades/{sample}/contigs.fasta"
    shell:
        """
        spades.py -1 {input.r1} -2 {input.r2} -k 99 -o spades/{wildcards.sample}
        """

# Step 4: Analyze contigs using Python script
# Rule to analyze the quality and size of the assembly
# Run analyze_contigs.py to count total contigs and total BP in the assembly
# Run extract_longest.py to isolate the best sequence for BLAST identification  
rule analyze_contigs:
    input:
        contigs = "spades/{sample}/contigs.fasta"
    output:
        report = "reports/{sample}_contigs_report.txt",
        longest = "spades/{sample}/longest_contig.fasta" 
    shell:
        """
        python scripts/analyze_contigs.py {wildcards.sample} {input.contigs} {output.report}
        python scripts/extract_longest.py {input.contigs} {output.longest}
        """

# Step 5: Create a local BLAST database of Betaherpesvirinae from NCBI
rule fetch_db:
    output:
        fasta = "blast_db/betaherpesvirinae.fasta"
    shell:
        """
        mkdir -p blast_db
        python scripts/fetch_db.py {output.fasta}
        """

# Create a local BLAST database
rule make_blast_db:
    input:
        fasta = "blast_db/betaherpesvirinae.fasta"
    output:
        nhr = "blast_db/betaherpesvirinae.fasta.nhr"
    shell:
        """
        makeblastdb -in {input.fasta} -dbtype nucl -out blast_db/betaherpesvirinae.fasta
        """
# Use blastn to identify the longest contig by comparing it to the local DB
# Format BLAST output as a table with accession, identity, and title 
rule blast_longest:
    input:
        query = "spades/{sample}/longest_contig.fasta",
        # Use the .nhr file to tell Snakemake to wait for the DB to be ready
        db_index = "blast_db/betaherpesvirinae.fasta.nhr"
    output:
        blast_out = "reports/{sample}_blast.txt"     
    shell:
        """
        # We point -db to the prefix 'blast_db/betaherpesvirinae.fasta'
        blastn -query {input.query} -db blast_db/betaherpesvirinae.fasta \
            -max_target_seqs 5 -max_hsps 1 \
            -outfmt "6 sacc pident length qstart qend sstart send bitscore evalue stitle" \
            > {output.blast_out}
        """

# Compile all results into the PipelineReport.txt
# Chnage the name of the final file depending on whatever the user wants 
rule compile_final_report:
    input:
        mapping = expand("reports/{sample}_mapping_report.txt", sample=SAMPLES),
        contigs = expand("reports/{sample}_contigs_report.txt", sample=SAMPLES),
        blasts = expand("reports/{sample}_blast.txt", sample=SAMPLES)
    output:
        report = "PipelineReport.txt"
    shell:
        "python scripts/compile_report.py {output.report} {input.mapping} {input.contigs} {input.blasts}"
