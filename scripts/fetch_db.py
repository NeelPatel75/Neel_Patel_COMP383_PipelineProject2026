import sys
from Bio import Entrez
# Map input from the terminal 
out_fasta = sys.argv[1]
# Email 
Entrez.email = "npatel79@luc.edu" 

# Makes sure to look for the Betaherpesvirine refseq data in NCBI  
query = "Betaherpesvirinae[Organism] AND refseq[filter]"
# Look through the nucleotide db 
search_handle = Entrez.esearch(db="nucleotide", term=query, retmax=100)
record = Entrez.read(search_handle) #Parse the search results 
ids = record["IdList"] # Extract the list of IDs found
# Get the necessary information for Betaherpesvirine 
fetch_handle = Entrez.efetch(db="nucleotide", id=ids, rettype="fasta", retmode="text")
# Write the output 
with open(out_fasta, "w") as f:
    f.write(fetch_handle.read())