#! /usr/bin/python3
import argparse
import textwrap as tw
from glob import glob
from Bio import SeqIO

parser = argparse.ArgumentParser()

parser.add_argument('-d', '--directory', nargs = 1, required = True)
parser.add_argument('-e', '--extension', nargs = 1, required = True, type = str)
parser.add_argument('-i', '--seq_id', nargs = 1, required = True, help = 'Input file containing IDs.')
parser.add_argument('-w', '--wrap', nargs = 1, default = 60, type = int)
args = parser.parse_args()

file_list = glob('{}/*.{}'.format(args.directory[0], args.extension[0]))
seq_id_file = args.seq_id[0]
seq_ids = []
seq_count = 0

if args.seq_id:
    with open(args.seq_id[0]) as f:
        for i in f:
            seq_ids.append(i.strip())

aa_seqs = [""] * len(seq_ids)

for file_name in file_list:
    with open(file_name) as f:
        for record in SeqIO.parse(f, "fasta"):
            aa_seqs[seq_count] += str(record.seq)
            seq_count += 1
        seq_count = 0

for i in aa_seqs:
    print(">{}".format(seq_ids[seq_count]))
    
    aa_seq_wrap = tw.fill(aa_seqs[seq_count], args.wrap)
    print(aa_seq_wrap)

    seq_count += 1
