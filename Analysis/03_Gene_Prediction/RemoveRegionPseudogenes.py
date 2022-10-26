#!/usr/bin/env python3

# load library
import argparse

# Description of this program
parser = argparse.ArgumentParser(
    description = '''Remove rows of feature labeled as "region" or "pseudogene".''')

# Set options
parser.add_argument('-i', '--input', nargs = 1, required = True, help = 'Input gff file.')
args = parser.parse_args()

# Set configs
inputf = args.input[0]

# Calculate gene density
with open(inputf) as f:
    for i in f:
        ary = i.strip().split("\t")
        if ary[0].startswith('#') == True: # Skip rows including '#' at the beginning of a sentence
            continue
        elif ary[0].startswith('>') == True:
            break
        elif ary [2] == "gene": # remove rows of feature labeled as "region" or "pseudogene"
            nextline = f.readline()
            ary2 = nextline.strip().split("\t")
            if ary2[2] == "CDS": # remove rows of rrna and trna sequences
                print(nextline, end = "")