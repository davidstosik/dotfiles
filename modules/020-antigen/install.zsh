#!/usr/bin/env zsh

ANTIGEN_ROOT="${HOME}/.antigen"

mkdir -p "$ANTIGEN_ROOT"

#TODO handle existance
git clone https://github.com/zsh-users/antigen "${ANTIGEN_ROOT}/git"

# Folder for the z plugin
mkdir -p ~/.z
