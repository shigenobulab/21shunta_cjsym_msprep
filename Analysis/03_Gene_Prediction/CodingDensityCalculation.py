#!/usr/bin/env python3

# load library
import argparse

# Description of this program
parser = argparse.ArgumentParser(
    description = '''This program calculate gene density.''')

# Set options
parser.add_argument('-g', '--genome_size', nargs = 1, required = True, help = 'Input Genome size. ex) 1000000 ...')
parser.add_argument('-i', '--input', nargs = 1, required = True, help = 'Input bed file.')
parser.add_argument('-t', '--target', nargs = 1, required = True, help = 'Input name of a target sequence.')
args = parser.parse_args()

# Set configs
gensize = int(args.genome_size[0])
inputf = args.input[0]
target_seq = args.target[0]
cds_total = 0
pseudo_total = 0

# Calculate gene density
with open(inputf) as f:
    for i in f:
        ary = i.strip().split("\t")
        if ary[0] == target_seq:
            cds_len = int(ary[2]) - int(ary[1])
            cds_total += cds_len

# Output results
gene_density = cds_total / gensize
print("===", inputf, "===", sep = " ")
print("Genome Size: ", gensize, sep = "")
print("Total length of CDSs: ", cds_total, sep = "")
print("Gene density:", cds_total, "/", gensize, "=", round(gene_density * 100, 3), "%", sep = " ")