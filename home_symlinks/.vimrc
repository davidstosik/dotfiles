scriptencoding utf-8
set encoding=utf-8

set nocompatible
set backspace=indent,eol,start
set history=200
set ruler
set showcmd
set wildmenu
set ttimeout
set ttimeoutlen=100
set display=truncate
set scrolloff=5
set nrformats-=octal
set nolangremap

filetype plugin indent on
syntax on

augroup vimStartup
  autocmd!
  autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif
  autocmd VimResized * exe "normal \<c-w>="
augroup END

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

set list
set listchars=eol:↵,tab:»\ ,trail:·,extends:>,precedes:<,nbsp:%
highlight NonText ctermfg=2
highlight SpecialKey ctermfg=2

set gdefault
set ignorecase smartcase
set hlsearch
set background=dark
set number
set updatetime=500

let mapleader = ","

map Q gq
inoremap <C-U> <C-G>u<C-U>
nnoremap L gt
nnoremap H gT
