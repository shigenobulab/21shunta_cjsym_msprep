#!/bin/sh
#PBS -q medium
#PBS -l ncpus=40
#PBS -l mem=10gb
cd $PBS_O_WORKDIR

### configs ###

NCPUS=40
DIR=../data/ArsenophonusProteins

###

source /etc/profile.d/modules.sh
module load OrthoFinder/2.5.2

orthofinder \
  -t $NCPUS \
  -f $DIR
