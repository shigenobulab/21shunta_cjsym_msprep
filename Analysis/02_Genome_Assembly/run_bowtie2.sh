#!/bin/sh
#PBS -q MPP
#PBS -l ncpus=40
#PBS -l mem=50gb
cd $PBS_O_WORKDIR

source /etc/profile.d/modules.sh
module load bowtie2/2.4.2
module load samtools/1.13

### configs ###

DIR=pilon_1st
REF=consensus.fasta
OUTF=$DIR/IlluminaTruSeq2raven
READ1=Cj_1.cln.Q30L50.fastq.gz
READ2=Cj_2.cln.Q30L50.fastq.gz

if [ ! -d "$DIR" ]; then
  mkdir $DIR
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

rm ${OUTF}.sam