#!/bin/sh

#=== conf ===
REFIDX=raven_output.fa
NCPU=48
#
# Note)
# This template is used for generating batch scripts using ezjob utility
#
# IMPORTANT)
# If you are aligning phred64-format fastq,
# --phred64 should be added to bowtie2 option below 
#===


NAME=CjLtPF
# ex) idx12_single

SEQ1=Reads_Raw/Lt_1.fastq.gz
SEQ2=Reads_Raw/Lt_2.fastq.gz

bowtie2 \
 -1 $SEQ1 -2 $SEQ2 \
 -p $NCPU \
 -x $REFIDX \
 --end-to-end \
 --trim3 51 \
 --upto 100000000 \
 | samtools view -bS - \
 > $NAME.bam

## important options
# --end-to-end \
# -a, -k: how to treat multiple hits
#  -u/--upto <int>    stop after first <int> reads/pairs (no limit)
#  -5/--trim5 <int>   trim <int> bases from 5'/left end of reads (0)
#  -3/--trim3 <int>   trim <int> bases from 3'/right end of reads (0)

#echo "Finished: " `date`

