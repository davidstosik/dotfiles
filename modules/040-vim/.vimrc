" Source VIM defaults
source $VIMRUNTIME/defaults.vim

" Initialize plugin system
call plug#begin('$HOME/.vim/plugged')

" Plugin manager
Plug 'junegunn/vim-plug'
" Sensible defaults
Plug 'tpope/vim-sensible'
" Automatic indentation detection
Plug 'tpope/vim-sleuth'
" Git tools
Plug 'tpope/vim-fugitive'
" GitHub tools
Plug 'tpope/vim-rhubarb'
" `end` blocks
Plug 'tpope/vim-endwise'
" comment code
Plug 'tpope/vim-commentary'
" Ruby on Rails
Plug 'tpope/vim-rails'
" File commands in vim (:Delete, :Rename, etc)
Plug 'tpope/vim-eunuch'
" Parens, brackets, quotes in pairs
Plug 'jiangmiao/auto-pairs'
" YAML syntax/indent
Plug 'mrk21/yaml-vim'
" :YamlGoToKey, :YamlGetFullPath
Plug 'lmeijvogel/vim-yaml-helper'
" Advanced CtrlP
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Search
set gdefault " Set the g (global) flag by default on search and replace
set ignorecase smartcase " Ignore case unless search term contains upper case
