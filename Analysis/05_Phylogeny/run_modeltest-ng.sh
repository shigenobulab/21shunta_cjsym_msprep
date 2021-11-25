#!/bin/sh
#PBS -S /bin/sh
#PBS -q small
#PBS -l ncpus=2
cd $PBS_O_WORKDIR

### configs ###

NCPUS=2
DATATYPE=nt
# INF=
OUTF=`basename $INF .fasta`_MTNG

###

modeltest-ng \
  --processes $NCPUS \
  --datatype $DATATYPE \
  --input $INF \
  --output $OUTF