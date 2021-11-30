#!/bin/bash
#PBS -S /bin/bash
#PBS -q SMP
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
REF=consensus.fasta
INBAM=IlluminaTruSeq2raven_sorted.bam
OUTDIR=pilon

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

pilon \
  --genome $REF \
  --frags $INBAM \
  --tracks \
  --changes \
  --threads $NCPUS \
  --outdir $OUTDIR