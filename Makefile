include .env

.PHONY: build
build:
	docker build --build-arg CUDA_VERSION=${CUDA_VERSION} --build-arg CUDNN_VERSION=${CUDNN_VERSION} --build-arg TENSORRT_VERSION=${TENSORRT_VERSION} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --push -t tkgling/stable-diffusion-webui:cu121_rt8 services/auto