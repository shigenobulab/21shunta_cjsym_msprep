#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
QV=20
MINCUT=25

INF1=../data/C_japonica_whole_body_10_individual_L001-ds.b4578ad908a14c8eac0055868fafd0b5/CJWBGD_S2_L001_R1_001.fastq.gz
INF2=../data/C_japonica_whole_body_10_individual_L001-ds.b4578ad908a14c8eac0055868fafd0b5/CJWBGD_S2_L001_R2_001.fastq.gz
ADP1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
ADP2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
OUTDIR=../data/C_japonica_whole_body_10_individual_L001-ds.b4578ad908a14c8eac0055868fafd0b5
OUTF1=$OUTDIR/`basename $INF1 .fastq.gz`.cln.Q${QV}L${MINCUT}.fastq.gz
OUTF2=$OUTDIR/`basename $INF2 .fastq.gz`.cln.Q${QV}L${MINCUT}.fastq.gz
LOG=$OUTDIR/`basename $INF1 .fastq.gz`_`basename $INF2 .fastq.gz`_cutadapt.log

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

cutadapt \
  --cores $NCPUS \
  --quality-cutoff $QV \
  --minimum-length $MINCUT \
  --trim-n \
  -a $ADP1 \
  -A $ADP2 \
  -o $OUTF1 \
  -p $OUTF2 \
  $INF1 \
  $INF2 \
  > $LOG 2>&1