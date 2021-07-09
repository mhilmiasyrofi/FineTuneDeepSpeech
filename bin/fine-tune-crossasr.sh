#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

# if [ -d "${COMPUTE_KEEP_DIR}" ]; then
#     checkpoint_dir=$COMPUTE_KEEP_DIR
# else
#     checkpoint_dir=$(python -c 'from xdg import BaseDirectory as xdg; print(xdg.save_data_path("deepspeech/ldc93s1"))')
# fi

# Force only one visible device because we have a single-sample dataset
# and when trying to run on multiple devices (like GPUs), this will break
export CUDA_VISIBLE_DEVICES=0

# python -u DeepSpeech.py --noshow_progressbar \
#   --train_files data/europarl-seed2021/rv-wav2vec2-train.csv \
#   --test_files data/europarl-seed2021/rv-wav2vec2-test.csv \
#   --train_batch_size 32 \
#   --test_batch_size 32 \
#   --n_hidden 100 \
#   --epochs 200 \
#   --checkpoint_dir "$checkpoint_dir" \
#   "$@"

python -u DeepSpeech.py --noshow_progressbar \
  --train_cudnn \
  --train_files data/europarl-seed2021/rv-wav2vec2-train.csv \
  --test_files data/europarl-seed2021/rv-wav2vec2-test.csv \
  --train_batch_size 32 \
  --test_batch_size 32 \
  --n_hidden 2048 \
  --epochs 3 \
  --learning_rate 1e-4 \
  --load_checkpoint_dir checkpoints/deepspeech-0.9.3/ \
  --save_checkpoint_dir checkpoints/deepspeech-fine-tuned/ \
  --scorer models/deepspeech-0.9.3-models.scorer

# python -u DeepSpeech.py --noshow_progressbar \
#   --train_cudnn \
#   --train_files ../output/europarl-seed2021/fine_tune_data/train.csv \
#   --test_files ../output/europarl-seed2021/fine_tune_data/test.csv \
#   --train_batch_size 32 \
#   --test_batch_size 32 \
#   --n_hidden 2048 \
#   --epochs 1 \
#   --learning_rate 1e-4 \
#   --load_checkpoint_dir checkpoints/ \
#   --scorer models/deepspeech-0.9.3-models.scorer
