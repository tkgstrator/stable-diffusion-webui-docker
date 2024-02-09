#!/bin/bash

set -Eeuo pipefail
ls -lha /$ROOT_DIR

# Generate Default Config
python3 config.py /data/config/config.json

# Generate Default UI Config
if [ ! -f /data/config/ui-config.json ]; then
  echo '{}' >/data/config/ui-config.json
fi

# Generate Default Styles
if [ ! -f /data/config/styles.csv ]; then
  touch /data/config/styles.csv
fi

# Mount Client -> Host
declare -A MOUNTS
MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["/${ROOT_DIR}/models"]="/data/models"
MOUNTS["/${ROOT_DIR}/embeddings"]="/data/embeddings"
MOUNTS["/${ROOT_DIR}/config.json"]="/data/config/config.json"
MOUNTS["/${ROOT_DIR}/ui-config.json"]="/data/config/ui-config.json"
MOUNTS["/${ROOT_DIR}/styles.csv"]="/data/config/styles.csv"
MOUNTS["/${ROOT_DIR}/extensions"]="/data/config/extensions"
MOUNTS["/${ROOT_DIR}/config_states"]="/data/config/config_states"
# MOUNTS["${ROOT}/repositories/CodeFormer/weights/facelib"]="/data/.cache"

# Make Directory and Symbolic Link
for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

shopt -s nullglob
# Install Packages Required by Extension
list=(extensions/*/install.py)
for SCRIPT in "${list[@]}"; do
  EXTNAME=$(echo $SCRIPT | cut -d '/' -f 3)
  if $(jq -e ".disabled_extensions|any(. == \"$EXTNAME\")" config.json); then
    continue
  fi
  echo ${ROOT_DIR} ${SCRIPT} ${PWD}
  PYTHONPATH=${PWD} python3 ${SCRIPT}
done

exec "$@"