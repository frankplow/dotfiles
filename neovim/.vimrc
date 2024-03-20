" {{{ Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'tpope/vim-sensible'

    Plug 'tpope/vim-surround'

    Plug 'tpope/vim-commentary'

    Plug 'tpope/vim-sleuth'

    Plug 'tpope/vim-dispatch'

    Plug 'tpope/vim-fugitive'

    Plug 'tpope/vim-repeat'

    Plug 'tpope/vim-unimpaired'

    Plug 'airblade/vim-gitgutter'
    let g:gitgutter_sign_priority='┃'
    let g:gitgutter_sign_allow_clobber='┃'
    let g:gitgutter_sign_added='┃'
    let g:gitgutter_sign_modified='┃'
    let g:gitgutter_sign_removed='┃'
    let g:gitgutter_sign_removed_first_line='┃'
    let g:gitgutter_sign_modified_removed='┃'

    Plug 'lambdalisue/suda.vim'

    Plug 'junegunn/fzf'

    Plug 'junegunn/fzf.vim'

    Plug 'christoomey/vim-tmux-navigator'

    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    call coc#util#install_extension(['coc-clangd'])
    call coc#util#install_extension(['coc-rust-analyzer'])
    call coc#util#install_extension(['coc-pyright'])
    au CursorHold * call CocActionAsync('highlight')

    Plug 'antoinemadec/coc-fzf'

    Plug 'rust-lang/rust.vim'
    let g:cargo_makeprg_params='build'
    let g:cargo_shell_command_runner='Start'

    Plug 'psf/black', { 'branch': 'stable' }

    Plug 'github/copilot.vim'
call plug#end()

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = {},
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}
EOF
" }}}

" {{{ Commands
function! AutoFormat(enable)
    let g:rustfmt_autosave=a:enable

    if a:enable
        augroup Format
            au BufWritePre *.py call black#Black()
        augroup END
    else
        autocmd! Format *
    endif
endfunction

call AutoFormat(v:true)

command -nargs=0 EnableAutoFormat call AutoFormat(v:true)
command -nargs=0 DisableAutoFormat call AutoFormat(v:false)

function! ShowDocumentation()
    let l:word = expand('<cword>')
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    elseif &keywordprg[0] ==# ':'
        exec &keywordprg[1:] .. ' ' .. l:word
    elseif &keywordprg ==# ''
        exec 'help ' .. l:word
    else
        exec '!' .. &keywordprg .. ' ' .. l:word
    endif
endfunction

command -nargs=0 ShowDocumentation call ShowDocumentation()

" https://gist.github.com/mattsacks/1544768
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction

command -nargs=0 Syn call Syn()

" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
    for win in range(1, winnr('$'))
        if getwinvar(win, 'scratch')
            execute win . 'windo close'
        endif
    endfor
    if a:cmd =~ '^!'
        let cmd = a:cmd =~' %'
            \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
            \ : matchstr(a:cmd, '^!\zs.*')
        if a:rng == 0
            let output = systemlist(cmd)
        else
            let joined_lines = join(getline(a:start, a:end), '\n')
            let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
            let output = systemlist(cmd . " <<< $" . cleaned_lines)
        endif
    else
        redir => output
        execute a:cmd
        redir END
        let output = split(output, "\n")
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    call setline(1, output)
endfunction

command -nargs=1 -complete=command -bar -range Redir call Redir(<q-args>, <range>, <line1>, <line2>)
" }}}

" {{{ Appearance
" Colourscheme
set background=dark
colo ansi16

" Line number
set number
set relativenumber
set cursorline
set cursorlineopt=number
set numberwidth=5
set signcolumn=yes:1

" Characters
let &listchars='eol:¶'
set fillchars+=vert:│
set fillchars+=fold:―

" Statusline
let &statusline='%<%f %h%m%r%=%{"[".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")."]"}%{"[".&ff."]"}%k %-8.(%l,%c%V%) %P'

" Cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
autocmd VimEnter * silent !echo -ne "\e[2 q]"
" }}}

" {{{ Mappings
let g:mapleader=','

nnoremap <silent> <ESC> :noh<CR>

nnoremap K :ShowDocumentation<CR>

nnoremap '<CR> :Start! -wait=always<CR>
nnoremap '! :Start! -wait=always

nnoremap <silent> g<CR> :History<CR>
nnoremap <silent> g/ :Rg<CR>
nnoremap <silent> g* :Rg <C-R><C-W><CR>

inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gD <Plug>(coc-declaration)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
" }}}

" {{{ Misc
" Searching
set ignorecase
set smartcase
set hlsearch

" Wildmenu
set wildmenu
set wildmode=list:longest

" Splits
set splitbelow
set splitright

" Mouse mode
set mouse=a

" Updatetime
set updatetime=100

" Build with multiple threads
let &makeprg='make -j'
" }}}

" vim:et:ts=4:sw=4:fdm=marker
