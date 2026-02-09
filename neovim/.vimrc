" {{{ Commands
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

" Escape to exit insert mode in terminal windows (Neovim)
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif
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
