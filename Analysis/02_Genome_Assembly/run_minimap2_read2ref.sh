#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

PRESET=map-ont # Nanopore vs reference mapping
NCPUS=8
# REF=
READ=../data/210419_CjapNanoporeReads.fastq
OUTF=`basename $READ .fastq`_to_`basename $REF .fasta`
# OUTDIR=

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

minimap2 \
  -x $PRESET \
  -t $NCPUS \
  $REF \ # target.fa
  $READ \ # query.fa
  | gzip -1 \
  > $OUTDIR/${OUTF}.paf.gz