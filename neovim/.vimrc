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
    autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

    Plug 'junegunn/fzf.vim'

    Plug 'christoomey/vim-tmux-navigator'

    " Breaking changes between v0.10.0.
    " Should update configuration to match new API once v1 is out.
    Plug 'nvim-treesitter/nvim-treesitter', {
        \ 'tag': 'v0.10.0',
        \ 'do': ':TSUpdate' }

    Plug 'rust-lang/rust.vim'
    let g:cargo_makeprg_params='build'
    let g:cargo_shell_command_runner='Start'

    Plug 'ziglang/zig.vim'

    Plug 'neovim/nvim-lspconfig'

    Plug 'nvim-lua/plenary.nvim'

    Plug 'sbdchd/neoformat'
    let g:neoformat_ocaml_ocamlformat = {
                \ 'exe': 'ocamlformat',
                \ 'no_append': 1,
                \ 'stdin': 1,
                \ 'args': ['--enable-outside-detected-project', '--name', '"%:p"', '-']
                \ }
    let g:neoformat_enabled_ocaml = ['ocamlformat']
    let g:neoformat_enabled_python = ['black']

    if !exists('g:vscode')
        Plug 'ojroques/nvim-lspfuzzy'

        Plug 'Saghen/blink.cmp', { 'tag': 'v1.0.0' }
    endif
call plug#end()

" LSP
if has('nvim')
lua << EOF

-- Falliable requires for packages not installed in e.g. VSCode
local blink_exists, blink = pcall(require, 'blink.cmp')
local lspfuzzy_exists, lspfuzzy = pcall(require, 'lspfuzzy')

vim.api.nvim_create_autocmd({"LspAttach"}, {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if lspfuzzy_exists then
        lspfuzzy.setup()
    end

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', 'gR', vim.lsp.buf.incoming_calls,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next,
                   { buffer = args.buf, noremap = true })
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev,
                   { buffer = args.buf, noremap = true })

    vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename,
                   { buffer = args.buf, noremap = true})
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action,
                   { buffer = args.buf, noremap = true})

    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    end
  end
})

vim.diagnostic.config({
  severity_sort = true,
})

vim.g.zig_fmt_parse_errors = 0

lsp_servers = {
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
        },
    },
    rust_analyzer = {},
    pyright = {},
    zls = {},
}

for server, config in pairs(lsp_servers) do
    if blink_exists then
        config.capabilities = blink.get_lsp_capabilities()
    end

    -- Needed to make lspfuzzy work for nvim >= 0.11
    if lspfuzzy_exists then
        config.on_attach = function(client, _)
            client.request = lspfuzzy.wrap_request(client.request)
        end
    end

    if vim.fn.has('nvim-0.11') then
        vim.lsp.config[server] = config
        vim.lsp.enable(server)
    else
        require('lspconfig')[server].setup(config)
    end
end

-- blink.cmp completion
if blink_exists then
    blink.setup()
end
EOF

" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "comment", "c", "cpp", "rust", "python", "vim", "ocaml", "bash" },
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
endif
" }}}

" {{{ Commands
function! AutoFormat(enable)
    let g:rustfmt_autosave=a:enable

    if a:enable
        augroup Format
            au BufWritePre * try | undojoin | silent Neoformat | catch /E790/ | silent Neoformat | endtry
        augroup END
    else
        autocmd! Format *
    endif
endfunction

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
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
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

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" The following is essentially a way to create a match which is specific
" specific to a buffer, as opposed to specific to a window like a normal
" match.
function! UpdateLongLinesMatch()
    if exists('w:matchlonglines')
        call matchdelete(w:matchlonglines)
        unlet w:matchlonglines
    endif
    if exists('b:matchlonglineschars')
        if b:matchlonglineschars <= 0
            return
        endif

        let l:pattern = '\%>' . b:matchlonglineschars . 'v.\+'
        let w:matchlonglines = matchadd('LongLine', l:pattern)
    endif
endfunction

au BufEnter * call UpdateLongLinesMatch()

function! HighlightLongLines(chars)
    let b:matchlonglineschars = a:chars
    call UpdateLongLinesMatch()
endfunction

command -nargs=1 -complete=command HighlightLongLines call HighlightLongLines(<q-args>)

function! HighlightTrailingSpaces(enable)
    if a:enable
        if !exists('g:matchtrailingwhitespace')
            let g:matchtrailingwhitespace = matchadd('TrailingWhitespace', '\s\+$')
        endif
    else
        if exists('g:matchtrailingwhitespace')
            call matchdelete(g:matchtrailingwhitespace)
            unlet g:matchtrailingwhitespace
        endif
    endif
endfunction

call HighlightTrailingSpaces(v:true)

command -nargs=1 -complete=command HighlightTrailingSpaces call HighlightTrailingSpaces(<q-args>)

" }}}

" {{{ Appearance
" Colourscheme
set background=dark
set notermguicolors
colo vim
colo ansi16

" Line number
set number
set relativenumber
set cursorline
set cursorlineopt=number
set numberwidth=5
if has('nvim')
    set signcolumn=yes:1
else
    set signcolumn=yes
endif

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

" gR is used for navigation, so rebind <leader>R to enter VREPLACE
nnoremap <silent> <leader>R gR

nnoremap <silent> g<CR> :History<CR>
nnoremap <silent> g/ :Rg<CR>
nnoremap <silent> g* :Rg <C-R><C-W><CR>

" emacs/shell bindings in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-BS> <C-W>

" Escape to exit insert mode in terminal windows
tnoremap <Esc> <C-\><C-n>
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

" Per-project configuration
set exrc

" Disable vsync - reduce latency
if has('nvim-0.10')
    set notermsync
endif

" :help last-position-jump
augroup RestoreCursor
  autocmd!
  autocmd BufReadPre * autocmd FileType <buffer> ++once
    \ let s:line = line("'\"")
    \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

" Allow straddling wrapped lines
set wrap smoothscroll

" Disable line numbers in terminal windows
autocmd TermOpen * setlocal nonumber norelativenumber
" }}}

" vim:et:ts=4:sw=4:fdm=marker
