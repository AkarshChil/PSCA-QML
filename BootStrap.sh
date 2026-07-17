#!/bin/bash -l
set -euo pipefail

module load conda
source "$(conda info --base)/etc/profile.d/conda.sh"

ENV_DIR="${PSCRATCH}/conda-envs/scaaml312"
WORKDIR="${PSCRATCH}/PSCA"
REPO="$WORKDIR/scaaml"

mkdir -p "$(dirname "$ENV_DIR")"
mkdir -p "$WORKDIR"

if [ ! -d "$ENV_DIR" ]; then
    conda create -y -p "$ENV_DIR" python=3.12 pip
fi

conda activate "$ENV_DIR"

echo "Python:"
which python
python --version

if [ -d "$REPO/.git" ]; then
    cd "$REPO"
    git pull
else
    git clone https://github.com/google/scaaml.git "$REPO"
    cd "$REPO"
fi

python -m pip install --upgrade pip setuptools wheel
python -m pip install -e .
python -m pip install chipwhisperer
python -m pip install sedpack
python -m pip install tensorflow

echo "Done."
echo "Activate later with:"
echo "module load conda"
echo "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
echo "conda activate $ENV_DIR"
echo "cd $REPO"
