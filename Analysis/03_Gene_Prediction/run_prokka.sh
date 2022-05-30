#!/bin/sh
#PBS -q CDE
#PBS -l ncpus=16
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

### configs ###

INDIR=pilon_3corrected
OUTDIR=BucCj_prokka
PREFIX=BucCj # {Filename output prefix} e.g. BucCj
LOCTAG=BucCj_NOSY1 # {Locus tag prefix} e.g. BucCj
GENUS=Buchnera # e.g. Buchnera
SPECIES=aphidicola # e.g. aphidicola
STRAIN=Cj_NOSY1 # e.g. Cj_NOSY1
KINGDOM=Bacteria
INFILE=BucCj.fasta

###

prokka \
  --cpus $NCPUS \
  --outdir $OUTDIR \
  --force \
  --prefix $PREFIX \
  --compliant \
  --rfam \
  --locustag $LOCTAG \
  --genus $GENUS \
  --species $SPECIES \
  --strain $STRAIN \
  --kingdom $KINGDOM \
  --usegenus \
  $INDIR/$INFILE

conda deactivate
