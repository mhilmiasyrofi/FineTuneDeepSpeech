# Source Code for Fine Tuning deepspeech

This repo is forked from [Mozilla Deepspeech 0.9.3 repository](https://github.com/mozilla/DeepSpeech/releases/tag/v0.9.3)


#### 1. Build a docker image for DeepSpeech environment

```
docker build . <your username>/traindeepspeech
```

#### 2. Run the docker image as a container

```
docker run --name gpu0-deepspeech --rm -it --gpus '"device=0"' -v <absolute path to this Deepspeech directory>/:/DeepSpeech/ -v <absolute path to ASREvolve directory>/output/:/output/ -v <absolute path to ASREvolve directory>/asr_models/finetuned_deepspeech/:/finetuned_deepspeech/ <your username>/traindeepspeech:v1 /bin/bash
```