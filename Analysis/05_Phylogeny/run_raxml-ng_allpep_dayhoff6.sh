#!/bin/sh
#PBS -q blast
#PBS -l ncpus=40
#PBS -l mem=32gb
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate raxml-ng

### configs ###

NCPUS=40
INDIR=../analysis/ArsenophonusAllProteins
INF=$INDIR/AlignmentsConcatenatedRecoded.fasta
MSAFMT=FASTA
MODEL=MULTI6_GTR+I+G4+M{SNPHAC}{X}
NBS=1000
OUTDIR=$INDIR/RAxML-NG-outputs_dayhoff6
OUTF=$OUTDIR/`basename $INF .fasta`_RMLNG

###

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

raxml-ng \
  --msa $INF \
  --msa-format $MSAFMT \
  --all \
  --model $MODEL \
  --bs-trees $NBS \
  --prefix $OUTF

conda deactivate
