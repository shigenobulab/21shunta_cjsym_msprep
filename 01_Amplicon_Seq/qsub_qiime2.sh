#!/bin/bash

SCRIPT=$1
DirNameList=$(cat Cjap_16Sread_list.txt)

for fastq_dir in $DirNameList
do
  qsub $SCRIPT -v IDX=$fastq_dir
done
