#!/usr/bin/env python3
from sys import argv
inputf = argv[1]

with open(inputf) as f:
    for i in f:
        if i.find("CDS") >= 0:
            ary = i.strip().split("\t")
            
            if ary[6] == "+":
                ary[6] = "1"
            else:
                ary[6] = "-1"
            
            if ary[8].find("Anthranilate synthase component 1") >= 0:
                ary[8] = "trpE"
            elif ary[8].find("Anthranilate synthase component 2") >= 0:
                ary[8] = "trpG"
            else:
                ary[8] = ""
            if ary[8] != "":
                print("pTrp", ary[3], ary[4], ary[6], ary[8], sep = "\t")
        else:
            continue
        
