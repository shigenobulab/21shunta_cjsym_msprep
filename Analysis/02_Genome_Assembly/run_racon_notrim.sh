#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
READ=../data/210419_CjapNanoporeReads.fastq
# ALIGN=
# REF=
# OUTDIR=

###

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

racon \
  -t $NCPUS \
  --no-trimming \
  $READ \
  $ALIGN \
  $REF \
  > $OUTDIR/racon_notrim.fasta