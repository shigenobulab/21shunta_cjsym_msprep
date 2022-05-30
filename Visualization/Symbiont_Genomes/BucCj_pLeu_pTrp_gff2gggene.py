#!/usr/bin/env python3
from sys import argv
inputf = argv[1]

with open(inputf) as f:
    for i in f:
        if i.startswith("gnl|Prokka|BucCj_NOSY1_2") == True:
            if i.find("CDS") >= 0:
                ary = i.strip().split("\t")
            
                if ary[6] == "+":
                    ary[6] = "1"
                else:
                    ary[6] = "-1"
            
                if ary[8].find("2-isopropylmalate synthase") >= 0:
                    ary[8] = "leuA"
                elif ary[8].find("3-isopropylmalate dehydrogenase") >= 0:
                    ary[8] = "leuB"
                elif ary[8].find("3-isopropylmalate dehydratase large subunit") >= 0:
                    ary[8] = "leuC"
                elif ary[8].find("3-isopropylmalate dehydratase small subunit 1") >= 0:
                    ary[8] = "leuD"
                elif ary[8].find("hypothetical protein") >= 0 and ary[6] == "-1":
                    ary[8] = "yghA"
                elif ary[8].find("hypothetical protein") >= 0 and ary[6] == "1":
                    ary[8] = "repA"
                else:
                    ary[8] = ""

                print("pLeu", ary[3], ary[4], ary[6], ary[8], sep = "\t")
            else:
                continue

        if i.startswith("gnl|Prokka|BucCj_NOSY1_3") == True:
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

        
