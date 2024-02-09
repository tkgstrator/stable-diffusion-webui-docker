#!/usr/bin/env bash

set -Eeuo pipefail

# Make Directory
mkdir -vp /data/.cache \
  /data/embeddings \
  /data/config/ \
  /data/models/ \
  /data/models/Stable-diffusion \
  /data/models/GFPGAN \
  /data/models/RealESRGAN \
  /data/models/LDSR \
  /data/models/VAE

# Download Models
aria2c -x 10 --disable-ipv6 --input-file models.txt --dir /data/models --continue
aria2c -x 10 --disable-ipv6 --input-file embeddings.txt --dir /data/embeddings --continue
