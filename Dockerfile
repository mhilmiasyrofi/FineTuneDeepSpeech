# Please refer to the TRAINING documentation, "Basic Dockerfile for training"

FROM tensorflow/tensorflow:1.15.4-gpu-py3
ENV DEBIAN_FRONTEND=noninteractive

ENV DEEPSPEECH_REPO=https://github.com/mozilla/DeepSpeech.git
ENV DEEPSPEECH_SHA=f2e9c85880dff94115ab510cde9ca4af7ee51c19

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        bash-completion \
        build-essential \
        cmake \
        curl \
        git \
        libboost-all-dev \
        libbz2-dev \
        locales \
        python3-venv \
        unzip \
        wget

# We need to remove it because it's breaking deepspeech install later with
# weird errors about setuptools
RUN apt-get purge -y python3-xdg

# Install dependencies for audio augmentation
RUN apt-get install -y --no-install-recommends libopus0 libsndfile1

# Try and free some space
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone $DEEPSPEECH_REPO DeepSpeech

WORKDIR /DeepSpeech
RUN git checkout $DEEPSPEECH_SHA

# Build CTC decoder first, to avoid clashes on incompatible versions upgrades
RUN cd native_client/ctcdecode && make NUM_PROCESSES=$(nproc) bindings
RUN pip3 install --upgrade native_client/ctcdecode/dist/*.whl

# Prepare deps
RUN pip3 install --upgrade pip==20.2.2 wheel==0.34.2 setuptools==49.6.0

# Install DeepSpeech
#  - No need for the decoder since we did it earlier
#  - There is already correct TensorFlow GPU installed on the base image,
#    we don't want to break that
RUN DS_NODECODER=y DS_NOTENSORFLOW=y pip3 install --upgrade -e .

WORKDIR /DeepSpeech/

# Tool to convert output graph for inference
RUN python3 util/taskcluster.py --source tensorflow --branch r1.15 \
        --artifact convert_graphdef_memmapped_format  --target .

# Build KenLM to generate new scorers
WORKDIR /DeepSpeech/native_client
RUN rm -rf kenlm && \
	git clone https://github.com/kpu/kenlm && \
	cd kenlm && \
	git checkout 87e85e66c99ceff1fab2500a7c60c01da7315eec && \
	mkdir -p build && \
	cd build && \
	cmake .. && \
	make -j $(nproc)
WORKDIR /DeepSpeech

ENV TF_FORCE_GPU_ALLOW_GROWTH=true

RUN ./bin/run-ldc93s1.sh
