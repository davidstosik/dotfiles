#!/usr/bin/env zsh

MYDIR="${0:a:h}"

vim -c "PlugSnapshot! ${MYDIR}/snapshot.vim" +qall >/dev/null 2>&1
