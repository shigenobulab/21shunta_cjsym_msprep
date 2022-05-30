#!/usr/bin/env python3

# load library
import argparse

# Description of this program
parser = argparse.ArgumentParser(
    description = '''This program calculate gene density.''')

# Set options
parser.add_argument('-g', '--genome_size', nargs = 1, required = True, help = 'Input Genome size. ex) 1000000 ...')
parser.add_argument('-i', '--input', nargs = 1, required = True, help = 'Input gff file.')
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
        if ary[0].startswith('#') == True: # Skip rows including '#' at the beginning of a sentence
            continue
        elif ary[0].startswith('>') == True:
            break
        elif ary[0] == target_seq:
            if ary[2] == "gene":
                cds_len = int(ary[4]) - int(ary[3]) + 1
                cds_total += cds_len
            elif ary[2] == "pseudogene":
                pseudo_len = int(ary[4]) - int(ary[3]) + 1
                pseudo_total += pseudo_len

# Output results
only_cds_region = cds_total - pseudo_total
gene_density = only_cds_region / gensize
print("===", inputf, "===", sep = " ")
print("Genome Size: ", gensize, sep = "")
print("Total length of CDSs: ", cds_total, sep = "")
print("Total length of pseudogenes: ", pseudo_total, sep = "")
print("Gene density:", only_cds_region, "/", gensize, "=", round(gene_density * 100, 3), "%", sep = " ")