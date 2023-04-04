if packer_plugins["suda.vim"] then
    vim.api.nvim_create_user_command('W', 'w suda://%', {nargs = 0})
end

vim.cmd([[
    function! IsPluginInstalled(name)
        let l:packer_plugins = luaeval('packer_plugins')
        return type(l:packer_plugins) ==# v:t_dict
            && haskey(l:packer_plugins, a:name)
    endfunction
]])

vim.cmd([[
    function! IsPluginLoaded(name)
        let l:packer_plugins = luaeval('packer_plugins')
        return type(l:packer_plugins) ==# v:t_dict
            && haskey(l:packer_plugins, a:name)
            && l:packer_plugins[a:name]['loaded']
    endfunction
]])

vim.cmd([[
    function! ShowDocumentation()
        let l:word = expand('<cword>')
        if IsPluginInstalled('coc.nvim') && CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        elseif &keywordprg[0] ==# ':'
            exec &keywordprg[1:] .. ' ' .. l:word
        elseif &keywordprg ==# ''
            exec 'help ' .. l:word
        else
            exec '!' .. &keywordprg .. ' ' .. l:word
        endif
    endfunction
]])
vim.api.nvim_create_user_command('ShowDocumentation', 'call ShowDocumentation()', {nargs = 0})

-- from https://gist.github.com/mattsacks/1544768
vim.cmd([[
    function! Syn()
        for id in synstack(line("."), col("."))
            echo synIDattr(id, "name")
        endfor
    endfunction
]])
vim.api.nvim_create_user_command('Syn', 'call Syn()', {nargs = 0})

-- from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
vim.cmd([[
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
]])

vim.api.nvim_create_user_command(
    'Redir',
    'silent call Redir(<q-args>, <range>, <line1>, <line2>)',
    {nargs = 1, complete = command, bar = true, range = true}
)

vim.cmd([[
    let g:clang_format_auto = v:false
    if executable('brew')
        call system('test -f $(brew --prefix)/Cellar/clang-format/*/share/clang/clang-format.py')
        if v:shell_error ==# 0
            let g:clang_format_plugin_path = '/opt/homebrew/Cellar/clang-format/*/share/clang/clang-format.py'
            let g:clang_format_auto = v:true
        else
            call system('test -f $(brew --prefix)/Cellar/llvm/*/share/clang/clang-format.py')
            if v:shell_error ==# 1
                let g:clang_format_plugin_path = '/opt/homebrew/Cellar/llvm/*/share/clang/clang-format.py'
                let g:clang_format_auto = v:true
            endif
        endif
    else
        call system('test -f /usr/share/clang/clang-format.py')
        if v:shell_error ==# 0
            let g:clang_format_plugin_path = '/usr/share/clang/clang-format.py'
            let g:clang_format_auto = v:true
        endif
    fi
]])

vim.cmd([[
    if has('python')
        function ClangFormat() range
            let l:lines=a:firstline .. ":" .. a:lastline
            execute 'pyf' g:clang_format_plugin_path
        endfunction
    elseif has('python3')
        function ClangFormat() range
            let l:lines=a:firstline .. ":" .. a:lastline
            execute 'py3f' g:clang_format_plugin_path
        endfunction
    endif
]])

vim.api.nvim_create_user_command(
    'ClangFormat',
    [[
        if <bang>0 || !empty(findfile('.clang-format', expand('%:p:h') . ';'))
            <line1>,<line2>call ClangFormat()
        endif
    ]],
    {nargs = 0, bang = true, range='%'}
)

vim.api.nvim_create_autocmd(
    {'BufWritePre'},
    {
        pattern = {'*.c', '*.cpp', '*.h', '*.hpp'},
        command =
        [[
            if g:clang_format_auto && &modified && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
                let winview=winsaveview()
                %call ClangFormat()
                call winrestview(winview)
            endif
        ]]
    }
)

-- vim:et:ts=4:sw=4
