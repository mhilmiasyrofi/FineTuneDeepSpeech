#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

## https://github.com/mozilla/DeepSpeech/issues/3088
# There is a random error mentioned above
# after changing the train batch size from 32 into 16, it works

export CUDA_VISIBLE_DEVICES=0

export TF_CUDNN_RESET_RND_GEN_STATE=1

python -u DeepSpeech.py --noshow_progressbar \
  --train_cudnn \
  --train_files ../output/europarl-seed2021/fine_tune_data/train.csv \
  --test_files ../output/europarl-seed2021/fine_tune_data/test.csv \
  --train_batch_size 16 \
  --test_batch_size 16 \
  --n_hidden 2048 \
  --epochs 30 \
  --learning_rate 1e-4 \
  --load_checkpoint_dir checkpoints/deepspeech-0.9.3/ \
  --save_checkpoint_dir checkpoints/deepspeech-fine-tuned/ \
  --export_dir ../finetuned_deepspeech/ \
  --scorer models/deepspeech-0.9.3-models.scorer

./convert_graphdef_memmapped_format --in_graph=../finetuned_deepspeech/output_graph.pb --out_graph=../finetuned_deepspeech/output_graph.pbmm