#!/usr/bin/env python3

# load library
import collections
import argparse

# Description of this program
parser = argparse.ArgumentParser(
    description = '''This program calculate gene density. (Genome size) - (All CDS length) + (Pseudogene length)''')

# Set options
parser.add_argument('-g', '--genome_size', nargs = 1, required = True, help = 'Input Genome size. ex) 1000000 ...')
parser.add_argument('-i', '--input', nargs = 1, required = True, help = 'Input gff file.')
parser.add_argument('-p', '--pseudogene', nargs = 1, required = False, help = 'Input list file of pseudogene IDs.')

args = parser.parse_args()

# Set configs
GENSIZE = int(args.genome_size[0])
INPUTF = args.input[0]
CDS_TOTAL = 0
PSEUDO_TOTAL = 0

# Calculate gene density
with open(INPUTF) as f:
    for i in f:
        ary = i.strip().split("\t")
        if ary[0].startswith('#') == True: # Skip rows including '#' at the beginning of a sentence
            continue
        elif ary[0].startswith('>') == True:
            break
        else:
            if ary[2] == "CDS":
                CDS_LEN = int(ary[4]) - int(ary[3]) + 1
                CDS_TOTAL += CDS_LEN

if args.pseudogene:
    PSEUDO_LIST = []
    with open(args.pseudogene[0]) as f:
        for i in f:
            PSEUDO_LIST.append(i.strip())

    with open(args.input[0]) as f:
        for i in f:
            ary = i.strip().split("\t")
            if ary[0].startswith('#') == True: # Skip rows including '#' at the beginning of a sentence
                continue
            elif ary[0].startswith('>') == True:
                break
            else:
                if ary[2] == "CDS":
                    ATTR_ary = ary[8].strip().split(";")
                    if ATTR_ary[0].lstrip("ID=") in PSEUDO_LIST:
                        PSEUDO_LEN = int(ary[4]) - int(ary[3]) + 1
                        PSEUDO_TOTAL += PSEUDO_LEN

# Output results
ONLY_CDS_RESION = CDS_TOTAL - PSEUDO_TOTAL
GENE_DENSITY = ONLY_CDS_RESION / GENSIZE
print("===", INPUTF, "===", sep = " ")
print("Genome Size: ", GENSIZE, sep = "")
print("Total length of CDSs: ", CDS_TOTAL, sep = "")
print("Total length of pseudogenes: ", PSEUDO_TOTAL, sep = "")
print("Gene density:", ONLY_CDS_RESION, "/", GENSIZE, "=", round(GENE_DENSITY * 100, 3), "%", sep = " ")