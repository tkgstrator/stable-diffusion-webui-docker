ARG CUDA_VERSION
ARG CUDNN_VERSION
ARG TORCH_VERSION
ARG UBUNTU_VERSION
ARG SHA256_COMMIT_HASH
ARG CLI_ARGS

# CUDA
FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime-ubuntu${UBUNTU_VERSION}
ENV ROOT_DIR stable-diffusion-webui
WORKDIR /

# Packages 
RUN apt-get update
RUN apt-get install -y git jq software-properties-common
RUN apt-get update
RUN apt-get install -y python3.10 python3-pip python3.10-venv python-is-python3
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Stable Diffusion WebUI and checkout a specific commit
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT_DIR}
WORKDIR /${ROOT_DIR}
RUN git reset --hard ${SHA256_COMMIT_HASH}

# PIP Install
RUN pip install pyngrok xformers==0.0.24 \
    git+https://github.com/TencentARC/GFPGAN.git@8d2447a2d918f8eba5a4a01463fd48e45126a379 \
    git+https://github.com/openai/CLIP.git@d50d76daa670286dd6cacf3bcd80b5e4823fc8e1 \
    git+https://github.com/mlfoundations/open_clip.git@v2.20.0
RUN pip install -r requirements_versions.txt --extra-index-url https://download.pytorch.org/whl/cu121

# Repositories
WORKDIR /${ROOT_DIR}/repositories
RUN git clone --depth 1 https://github.com/Stability-AI/stablediffusion.git stable-diffusion-stability-ai && rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif
RUN git clone --depth 1 https://github.com/sczhou/CodeFormer.git && rm -rf assets inputs
RUN git clone --depth 1 https://github.com/salesforce/BLIP.git
RUN git clone --depth 1 https://github.com/crowsonkb/k-diffusion.git
RUN git clone --depth 1 https://github.com/pharmapsychotic/clip-interrogator
RUN git clone --depth 1 https://github.com/Stability-AI/generative-models
RUN pip install -r CodeFormer/requirements.txt
RUN pip install dctorch

# TensorRT
RUN pip install --pre --extra-index-url https://pypi.nvidia.com tensorrt==9.0.1.post11.dev4
RUN pip install polygraphy --extra-index-url https://pypi.ngc.nvidia.com

# Configure
WORKDIR /${ROOT_DIR}
COPY . .
ENTRYPOINT ["./entrypoint.sh"]
CMD python3 -u webui.py --listen --port 7860 ${CLI_ARGS}