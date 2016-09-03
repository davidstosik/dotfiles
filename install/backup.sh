#!/usr/bin/env bash

# Backup files that are provided by the dotfiles into a ~/dotfiles-backup directory

DOTFILES=$HOME/.dotfiles
BACKUP_DIR="$HOME/dotfiles-backup-`date -u +"%Y%m%dT%H%M%S"`"

# Stop on error
set -e

echo "Creating backup directory at $BACKUP_DIR"
mkdir -p $BACKUP_DIR

linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )

for file in $linkables; do
    filename=".$( basename $file '.symlink' )"
    target="$HOME/$filename"
    if [ -e $target ]; then
        echo "backing up $filename"
        mv $target $BACKUP_DIR
    fi
done

