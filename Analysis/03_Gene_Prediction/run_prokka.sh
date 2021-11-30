#!/bin/sh
#PBS -S /bin/sh
#PBS -q CDE
#PBS -l ncpus=4
cd $PBS_O_WORKDIR

### configs ###

NCPUS=4
# DIR=
# PREFIX={Filename output prefix} e.g. BucCj
# LOCTAG={Locus tag prefix} e.g. BucCj
# GENUS= e.g. Buchnera
# SPECIES= e.g. aphidicola
# STRAIN= e.g. CjN
KINGDOM=Bacteria
# INF=

###

prokka \
  --cpus $NCPUS \
  --outdir $DIR \
  --force \
  --prefix $PREFIX \
  --addgenes \
  --addmrna \
  --locustag $LOCTAG \
  --genus $GENUS \
  --species $SPECIES \
  --strain $STRAIN \
  --kingdom $KINGDOM \
  --usegenus \
  $DIR/$INF
