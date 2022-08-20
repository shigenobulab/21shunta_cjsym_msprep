#!/bin/sh
#PBS -q small
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate raxml-ng

### configs ###

OUTDIR=../analysis/ArsenophonusAllProteins/trimal_results
OUTF=$OUTDIR/`basename $INF .fasta`_trimal
GAPTHRESHOLD=1.0

###

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

trimal \
  -in $INF \
  -out ${OUTF}.fasta \
  -htmlout ${OUTF}.html \
  -gt $GAPTHRESHOLD \

conda deactivate
