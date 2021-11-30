#!/bin/sh
#PBS -S /bin/sh
#PBS -q smps
#PBS -l ncpus=18
cd $PBS_O_WORKDIR

### configs ###

NCPUS=18
READ=../data/210419_CjapNanoporeReads.fastq
OUTDIR=../analysis/210608_raven

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

raven \
  -t $NCPUS \
  $READ \
  > $OUTDIR/raven_output.fa