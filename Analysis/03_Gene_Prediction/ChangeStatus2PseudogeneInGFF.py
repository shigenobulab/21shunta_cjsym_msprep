#!/bin/usr/env python3

from sys import argv
pgene_file = argv[1]
gff_file = argv[2]

pgene_list = []

with open(pgene_file) as f:
    for i in f:
        pgene_list.append(i.strip())

with open(gff_file) as f:
    for i in f:
        ary = i.strip().split('\t')
        if i.startswith('#') == True:
            print(i, end = '')
        elif ary[0].startswith('gnl') == True:
            if ary[2] == 'gene':
                for j in pgene_list:
                    if ary[8].find(j) >= 0:
                        ary[2] = 'pseudogene'
                    else:
                        continue
            print('\t'.join(ary))
        else:
            print(i, end = '')