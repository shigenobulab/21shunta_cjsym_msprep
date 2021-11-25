#!/bin/bash
#PBS -S /bin/bash
#PBS -q CDE
cd $PBS_O_WORKDIR

INDIR=../data/
OUTDIR=../analysis/201020_qiime2_imported

if [ ! -d $OUTDIR ]; then
  mkdir $OUTDIR
fi

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $INDIR/$IDX \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $OUTDIR/${IDX}.qza

qiime demux summarize \
  --i-data $OUTDIR/${IDX}.qza \
  --o-visualization $OUTDIR/${IDX}.qzv