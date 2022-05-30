#!/bin/sh
#PBS -q MPP
#PBS -l ncpus=40
#PBS -l mem=50gb
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

### configs ###

DIR=pilon
REF=consensus.fasta
INBAM=$DIR/IlluminaTruSeq2raven_sorted.bam
LOG=$DIR/pilon

if [ ! -d "$DIR" ]; then
  mkdir $DIR
fi

###

pilon \
  --genome $REF \
  --frags $INBAM \
  --tracks \
  --changes \
  --threads $NCPUS \
  --outdir $DIR \
  > ${LOG}.log 2>&1

conda deactivate
