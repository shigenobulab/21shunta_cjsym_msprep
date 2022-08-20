#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
cd $PBS_O_WORKDIR

source /etc/profile.d/modules.sh
module load mafft/7.487

### CONFIGS ###

NCPUS=1
OUTDIR=../analysis/ArsenophonusAllProteins
OUTF=$OUTDIR/`basename $INF .fa`_mafft

###

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

mafft-linsi \
  --thread $NCPUS \
  $INF \
  > ${OUTF}.fasta
  2> ${OUTF}.log
