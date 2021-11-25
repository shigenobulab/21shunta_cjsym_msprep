#!/bin/sh
#PBS -S /bin/sh
#PBS -q small
#PBS -l ncpus=8
#PBS -l mem=4gb
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
# INF=
MFMT=FASTA
DTYPE=DNA
# MODEL=
NBS=1000
OUTF=`basename $INF .fasta`

###

raxml-ng \
  --msa $INF \
  --msa-format $MFMT \
  --data-type $DTYPE \
  --all \
  --model $MODEL \
  --bs-trees $NBS \
  --prefix $OUTF