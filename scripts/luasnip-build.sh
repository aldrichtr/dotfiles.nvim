#!/usr/bin/env bash


# This script builds and installs LuaSnip for Neovim on Windows using MSYS2 UCRT64 environment.
# It installs necessary packages, compiles the source code, and places the resulting files in the appropriate
# directories.
# Prerequisites:
# - MSYS2 installed with UCRT64 environment.
# - Neovim installed and configured to use LuaSnip.
# - Git installed and available in the system PATH.
# - PowerShell 5.1 or later.
# - Internet connection to download packages and source code.

NVIM_DATA="~/.local/share/nvim-data"
LUASNIP_DIR="$NVIM_DATA/lazy/LuaSnip"

export NVIM_BIN_PATH="/c/programs/neovim/bin/nvim.exe"

declare -a packages=(
    'mingw-w64-ucrt-x86_64-luajit',
    'mingw-w64-ucrt-x86_64-gcc',
    'mingw-w64-ucrt-x86_64-make',
    'mingw-w64-ucrt-x86_64-pkgconf',
    'mingw-w64-ucrt-x86_64-cmake',
    'git'
)

declare -a install_options=(
    '--color', 'always',
    '--needed',
    '--noconfirm',
    '--overwrite'
)

declare -a build_options=(
    'CC=gcc'
    'CFLAGS=-I/ucrt64/include/luajit-2.1 -O2 -Wall -fPIC'
    'LDFLAGS=-shared -lluajit-5.1'
)

## Colors used in output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
NC='\033[0m' # no color

join_by() {
    local IFS="$1"
    shift
    echo "$*"
}

_isInstalled() {
    package="$1";
    check="$(pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0;
        return;
    fi;
    echo 1;
    return;
}


# `install_packages <pkg1> <pkg2> ...`
install_packages() {
   local packages=("$@");

    for pkg in "${packages[@]}"; do
        echo -e -n "Checking if ${pkg} is installed";
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo -e " - [${GREEN}\u2714${NC}]";
            continue;
        else
            echo -e " - [${RED}\u2716${NC}]";
            pacman -S $(join_by ' ' "${install_options[@]}")  "${pkg}";
        fi;
    done;
}

build_luasnip() {
  echo -e << EOF
${CYAN}################################################################
# Building LuaSnip
################################################################
${NC}
EOF
  make $(join_by ' ' "${build_options[@]}") install_jsregexp
}

current_dir="$(pwd)"
cd $LUASNIP_DIR
install_packages ${packages[@]};
build_luasnip;
cd "$current_dir"
