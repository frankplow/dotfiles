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
    let g:gitgutter_sign_added='┃'
    let g:gitgutter_sign_modified='┃'
    let g:gitgutter_sign_removed='┃'
    let g:gitgutter_sign_removed_first_line='┃'
    let g:gitgutter_sign_removed_above_and_below='┃'
    let g:gitgutter_sign_modified_removed='┃'

    Plug 'lambdalisue/suda.vim'

    Plug 'junegunn/fzf'

    Plug 'junegunn/fzf.vim'

    Plug 'christoomey/vim-tmux-navigator'

    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

    Plug 'rust-lang/rust.vim'
    let g:cargo_makeprg_params='build'
    let g:cargo_shell_command_runner='Start'

    Plug 'psf/black', { 'branch': 'stable' }

    Plug 'github/copilot.vim'

    Plug 'neovim/nvim-lspconfig'

    Plug 'gfanto/fzf-lsp.nvim'

    Plug 'nvim-lua/plenary.nvim'
call plug#end()

" LSP
lua << EOF
vim.api.nvim_create_autocmd({"LspAttach"}, {
  callback = function(args)
    vim.keymap.set('n', 'gd', require'fzf_lsp'.definition_call,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gD', require'fzf_lsp'.declaration_call,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gy', require'fzf_lsp'.type_definition_call,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gi', require'fzf_lsp'.implementation_call,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gr', require'fzf_lsp'.references_call,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev,
                   { buffer = args.buf, noremap = true })

    vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename,
                   { buffer = args.buf, noremap = true})
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action,
                   { buffer = args.buf, noremap = true})
  end
})

local lspconfig = require('lspconfig')
lspconfig.clangd.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.pyright.setup {}
EOF

" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "rust", "python", "vim" },
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

function! HighlightLongLines(chars)
    if exists('b:matchlonglines')
        call matchdelete(b:matchlonglines)
    endif
    if a:chars <= 0
        return
    endif
    let l:pattern = '\%>' . a:chars . 'v.\+'
    let b:matchlonglines = matchadd('LongLine', l:pattern)
endfunction

command -nargs=1 -complete=command HighlightLongLines call HighlightLongLines(<q-args>)
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

nnoremap '<CR> :Start! -wait=always<CR>
nnoremap '! :Start! -wait=always

nnoremap <silent> g<CR> :History<CR>
nnoremap <silent> g/ :Rg<CR>
nnoremap <silent> g* :Rg <C-R><C-W><CR>
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

" Autocompletion
set completeopt=menu
" }}}

" vim:et:ts=4:sw=4:fdm=marker
