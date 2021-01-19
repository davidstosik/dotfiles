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
" FIXME load from modules/000-fzf?
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Explore the undo tree
Plug 'mbbill/undotree'

call plug#end()

" Automatically source vimrc on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" vim-plug is added to plugins above, so updates itself with :PlugUpdate
delc PlugUpgrade

" Allow vim-sensible overrides
" runtime! plugin/sensible.vim

" Search
set gdefault " Set the g (global) flag by default on search and replace
set ignorecase smartcase " Ignore case unless search term contains upper case

" FZF-powered CtrlP
nmap <C-P> :FZF<CR>
" Use my default AG options for :Ag
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, $AG_DEFAULT_OPTIONS, <bang>0)

" Yank in/paste from macOS's clipboard
" FIXME doesn't work in tmux (+ what about other OSes?)
set clipboard=unnamed

let mapleader = ","

" Split vertically for diffs
set diffopt+=vertical

" leader+M opens notes
noremap <silent> <leader>m          :10split ~/notes.md <CR>

" Force a dark background because Vim misbehaves in tmux
set background=dark
