#!/usr/bin/python3
import re
from sys import argv

aa_fasta = argv[1]

def dayhoff6(seq): # Amino acids to Dayhoff6 categories
    seq = re.sub(r'[AGPST]', 'S', seq) # Ala, Gly, Pro, Ser, Thr: Small
    seq = re.sub(r'[DENQ]', 'N', seq) # Asp, Glu, Asn, Gln: Acid and amide
    seq = re.sub(r'[HKR]', 'P', seq) # His, Lys, Arg: Basic
    seq = re.sub(r'[ILMV]', 'H', seq) # Ile, Leu, Val, Met: Hydrophobic
    seq = re.sub(r'[FWY]', 'A', seq) # Phe, Trp, Tyr: Aromaticity
    return(seq) # Cys : sulfur polymerization

with open(aa_fasta) as f:
    for i in f:
        if i.startswith('>'):
            print(i, end = '')
        else:
            aa_seq = i.strip()
            aa_recoded = dayhoff6(aa_seq)
            print(aa_recoded)
