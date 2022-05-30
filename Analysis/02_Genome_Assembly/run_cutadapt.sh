#!/bin/sh
#PBS -q medium
#PBS -l ncpus=32
#PBS -l mem=50gb
cd $PBS_O_WORKDIR

source /etc/profile.d/modules.sh
module load cutadapt/2.10

### configs ###

NCPUS=32
QV=30
OL=7
MINCUT=50

INF1=Lt_1.fastq.gz
INF2=Lt_2.fastq.gz
ADP1=CTGTCTCTTATACACATCT
ADP2=ATGTGTATAAGAGACA
OUTF1=`basename $INF1 .fastq.gz`.cln.Q${QV}L${MINCUT}.fastq.gz
OUTF2=`basename $INF2 .fastq.gz`.cln.Q${QV}L${MINCUT}.fastq.gz
LOG=`basename $INF1 .fastq.gz`_`basename $INF2 .fastq.gz`_cutadapt.log

###

cutadapt \
  --cores $NCPUS \
  --quality-cutoff $QV \
  --overlap $OL \
  --minimum-length $MINCUT \
  --trim-n \
  -a $ADP1 \
  -a $ADP2 \
  -A $ADP1 \
  -A $ADP2 \
  -o $OUTF1 \
  -p $OUTF2 \
  $INF1 \
  $INF2 \
  > $LOG 2>&1