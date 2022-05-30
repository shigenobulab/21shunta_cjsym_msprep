#!/bin/usr/env python3

from sys import argv
pgene_file = argv[1]
eggano = argv[2]

pgene_list = []

with open(pgene_file) as f:
    for i in f:
        pgene_list.append(i.strip())

with open(eggano) as f:
    for i in f:
        ary = i.strip().split('\t')
        if i.startswith('#') == True:
            print(i, end = '')
        elif ary[0] in pgene_list:
            continue
        else:
            print(i, end = '')