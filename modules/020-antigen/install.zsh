#!/usr/bin/env zsh

MYDIR="${0:a:h}"

curl --progress-bar -L git.io/antigen > "${MYDIR}/antigen.zsh"

# Folder for the z plugin
mkdir -p ~/.z
