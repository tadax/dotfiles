set number
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

" 0 が前置されている場合でも 10 進数として扱う
set nrformats=

" 履歴を参照する際にカーソルキーを使わない
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

syntax on

autocmd BufNewFile,BufRead *.js setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.jsx setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.ts setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.tsx setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.html setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.css setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.json setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.yml setlocal sw=2 sts=2 ts=2 et
autocmd BufNewFile,BufRead *.yaml setlocal sw=2 sts=2 ts=2 et
