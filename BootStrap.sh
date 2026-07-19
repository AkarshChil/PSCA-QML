#!/bin/bash -l
set -euo pipefail
trap 'echo "FAILED at line $LINENO: $BASH_COMMAND"' ERR

ENV_NAME="scaaml312"
WORKDIR="${PSCRATCH}/PSCA"
REPO="$WORKDIR/scaaml"

module load conda
source "$(conda info --base)/etc/profile.d/conda.sh"

if ! conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    echo "Creating Conda environment..."
    conda create -y -n "$ENV_NAME" python=3.12 pip
fi

conda activate "$ENV_NAME"

echo "Python:"
which python
python --version

mkdir -p "$WORKDIR"

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

echo
echo "Environment ready."
echo "To use it later:"
echo "module load conda"
echo "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
echo "conda activate $ENV_NAME"
echo "cd $REPO"
