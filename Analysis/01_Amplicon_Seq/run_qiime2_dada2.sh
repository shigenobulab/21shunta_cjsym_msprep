#!/bin/bash
#PBS -S /bin/bash
#PBS -q CDE
#PBS -l ncpus=2
cd $PBS_O_WORKDIR

### config ###

INDIR=../analysis/201020_qiime2_imported
OUTDIR=../analysis/201020_qiime2_dada2

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [[ $IDX == *V1V2* ]]; then
  F5E=19
  R5E=16
  TRIM=F${F5E}R${R5E}
elif [[ $IDX == *V3V4* ]]; then
  F5E=16
  R5E=24
  TRIM=F${F5E}R${R5E}
fi

F3E=250
R3E=250
TOOL=dada2
METHOD=denoise-paired

###

qiime $TOOL $METHOD \
    --i-demultiplexed-seqs $INDIR/${IDX}.qza \
    --p-trim-left-f $F5E \
    --p-trim-left-r $R5E \
    --p-trunc-len-f $F3E \
    --p-trunc-len-r $R3E \
    --p-n-threads $NCPUS \
    --o-representative-sequences $OUTDIR/${IDX}_${TRIM}_rep-seqs-${TOOL}.qza \
    --o-table $OUTDIR/${IDX}_${TRIM}_table-${TOOL}.qza \
    --o-denoising-stats $OUTDIR/${IDX}_${TRIM}_stats-${TOOL}.qza

qiime metadata tabulate \
    --m-input-file $OUTDIR/${IDX}_${TRIM}_stats-${TOOL}.qza \
    --o-visualization $OUTDIR/${IDX}_${TRIM}_stats-${TOOL}.qzv

qiime feature-table summarize \
    --i-table $OUTDIR/${IDX}_${TRIM}_table-${TOOL}.qza \
    --o-visualization $OUTDIR/${IDX}_${TRIM}_table-${TOOL}.qzv

qiime feature-table tabulate-seqs \
    --i-data $OUTDIR/${IDX}_${TRIM}_rep-seqs-${TOOL}.qza \
    --o-visualization $OUTDIR/${IDX}_${TRIM}_rep-seqs-${TOOL}.qzv
    