#!/bin/bash

GENOME=References/raven_output.fa
DB=refseq_protein.fasta.dmnd
OUT=`basename $GENOME`.vs.`basename $DB`.blastx.dmnd.out
NCPU=60

diamond blastx \
 --query $GENOME \
 --max-target-seqs 25 \
 --sensitive \
 --threads $NCPU \
 --db $DB \
 --range-culling \
 --evalue 1e-25 \
 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids sscinames stitle  \
 --frameshift 15  \
 -c1 \
 --out $OUT
