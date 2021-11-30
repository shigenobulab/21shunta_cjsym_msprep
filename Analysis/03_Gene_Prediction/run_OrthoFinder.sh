#!/bin/sh
#PBS -S /bin/sh
#PBS -q small
#PBS -l ncpus=16
cd $PBS_O_WORKDIR

### configs ###

NCPUS=16
# DIR=

###

orthofinder \
  -t $NCPUS \
  -f $DIR