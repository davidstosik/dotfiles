##!/usr/bin/env zsh

ANTIGEN_ROOT="${HOME}/.antigen"

# TODO handle existance?
git clone https://github.com/zsh-users/antigen "${ANTIGEN_ROOT}/git"

# prepare data file for Z
touch "${ANTIGEN_ROOT}/.z"

MYDIR="${0:a:h}"
source "${MYDIR}/zshrc"
