#!/usr/bin/env python3

# load library
import csv
import collections
import argparse

# Description of this program
parser = argparse.ArgumentParser(
    description = '''This program extracts and counts COG tag from 
    an EGGNOG-mapper annotation table and make a table for ggplot.''')

# Set options
parser.add_argument('-i', '--input', nargs = '*', required = True, help = 'Input file name. Multiple arguments can be input. ex) input1 input2 ...')
parser.add_argument('-g', '--genus', nargs = '*', required = True, help = 'Required. Input genus name. Multiple arguments can be input. ex) genus1 genus2 ...')
parser.add_argument('-s', '--strain', nargs = '*', required = True, help = 'Required. Input strain name. Multiple arguments can be input. ex) strain1 strain2 ...')
parser.add_argument('-hd', '--header', action = 'store_true', help = 'Optional. Output header.')
parser.add_argument('-ft', '--footer', action = 'store_true', help = 'Optional. Output footer.')

args = parser.parse_args()

# Set configs
TAG = []
COGs = []
INFNUM = 0
QCOUNT = 0 # Number of CDSs
DCOUNT = 0 # Number of CDSs with duplicated COG tags
INPUTF = args.input
GENUS = args.genus
STRAIN = args.strain
COGtags = [
    'D','M','N','O','T','U','V','W','Y','Z','A','B','J','K','L',
    'C','E','F','G','H','I','P','Q','R','S','-'
]
COGlabels = {
'D': 'Cell cycle control, cell division, chromosome partitioning',
'M': 'Cell wall/membrane/envelope biogenesis',
'N': 'Cell motility',
'O': 'Post-translational modification, protein turnover, and chaperones',
'T': 'Signal transduction mechanisms',
'U': 'Intracellular trafficking, secretion, and vesicular transport',
'V': 'Defense mechanisms',
'W': 'Extracellular structures',
'Y': 'Nuclear structures',
'Z': 'Cytoskeleton',
'A': 'RNA processing and modification',
'B': 'Chromatin structure and dynamics',
'J': 'Translation, ribosomal structure and biogenesis',
'K': 'Transcription',
'L': 'Replication, recombination and repair',
'C': 'Energy production and conversion',
'E': 'Amino acid transport and metabolism',
'F': 'Nucleotide transport and metabolism',
'G': 'Carbohydrate transport and metabolism',
'H': 'Coenzyme transport and metabolism',
'I': 'Lipid transport and metabolism',
'P': 'Inorganic ion transport and metabolism',
'Q': 'Secondary metabolites biosynthesis, transport, and catabolism',
'R': 'General function prediction only',
'S': 'Function unknown',
'-': 'Not in COGs'
}

# Output header
if args.header == True:
    print('# COGs summary from EGGNOG-mapper annotation table')
    print('# Genus, Strain, COG tag, COG description, Number of tags')

# Count COG tags
for inf in INPUTF:
    with open(inf) as f:
        tsv = csv.reader(f, delimiter = '\t')
        for i in tsv:
            if i[0].startswith('#') != True: # Skip rows including '#' at the beginning of a sentence
                QCOUNT += 1
                TAG = i[6]
                COGs += TAG
                if len(TAG) >= 2:
                    DCOUNT += 1
                    
        c = collections.Counter(COGs)

# Output results
        for j in COGtags:
            print(GENUS[INFNUM], STRAIN[INFNUM], j, COGlabels[j], c[j], sep = '\t')

# Output footer
        if args.footer == True:
            print('# === Finished [', GENUS[INFNUM], STRAIN[INFNUM], '] ===')
            print('# Number of scanned queries:', QCOUNT)
            print('# Number of queries assigned multiple COG tags:',DCOUNT)
            print('# ===')

# Reset parameters
        INFNUM += 1
        QCOUNT = 0
        DCOUNT = 0
        TAG = []
        COGs = []
