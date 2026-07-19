#!/bin/bash -l
set -euo pipefail
trap 'echo "FAILED at line $LINENO: $BASH_COMMAND"' ERR

module load conda
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate scaaml312
module load cudatoolkit cudnn

echo "Python:"
which python
python --version

REPO="${PSCRATCH}/PSCA/scaaml"
DATASET_ROOT="${PSCRATCH}/scaaml_datasets/GPAM"
CONFIG_ROOT="papers/2024/GPAM/configurations"

cd "$REPO"

echo "Checking TensorFlow GPU visibility..."
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

echo "===================="
echo "Running CM0"
echo "===================="

python papers/2024/GPAM/train_with_config.py \
    --dataset_path "${DATASET_ROOT}/K82F_ECC_CM0_ECC-FR256_CW308" \
    --config "${CONFIG_ROOT}/ECC_CM0.json" \
    --result_file "${CONFIG_ROOT}/ECC_CM0_result.json"
