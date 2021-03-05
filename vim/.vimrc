" paths
set runtimepath=$VIM,$VIMRUNTIME,$HOME/.config/vim,$HOME/.config/vim/ftdetect
set packpath=$VIM/vimfiles,$VIMRUNTIME,$HOME/.config/vim/pack
set viminfo+=n~/.config/vim/viminfo

" line numbers
set number relativenumber
set cursorline
set cursorlineopt=number
set numberwidth=3

" tabs settings
set tabstop=4
set shiftwidth=4
set expandtab

" borders
set fillchars+=vert:│
set fillchars+=fold:―

" searching
set hlsearch

" cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
autocmd VimEnter * silent !echo -ne "\e[2 q]"

" colours
set t_Co=16
set background=dark
try
	colorscheme ansi16
catch
endtry

" syntax
set conceallevel=2

" plugins
call plug#begin('~/.config/vim/plugins')
Plug 'tpope/vim-sensible'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'lambdalisue/suda.vim'
command W w suda://%

Plug 'bfrg/vim-cpp-modern'

Plug 'calviken/vim-gdscript3'

Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=['~/.config/vim/UltiSnips']
let g:UltiSnipsEditSplit='tabdo'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
call plug#end()
