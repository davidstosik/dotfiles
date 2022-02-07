##!/usr/bin/env zsh

MYDIR="${0:a:h}"

# Fix Antigen bug caused by spaces in paths
# See https://github.com/zsh-users/antigen/issues/734
git -C "${MYDIR}/../../submodules/antigen" apply "${MYDIR}/fix_spaces.patch"

source "${MYDIR}/zshrc"
