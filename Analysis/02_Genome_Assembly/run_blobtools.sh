GENOME=References/raven_output.fa
BAM=CjLtPF.srt.bam
HIT=raven_output.fa.vs.refseq_protein.fasta.dmnd.blastx.dmnd.out.taxified
NAME=Cj_raven_02
TAXDB=blobtools/data/nodesDB.txt

blobtools create -i $GENOME -b $BAM -t $HIT -o $NAME --db $TAXDB

blobtools view -i ${NAME}.blobDB.json

blobtools plot -i ${NAME}.blobDB.json
