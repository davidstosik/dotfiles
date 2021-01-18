#!/usr/bin/env zsh

ANTIGEN_ROOT="${HOME}/.antigen"

mkdir -p "$ANTIGEN_ROOT"

# TODO handle existance
git clone https://github.com/zsh-users/antigen "${ANTIGEN_ROOT}/git"

# Prevent "no such file or directory" on first launch
touch "${HOME}/.antigen/.z"
