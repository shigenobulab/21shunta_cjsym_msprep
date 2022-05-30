#!/bin/sh
#PBS -S /bin/sh
#PBS -q medium
#PBS -l ncpus=4
cd $PBS_O_WORKDIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate eggnog

### configs ###

INDIR=BucCj_prokka
INFILE=BucCj.faa
TYPE=proteins
MODE=diamond
OUTFILE=`basename $INFILE .faa`_emapper
OUTDIR=BucCj_emapper
TAXID=1236 # gammaproteobacteria
TAXMD=inner_broadest
GOEVI=non-electronic
LOG=`basename $INFILE .faa`_emapper.log

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

###

emapper.py \
  --cpu $NCPUS \
  -i $INDIR/$INFILE \
  --itype $TYPE \
  --output $OUTFILE \
  --output_dir $OUTDIR \
  -m $MODE \
  --tax_scope $TAXID \
  --tax_scope_mode $TAXMD \
  --go_evidence $GOEVI \
  > $OUTDIR/$LOG 2>&1

conda deactivate