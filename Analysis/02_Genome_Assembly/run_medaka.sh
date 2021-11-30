#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
READ=../data/210419_CjapNanoporeReads.fastq
# REF=
MODEL=r103_min_high_g360
# {pore type: R 10.3}_{device: MinION}_{caller_variant: High-accuracy basecalling model}_
# {caller_version: Guppy 4.3.4 (I selected latest one 'g360' in medaka v1.4.1)}
# OUTDIR=

###

medaka_consensus \
  -t $NCPUS \
  -i $READ \
  -d $REF \
  -o $OUTDIR \
  -m $MODEL
