#!/bin/bash
set -e
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install 3.1.40
./emsdk activate 3.1.40
source ./emsdk_env.sh
echo "Emscripten installed successfully"
