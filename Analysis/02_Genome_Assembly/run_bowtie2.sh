#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=8
cd $PBS_O_WORKDIR

### configs ###

NCPUS=8
REF=consensus.fasta
READ1=CJWBGD_S2_L001_R1_001.cln.Q20L25.fastq.gz
READ2=CJWBGD_S2_L001_R2_001.cln.Q20L25.fastq.gz
OUTF=IlluminaTruSeq2raven

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

bowtie2-build \
  -f $REF \
  $REF

bowtie2 \
  -p $NCPUS \
  -x $REF \
  -1 $READ1 \
  -2 $READ2 \
  -S ${OUTF}.sam \
  > ${OUTF}_bowtie2.log 2>&1

samtools sort \
  ${OUTF}.sam \
  -o ${OUTF}_sorted.bam

samtools index \
  ${OUTF}_sorted.bam