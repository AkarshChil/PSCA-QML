#!/bin/bash -l
set -euo pipefail

ENV_NAME="scaaml314"
WORKDIR="${PSCRATCH}/PSCA"
REPO="$WORKDIR/scaaml"

module load conda
source "$(conda info --base)/etc/profile.d/conda.sh"

# Create the env if needed
if ! conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    echo "Creating Conda environment..."
    conda create -y -n "$ENV_NAME" python=3.14 pip
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
pip install -e .
pip install chipwhisperer
pip install sedpack
pip install "tensorflow[and-cuda]"

echo
echo "Environment ready."
echo "To use it later:"
echo "module load conda"
echo "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
echo "conda activate $ENV_NAME"
echo "cd $REPO"
