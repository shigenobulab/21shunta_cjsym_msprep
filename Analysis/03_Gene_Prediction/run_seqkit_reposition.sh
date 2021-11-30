#!/bin/sh

# Buchnera genome usually starts from mnmG gene.
seqkit seq -pr BucCj_chr.fa > BucCj_chr_revcomp.fa # -p: complement sequence, -r reverse sequence
seqkit restart -i 291750 BucCj_chr_revcomp.fa > BucCj_chr_revcomp_restarted.fa # -i: new start position

# Plasmid sequences from raw Nanopore reads are about two-fold lengths, so I extracted minimum unit of the repeat.
seqkit subseq -r 3834:10831 BucCj_pLeu.fa > BucCj_pLeu_1unit.fa # -r: by region. e.g 1:12 for first 12 bases
seqkit subseq -r 2496:13139 BucCj_pTrp.fa > BucCj_pTrp_1unit.fa

# The start position of Arsenophonus genomes differs among species.
# Usually, dnaA is used as a start position in bacterial genomes.
seqkit restart -i 20745 ArsCj_chr_revcomp.fa > ArsCj_chr_restarted.fa

# Hamiltonella genome was not circular, so I did not reset the start position.

# mtDNA genome usually start from coxI gene.
seqkit restart -i 1886 mtDNA_Cj.fa > mtDNA_Cj_restarted.fa