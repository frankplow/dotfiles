" paths
set runtimepath=$VIM,$VIMRUNTIME,$HOME/.config/vim
set packpath=$VIM/vimfiles,$VIMRUNTIME,$HOME/.config/vim/pack
set viminfo+=n~/.config/vim/viminfo

" line numbers
set ruler
set relativenumber
set numberwidth=3

" tabs settings
set tabstop=4
set shiftwidth=4
set expandtab

" borders
set fillchars+=vert:│
set fillchars+=fold:―

" enable filetype plugins
filetype plugin on
filetype indent on

" colours
syntax enable
set t_Co=16
set background=light
try
	colorscheme ansi16
catch
endtry

" cursor
silent !{echo "\e[5 q"}
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" plugins
call plug#begin('~/.config/vim/plugins')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'lambdalisue/suda.vim'
Plug 'bfrg/vim-cpp-modern'
Plug 'calviken/vim-gdscript3'
command W w suda://%
call plug#end()
