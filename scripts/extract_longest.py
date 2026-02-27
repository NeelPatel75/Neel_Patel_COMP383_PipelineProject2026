import sys
from Bio import SeqIO
# Map inputs from the terminal 
contigs_file = sys.argv[1]
out_file = sys.argv[2]
# Read FASTA sequences using Seq.parse
# Converts the Seq record into a list so they can be accessed by their index
contigs = list(SeqIO.parse(contigs_file, "fasta"))
# Find max based on sequence length
longest = max(contigs, key=lambda c: len(c.seq))
# Write out the longest fasta ina file 
SeqIO.write(longest, out_file, "fasta")