#!/bin/bash -eu

OUT_DIR="build/desktop"
mkdir -p $OUT_DIR
odin build flavors/desktop -out:$OUT_DIR/game.exe
echo "Desktop build created in ${OUT_DIR}"