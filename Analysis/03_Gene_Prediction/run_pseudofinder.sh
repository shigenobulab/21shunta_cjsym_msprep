#!/bin/sh
#PBS -q small
#PBS -l ncpus=8
#PBS -l mem=10gb
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate pseudofinder

### configs ###

INDIR=BucCj_prokka
GENBANK=$INDIR/BucCj.gbk
PREFIX=`basename $GENBANK .gbk`
DB=~/database/swissprot_bacteria/uniprot-reviewed_yes+taxonomy_2.fasta
LOG=`basename $GENBANK .gbk`_pseudofinder

###

pseudofinder.py annotate \
  --genome $GENBANK \
  --outprefix $PREFIX \
  --database $DB \
  --diamond \
  --skip_makedb \
  --threads $NCPUS \
  > ${LOG}.log 2>&1

conda deactivate