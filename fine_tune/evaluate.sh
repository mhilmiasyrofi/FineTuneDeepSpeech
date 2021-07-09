#!/bin/sh
set -xe
if [ ! -f evaluate.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

## https://github.com/mozilla/DeepSpeech/issues/3088
# There is a random error mentioned above
# after changing the train batch size from 32 into 16, it works

export CUDA_VISIBLE_DEVICES=0

export TF_CUDNN_RESET_RND_GEN_STATE=1

python -u evaluate.py \
  --test_files ../output/europarl-seed2021/fine_tune_data/test.csv \
  --test_batch_size 16 \
  --n_hidden 2048 \
  --load_checkpoint_dir checkpoints/deepspeech-0.9.3/ \
  --scorer models/deepspeech-0.9.3-models.scorer
