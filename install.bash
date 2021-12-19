#!/bin/bash

set -e

script_dir=$(dirname "$0")

my_bash_aliases_link () {
    local name=$(basename "$1")
    local dest_link_path="$HOME/.my_bash_aliases/$name"
    [ -L "$dest_link_path" ] && rm "$dest_link_path"
    ln -s $(realpath "$1") "$dest_link_path"
}

pushd $script_dir

stow stow

popd

