#!/bin/bash

set -e

script_dir=$(dirname "$0")

pushd $script_dir

stow -R stow -t ~/ --no-folding

popd

