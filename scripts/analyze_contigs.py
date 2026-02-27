import sys
from Bio import SeqIO
# Map inputs from the terminal 
sample = sys.argv[1]
contigs_file = sys.argv[2]
out_file = sys.argv[3]
# Read FASTA sequences using Seq.parse
# Converts the Seq record into a list so they can be accessed by their index
contigs = list(SeqIO.parse(contigs_file, "fasta"))
# Create a new list containing only contigs longer than 1,000 base pairs
long_contigs = [c for c in contigs if len(c.seq) > 1000]
# Sum up the lengths of all the sequences that passed the filter
total_len = sum(len(c.seq) for c in long_contigs)
# Write the outfile 
with open(out_file, 'w') as f:
    f.write(f"In the assembly of sample {sample}, there are {len(long_contigs)} contigs > 1000 bp and {total_len} total bp.\n")