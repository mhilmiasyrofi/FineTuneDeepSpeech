# Source Code for Fine Tuning deepspeech

This repo is forked from [Mozilla Deepspeech 0.9.3 repository](https://github.com/mozilla/DeepSpeech/releases/tag/v0.9.3)

```
git clone https://github.com/mhilmiasyrofi/FineTuneDeepSpeech.git
cd FineTuneDeepSpeech
wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/linux.amd64.convert_graphdef_memmapped_format.xz
# extract the .xz file
unxz linux.amd64.convert_graphdef_memmapped_format.xz
mv linux.amd64.convert_graphdef_memmapped_format convert_graphdef_memmapped_format
```
#### 1. Prepare a Docker Image 

Use a prepared docker image

```
docker pull mhilmiasyrofi/traindeepspeech
```

If you encounter an error then, alternatively, you need to build the docker image manually.

```
docker build -t <your username>/traindeepspeech .
```

If you can't successfully build the the docker image, please build the docker image by following the latest Docker configuration from [the Deepspeech repository](https://github.com/mozilla/DeepSpeech/)

#### 2. Run the docker image as a container

```
docker run --name gpu0-deepspeech --rm -it --gpus '"device=0"' -v <path to FineTuneDeepSpeech>:/DeepSpeech -v <path to ASRDebugger>:<path to ASRDebugger> mhilmiasyrofi/traindeepspeech /bin/bash
```
