#!/usr/bin/env zsh

MYDIR="${0:a:h}"
GITCONFIG_TARGET="${MYDIR}/gitconfig"
GITCONFIG_PATH="${HOME}/.gitconfig"

if [ -f "$GITCONFIG_PATH" ]; then
  if [ ! "$(readlink "$GITCONFIG_PATH")" -ef "$GITCONFIG_TARGET" ]; then
    mv "$GITCONFIG_PATH" "${GITCONFIG_PATH}.original"
  fi
fi

ln -s -f "$GITCONFIG_TARGET" "$GITCONFIG_PATH"

GITIGNORE_PATH="${HOME}/.gitignore"

if [ -f "$GITIGNORE_PATH" ]; then
  mv "$GITIGNORE_PATH" "$GITIGNORE_PATH.backup"
fi
ln -s "${MYDIR}/gitignore" "$GITIGNORE_PATH"
