#!/usr/bin/env bash
#set -e

ENV_NAME="scaaml311"

source "$HOME/anaconda3/etc/profile.d/conda.sh"

if ! conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    echo "Creating Conda environment..."
    conda create -y -n "$ENV_NAME" python=3.11 pip
fi

conda activate "$ENV_NAME"

echo "Python:"
python --version

WORKDIR="/global/u1/a/achilaka/PSCA"
REPO="$WORKDIR/scaaml"

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
echo
echo "Run:"
echo "conda activate scaaml311"
echo "cd $REPO"
