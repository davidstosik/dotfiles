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
"  " GitHub tools
"  Plug 'tpope/vim-rhubarb'
"  " `end` blocks
"  Plug 'tpope/vim-endwise'
"  " comment code
"  Plug 'tpope/vim-commentary'
"  " Ruby on Rails
"  Plug 'tpope/vim-rails'
"  " File commands in vim (:Delete, :Rename, etc)
"  Plug 'tpope/vim-eunuch'
"  " Parens, brackets, quotes in pairs
"  "Plug 'jiangmiao/auto-pairs'
"  " YAML syntax/indent
"  Plug 'mrk21/yaml-vim'
"  " :YamlGoToKey, :YamlGetFullPath
"  Plug 'lmeijvogel/vim-yaml-helper'
"  " Advanced CtrlP
"  " FIXME load from modules/000-fzf?
"  Plug 'junegunn/fzf'
"  Plug 'junegunn/fzf.vim'
"  " Explore the undo tree
"  Plug 'mbbill/undotree'
"  " JSONNET syntax highlighting
"  Plug 'google/vim-jsonnet'
"  
"  " JS autoformatting (TODO: move to modules/000-prettier)
"  "Plug 'prettier/vim-prettier', {
"  "  \ 'do': 'yarn install',
"  "  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml']
"  "  \ }
"  
"  " Sync editor with browser
"  "Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
"  " Only enabled for Vim 8 (not for Neovim).
"  "Plug 'roxma/nvim-yarp', v:version >= 800 && !has('nvim') ? {} : { 'on': [], 'for': [] }
"  "Plug 'roxma/vim-hug-neovim-rpc', v:version >= 800 && !has('nvim') ? {} : { 'on': [], 'for': [] }

call plug#end()

"  " Automatically source vimrc on save.
"  autocmd! bufwritepost $MYVIMRC source $MYVIMRC
"  
"  " vim-plug is added to plugins above, so updates itself with :PlugUpdate
"  delc PlugUpgrade
"  
"  " Allow vim-sensible overrides
"  " runtime! plugin/sensible.vim
"  
"  " Display invisible characters
"  set list
"  set listchars=eol:↵,tab:»\ ,trail:·,extends:>,precedes:<,nbsp:%
"  highlight NonText ctermfg=2
"  highlight SpecialKey ctermfg=2
"  
"  " Search
"  set gdefault             " Set the g (global) flag by default on search and replace
"  set ignorecase smartcase " Ignore case unless search term contains upper case
"  set hlsearch             " Highlight results
"  
"  " === FZF ===
"  " CtrlP shortcut
"  nmap <C-P> :FZF<CR>
"  
"  let g:fzf_preview_window = ['right:50%', 'ctrl-_']
"  
"  " Use my default AG options for :Ag
"  " See https://github.com/junegunn/fzf.vim/issues/1225
"  command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, $AG_DEFAULT_OPTIONS, call('fzf#vim#with_preview', g:fzf_preview_window), <bang>0)
"  
"  " Yank in/paste from macOS's clipboard
"  " FIXME doesn't work in tmux? (+ what about other OSes?)
"  set clipboard=unnamed
"  
"  let mapleader = ","
"  
"  " Split vertically for diffs
"  "set diffopt+=vertical
"  
"  " leader+M opens notes
"  noremap <silent> <leader>m          :10split ~/notes.md <CR>
"  
"  " Force a dark background because Vim misbehaves in tmux
"  set background=dark
"  
"  " Equalize viewports on resize (eg. Tmux zoom in/out)
"  autocmd VimResized * exe "normal \<c-w>="
"  
"  " Display line numbers
"  set number
"  
"  " Run Prettier on save if a config file is present
"  let g:prettier#autoformat_require_pragma = 0
"  let g:prettier#autoformat_config_present = 1
"  let g:prettier#autoformat_config_files = [".prettierrc.json"]
"  
"  " Rails Runner
"  noremap <silent> <leader>r :w !rails runner -<CR>
"  " Ruby runner
"  noremap <silent> <leader>R :w !ruby<CR>
"  
"  " Tab switching
"  nnoremap L gt
"  nnoremap H gT
"  
"  " For GhostText autoswitching
"  let g:ghost_darwin_app = 'Terminal'
"  let g:ghost_cmd = 'tabedit'
"  
"  " GhostText filetype
"  augroup ghost
"  au!
"  autocmd BufNewFile,BufRead ghost-* set filetype=markdown
"  augroup END
