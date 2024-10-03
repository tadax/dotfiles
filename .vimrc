set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set nowrap
set encoding=utf-8
set re=0
set history=200

" backspace の拡張
" cf. https://maku77.github.io/vim/settings/backspace.html
set backspace=indent,eol,start

" cf. https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
set clipboard^=unnamed,unnamedplus

" 0 が前置されている場合でも 10 進数として扱う
set nrformats=

" %コマンドの拡張
set nocompatible
filetype plugin on
runtime macros/matchit.vim

" 履歴を参照する際にカーソルキーを使わない
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Install Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'itchyny/vim-haskell-indent'
  Plugin 'neovimhaskell/haskell-vim'
call vundle#end()
filetype plugin indent on
syntax on

autocmd BufNewFile,BufRead *.hs setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.js setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.jsx setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.ts setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.tsx setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.html setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.css setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.json setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.yml setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.yaml setlocal sw=2 sts=2 ts=2 et
