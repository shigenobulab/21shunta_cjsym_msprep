#!/usr/bin/env python3
from sys import argv
inputf = argv[1]

with open(inputf) as f:
    for line in f:
        if line.startswith("#") == False:
            ary = line.strip().split("\t")
            seqid = ary[0]
            keggid = ary[11].split(",")
            if keggid[0] == "-":
                continue
            elif len(keggid) == 1:
                keggid_rev = keggid[0].strip("ko:")
                print(seqid, keggid_rev, sep = "\t")
            elif len(keggid) > 1:
                for i in range(len(keggid)):
                    keggid_rev = keggid[i].strip("ko:")
                    print(seqid, keggid_rev, sep = "\t")