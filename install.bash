#!/bin/bash

script_path=$(realpath "$0")
script_dir=$(dirname "$0")

pushd script_dir

path=$(realpath "src")

echo "export PATH=\"$path:$PATH\"" >> ~/.bashrc

popd

