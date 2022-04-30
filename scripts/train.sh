#! /bin/bash

scripts=`dirname "$0"`
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools

mkdir -p $models

num_threads=4
device=1

SECONDS=0

(cd $tools/pytorch-examples/word_language_model &&
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python main.py --data $data/inaugural_speeches \
        --epochs 40 \
        --log-interval 100 \
        --emsize 250 --nhid 250 --dropout 0.2 --tied \
        --save $models/model02.pt
)

echo "time taken:"
echo "$SECONDS seconds"
