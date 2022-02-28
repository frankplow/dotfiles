" paths
set runtimepath=$VIM,$VIMRUNTIME,$HOME/.config/vim,$HOME/.config/vim/after,$HOME/.config/vim/ftdetect
let vimrcpath="$HOME/.vimrc.d"
set packpath=$VIM/vimfiles,$VIMRUNTIME,$HOME/.config/vim/pack
set viminfo+=n~/.config/vim/viminfo

execute "source" vimrcpath.."/plugins.vim"
execute "source" vimrcpath.."/functions.vim"

" line numbers
set number relativenumber
set cursorline
set cursorlineopt=number
set numberwidth=3

" show new lines
set listchars=eol:¶

" borders
set fillchars+=vert:│
set fillchars+=fold:―

" searching
set ignorecase
set smartcase
set hlsearch

" wildmenu
set wildmenu
set wildmode=list:longest

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
" set conceallevel=2

" filetype-specfic
filetype plugin on
let g:tex_flavor='latex'
