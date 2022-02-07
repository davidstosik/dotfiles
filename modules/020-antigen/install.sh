##!/usr/bin/env zsh

MYDIR="${0:a:h}"

ANTIGEN_ROOT="${HOME}/.antigen"

# TODO handle existance?
git clone https://github.com/zsh-users/antigen "${ANTIGEN_ROOT}/git"

# Fix Antigen bug caused by spaces in paths
# See https://github.com/zsh-users/antigen/issues/734
git -C "${ANTIGEN_ROOT}/git" apply "${MYDIR}/fix_spaces.patch"

# prepare data file for Z
touch "${ANTIGEN_ROOT}/.z"

source "${MYDIR}/zshrc"
