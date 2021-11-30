#!/bin/sh
#PBS -S /bin/sh
#PBS -q smps
#PBS -l ncpus=4
cd $PBS_O_WORKDIR

### configs ###

NCPUS=4
# INF=
TYPE=proteins
OUTF=`basename $INF .faa`_emapper
MODE=diamond
TAXID=1236 # gammaproteobacteria
TAXMD=inner_broadest
GOEVI=non-electronic
LOG=`basename $INF .faa`_emapper.log

###

emapper.py \
  --cpu $NCPUS \
  -i $INF \
  --itype $TYPE \
  --output $OUTF \
  -m $MODE \
  --tax_scope $TAXID \
  --tax_scope_mode $TAXMD \
  --go_evidence $GOEVI \
  > $LOG 2>&1
  