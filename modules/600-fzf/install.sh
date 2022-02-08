#!/usr/bin/env zsh

echo "== Installing FZF binary =="
${0:a:h}/../../submodules/fzf/install --bin

echo "== Linking FZF into vim-plug's directory =="
rm -rf "$HOME"/.vim/plugged/fzf
ln -s ${0:a:h}/../../submodules/fzf "$HOME"/.vim/plugged
