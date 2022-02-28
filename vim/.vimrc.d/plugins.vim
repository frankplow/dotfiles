" plugins
call plug#begin("~/.config/vim/plugins")
    " general useful plugins
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-dispatch'
    Plug 'lambdalisue/suda.vim'
    command! W w suda://%
    Plug '~/.config/vim/plugins/vim-meetmaker'

    " lsp
    Plug 'prabirshrestha/vim-lsp'
    let g:lsp_semantic_enabled=v:true
    set tagfunc=lsp#tagfunc
    if (executable('clangd'))
        au User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd']},
            \ 'allowlist': ['c', 'cpp'],
            \ 'semantic_highlight': {
            \     'type': 'Type',
            \     'class': 'Class',
            \     'enum': 'Type',
            \     'interface': '',
            \     'struct': 'Type',
            \     'typeParameter': 'Type',
            \     'parameter': 'Type',
            \     'variable': 'Identifier',
            \     'property': '',
            \     'enumMember': '',
            \     'event': '',
            \     'function': 'Function',
            \     'method': 'Function',
            \     'macro': 'Macro',
            \     'keyword': 'Keyword',
            \     'modifier': 'Type',
            \     'comment': 'Comment',
            \     'string': 'String',
            \     'number': 'Number',
            \     'regexp': 'String',
            \     'operator': 'Operator',
            \     'namespace': 'Special'
            \ }
            \ })
    endif
    if executable('texlab')
       au User lsp_setup call lsp#register_server({
          \ 'name': 'texlab',
          \ 'cmd': {server_info->['texlab']},
          \ 'whitelist': ['tex', 'plaintex', 'context', 'bib', 'sty'],
          \ })
    endif
    if (executable('pylsp'))
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pylsp',
            \ 'cmd': {server_info->['pylsp']},
            \ 'allowlist': ['python']})
    endif
    if (executable('vim-language-server'))
        au User lsp_setup call lsp#register_server({
            \ 'name': 'vim-language-server',
            \ 'cmd': {server_info->['vim-language-server', '--stdio']},
            \ 'initialization_options': {
            \     'vimruntime': $VIMRUNTIME,
            \     'runtimepath': &rtp
            \ },
            \ 'allowlist': ['vim']})
    endif
    
    " autocompletion
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    function! s:on_lsp_buffer_enabled() abort
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
    endfunction
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

    " tex
    Plug 'plasticboy/vim-markdown'
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_math = 1
    Plug 'lervag/vimtex'
    let g:vimtex_view_method="zathura"
    Plug 'SirVer/ultisnips'
    let g:UltiSnipsSnippetDirectories=["~/.config/vim/UltiSnips"]
    let g:UltiSnipsEditSplit = "tabdo"
    let g:UltiSnipsExpandTrigger = "<Tab>"
    let g:UltiSnipsJumpForewardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"

    Plug 'preservim/vim-pencil'
    let g:pencil#wrapModeDefault = 'soft'
    let g:pencil#conceallevel = 2
    augroup pencil
        autocmd!
        autocmd FileType tex call pencil#init()
        autocmd FileType txt call pencil#init()
        autocmd FileType markdown  call pencil#init()
    augroup END

    " syntax plugins
    Plug 'sqwishy/vim-sqf-syntax'
    Plug 'sevko/vim-nand2tetris-syntax'
call plug#end()
