if empty(glob('~/.vim/autoload/plug.vim'))
  silent !echo "Installing vim-plug plug-in manager."
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rails'
Plug 'slim-template/vim-slim'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
"Plug 'tpope/vim-sleuth'
Plug 'scrooloose/nerdcommenter'
"Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'scrooloose/nerdtree'
Plug 'mbbill/undotree'
Plug 'kchmck/vim-coffee-script'
"Plug 'shime/vim-livedown'
"Plug 'plasticboy/vim-markdown'
Plug 'freitass/todo.txt-vim'
Plug '/usr/local/opt/fzf'

call plug#end()
