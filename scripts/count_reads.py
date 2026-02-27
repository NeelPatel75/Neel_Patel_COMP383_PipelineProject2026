import sys

# Map inputs from the terminal 
sample = sys.argv[1]
raw_fastq = sys.argv[2]
mapped_fastq = sys.argv[3]
out_file = sys.argv[4]

def count_read_pairs(fastq_file):
    with open(fastq_file, 'r') as f: # Open the necessary files 
        lines = sum(1 for _ in f) # iterates through every line in the file and simply counts them
    return lines // 4 # Number of reads = number of lines divided by 4
# How much raw data there was 
before = count_read_pairs(raw_fastq)
# How much was left after filtering 
after = count_read_pairs(mapped_fastq)
 # Write out file 
with open(out_file, 'w') as f:
    f.write(f"Sample {sample} had {before} read pairs before and {after} read pairs after Bowtie2 filtering.\n")