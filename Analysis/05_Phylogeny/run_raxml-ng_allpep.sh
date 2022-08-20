#!/bin/sh
#PBS -q medium
#PBS -l ncpus=40
#PBS -l mem=32gb
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate raxml-ng

### configs ###

NCPUS=40
INDIR=../analysis/ArsenophonusAllProteins
INF=$INDIR/AlignmentsConcatenated.fasta
MSAFMT=FASTA
DATATYPE=AA
MODEL=CPREV+I+G4+F
NBS=1000
OUTDIR=$INDIR/RAxML-NG-outputs
OUTF=$OUTDIR/`basename $INF .fasta`_RMLNG

###

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

raxml-ng \
  --msa $INF \
  --msa-format $MSAFMT \
  --data-type $DATATYPE \
  --all \
  --model $MODEL \
  --bs-trees $NBS \
  --prefix $OUTF

conda deactivate
